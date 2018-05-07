using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using Escrow.Utility.Interfaces;
using Escrow.BOAS.Service.Interfaces;
using Escrow.BOAS.Service.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Escrow.Security.Models;
using Escrow.Security.Factories;
using Escrow.BOAS.Service.Factories;
using System.Threading.Tasks;

namespace Escrow.BOAS.Web.SignalRHub
{
    [HubName("notification")]
    public class NotificationHub : Hub
    {

        #region global variables

        private IReadOnlyFactory<tblBrokerInformation> brokerFactory;
        private IGenericFactory<AspNetUser> userFactory;
        private IGenericFactory<tblPlaceOrder> placeOrderFactory;

        private IPlaceOrderFactory iPlaceOrderFactory;

        #endregion

        public void PushNotification(string BrokerName, string UserName)
        {
            brokerFactory = new BrokerFactory();
            decimal membership_id = brokerFactory.GetAll().Where(a => a.Name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

            userFactory = new UserFactory();
            string UserId = userFactory.GetAll().Where(a => a.UserName == UserName).Select(a => a.Id).FirstOrDefault();

            iPlaceOrderFactory = new PlaceOrderFactory();

            Clients.All.response(iPlaceOrderFactory.getPendingOrderById(UserId, membership_id));
        }

        public void GetNotification(string BrokerName, string UserName)
        {
            brokerFactory = new BrokerFactory();
            decimal membership_id = brokerFactory.GetAll().Where(a => a.Name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

            userFactory = new UserFactory();
            string UserId = userFactory.GetAll().Where(a => a.UserName == UserName).Select(a => a.Id).FirstOrDefault();

            iPlaceOrderFactory = new PlaceOrderFactory();

            Clients.All.response(iPlaceOrderFactory.getPendingOrderById(UserId, membership_id).Count());
        }

        public override Task OnConnected()
        {
            return base.OnConnected();

        }

        //public void PushNotification(string msg)
        //{
        //    Clients.All.response(msg);
        //}
    }
}