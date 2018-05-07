using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.InstrumentManagement.Models
{
    [MetadataType(typeof(tblInstrumentmetadata))]

    public partial  class tblInstrument
    {
        public class tblInstrumentmetadata
        {
            [StringLength(12, ErrorMessage="ISIN should be 12 digits only")]
            public string isin { get; set; }
            [Required (ErrorMessage="Please Provide Security Code")]
            public string security_code { get; set; }
            [Required (ErrorMessage="Please Provide Instrument Name")]
            public string instrument_name { get; set; }
            [Required(ErrorMessage = "Please Select Sector")]
            public int sector_id { get; set; }
            [Required(ErrorMessage="Please Select Depository Company")]
            public int depository_company_id { get; set; }
            [Required(ErrorMessage="Please Provide Face Value")]
            public decimal face_value { get; set; }
            [Required(ErrorMessage = "Please Provide Lot")]
            public decimal lot { get; set; }
            [Required(ErrorMessage="Please Select Group")]
            public int group_id { get; set; }
        }
    }
    
}
