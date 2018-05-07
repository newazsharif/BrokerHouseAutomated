using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.BOAS.Configuration.Models;
using Escrow.BOAS.Configuration.Factories;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Web
{
    public static class DateTimeConfig
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