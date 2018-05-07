using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
//using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using Owin;
using Escrow.Service.Models;
using System.Web.Http;
using Escrow.Security.Models;
using Escrow.Security.Factories;
using Escrow.Utility.Interfaces;
using System.Net.Http;
using Escrow.Service.Utility;
using System.Net;
using Escrow.BOAS.BrokerManagement.Models;
using System.Data.Entity;
using Escrow.BOAS.BrokerManagement.Factories;


namespace Escrow.Service.Controllers
{
    [Authorize]
    public class AccountController : ApiController
    {
        #region Global Variable

        private IReadOnlyFactory<tblBrokerInformation> brokerFactory;
        private IGenericFactory<tblBrokerUser> brokerUserFactory;
        private IReadOnlyFactory<tblDayProcess> dayProcessFactory;
        private IGenericFactory<tblBrokerModuleMapping> brokerModuleMappingFactory;
        private IGenericFactory<tblUserActionMapping> userActionMappingFactory;
        private IGenericFactory<tblAction> actionFactory;
        private IGenericFactory<tblInvestor> investorFactory;
        //private IGenericFactory<Escrow.BOAS.AccountingManagement.Models.tblBankBranch> bankBranchFactory;

        #endregion


        public AccountController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public AccountController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;

        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        [HttpGet]
        public HttpResponseMessage LoadModules(string BrokerName)
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();

            try
            {
                brokerFactory = new BrokerFactory();
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

                userActionMappingFactory = new UserActionMappingFactory();
                string user_id = User.Identity.GetUserId();

                var result = brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == membership_id && !a.tblUIModule.id_name.ToUpper().EndsWith("REPORTS"))
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
                            ac.display_name,
                            ac.url
                        }
                        ).ToList()
                }).Where(a => a.action.Count() > 0).ToList();

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }

        [HttpGet]
        public HttpResponseMessage LoadReports(string BrokerName)
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
            try
            {
                brokerFactory = new BrokerFactory();
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

                userActionMappingFactory = new UserActionMappingFactory();
                string user_id = User.Identity.GetUserId();

                var result = brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == membership_id && a.tblUIModule.id_name.ToUpper().EndsWith("REPORTS"))
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
                            ac.display_name,
                            ac.url
                        }
                        ).ToList()
                }).Where(a => a.action.Count() > 0).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }



        [HttpGet]
        public HttpResponseMessage GetProcessDateAndBrokerName(string BrokerName)
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
            try
            {
                brokerFactory = new BrokerFactory();
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

                string brokerFullName = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.Name).FirstOrDefault();

                userActionMappingFactory = new UserActionMappingFactory();
                string user_id = User.Identity.GetUserId();

                dayProcessFactory = new DayProcessFactory();

                var result = dayProcessFactory.GetAll().Where(a => a.membership_id == membership_id).OrderByDescending(a => a.process_date).Select(a => a.DimDate.Date).FirstOrDefault() ?? DateTime.Now;

                return Request.CreateResponse(HttpStatusCode.OK, new { result, brokerFullName });
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }

        protected override void Dispose(bool disposing)
        {
            if (disposing && UserManager != null)
            {
                UserManager.Dispose();
                UserManager = null;
            }
            base.Dispose(disposing);
        }

        #region Helpers
        // Used for XSRF protection when adding external logins
        private const string XsrfKey = "XsrfId";

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                //return HttpContext.GetOwinContext().Authentication;
                return HttpContext.Current.GetOwinContext().Authentication;
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


        [HttpPost]
        public async Task<HttpResponseMessage> ChangePassword(ManageUserViewModel model)
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
                        return Request.CreateResponse(HttpStatusCode.OK, "Successfully Password Changed!!!");
                    }
                    else
                    {
                        return Request.CreateErrorResponse(HttpStatusCode.OK, "Cannot Change Password!!!");
                    }
                }
                else
                {
                    return Request.CreateErrorResponse(HttpStatusCode.OK, "Model is not valid");
                }
            }
            else
            {
                return Request.CreateErrorResponse(HttpStatusCode.OK, "Password is not Correct!!");
            }

        }


        //public HttpResponseMessage LoadModules(string userId)
        //{
        //    brokerModuleMappingFactory = new BrokerModuleMappingFactory();
        //    List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
        //    try
        //    {
        //        brokerUserFactory = new BrokerUserFactory();
        //        //decimal id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
        //        decimal id = brokerUserFactory.GetAll().Where(a => a.UserId == userId).Select(a => a.membership_id).FirstOrDefault();

        //        userActionMappingFactory = new UserActionMappingFactory();
        //        string user_id = User.Identity.GetUserId();
                
        //        var result = brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == id && !a.tblUIModule.id_name.ToUpper().EndsWith("REPORTS"))
        //        .Select(a => new
        //        {
        //            a.tblUIModule.name,
        //            a.tblUIModule.sort_id,
        //            a.tblUIModule.id,
        //            a.tblUIModule.id_name,
        //            action = a.tblUIModule.tblActions.Where(b => b.is_in_menu == 1 && b.tblUserActionMappings.Where(am => am.user_id == user_id && am.is_permitted == 1).Any())
        //            .Select(ac
        //                => new
        //                {
        //                    ac.id,
        //                    ac.name,
        //                    ac.display_name,
        //                    ac.url
        //                }
        //                ).ToList()
        //        }).Where(a => a.action.Count() > 0).ToList();

        //        //return Json(new { result = result, success = true }, JsonRequestBehavior.AllowGet);
        //        return Request.CreateResponse(HttpStatusCode.OK, result);
        //    }
        //    catch (Exception ex)
        //    {

        //        throw ex;
        //    }

        //}
        public HttpResponseMessage LoadModuleById(string menu_key, string userId)
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
            try
            {
                brokerUserFactory = new BrokerUserFactory();
                //decimal id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                decimal id = brokerUserFactory.GetAll().Where(a => a.UserId == userId).Select(a => a.membership_id).FirstOrDefault();

                userActionMappingFactory = new UserActionMappingFactory();
                string user_id = User.Identity.GetUserId();
                
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
                            ac.display_name,
                            ac.url,
                            //ac.tblUIModule
                        }).Where(dc => dc.display_name.Contains(menu_key))
                }).Where(a => a.action.Count() > 0).ToList();

               // return Request.CreateResponse(HttpStatusCode.OK, new { result, brokerFullName });
                return Request.CreateResponse(HttpStatusCode.OK, new { result });
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        //public HttpResponseMessage LoadReports(string userId)
        //{
        //    brokerModuleMappingFactory = new BrokerModuleMappingFactory();
        //    List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
        //    try
        //    {
        //        brokerUserFactory = new BrokerUserFactory();
        //        //decimal id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
        //        decimal id = brokerUserFactory.GetAll().Where(a => a.UserId == userId).Select(a => a.membership_id).FirstOrDefault();

        //        userActionMappingFactory = new UserActionMappingFactory();
        //        string user_id = User.Identity.GetUserId();
                
        //        var result = brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == id && a.tblUIModule.id_name.ToUpper().EndsWith("REPORTS"))
        //        .Select(a => new
        //        {
        //            a.tblUIModule.name,
        //            a.tblUIModule.sort_id,
        //            a.tblUIModule.id,
        //            a.tblUIModule.id_name,
        //            action = a.tblUIModule.tblActions.Where(b => b.is_in_menu == 1 && b.tblUserActionMappings.Where(am => am.user_id == user_id && am.is_permitted == 1).Any())
        //            .Select(ac
        //                => new
        //                {
        //                    ac.id,
        //                    ac.name,
        //                    ac.display_name,
        //                    ac.url
        //                }
        //                ).ToList()
        //        }).Where(a => a.action.Count() > 0).ToList();

        //        //return Json(new { result = result, success = true }, JsonRequestBehavior.AllowGet);
        //        return Request.CreateResponse(HttpStatusCode.OK, result);
        //    }
        //    catch (Exception ex)
        //    {

        //        throw ex;
        //    }

        //}

        public HttpResponseMessage LoadReportById(string menu_key, string userId)
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            List<tblUserActionMapping> actionMappings = new List<tblUserActionMapping>();
            try
            {
                brokerUserFactory = new BrokerUserFactory();
                //decimal id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                decimal id = brokerUserFactory.GetAll().Where(a => a.UserId == userId).Select(a => a.membership_id).FirstOrDefault();

                userActionMappingFactory = new UserActionMappingFactory();
                string user_id = User.Identity.GetUserId();
                
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
                            ac.display_name,
                            ac.url,
                            //ac.tblUIModule
                        }).Where(dc => dc.display_name.Contains(menu_key))
                })).Where(a => a.action.Count() > 0).ToList();

                //return Json(new { result = result, success = true }, JsonRequestBehavior.AllowGet);
                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        [HttpGet]
        public HttpResponseMessage GetInvestorInfoById(string id)
        {
            try
            {
                investorFactory = new InvestorFactory();
                // InvestorImageFactory imageFactory = new InvestorImageFactory();
                var investor = investorFactory.FindBy(b => b.client_id == id).Select(
                a => new
                {
                    a.client_id,
                    a.first_holder_name,
                    a.gender_id,
                    a.bo_refernce_id,
                    a.bo_code,
                    a.birth_date,
                    DOB = a.birth_date == null ? null : DbFunctions.TruncateTime(a.birth_date).ToString(),
                    a.father_name,
                    a.mother_name,
                    a.national_id,
                    a.passport_no,
                    a.nibondhon_no,
                    a.branch_id,
                    a.bank_branch_id,
                    a.bank_id,
                    a.account_type_id,
                    a.operation_type_id,
                    a.sub_account_type_id,
                    a.mailing_address,
                    a.permanent_address,
                    a.thana_id,
                    a.district_id,
                    a.mobile_no,
                    a.phone_no,
                    a.email_address,
                    a.banc_account_no,
                    a.beftn_enabled,
                    a.email_enabled,
                    a.sms_enabled,
                    a.internet_enabled,
                    a.opening_date,
                    Opening_date = a.DimDate.FullDateUK,
                    a.passport_issue_place,
                    a.passport_issue_date,
                    Passport_issue_date = a.passport_issue_date == null ? null : DbFunctions.TruncateTime(a.passport_issue_date).ToString(),
                    a.passport_valid_to_date,
                    Passport_valid_to_date = a.passport_valid_to_date == null ? null : DbFunctions.TruncateTime(a.passport_valid_to_date).ToString(),
                    a.trader_id,
                    a.ipo_type_id,
                    a.trade_type_id,
                    a.omnibus_master_id,
                    a.active_status_id,
                    a.membership_id,
                }).FirstOrDefault();
                //string imageBase64String = "";
                //string signatureBase64String = "";
                //var investorImage = imageFactory.FindBy(b => b.client_id == id).Select(
                //    a => new
                //    {
                //        a.client_id,
                //        a.photo,
                //        a.signature
                //    }).FirstOrDefault();
                //if (investorImage != null)
                //{
                //    if (investorImage.photo != null)
                //    {
                //        imageBase64String = Convert.ToBase64String(investorImage.photo, 0, investorImage.photo.Length);
                //    }
                //    if (investorImage.signature != null)
                //    {
                //        signatureBase64String = Convert.ToBase64String(investorImage.signature, 0, investorImage.signature.Length);
                //    }
                //}

                //return Json(new { investor = insvestor, investorImage = investorImage, ImageData = imageBase64String, SignatureData = signatureBase64String, success = true }, JsonRequestBehavior.AllowGet);
                return Request.CreateResponse(HttpStatusCode.OK, new { investor });
                //return Request.CreateResponse(HttpStatusCode.OK, new { result, brokerFullName });
            }
            catch (Exception ex)
            {
                
                throw;
            }

        }

        //private class ChallengeResult : HttpUnauthorizedResult
        //{
        //    public ChallengeResult(string provider, string redirectUri)
        //        : this(provider, redirectUri, null)
        //    {
        //    }

        //    public ChallengeResult(string provider, string redirectUri, string userId)
        //    {
        //        LoginProvider = provider;
        //        RedirectUri = redirectUri;
        //        UserId = userId;
        //    }

        //    public string LoginProvider { get; set; }
        //    public string RedirectUri { get; set; }
        //    public string UserId { get; set; }

        //    public override void ExecuteResult(ControllerContext context)
        //    {
        //        var properties = new AuthenticationProperties() { RedirectUri = RedirectUri };
        //        if (UserId != null)
        //        {
        //            properties.Dictionary[XsrfKey] = UserId;
        //        }
        //        context.HttpContext.GetOwinContext().Authentication.Challenge(properties, LoginProvider);
        //    }
        //}
        #endregion
    }
}