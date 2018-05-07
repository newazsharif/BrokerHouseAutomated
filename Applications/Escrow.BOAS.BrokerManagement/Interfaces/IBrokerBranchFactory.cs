using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.Utility.Interfaces;
using Escrow.BOAS.BrokerManagement.Models;

namespace Escrow.BOAS.BrokerManagement.Interfaces
{
    public interface IBrokerBranchFactory : IGenericFactory<tblBrokerBranch>, IDisposable
    {
        List<ssp_branches_by_user_id_Result> getBrokerByUserAndMember(string user_id, decimal membership_id);
    }
}
