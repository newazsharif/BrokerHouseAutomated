using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.OAuth;
using Escrow.Service.Models;
using Escrow.Utility.Interfaces;
using Escrow.Security.Models;
using Escrow.Security.Factories;
using Escrow.BOAS.InvestorManagement.Factories;

namespace Escrow.Service.Providers
{

    public class ApplicationOAuthProvider : OAuthAuthorizationServerProvider
    {
        private readonly string _publicClientId;

        public ApplicationOAuthProvider(string publicClientId)
        {
            if (publicClientId == null)
            {
                throw new ArgumentNullException("publicClientId");
            }

            _publicClientId = publicClientId;
        }

        public ApplicationOAuthProvider()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ApplicationOAuthProvider(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;

        }


        #region Global Variable

        private IGenericFactory<tblBrokerUser> brokerUserFactory;
        private IReadOnlyFactory<tblDayProcess> dayProcessFactory;

        #endregion

        public UserManager<ApplicationUser> UserManager { get; private set; }

        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            var userManager = context.OwinContext.GetUserManager<ApplicationUserManager>();

            ApplicationUser user = await userManager.FindAsync(context.UserName, context.Password);

            var data = await context.Request.ReadFormAsync();

            string BrokerName = data["BrokerName"].ToString();

            if (user != null)
            {
                brokerUserFactory = new BrokerUserFactory();
                tblBrokerUser brokerUser = brokerUserFactory.FindBy(u => u.tblBrokerInformation.short_name == BrokerName && u.UserId == user.Id).FirstOrDefault();

                var userName = brokerUser.AspNetUser.UserName;

                InvestorFactory investorFactory = new Escrow.BOAS.InvestorManagement.Factories.InvestorFactory();

                var investor = investorFactory.FindBy(a => a.client_id == userName).FirstOrDefault();
                if(investor != null && brokerUser.approve_by == null )
                {
                    context.SetError("invalid_grant", "Unapproved Broker user");
                    return;
                }
                else if (brokerUser != null &&  investor != null)
                {
                    dayProcessFactory = new DayProcessFactory();

                    DateTime processDate = dayProcessFactory.GetAll().OrderByDescending(a => a.process_date).Select(a => a.DimDate.Date).FirstOrDefault() ?? DateTime.Now;
                    brokerUser.is_loggedIn = 1;
                    brokerUser.last_logged_time = DateTime.Now;
                    brokerUserFactory.Edit(brokerUser);
                    brokerUserFactory.Save();

                    ClaimsIdentity oAuthIdentity = await user.GenerateUserIdentityAsync(userManager,
                       OAuthDefaults.AuthenticationType);
                    ClaimsIdentity cookiesIdentity = await user.GenerateUserIdentityAsync(userManager,
                        CookieAuthenticationDefaults.AuthenticationType);

                    AuthenticationProperties properties = CreateProperties(user.UserName);
                    AuthenticationTicket ticket = new AuthenticationTicket(oAuthIdentity, properties);
                    context.Validated(ticket);
                    context.Request.Context.Authentication.SignIn(cookiesIdentity);
                }
                else
                {
                    context.SetError("invalid_grant", "Invalid broker or user id or password.");
                    return;
                }
            }
            else
            {
                context.SetError("invalid_grant", "Invalid broker or user id or password.");
                return;
            }
        }

        public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        {
            foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
            {
                context.AdditionalResponseParameters.Add(property.Key, property.Value);
            }

            return Task.FromResult<object>(null);
        }

        public override Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            // Resource owner password credentials does not provide a client ID.
            if (context.ClientId == null)
            {
                context.Validated();
            }

            return Task.FromResult<object>(null);
        }

        public override Task ValidateClientRedirectUri(OAuthValidateClientRedirectUriContext context)
        {
            if (context.ClientId == _publicClientId)
            {
                Uri expectedRootUri = new Uri(context.Request.Uri, "/");

                if (expectedRootUri.AbsoluteUri == context.RedirectUri)
                {
                    context.Validated();
                }
            }

            return Task.FromResult<object>(null);
        }

        public static AuthenticationProperties CreateProperties(string userName)
        {
            IDictionary<string, string> data = new Dictionary<string, string>
            {
                { "userName", userName }
            };
            return new AuthenticationProperties(data);
        }
    }
}