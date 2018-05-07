using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.Trade.Models
{
    public partial class TradeEntities : DbContext
    {
        public TradeEntities(bool TimeFromWebConfig)
            : base("name=TradeEntities")
        {
            this.Database.CommandTimeout = this.Database.Connection.ConnectionTimeout;
        }

        
    
    }
}
