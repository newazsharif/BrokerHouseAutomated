using Escrow.BOAS.Service.Models;
using Escrow.Utility.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.Service.Interfaces
{
    public interface IPlaceOrderFactory : IGenericFactory<tblPlaceOrder>, IDisposable
    {
        List<ssp_pending_order_by_user_id_Result> getPendingOrderById(string UserID, decimal membership_id);

        List<ssp_placed_order_by_user_id_Result> getPlacedOrderById(string UserID, decimal membership_id);
    }
}
