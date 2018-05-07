using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Escrow.BOAS.Web.Models
{
    public class EmailVM
    {
        public string client_id { get; set; }
        public string email_address { get; set; }
        public string status { get; set; } 
    }
}