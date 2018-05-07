using Escrow.BOAS.BrokerManagement.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.BrokerManagement.Interfaces;

namespace Escrow.BOAS.BrokerManagement.Factories
{
    public class BrokerBranchFactory : GenericFactory<BrokerManagementEntities, tblBrokerBranch>, IBrokerBranchFactory
    {
        public List<ssp_branches_by_user_id_Result> getBrokerByUserAndMember(string user_id, decimal membership_id)
        {
            List<ssp_branches_by_user_id_Result> obj = this.Context.ssp_branches_by_user_id(user_id, membership_id).ToList();
            return obj;
        }
    }
}
