using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Service.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;
using Escrow.BOAS.Service.Interfaces;

namespace Escrow.BOAS.Service.Factories
{
    public class PlaceOrderFactory : GenericFactory<ServiceEntities, tblPlaceOrder>, IPlaceOrderFactory
    {
        public List<ssp_pending_order_by_user_id_Result> getPendingOrderById(string UserID, decimal membership_id)
        {
            List<ssp_pending_order_by_user_id_Result> obj = Context.ssp_pending_order_by_user_id(UserID, membership_id).ToList();

            return obj;
        }
        public List<ssp_placed_order_by_user_id_Result> getPlacedOrderById(string UserID, decimal membership_id)
        {
            List<ssp_placed_order_by_user_id_Result> obj = Context.ssp_placed_order_by_user_id(UserID, membership_id).ToList();
           // List<ssp_placed_order_by_user_id_Result> obj = Context.ssp_placed_order_by_user_id1

            return obj;
        }
    }
}
