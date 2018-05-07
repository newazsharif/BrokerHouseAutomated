using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.Security.Models;
using Escrow.Security.Factories;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;
using System.Text;
using Escrow.BOAS.Transaction.Models;
using System.Net.Mail;
using System.Threading;
using System.Net;

namespace Escrow.BOAS.Web.Controllers
{
    
    public class AccountController : Controller
    {
        private IReadOnlyFactory<tblBrokerInformation> brokerFactory;
        private IGenericFactory<tblBrokerUser> brokerUserFactory;
        private IReadOnlyFactory<tblDayProcess> dayProcessFactory;
        private IGenericFactory<tblBrokerModuleMapping> brokerModuleMappingFactory;
        private IGenericFactory<tblUserActionMapping> userActionMappingFactory;
        private IGenericFactory<AspNetUser> aspnetUserFactory;
        private IGenericFactory<tblAction> actionFactory;
        private IGenericFactory<tblUIModule> moduleFactory;

        private Escrow.BOAS.InvestorManagement.Factories.InvestorFactory investorFactory;
        private Escrow.Security.Factories.BrokerUserFactory userFacroty;
        
        
        public AccountController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public AccountController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
            
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        //
        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            TempData["errorMessage"] = string.Empty;
            ViewBag.ReturnUrl = returnUrl;
            //return View();

            return RedirectToAction("Index", "Home");

        }

        //
        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Login(LoginViewModel model, string returnUrl)
        {
            TempData["errorMessage"] = string.Empty;
            if (ModelState.IsValid)
            {
                var user = await UserManager.FindAsync(model.UserName, model.Password);
                if (user != null)
                {

                    brokerUserFactory = new BrokerUserFactory();
                    tblBrokerUser brokerUser = brokerUserFactory.FindBy(u => u.tblBrokerInformation.short_name == model.BrokerName && u.UserId == user.Id).FirstOrDefault();

                    
                    if (brokerUser != null)
                    {
                        if (brokerUser.is_loggedIn == 1)
                        {
                            TempData["errorMessage"] = "You are logged in from another browser";
                            return Redirect("/");
                        }
                        await SignInAsync(user, model.RememberMe);

                        dayProcessFactory = new DayProcessFactory();

                        DateTime processDate = dayProcessFactory.GetAll().OrderByDescending(a => a.process_date).Select(a => a.DimDate.Date).FirstOrDefault() ?? DateTime.Now;
                        brokerUser.is_loggedIn = 1;
                        brokerUser.last_logged_time = DateTime.Now;
                        brokerUserFactory.Edit(brokerUser);
                        brokerUserFactory.Save();
                        SessionManger.SetLoggedInTime(Session, processDate);
                        brokerFactory = new BrokerFactory();
                        SessionManger.SetBrokerOfLoggedInUser(Session, brokerFactory.FindBy(b => b.short_name == model.BrokerName).FirstOrDefault());
                        return Redirect("/#Index");
                    }
                    else
                    {
                        ModelState.AddModelError("", "Invalid broker or user id or password.");
                        TempData["errorMessage"] = "Invalid broker or user id or password.";
                    }
                        
                    //}
                }
                else
                {
                    ModelState.AddModelError("", "Invalid broker or user id or password.");
                    TempData["errorMessage"] = "Invalid broker or user id or password.";
                }
            }

            // If we got this far, something failed, redisplay form
            //return View(model);
            return Redirect("/");
        }
        [CheckUserSessionAttribute]
        
        public ActionResult UserList()
        {
            return View();
        }
        [CheckUserSessionAttribute]
        public JsonResult LoadUserList()
        {
            try
            {
                brokerUserFactory = new BrokerUserFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                var users = brokerUserFactory.FindBy(b => b.membership_id == membership_id).Select(s =>
                    new
                    {
                        s.AspNetUser.Id,
                        s.AspNetUser.UserName,
                        //s.AspNetUser.UserFullName,
                        s.AspNetUser.Email,
                        s.AspNetUser.PhoneNumber
                    }).ToList();

                //var users = brokerUserFactory.FindBy(b => b.membership_id == membership_id).Select(s => s.AspNetUser).ToList();
                return Json(new { success = true, users = users }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        [CheckUserSessionAttribute]
        public ViewResult EditUser(string id)
        {
            return View();
        }

        
        public ActionResult UserActionMapping()
        {
            return View();
        }

        public ActionResult UserReportActionMapping()
        {
            return View();
        }

        [CheckUserSession]
        public JsonResult LoadUserInfo(string id)
        {
            try
            {
                brokerUserFactory  = new BrokerUserFactory();
                
                var user = brokerUserFactory.FindBy(c => c.UserId == id).Select(a => new
                    {
                        a.UserId,
                        a.AspNetUser.UserName,
                        a.AspNetUser.Email,
                        a.AspNetUser.PhoneNumber,
                        a.is_admin
                    }).FirstOrDefault();

                
                return Json(new { success = true, result = user }, JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        [CheckUserSessionAttribute]
        public async Task<JsonResult> UpdateUser(AspNetUser model)
       {
           try 
           {
               brokerUserFactory = new BrokerUserFactory();
               var user = brokerUserFactory.FindBy(c => c.UserId == model.Id).FirstOrDefault();
               
               user.AspNetUser.Email = model.Email;
               user.AspNetUser.PhoneNumber = model.PhoneNumber;
               user.is_admin = model.is_admin;
               //var users = UserManager.FindByName(model.Id);
               ////user.UserFullName = model.UserFullName;
               //user.Email = model.Email;
               //user.PhoneNumber = model.PhoneNumber;

               if (ModelState.IsValid)
               {
                   brokerUserFactory.Edit(user);
                   brokerUserFactory.Save();

                   return Json(new { success = true, successMessage = "Data Updated Successfully!!" }, JsonRequestBehavior.AllowGet);
               }
               else
                   return Json(new { success = false, errorMessage = "" }, JsonRequestBehavior.AllowGet);
           
           }
            catch(Exception ex)
           {
               return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
           }
       }


        //
        // GET: /Account/Register
        [CheckUserSessionAttribute]
        public ActionResult Register()
        {
            return View();
        }

        //
        // POST: /Account/Register
        [HttpPost]
        [CheckUserSessionAttribute]
        //[ValidateAntiForgeryToken]
        public async Task<ActionResult> Register(AspNetUser model)
        {
            if (ModelState.IsValid)
            {
                //Need to remove after code complete
                //brokerUserFactory = new BrokerUserFactory();
                //brokerUserFactory.Delete(bu => bu.AspNetUser.UserName == model.UserName);
                //brokerUserFactory.Save();

                var results = await UserManager.FindByNameAsync(model.UserName);
                if (results != null)
                {
                    return Json(new { success = false, errorMessage = "This User Name Already Exists" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    // Create User
                    var user = new ApplicationUser() { UserName = model.UserName, Email = model.Email, PhoneNumber = model.PhoneNumber };
                    var result = await UserManager.CreateAsync(user, model.Password);
                    

                    if (result.Succeeded)
                    {
                        //Generate token
                        //var provider = new DpapiDataProtectionProvider("Escrow");
                        //UserManager.UserTokenProvider = new DataProtectorTokenProvider<ApplicationUser>(provider.Create("CreateUser"));
                        //var code = await UserManager.GenerateEmailConfirmationTokenAsync(user.Id);

                        //var callbackUrl = Url.Action("ConfirmEmail", "Account", new { userId = user.Id, code = code }, protocol: Request.Url.Scheme);

                        ////Email for confirmation
                        //IdentityMessage msg = new IdentityMessage();
                        //msg.Destination = user.Email;
                        //msg.Subject = "Confirm your account";
                        //msg.Body = "Please confirm your account by clicking this link: <a href=\"" + callbackUrl + "\">link</a>";
                        //EmailService eservice = new EmailService();
                        //await eservice.SendAsync(msg);

                        //await UserManager.ConfirmEmailAsync(user.Id, code);

                        // Broker Setting with user
                        using (brokerUserFactory = new BrokerUserFactory())
                        {
                            tblBrokerUser brokeruser = new tblBrokerUser();
                            brokeruser.UserId = user.Id;
                            brokeruser.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                            brokeruser.is_admin = model.is_admin;
                            brokerUserFactory.Add(brokeruser);
                            brokerUserFactory.Save();
                        }

                        // ViewBag.Link = callbackUrl;   // Used only for initial demo.
                        //return View("DisplayEmail");
                        return Json(new { success = true, successMessage = "Successfully User Created" });
                    }
                    else
                    {
                        //AddErrors(result);

                        //var userExist = await UserManager.FindByNameAsync(model.UserName);
                        //if (userExist != null) await UserManager.DeleteAsync(userExist);
                        return Json(new { success = false, errorMessage = "Model is not Valid" }, JsonRequestBehavior.AllowGet);

                    }
                }
            }
            else
            {
                return Json(new { success = false, errorMessage = "Model is not Valid" }, JsonRequestBehavior.AllowGet);
            }

            // If we got this far, something failed, redisplay form

        }

        [HttpPost]
        public async Task<ActionResult>RegisterDefaultBrokerUser(AspNetUser model, decimal membership_id)
        {
            if (ModelState.IsValid)
            {                
                var results = await UserManager.FindByNameAsync(model.UserName);
                if (results != null)
                {
                    return Json(new { success = false, errorMessage = "This User Name Already Exists" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    // Create User
                    var user = new ApplicationUser() { UserName = model.UserName, Email = model.Email, PhoneNumber = model.PhoneNumber };
                    var result = await UserManager.CreateAsync(user, model.Password);


                    if (result.Succeeded)
                    {                      
                        // Broker Setting with user
                        using (brokerUserFactory = new BrokerUserFactory())
                        {
                            tblBrokerUser brokeruser = new tblBrokerUser();
                            brokeruser.UserId = user.Id;
                            brokeruser.membership_id = membership_id;
                            brokeruser.is_admin = model.is_admin;
                            brokerUserFactory.Add(brokeruser);
                            brokerUserFactory.Save();
                        }
                        
                        using (brokerModuleMappingFactory = new BrokerModuleMappingFactory()) // giving all module permission by default without system management
                        {
                            
                            try
                            {
                                moduleFactory = new ModuleFactory();
                                tblBrokerModuleMapping tempBrokerModuleMapping = new tblBrokerModuleMapping();
                                List<tblUIModule> uiModule = moduleFactory.GetAll().ToList();
                                foreach (var item in uiModule)
                                {
                                    if(item.id != 116)
                                    {                                        
                                        tempBrokerModuleMapping.ui_module_id = item.id;
                                        tempBrokerModuleMapping.membership_id = membership_id;
                                        brokerModuleMappingFactory.Add(tempBrokerModuleMapping);
                                        brokerModuleMappingFactory.Save(tempBrokerModuleMapping);
                                    }                       
                                }                                                                
                            }
                            catch (Exception exception)
                            {
                                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
                            } 
                        }
                        //userActionMappingFactory = new UserActionMappingFactory();
                        actionFactory = new ActionFactory();
                        using (userActionMappingFactory = new UserActionMappingFactory())
                        {
                            try
                            {
                                List<tblAction> actions = new List<tblAction>();
                                actions = actionFactory.GetAll().Where(x => x.ui_module_id != 116).ToList();
                                //tblUserActionMapping actionMapping = new tblUserActionMapping();
                                foreach (var item in actions)
                                {
                                    tblUserActionMapping actionMapping = new tblUserActionMapping();
                                    actionMapping.action_id = item.id;
                                    actionMapping.user_id = user.Id;
                                    actionMapping.is_permitted = 1;
                                    actionMapping.membership_id = membership_id;
                                    userActionMappingFactory.Add(actionMapping);
                                    //userActionMappingFactory.Save(actionMapping);
                                }
                                userActionMappingFactory.Save();
                            }
                            catch (Exception ex)
                            {
                                throw;
                            } 
                        }                  
                         
                        return Json(new { success = true, successMessage = "User Created Successfully " });
                    }
                    else
                    {
                      return Json(new { success = false, errorMessage = "Model is not Valid" }, JsonRequestBehavior.AllowGet);
                    }
                }
            }
            else
            {
                return Json(new { success = false, errorMessage = "Model is not Valid" }, JsonRequestBehavior.AllowGet);
            }




            // If we got this far, something failed, redisplay form

        }


        //
        // POST: /Account/Disassociate
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Disassociate(string loginProvider, string providerKey)
        {
            ManageMessageId? message = null;
            IdentityResult result = await UserManager.RemoveLoginAsync(User.Identity.GetUserId(), new UserLoginInfo(loginProvider, providerKey));
            if (result.Succeeded)
            {
                message = ManageMessageId.RemoveLoginSuccess;
            }
            else
            {
                message = ManageMessageId.Error;
            }
            return RedirectToAction("Manage", new { Message = message });
        }

        //
        // GET: /Account/ResetPassword
        public ActionResult ResetPassword(string id, ManageMessageId? message)
        {
           
            return View();
        }

        
        //
        // POST: /Account/Manage
        [HttpPost]
        //[MyValidateAntiForgeryTokenAttribute]
        [MyAntiForgeryValidate]
        public async Task<ActionResult> ResetPassword(ResetPasswordVM model)
        {
            string cookieToken = "";
            string formToken = "";

            IEnumerable<string> tokenHeaders;
            tokenHeaders = this.HttpContext.Request.Headers.GetValues("RequestVerificationToken");
            // actionContext.Request.Headers.TryGetValues("RequestVerificationToken", out tokenHeaders
            //if (this.HttpContext.Request.Headers.GetValues("RequestVerificationToken", out tokenHeaders))
            //{
                string[] tokens = tokenHeaders.First().Split(':');
                if (tokens.Length == 2)
                {
                    cookieToken = tokens[0].Trim();
                    cookieToken = cookieToken.Remove(0, 31);
                    formToken = tokens[1].Trim();
                }
            //}
            System.Web.Helpers.AntiForgery.Validate(cookieToken, formToken);


            if (ModelState.IsValid)
            {
                var provider = new DpapiDataProtectionProvider("Sample");
                UserManager.UserTokenProvider = new DataProtectorTokenProvider<ApplicationUser>(
                provider.Create("ResetPassword"));
                //var user = await UserManager.FindByNameAsync(model.UserName);
                var token = UserManager.GeneratePasswordResetToken(model.UserId);
                IdentityResult result = await UserManager.ResetPasswordAsync(model.UserId, token, model.NewPassword);
                

                //IdentityResult result = await UserManager.ChangePasswordAsync(model.UserId, model.ConfirmPassword, model.NewPassword);
                if (result.Succeeded)
                {
                    return Json(new { success = true, successMessage = "Successfully Password Reset!!!" });
                }
                else
                {
                    return Json(new { success = false, errorMessage = "Cannot Reset Password!!!" });
                }
            }


            // If we got this far, something failed, redisplay form
            return View(model);
        }

        
        // GET: /Account/ChangePassword
        [CheckUserSessionAttribute]
        public ActionResult ChangePassword(ManageMessageId? message)
        {
            //ViewBag.StatusMessage =
            //    message == ManageMessageId.ChangePasswordSuccess ? "Your password has been changed."
            //    : message == ManageMessageId.Error ? "An error has occurred."
            //    : "";
            // ViewBag.HasLocalPassword = HasPassword();
            //ViewBag.ReturnUrl = Url.Action("ChangePassword");
            return View();
        }

        //
        // POST: /Account/Manage
        
        [HttpPost]
        [CheckUserSessionAttribute]
        //[ValidateAntiForgeryToken]
        public async Task<ActionResult> ChangePassword(ManageUserViewModel model)
        {
            //bool hasPassword = HasPassword();
            //ViewBag.HasLocalPassword = hasPassword;
            //ViewBag.ReturnUrl = Url.Action("ChangePassword");
            var user = UserManager.Find(User.Identity.GetUserName(), model.OldPassword);
            if (user != null)
            {
                if (ModelState.IsValid)
                {
                    IdentityResult result = await UserManager.ChangePasswordAsync(User.Identity.GetUserId(), model.OldPassword, model.NewPassword);
                    if (result.Succeeded)
                    {
                        return Json(new { success = true, successMessage = "Successfully Password Changed!!!" });
                    }
                    else
                    {
                        return Json(new { success = false, errorMessage = "Cannot Change Password!!!" });
                    }
                }
                else
                {
                    return Json(new { success = false, errorMessage = "Model is not valid" });
                }
            }
            else
            {
                return Json(new { success = false, errorMessage = "Password is not Correct!!" });
            }

        }

        public JsonResult GetUserName(string userId)
        {
            var user = UserManager.FindById(userId).UserName;
            return Json(new { success = true, result = user },JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Account/Manage
        public ActionResult Manage(ManageMessageId? message)
        {
            ViewBag.StatusMessage =
                message == ManageMessageId.ChangePasswordSuccess ? "Your password has been changed."
                : message == ManageMessageId.SetPasswordSuccess ? "Your password has been set."
                : message == ManageMessageId.RemoveLoginSuccess ? "The external login was removed."
                : message == ManageMessageId.Error ? "An error has occurred."
                : "";
            ViewBag.HasLocalPassword = HasPassword();
            ViewBag.ReturnUrl = Url.Action("Manage");
            return View();
        }

        //
        // POST: /Account/Manage
        [HttpPost]
        [ValidateAntiForgeryToken]
        [CheckUserSessionAttribute]
        public async Task<ActionResult> Manage(ManageUserViewModel model)
        {
            bool hasPassword = HasPassword();
            ViewBag.HasLocalPassword = hasPassword;
            ViewBag.ReturnUrl = Url.Action("Manage");
            if (hasPassword)
            {
                if (ModelState.IsValid)
                {
                    IdentityResult result = await UserManager.ChangePasswordAsync(User.Identity.GetUserId(), model.OldPassword, model.NewPassword);
                    if (result.Succeeded)
                    {
                        return RedirectToAction("Manage", new { Message = ManageMessageId.ChangePasswordSuccess });
                    }
                    else
                    {
                        AddErrors(result);
                    }
                }
            }
            else
            {
                // User does not have a password so remove any validation errors caused by a missing OldPassword field
                ModelState state = ModelState["OldPassword"];
                if (state != null)
                {
                    state.Errors.Clear();
                }

                if (ModelState.IsValid)
                {
                    IdentityResult result = await UserManager.AddPasswordAsync(User.Identity.GetUserId(), model.NewPassword);
                    if (result.Succeeded)
                    {
                        return RedirectToAction("Manage", new { Message = ManageMessageId.SetPasswordSuccess });
                    }
                    else
                    {
                        AddErrors(result);
                    }
                }
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        public JsonResult GetAllUserForCurrentBroker()
        {
            brokerUserFactory = new BrokerUserFactory();
            decimal membershipId = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
            try
            {
                //var users = DropDown.ddlUsers(membershipId);
                var users = brokerUserFactory.FindBy(c => c.membership_id == membershipId).Select(
                a => new
                {
                    text = a.AspNetUser.UserName,
                    value = a.UserId
                }).ToList();
                
                return Json(new {data = users, success = true}, JsonRequestBehavior.AllowGet);
        }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult UserMenuActionForPermission(string userId)
        {
            decimal id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
            userActionMappingFactory = new UserActionMappingFactory();
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            //string user_id = User.Identity.GetUserId();
            //var views = userActionMappingFactory.GetAll().Where(a => a.user_id == user_id)
            //    .Select(x => x.action_id).ToList();
            var result = brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == id && !a.tblUIModule.id_name.ToUpper().EndsWith("REPORTS"))
            .Select(a => new
            {
                a.tblUIModule.id,
                label = a.tblUIModule.name,
                children = a.tblUIModule.tblActions.Where(x=>x.is_view==1)
                .Select(ac
                    => new
            {
                        ac.id,
                        label = ac.display_name,
                        //a.membership_id,
                        selected = ac.tblUserActionMappings.Where(x => x.user_id == userId).Select(x=>x.user_id).FirstOrDefault() == null ? false : true
                    }
                    ).ToList()
            }).ToList();

            return Json(new { data = result, success = true }, JsonRequestBehavior.AllowGet);
            }

        
        public JsonResult UserReportActionForPermission(string userId)
        {
            decimal id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
            userActionMappingFactory = new UserActionMappingFactory();
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            //string user_id = User.Identity.GetUserId();
            //var views = userActionMappingFactory.GetAll().Where(a => a.user_id == user_id)
            //    .Select(x => x.action_id).ToList();
            var result = brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == id && a.tblUIModule.id_name.ToUpper().EndsWith("REPORTS"))
            .Select(a => new
            {
                a.tblUIModule.id,
                label = a.tblUIModule.name,
                children = a.tblUIModule.tblActions.Where(x => x.is_view == 1)
                .Select(ac
                    => new
            {
                        ac.id,
                        label = ac.display_name,
                        //a.membership_id,
                        selected = ac.tblUserActionMappings.Where(x => x.user_id == userId).Select(x => x.user_id).FirstOrDefault() == null ? false : true
            }
                    ).ToList()
            }).ToList();

            return Json(new { data = result, success = true }, JsonRequestBehavior.AllowGet);
        }

        [CheckUserSessionAttribute]
        public ActionResult ForceLogOffUser()
        {
            return View();
        }
        /// <summary>
        /// Load User List for force LogOff UI
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public JsonResult LoadUserListForLogOff()
        {
            try
        {
                brokerUserFactory = new BrokerUserFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                string currentUser = User.Identity.GetUserId();
                var users = brokerUserFactory.FindBy(b => b.membership_id == membership_id && b.UserId != currentUser).Select(s =>
                    new
            {
                        s.AspNetUser.Id,
                        s.AspNetUser.UserName,
                        is_loggedIn = s.is_loggedIn == 1? "Yes":"No",
                        is_forceLog_available = s.is_loggedIn==1,
                        last_logged_time = s.last_logged_time.ToString(),
                        s.AspNetUser.Email,
                        s.AspNetUser.PhoneNumber
                    }).ToList();

                //var users = brokerUserFactory.FindBy(b => b.membership_id == membership_id).Select(s => s.AspNetUser).ToList();
                return Json(new { success = true, users = users }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        [CheckUserSessionAttribute]
        public ActionResult ForceLogOff()
        {
            brokerUserFactory = new BrokerUserFactory();
            List<tblBrokerUser> brokerUser = new List<tblBrokerUser>();
            brokerUser = brokerUserFactory.GetAll().ToList();
            brokerUser.Select(c => { c.is_loggedIn = 0; return c; }).ToList();
            foreach(var n in brokerUser)
            {
                brokerUserFactory.Edit(n);
            }
            brokerUserFactory.Save();
            return Json(true, JsonRequestBehavior.AllowGet);
            }

        /// <summary>
        /// Force Log Off a User
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public ActionResult ForceLogOffById(string id)
                {
            brokerUserFactory = new BrokerUserFactory();
            var brokerUser = brokerUserFactory.GetAll().FirstOrDefault(a => a.UserId == id);
            if (brokerUser != null)
                    {
                brokerUser.is_loggedIn = 0;
                brokerUserFactory.Edit(brokerUser);
                }
            brokerUserFactory.Save();
            return Json(new {message = "Successfully Logged Off",success = true}, JsonRequestBehavior.AllowGet);
            }


        //
        // POST: /Account/LogOff
        //[HttpPost]
        [CheckUserSessionAttribute]
        public ActionResult LogOff()
        {
            brokerUserFactory = new BrokerUserFactory();
            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
            string user_id = User.Identity.GetUserId();
            tblBrokerUser brokerUser = brokerUserFactory.FindBy(u => u.tblBrokerInformation.membership_id 
                                       == membership_id && u.UserId 
                                       == user_id).FirstOrDefault();
            AuthenticationManager.SignOut();
            Session.Clear();
            Session.RemoveAll();
            Session.Abandon();
            brokerUser.is_loggedIn = 0;
            brokerUserFactory.Edit(brokerUser);
            brokerUserFactory.Save();
            //return RedirectToAction("Index", "Home");
            
            return Redirect("/");
        }
        [CheckUserSessionAttribute]
        public JsonResult SaveUserPermission(decimal[] id, string userId)
        {
            userActionMappingFactory = new UserActionMappingFactory();
            actionFactory = new ActionFactory();
            try
            {
                List<tblAction> actions = new List<tblAction>();
                actions = actionFactory.GetAll().ToList();
                
                List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
                actionMappings = userActionMappingFactory.GetAll().Where(a => a.user_id == userId && !a.tblAction.tblUIModule.id_name.ToUpper().EndsWith("REPORTS")).ToList();
                
                foreach (var items in actionMappings)
                {
                    userActionMappingFactory.Delete(items);
                }

                if (id != null)
                {
                    foreach (var items in id)
                    {
                        tblUserActionMapping actionMapping = new tblUserActionMapping();
                        actionMapping.action_id = items;
                        actionMapping.user_id = userId;
                        actionMapping.is_permitted = 1;
                        actionMapping.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                        userActionMappingFactory.Add(actionMapping);
                        var selectedAction = actions.Where(a => a.id == items).FirstOrDefault();
                        if (selectedAction != null)
                        {
                            var hidenactions =
                                actions.Where(ha => ha.class_name == selectedAction.class_name && ha.id != items);
                            foreach (var hidenAction in hidenactions)
                            {
                                tblUserActionMapping hactionMapping = new tblUserActionMapping();
                                hactionMapping.action_id = hidenAction.id;
                                hactionMapping.user_id = userId;
                                hactionMapping.is_permitted = 1;
                                hactionMapping.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                                userActionMappingFactory.Add(hactionMapping);
                            }
                        }
                    }
                }
                userActionMappingFactory.Save();

                return Json(new {success = true, errorMessage = "Mapped Successfully"},JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
            
        }

        [CheckUserSessionAttribute]
        /// <summary>
        /// Set Report permission for an User
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public JsonResult SaveUserReportPermission(decimal[] id, string userId)
        {
            userActionMappingFactory = new UserActionMappingFactory();
            actionFactory = new ActionFactory();
            try
            {
                List<tblAction> actions = new List<tblAction>();
                actions = actionFactory.GetAll().ToList();

                List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
                actionMappings = userActionMappingFactory.GetAll().Where(a => a.user_id == userId && a.tblAction.tblUIModule.id_name.ToUpper().EndsWith("REPORTS")).ToList();
                foreach (var items in actionMappings)
                {
                    userActionMappingFactory.Delete(items);
                }

                if (id != null)
        {
                    foreach (var items in id)
                    {
                        tblUserActionMapping actionMapping = new tblUserActionMapping();
                        actionMapping.action_id = items;
                        actionMapping.user_id = userId;
                        actionMapping.is_permitted = 1;
                        actionMapping.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                        userActionMappingFactory.Add(actionMapping);
                        var selectedAction = actions.Where(a => a.id == items).FirstOrDefault();
                        if (selectedAction != null)
                        {
                            var hidenactions =
                                actions.Where(ha => ha.class_name == selectedAction.class_name && ha.id != items);
                            foreach (var hidenAction in hidenactions)
                            {
                                tblUserActionMapping hactionMapping = new tblUserActionMapping();
                                hactionMapping.action_id = hidenAction.id;
                                hactionMapping.user_id = userId;
                                hactionMapping.is_permitted = 1;
                                hactionMapping.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                                userActionMappingFactory.Add(hactionMapping);
        }
                        }
                    }
                }
                userActionMappingFactory.Save();

                return Json(new { success = true, errorMessage = "Mapped Successfully" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }

        }
        //public ActionResult UserMapping()
        //{
            
        //}

        
        [ChildActionOnly]
        public ActionResult RemoveAccountList()
        {
            var linkedAccounts = UserManager.GetLogins(User.Identity.GetUserId());
            ViewBag.ShowRemoveButton = HasPassword() || linkedAccounts.Count > 1;
            return (ActionResult)PartialView("_RemoveAccountPartial", linkedAccounts);
        }


        [CheckUserSessionAttribute]
        public ActionResult GetPendingOnlineUserList()
        {
            return View();
        }


        [CheckUserSessionAttribute]
        public ActionResult GetApprovedOnlineUserList()
        {
            return View();
        }

        [CheckUserSessionAttribute]
        public JsonResult GetAllApprovedOnlineUser()
        {
            investorFactory = new Escrow.BOAS.InvestorManagement.Factories.InvestorFactory();
            brokerUserFactory = new Escrow.Security.Factories.BrokerUserFactory();
            //  tblInvestor investor = new tblInvestor();
            try
            {
                var AllInvestor = investorFactory.GetAll().Select(
                    a => new
                    {
                        a.client_id,
                        a.email_address,
                        branch_name = a.tblBrokerBranch.name,
                        a.father_name,
                        a.mobile_no,
                        a.mother_name,
                        first_holder_name = a.first_holder_name,
                        join_holder_name = a.tblJoinHolder.join_holder_name,
                        a.bo_code,
                        a.trader_id,
                        a.sub_account_type_id,
                        selected = false,
                    }).ToList();

                var AllBrokerUsers = brokerUserFactory.GetAll()
                    .Where(b => b.approve_by != null && b.approve_date != null)
                    .Select(b => new
                    {
                        b.UserId,
                        UserName = b.AspNetUser.UserName,
                        selected = false,
                    }).ToList();

                var pendingUsers = (from all in AllInvestor
                                    join bu in AllBrokerUsers on all.client_id equals bu.UserName
                                    select all).ToList();

                var jsonResult = Json(new { investors = pendingUsers, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception exception)
            {
                return Json(new { result = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }

        }

        [CheckUserSessionAttribute]
        public JsonResult GetAllPendingOnlineUser()
        {
            investorFactory = new Escrow.BOAS.InvestorManagement.Factories.InvestorFactory();
            brokerUserFactory = new Escrow.Security.Factories.BrokerUserFactory();
          //  tblInvestor investor = new tblInvestor();
            try
            {
                var AllInvestor = investorFactory.GetAll().Select(
                    a => new
                    {
                        a.client_id,
                        a.email_address,
                        branch_name = a.tblBrokerBranch.name,
                        a.father_name,
                        a.mobile_no,
                        a.mother_name,
                        first_holder_name = a.first_holder_name,
                        
                        join_holder_name = a.tblJoinHolder.join_holder_name,
                        a.bo_code,
                        a.trader_id,
                        a.sub_account_type_id,
                        selected = false,
                    }).ToList();

                var AllBrokerUsers = brokerUserFactory.GetAll()
                    .Where(b => b.approve_by == null && b.approve_date == null)
                    .Select(b => new
                    {
                        b.UserId,
                        UserName = b.AspNetUser.UserName,
                        selected = false,
                    }).ToList();

                var pendingUsers = (from all in AllInvestor
                                    join bu in AllBrokerUsers on all.client_id equals bu.UserName
                                   select all).ToList();

                var jsonResult = Json(new { investors = pendingUsers, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception exception)
            {
                return Json(new { result = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }

        }

        [HttpPost]
        //[CheckUserSessionAttribute]
        public JsonResult ApproveOnlinePendingUsers(string[] SelectedUsers)
        {
            //string userId = SessionManger.BrokerOfLoggedInUser;
            string user_id = User.Identity.GetUserId();
            DateTime date = DateTime.Now;
            brokerUserFactory = new BrokerUserFactory();
            investorFactory = new InvestorManagement.Factories.InvestorFactory();
     

           try 
	        {               

                tblBrokerUser brokerUser = null;
                foreach (var item in SelectedUsers)
                {
                    brokerUser = new tblBrokerUser();
                    brokerUser = brokerUserFactory.GetAll().Where(a => a.AspNetUser.UserName == item).FirstOrDefault();

                    brokerUser.approve_by = user_id;
                    brokerUser.approve_date = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"));
                    brokerUserFactory.Edit(brokerUser);
                    Escrow.BOAS.InvestorManagement.Models.tblInvestor investor_info = new Escrow.BOAS.InvestorManagement.Models.tblInvestor();
                   // tblInvestor investor_info = new tblInvestor();
                     investor_info = investorFactory.GetAll().Where(a => a.client_id == item).ToList().FirstOrDefault();
                    //inves.client_id = 
                    SendConfirmationMail(investor_info);


                }
                brokerUserFactory.Save();               
               
                 return Json(new { success = true });
	        }
	        catch (Exception ex)
	        {
		        return Json(new { success = false, errorMessage = ex.Message });		        
	        }
                

        }        
        protected override void Dispose(bool disposing)
        {
            if (disposing && UserManager != null)
            {
                UserManager.Dispose();
                UserManager = null;
            }
            if (brokerUserFactory != null)
            {
                brokerUserFactory.Dispose();
            }
            base.Dispose(disposing);
        }


        public void SendConfirmationMail(Escrow.BOAS.InvestorManagement.Models.tblInvestor investor)
        {
             int tryAgain = 5;
                bool failed = false;
            BrokerFactory brokerFactory = new BrokerFactory();
            var Broker = brokerFactory.GetAll().Where(a => a.membership_id == investor.membership_id).FirstOrDefault();

                do
                {
                    try
                    {
                        failed = false;                   
                        string smtpAddress = ConfigManager.smtp_address;
                        int portNumber = 587;
                        bool enableSSL = true;                     
                        string emailFrom = ConfigManager.email_from;
                        string password = ConfigManager.email_password;


                        using (MailMessage mail = new MailMessage())
                        {

                            mail.From = new MailAddress(emailFrom);
                            mail.To.Add(investor.email_address);
                           
                            mail.Subject = "Approval of user registration request";
                            mail.Body = "Attention, " + "<br/>" + " Client Code: " + investor.client_id + "<br/>" + "BO Code: " + investor.bo_code + "<br/><br/>"  + " Dear sir," + "<br/>" + "Good day, your registration request for online operation has approved." + "<br/><br/>" + "Login information are given below" + "<br/>" + " Broker name: " + Broker.short_name.ToUpper() + "<br/>" + " User name: " + investor.client_id + "<br/>";
                            mail.IsBodyHtml = true;
                          

                            using (SmtpClient smtp = new SmtpClient(smtpAddress, portNumber))
                            {

                                smtp.UseDefaultCredentials = true;
                                smtp.Credentials = new NetworkCredential(emailFrom, password);
                                smtp.EnableSsl = enableSSL;
                                smtp.Timeout = Int32.Parse(ConfigManager.smtp_timeout); 
                                //smtp.SendCompleted += SendCompletedCallback;
                                smtp.Send(mail);
                              //  CreateLog(txtFileName, SelectedInvestors[j].ToString()+"-"+MailAddress[j].ToString() + "-Success");
                            }

                        }
                    }
                    catch (Exception ex)
                    {
                        failed = true;
                        tryAgain--;
                        Thread.Sleep(120000); // Sleep 2 min
                        //if(tryAgain == 0)
                        //{
                        //   // CreateLog(txtFileName, SelectedInvestors[j].ToString() + "-" + MailAddress[j].ToString() + "-Failed");
                        //}
                    }
                } while (failed && tryAgain != 0);
        }

        #region Helpers
        // Used for XSRF protection when adding external logins
        private const string XsrfKey = "XsrfId";

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }

        private async Task SignInAsync(ApplicationUser user, bool isPersistent)
        {
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ExternalCookie);
            var identity = await UserManager.CreateIdentityAsync(user, DefaultAuthenticationTypes.ApplicationCookie);
            AuthenticationManager.SignIn(new AuthenticationProperties() { IsPersistent = isPersistent }, identity);
        }

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }

        private bool HasPassword()
        {
            var user = UserManager.FindById(User.Identity.GetUserId());
            if (user != null)
            {
                return user.PasswordHash != null;
            }
            return false;
        }

        public enum ManageMessageId
        {
            ChangePasswordSuccess,
            SetPasswordSuccess,
            RemoveLoginSuccess,
            Error
        }

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            else
            {
                //return RedirectToAction("Index", "Home");
                return Redirect("/#RedirectToMain");
            }
        }

        

        public JsonResult LoadModules()
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
            try
            {
                decimal id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                userActionMappingFactory = new UserActionMappingFactory();
                string user_id = User.Identity.GetUserId();
                //var views = userActionMappingFactory.GetAll().Where(a => a.user_id == user_id)
                //    .Select(x => x.action_id).ToList();
                var result = brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == id && !a.tblUIModule.id_name.ToUpper().EndsWith("REPORTS"))
                .Select(a => new
                {
                    a.tblUIModule.name,
                    a.tblUIModule.sort_id,
                    a.tblUIModule.id,
                    a.tblUIModule.id_name,
                    action = a.tblUIModule.tblActions.Where(b => b.is_in_menu == 1 && b.tblUserActionMappings.Where(am=>am.user_id==user_id && am.is_permitted == 1).Any())
                    .Select(ac
                        => new
                        {
                            ac.id,
                            ac.name,
                            display_name = ConfigManager.is_digits_enabled_menu == "1" ? ac.display_name + "(" + ac.id + ")" : ac.display_name,
                            ac.url
                        }
                        ).ToList()
                }).Where(a=>a.action.Count()>0).ToList();
               return Json(new { result = result, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                
                throw ex;
            }
            
        }
        public JsonResult LoadModuleById(string menu_key)
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
            try
            {
                decimal id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                userActionMappingFactory = new UserActionMappingFactory();
                string user_id = User.Identity.GetUserId();
                //var views = userActionMappingFactory.GetAll().Where(a => a.user_id == user_id)
                //    .Select(x => x.action_id).ToList();

                var result = brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == id && !a.tblUIModule.id_name.ToUpper().EndsWith("REPORTS"))
                .Select(a => new
                {
                    a.tblUIModule.name,
                    a.tblUIModule.sort_id,
                    a.tblUIModule.id,
                    a.tblUIModule.id_name,
                    action = a.tblUIModule.tblActions.Where(b => b.is_in_menu == 1 && b.tblUserActionMappings.Where(am => am.user_id == user_id && am.is_permitted == 1).Any())
                    .Select(ac
                        => new
                        {
                            ac.id,
                            ac.name,
                            display_name = ConfigManager.is_digits_enabled_menu == "1" ? ac.display_name+"("+ac.id+")":ac.display_name ,
                            ac.url,
                            //ac.tblUIModule
                        }).Where(dc=>dc.display_name.Contains(menu_key))
                }).Where(a=>a.action.Count()>0).ToList();
                return Json(new { result = result, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public JsonResult LoadReports()
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
            try
            {
                decimal id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                userActionMappingFactory = new UserActionMappingFactory();
                string user_id = User.Identity.GetUserId();
                //var views = userActionMappingFactory.GetAll().Where(a => a.user_id == user_id)
                //    .Select(x => x.action_id).ToList();
                var result = brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == id && a.tblUIModule.id_name.ToUpper().EndsWith("REPORTS"))
                .Select(a => new
                {
                    a.tblUIModule.name,
                    a.tblUIModule.sort_id,
                    a.tblUIModule.id,
                    a.tblUIModule.id_name,
                    action = a.tblUIModule.tblActions.Where(b => b.is_in_menu == 1 && b.tblUserActionMappings.Where(am => am.user_id == user_id && am.is_permitted == 1).Any())
                    .Select(ac
                        => new
                        {
                            ac.id,
                            ac.name,
                            display_name = ConfigManager.is_digits_enabled_menu == "1" ? ac.display_name + "(" + ac.id + ")" : ac.display_name,
                            ac.url
                        }
                        ).ToList()
                }).Where(a=>a.action.Count()>0).ToList();
                return Json(new { result = result, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }

        public JsonResult LoadReportById(string menu_key)
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
            try
            {
                decimal id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                userActionMappingFactory = new UserActionMappingFactory();
                string user_id = User.Identity.GetUserId();
                //var views = userActionMappingFactory.GetAll().Where(a => a.user_id == user_id)
                //    .Select(x => x.action_id).ToList();
                var result = (brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == id && a.tblUIModule.id_name.ToUpper().EndsWith("REPORTS"))
                .Select(a => new
                {
                    a.tblUIModule.name,
                    a.tblUIModule.sort_id,
                    a.tblUIModule.id,
                    a.tblUIModule.id_name,
                    action = a.tblUIModule.tblActions.Where(b => b.is_in_menu == 1 && b.tblUserActionMappings.Where(am => am.user_id == user_id && am.is_permitted == 1).Any())
                    .Select(ac
                        => new
                        {
                            ac.id,
                            ac.name,
                            display_name = ConfigManager.is_digits_enabled_menu == "1" ? ac.display_name + "(" + ac.id + ")" : ac.display_name,
                            ac.url,
                            //ac.tblUIModule
                        }).Where(dc => dc.display_name.Contains(menu_key))
                })).Where(a => a.action.Count() > 0).ToList();
                return Json(new { result = result, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
        }

        }
        private class ChallengeResult : HttpUnauthorizedResult
        {
            public ChallengeResult(string provider, string redirectUri)
                : this(provider, redirectUri, null)
            {
            }

            public ChallengeResult(string provider, string redirectUri, string userId)
            {
                LoginProvider = provider;
                RedirectUri = redirectUri;
                UserId = userId;
            }

            public string LoginProvider { get; set; }
            public string RedirectUri { get; set; }
            public string UserId { get; set; }

            public override void ExecuteResult(ControllerContext context)
            {
                var properties = new AuthenticationProperties() { RedirectUri = RedirectUri };
                if (UserId != null)
                {
                    properties.Dictionary[XsrfKey] = UserId;
                }
                context.HttpContext.GetOwinContext().Authentication.Challenge(properties, LoginProvider);
            }
        }
        #endregion
    }
}