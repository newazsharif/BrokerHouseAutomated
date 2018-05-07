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
using Escrow.Utility.Interfaces;
using System.Net.Http;
using Escrow.Service.Utility;
using System.Net;

using System.Data.Entity;
using Escrow.BOAS.InvestorManagement.Models;
using Escrow.BOAS.InvestorManagement.Factories;
using Escrow.Security.Models;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.Security.Factories;
using Escrow.BOAS.Service.Models;


//using System.Web.Mvc;

namespace Escrow.Service.Controllers
{
    public class RegisterController : ApiController
    {
        private IGenericFactory<tblBrokerUser> brokerUserFactory;
        public RegisterController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {
            
        }

        public RegisterController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
            
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }


        // GET: Register

        #region Global variable

       private Escrow.BOAS.InvestorManagement.Factories.InvestorFactory investorFactory;
       //private IGenericFactory<tblInvestor> investorFactory;
        
        #endregion

        [HttpGet]
       public HttpResponseMessage GetInvestorInfoById(string id, string broker)
        {
            try
            {
                investorFactory = new Escrow.BOAS.InvestorManagement.Factories.InvestorFactory();
                
               // InvestorImageFactory imageFactory = new InvestorImageFactory();
                var investor = investorFactory.getInvestorInfoByClientId(id, Convert.ToDecimal(broker));            
           
                return Request.CreateResponse(HttpStatusCode.OK, new { investor });               
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.ExpectationFailed, ex.Message);
            }
        }

        [HttpPost]
        public HttpResponseMessage AddNewInvestor(Escrow.BOAS.InvestorManagement.Models.tblInvestor investor)
        {
            string message = "";
            try
            {
                AspNetUser user = new AspNetUser();
                user.Email = investor.email_address;
                user.EmailConfirmed = false;
                user.Password = investor.password;
                user.ConfirmPassword = investor.password;
                user.PhoneNumber = investor.mobile_no;
                user.UserName = investor.client_id;
                user.PhoneNumberConfirmed = false;
              
                var value = RegisterDefaultBrokerUser(user, investor.membership_id);

                bool update_status = UpdateUserInfo(investor);

                if (update_status == true)
                {
                    if (value == "user already exist")
                    {
                        message = "user already exist";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message });
                    }
                    else if (value == "User created")
                    {
                        message = "User created";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message });
                    }
                    else if (value == "Unable to Create User")
                    {
                        message = "Unable to Create User";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message });
                    }
                    else
                    {
                        message = "Invalid";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message });
                    } 
                }
                else
                {
                    message = "User Update Failed";
                    return Request.CreateResponse(HttpStatusCode.Forbidden, new { message });
                }

                
            }
            catch (Exception ex)
            {
                //throw ex;
                 return Request.CreateResponse(HttpStatusCode.ExpectationFailed, ex.Message);
            }
         }
        
         [HttpPost]
        public string RegisterDefaultBrokerUser(AspNetUser model, decimal membership_id)
        {
            if (ModelState.IsValid)
            {                
                //var results = await UserManager.FindByNameAsync(model.UserName);
                var results = UserManager.FindByName(model.UserName);
                if (results != null)
                {
                    return "user already exist";
                  //  return Json(new { success = false, errorMessage = "This User Name Already Exists" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    // Create User
                    var user = new ApplicationUser() { UserName = model.UserName, Email = model.Email, PhoneNumber = model.PhoneNumber };
                  //  var result = await UserManager.CreateAsync(user, model.Password);
                    var result = UserManager.Create(user, model.Password);

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
                        return "User created";
                    }
                    return "Unable to Create User";
                }
             }
            else
            {
                return "Invalid model";
            }
        }


         public bool UpdateUserInfo(Escrow.BOAS.InvestorManagement.Models.tblInvestor investor)
         {
             try
             {
                 investorFactory = new InvestorFactory();
                 Escrow.BOAS.InvestorManagement.Models.tblInvestor inv = new Escrow.BOAS.InvestorManagement.Models.tblInvestor();

                 inv = investorFactory.GetAll().Where(a => a.client_id == investor.client_id).FirstOrDefault();
                 inv.email_address = investor.email_address;
                 inv.mobile_no = investor.mobile_no;
                 inv.email_enabled = 1;

                 investorFactory.Edit(inv);
                 investorFactory.Save();
                 return true;
             }
             catch (Exception ex)
             {
                 return false;
             }
         }

       // [HttpGet]
        // public HttpResponseMessage GetInvestorDashboardInfo(Escrow.BOAS.InvestorManagement.Models.tblInvestor investor)
        //{
        //    tblPlaceOrder placedOrder = new tblPlaceOrder();
        //    placeOrderFactory = new PlaceOrderFactory();
        //   // string i = id;
        //  //  placedOrder = placeOrderFactory.FindBy(a => a.client_id == id).FirstOrDefault();

        //    return Request.CreateResponse(HttpStatusCode.OK, new { placedOrder });
        //}


    }
}