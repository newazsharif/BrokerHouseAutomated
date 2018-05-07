using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Escrow.Service
{
    public class DateTimeConfig
    {
        public static decimal FullDateUKtoDateKey(string strDate)
        {
            return Convert.ToDecimal(strDate.Substring(6, 4) + strDate.Substring(3, 2) + strDate.Substring(0, 2));
        }
        public static string DateKeytoFullDateUK(string strDate)
        {
            return strDate.Substring(6, 2) + "/" + strDate.Substring(4, 2) + "/" + strDate.Substring(0, 4);
        }
    }
}