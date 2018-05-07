using Escrow.Security.Factories;
using Escrow.Security.Models;
using Escrow.Utility.Interfaces;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Helpers;
using System.Web.Http.Controllers;
using System.Web.Mvc;
using System.Security;
using Microsoft.AspNet.Identity;
using Escrow.BOAS.Web.Models;
using Microsoft.AspNet.Identity.EntityFramework;
using System.Security.Principal;



namespace Escrow.BOAS.Utility
{

    public static class SessionManger
    {
        
       
        public static tblBrokerInformation BrokerOfLoggedInUser(HttpSessionStateBase session)
        {
            return (tblBrokerInformation)session["BrokerOfLoggedInUser"];
        }

        
        
        public static void SetBrokerOfLoggedInUser(HttpSessionStateBase session, tblBrokerInformation broker)
        {
            session["BrokerOfLoggedInUser"] = broker;
        }

        
        public static DateTime LoggedInTime(HttpSessionStateBase session)
        {
            if (session["LoggedInTime"] != null)
            {
                return (DateTime)session["LoggedInTime"];
            }
            else
                return DateTime.Now;
           
        }

        public static void SetLoggedInTime(HttpSessionStateBase session, DateTime datetime)
        {
            session["LoggedInTime"] = datetime;
        }
        
        public static bool IsSessionNull(HttpSessionStateBase session)
        {
            if(session.Count>0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        public static bool  isUserLoggedIn()
        {
            decimal? loggedIn = 0;
            string userId = HttpContext.Current.User.Identity.GetUserId();
            BrokerUserFactory brokerUserFactory = new BrokerUserFactory();
            loggedIn = brokerUserFactory.GetAll().Where(a => a.UserId == userId).Select(a => a.is_loggedIn).FirstOrDefault();
            if (loggedIn == 1)
                return true;
            else
                return false;
        }


    }

    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, Inherited = true, AllowMultiple = false)]
    public class CheckUserSessionAttribute : ActionFilterAttribute
    {
        public string user_id { get; set; }

        private IGenericFactory<tblBrokerUser> brokerUserFactory;
        public UserManager<ApplicationUser> UserManager { get; private set; }
        private IGenericFactory<tblUserActionMapping> userActionMappingFactory;
        public string PropertyName { get; private set; }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            HttpSessionStateBase session = filterContext.HttpContext.Session;
            //var user = session["BrokerOfLoggedInUser"];
            if ((session["BrokerOfLoggedInUser"] == null))
            {
                if (GetUserLoggedIn(HttpContext.Current.User.Identity.GetUserId()) == 1)
                {
                    brokerUserFactory = new BrokerUserFactory();
                    //decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                    string user_id = HttpContext.Current.User.Identity.GetUserId();
                    tblBrokerUser brokerUser = brokerUserFactory.FindBy(u => u.UserId
                                               == user_id).FirstOrDefault();
                    brokerUser.is_loggedIn = 0;
                    brokerUserFactory.Edit(brokerUser);
                    brokerUserFactory.Save();
                    filterContext.HttpContext.GetOwinContext().Authentication.SignOut();
                    session.RemoveAll();
                    session.Clear();
                    session.Abandon();
                }
                
                //send them off to the login page
                var url = new UrlHelper(filterContext.RequestContext);
                var loginUrl = url.Content("~/Home/RedirectToMain");
                filterContext.Result = new RedirectResult(loginUrl);
                return;
            }
            else
            {
                if (filterContext.ActionDescriptor.ControllerDescriptor.ControllerName.ToUpper() == "REPORT" &&
                    filterContext.ActionDescriptor.ActionName.ToUpper() == "VIEWREPORT")
                {
                    if (!isUserPermitted(filterContext.RouteData.Values["id"].ToString(), filterContext.HttpContext.User.Identity.GetUserId()))
                      {
                   
                        var url = new UrlHelper(filterContext.RequestContext);
                        var loginUrl = url.Content("~/Home/RedirectToMain");
                        filterContext.Result = new RedirectResult(loginUrl);
                        return;
                       }   
                }

                else if (!isUserPermitted(filterContext.ActionDescriptor.ActionName, filterContext.HttpContext.User.Identity.GetUserId()))
                {
                   
                    var url = new UrlHelper(filterContext.RequestContext);
                    var loginUrl = url.Content("~/Home/RedirectToMain");
                    filterContext.Result = new RedirectResult(loginUrl);
                    return;
                }
            }
            
        }

        public bool isUserPermitted(string actionName, string userId)
        {
            bool isPermitted = false;
            userActionMappingFactory = new UserActionMappingFactory();
            ActionFactory actionFactory = new ActionFactory();
            decimal actionId = actionFactory.GetAll().Where(x => x.name == actionName).Select(a => a.id).FirstOrDefault();
            int count = userActionMappingFactory.GetAll().Count(a => a.action_id == actionId && a.is_permitted == 1);

            if (count > 0)
            {
                isPermitted = true;
            }
            return isPermitted;

        }

        public decimal? GetUserLoggedIn(string userId)
        {
            decimal? loggedIn = 0;
            BrokerUserFactory brokerUserFactory = new BrokerUserFactory();
            loggedIn = brokerUserFactory.GetAll().Where(a => a.UserId == userId).Select(a => a.is_loggedIn).FirstOrDefault();
            return loggedIn;
        }
    }


    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, Inherited = true, AllowMultiple = false)]
    public class MyAntiForgeryValidate : System.Web.Http.Filters.ActionFilterAttribute
    {
        public override void OnActionExecuting(HttpActionContext filterContext)
        {
            string cookieToken = "";
            string formToken = "";

            IEnumerable<string> tokenHeaders;
           // actionContext.Request.Headers.TryGetValues("RequestVerificationToken", out tokenHeaders
            if (filterContext.Request.Headers.TryGetValues("RequestVerificationToken", out tokenHeaders))
            {
                string[] tokens = tokenHeaders.First().Split(':');
                if (tokens.Length == 2)
                {
                    cookieToken = tokens[0].Trim();
                    cookieToken = cookieToken.Remove(0, 31);
                    formToken = tokens[1].Trim();
                }
            }
            System.Web.Helpers.AntiForgery.Validate(cookieToken, formToken);

            //base.OnActionExecuting(actionContext);
            base.OnActionExecuting(filterContext);

        }
    }
}