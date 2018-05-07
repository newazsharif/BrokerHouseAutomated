using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Trade.Interfaces;
using System.Data;
using System.Data.SqlClient;
using System.Transactions;

namespace Escrow.BOAS.Trade.Factories
{
    public class ImportCashLimitFactory : IImportCashLimitFactory
    {
        #region global variables

        SqlConnection sqlConn;
        SqlCommand cmd;

        #endregion
        public string UploadCashLimitsFile(string connStr, decimal membership_id, decimal import_dt, string omnibus_master_id)
        {
            sqlConn = new SqlConnection(connStr);

            DataSet ds = new DataSet();
            try
            {
                using (SqlCommand cmd = new SqlCommand("Trade.ssp_ft_validate_omb_limits", sqlConn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@membership_id", SqlDbType.Decimal).Value = membership_id;

                    cmd.Parameters.Add("@import_dt", SqlDbType.Decimal).Value = import_dt;

                    cmd.Parameters.Add("@omnibus_master_id", SqlDbType.VarChar).Value = omnibus_master_id;

                    sqlConn.Open();

                    using (var da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }

                    sqlConn.Close();
                    sqlConn.Dispose();
                }

                if (ds.Tables.Count == 0)
                {
                    return string.Empty;
                }
                else
                {
                    return ConvertDataErrorToString(ds);
                }
            }
            catch (Exception ex)
            {
                sqlConn.Close();
                sqlConn.Dispose();

                return ex.Message;
            }
        }

        public void importCashLimits(string connStr, decimal membership_id, decimal import_dt, string file_name, string omnibus_master_id, string changed_user_id, DateTime changed_date)
        {
            sqlConn = new SqlConnection(connStr);

            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand();

            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Trade.psp_ft_imp_omb_limits";

                    cmd.Parameters.Add("@membership_id", SqlDbType.Decimal).Value = membership_id;

                    cmd.Parameters.Add("@import_dt", SqlDbType.Decimal).Value = import_dt;

                    cmd.Parameters.Add("@file_name", SqlDbType.VarChar).Value = file_name;

                    cmd.Parameters.Add("@omnibus_master_id", SqlDbType.VarChar).Value = omnibus_master_id;

                    cmd.Parameters.Add("@changed_user_id", SqlDbType.VarChar).Value = changed_user_id;

                    cmd.Parameters.Add("@changed_date", SqlDbType.DateTime).Value = changed_date;

                    cmd.Connection = sqlConn;

                    sqlConn.Open();

                    cmd.ExecuteNonQuery();

                    scope.Complete();
                }
                catch (Exception)
                {
                    System.Transactions.Transaction.Current.Rollback();
                    throw;
                }
                finally
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                    scope.Dispose();
                }
            }
        }

        private string ConvertDataErrorToString(DataSet dsErrors)
        {
            StringBuilder sbErrors = new StringBuilder();

            foreach (DataTable table in dsErrors.Tables)
            {
                if (table.Rows.Count > 0)
                {
                    string title = table.Rows[0][1].ToString();
                    sbErrors.Append(title);
                    foreach (DataRow row in table.Rows)
                    {
                        sbErrors.Append(row[0].ToString());
                        sbErrors.Append(", ");
                    }
                    sbErrors.Remove(sbErrors.Length - 2, 2);
                }
                sbErrors.AppendLine();
            }

            return sbErrors.ToString().Trim();
        }
    }
}
