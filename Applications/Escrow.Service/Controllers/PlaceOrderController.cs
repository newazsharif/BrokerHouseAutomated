using Escrow.BOAS.Service.Factories;
using Escrow.BOAS.Service.Models;
using Escrow.Security.Factories;
using Escrow.Security.Models;
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
    public class PlaceOrderController : ApiController
    {
        // GET api/<controller>

        public PlaceOrderController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public PlaceOrderController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;

        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region Global Variable

        private IReadOnlyFactory<tblBrokerInformation> brokerFactory;
        private IGenericFactory<tblPlaceOrder> placeOrderFactory;

        #endregion

        // POST api/<controller>
        [HttpPost]
        public HttpResponseMessage OrderPlace([FromBody]tblPlaceOrder placeOrder, string BrokerName)
        {
            try
            {
                brokerFactory = new BrokerFactory();
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

                placeOrderFactory = new PlaceOrderFactory();

                tblPlaceOrder obj = new tblPlaceOrder();

                obj = placeOrder;

                obj.client_id = User.Identity.GetUserName();
                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;

                placeOrderFactory.Add(obj);
                placeOrderFactory.Save();

                return Request.CreateResponse(HttpStatusCode.Created);
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}