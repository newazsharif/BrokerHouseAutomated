using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Escrow.BOAS.Configuration.Models
{
    [MetadataType(typeof(tblConstantObjectMetadata))]

    public partial class tblConstantObject
    {
        public class tblConstantObjectMetadata
        {
            [Required]
            [Display(Name = "Object Name")]
            public string object_name { get; set; }

            [Display(Name = "Purpose")]
            public string Purpose { get; set; }
        }
    }
}
