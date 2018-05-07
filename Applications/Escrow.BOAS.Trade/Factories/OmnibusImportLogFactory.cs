using Escrow.BOAS.Trade.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Trade.Interfaces;

namespace Escrow.BOAS.Trade.Factories
{
    public class OmnibusImportLogFactory : GenericFactory<TradeEntities, tblFTOmnibusImportLog>, IOmnibusImportLogFactory
    {
        public dynamic getImportLogListByType(string file_type, decimal membership_id, bool is_for_import)
        {
            var obj = (dynamic)null;

            if (is_for_import)
            {
                obj = (from tfil in this.Context.tblFTOmnibusImportLogs
                       join ddid in this.Context.DimDates on tfil.import_dt equals ddid.DateKey
                           into ddids
                       from ddid in ddids.DefaultIfEmpty()
                       where tfil.file_type == file_type && tfil.membership_id == membership_id && (tfil.export_st == null || tfil.export_st == 0)
                       orderby tfil.log_id
                       select new
                       {
                           id = tfil.log_id,
                           file_type = tfil.file_type.ToUpper(),
                           tfil.file_name,
                           import_dt = ddid.FullDateUK,
                           tfil.version_no,
                           exported = (tfil.export_st == null ? "N" : (tfil.export_st == 0 ? "N" : "Y"))
                       }
                        ).ToList();
            }
            else
            {
                obj = (from tfil in this.Context.tblFTOmnibusImportLogs
                       join ddid in this.Context.DimDates on tfil.import_dt equals ddid.DateKey
                           into ddids
                       from ddid in ddids.DefaultIfEmpty()
                       where tfil.file_type == file_type && tfil.membership_id == membership_id
                       orderby tfil.log_id
                       select new
                       {
                           id = tfil.log_id,
                           file_type = tfil.file_type.ToUpper(),
                           tfil.file_name,
                           import_dt = ddid.FullDateUK,
                           tfil.version_no,
                           exported = (tfil.export_st == null ? "N" : (tfil.export_st == 0 ? "N" : "Y"))
                       }
                        ).ToList();
            }

            return obj;
        }
    }
}
