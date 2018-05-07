using Escrow.BOAS.InvestorManagement.Models;
using Escrow.Service.Models;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Escrow.Service.Controllers
{
    [Authorize]
    public class InvestorController : ApiController
    {
        // GET api/<controller>

        public InvestorController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public InvestorController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;

        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region Global Variable

        private IGenericFactory<tblInvestor> investorFactory;

        #endregion

        /// <summary>
        /// Get single investor information by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>investor</returns>
        [HttpGet]
        public HttpResponseMessage getInvestorInfoById()
        {
            try
            {
                string client_id = User.Identity.GetUserName();

                tblInvestor investor = CommonUtility.getInvestorInfoById(client_id);

                if (investor != null)
                {
                    string invImageBase64String = "";
                    string invSignatureBase64String = "";
                    string joinHolderImageBase64String = "";
                    string joinHolderSignatureBase64String = "";

                    if (investor.photo != null)
                    {
                        invImageBase64String = Convert.ToBase64String(investor.photo, 0, investor.photo.Length);
                    }
                    if (investor.signature != null)
                    {
                        invSignatureBase64String = Convert.ToBase64String(investor.signature, 0, investor.signature.Length);
                    }

                    if (investor.join_holders_photo != null)
                    {
                        joinHolderImageBase64String = Convert.ToBase64String(investor.join_holders_photo, 0, investor.join_holders_photo.Length);
                    }
                    if (investor.join_holders_signature != null)
                    {
                        joinHolderSignatureBase64String = Convert.ToBase64String(investor.join_holders_signature, 0, investor.join_holders_signature.Length);
                    }

                    if (investor.active_status.ToUpper() == "ACTIVE")
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { investor = investor, se="dfs", invPic = invImageBase64String, invSignature = invSignatureBase64String, invJoinHolderPic = joinHolderImageBase64String, invJoinHolderSignature = joinHolderSignatureBase64String, success = true });
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, errorMessage = investor.active_status + " Investor" });
                    }
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = false, errorMessage = "Invalid Investor" });
                }
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.OK, new { success = false, errorMessage = ex.Message });
            }
        }
    }
}