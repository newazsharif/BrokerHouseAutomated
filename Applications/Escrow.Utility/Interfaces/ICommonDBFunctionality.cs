using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.Utility.Interfaces
{
    public interface ICommonDBFunctionality
    {
        bool sqlBulkCopy(DataTable dt, string connStr);
    }
}
