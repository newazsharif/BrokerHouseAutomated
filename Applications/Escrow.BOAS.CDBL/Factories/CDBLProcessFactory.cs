using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.CDBL.Interfaces;
using Escrow.BOAS.CDBL.Models;
using Escrow.Utility.Factories;
using System.Data;
using System.Data.SqlClient;

namespace Escrow.BOAS.CDBL.Factories
{
    public class CDBLProcessFactory : GenericFactory<CDBLEntities, ssp_CDBL_invalid_data_list_Result>, ICDBLProcessFactory
    {
        #region global variables

        SqlConnection sqlConn;
        SqlCommand cmd;

        #endregion

        public string ProcessCdbl(string connStr, string displayNames, string fromDate, string toDate, decimal membershipId, string changedUserId, DateTime changedDate, decimal isDirty)
        {
            sqlConn = new SqlConnection(connStr);

            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand();

            try
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 200;
                cmd.CommandText = "CDBL.psp_cdbl";

                cmd.Parameters.Add("@display_names", SqlDbType.VarChar).Value = displayNames;

                cmd.Parameters.Add("@from_date", SqlDbType.VarChar).Value = fromDate;

                cmd.Parameters.Add("@to_date", SqlDbType.VarChar).Value = toDate;

                cmd.Parameters.Add("@membership_id", SqlDbType.Decimal).Value = membershipId;

                cmd.Parameters.Add("@changed_user_id", SqlDbType.NVarChar).Value = changedUserId;

                cmd.Parameters.Add("@changed_date", SqlDbType.DateTime).Value = changedDate;

                cmd.Parameters.Add("@is_dirty", SqlDbType.Decimal).Value = isDirty;

                cmd.Parameters.Add("@result", SqlDbType.VarChar, 8000);

                cmd.Parameters["@result"].Direction = ParameterDirection.Output;

                cmd.Connection = sqlConn;

                sqlConn.Open();

                cmd.ExecuteNonQuery();

                return (string)cmd.Parameters["@result"].Value;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            finally
            {
                sqlConn.Close();
                sqlConn.Dispose();
            }
        }

        public List<ssp_CDBL_invalid_data_list_process_Result> getInvalidDataListForProcess(string display_names)
        {
            List<ssp_CDBL_invalid_data_list_process_Result> obj = Context.ssp_CDBL_invalid_data_list_process(display_names).ToList();

            return obj;
        }

        public List<ssp_CDBL_invalid_data_list_Result> getInvalidDataList(string display_names)
        {
            List<ssp_CDBL_invalid_data_list_Result> obj = Context.ssp_CDBL_invalid_data_list(display_names).ToList();

            return obj;
        }
    }
}
