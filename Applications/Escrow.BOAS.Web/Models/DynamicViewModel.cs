using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Escrow.BOAS.Web.Models
{
    public class DynamicViewModel
    {
        public string field_id { get; set; }
        public string field_type { get; set; }
        public string field_label { get; set; }
        public string field_value { get; set; }
        public string field_value_dt { get; set; }
        public string max { get; set; }
        public string min { get; set; }
        public bool is_field_required { get; set; }
        public string number_type { get; set; }
    }
}