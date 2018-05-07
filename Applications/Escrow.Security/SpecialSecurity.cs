using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.Security.Factories;

namespace Escrow.Security
{
    public class SpecialSecurity
    {
        private SpecialPermissionFactory specialPermissionFactory;
        public bool IsPermitted(string investorCode, string userId)
        {
            specialPermissionFactory = new SpecialPermissionFactory();
            //bool isItPermitted = true;
            if (specialPermissionFactory.GetAll().Any(a => a.Client_id == investorCode))
            {
                if (specialPermissionFactory.GetAll().Any(a => a.Client_id == investorCode && a.user_id == userId))
                {
                    return true;
                }
                return false;
            }
            return true;
        }
    }
}
