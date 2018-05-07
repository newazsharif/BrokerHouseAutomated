using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Trade.Interfaces;
using System.Data;
using System.Data.SqlClient;
using Escrow.Utility;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;
using Escrow.BOAS.Trade.Models;

namespace Escrow.BOAS.Trade.Factories
{
    public class ExportCashLimitFactory : IExportCashLimitFactory
    {
        #region Global Variable

        SqlConnection sqlConn;
        SqlCommand oCmd;

        XMLManager oXmlManager = new XMLManager();

        #endregion

        public DataSet getCashLimits(decimal export_dt, bool isMorning, bool isDeactivateAll, string omb_ids, string fileName, string branch_ids, decimal membership_id, string connStr)
        {
            string sqlQuery = string.Empty;
            if (isMorning == true)
            {
                if (isDeactivateAll)
                {
                    sqlQuery = "[Trade].[psp_ft_exp_client_limits]";
                }
                else
                {
                    sqlQuery = "[Trade].[psp_ft_exp_client_limits_morning]";
                }
            }
            else
            {
                sqlQuery = "[Trade].[psp_ft_exp_client_limits_intraday]";

            }

            DataSet ds = new DataSet();

            sqlConn = new SqlConnection(connStr);
            oCmd = new SqlCommand();
            oCmd.Connection = sqlConn;
            oCmd.CommandTimeout = sqlConn.ConnectionTimeout;

            oCmd.Parameters.Add("@export_dt", SqlDbType.Decimal).Value = export_dt;

            if (string.IsNullOrEmpty(omb_ids) || omb_ids == "undefined")
                oCmd.Parameters.Add("@omb_ids", SqlDbType.VarChar).Value = DBNull.Value;
            else
                oCmd.Parameters.Add("@omb_ids", SqlDbType.VarChar).Value = omb_ids;

            if (string.IsNullOrEmpty(fileName) || fileName == "undefined")
                oCmd.Parameters.Add("@file_name", SqlDbType.VarChar).Value = DBNull.Value;
            else
                oCmd.Parameters.Add("@file_name", SqlDbType.VarChar).Value = fileName;

            if (string.IsNullOrEmpty(branch_ids) || branch_ids == "undefined")
                oCmd.Parameters.Add("@branch_ids", SqlDbType.VarChar).Value = DBNull.Value;
            else
                oCmd.Parameters.Add("@branch_ids", SqlDbType.VarChar).Value = branch_ids;

            oCmd.Parameters.Add("@membership_id", SqlDbType.Decimal).Value = membership_id;

            oCmd.CommandText = sqlQuery;
            oCmd.CommandType = CommandType.StoredProcedure;

            using (oCmd)
            {

                SqlDataAdapter adapter = new SqlDataAdapter(oCmd);
                if (sqlConn.State != ConnectionState.Open) sqlConn.Open();
                try
                {
                    oCmd.Transaction = sqlConn.BeginTransaction();
                    adapter.Fill(ds);
                    oCmd.Transaction.Commit();
                }
                catch (Exception)
                {
                    if (oCmd.Transaction != null)
                            oCmd.Transaction.Rollback();
                    throw;
                }
                finally
                {
                    if (sqlConn.State != ConnectionState.Closed) sqlConn.Close();
                }
            }
            return ds;
        }

        public string ConvertToCashLimitXMLString(DataSet ds, bool isMorning, bool isDeactivateAll)
        {
            return oXmlManager.ConvertToClientsXMLString(ds, isMorning, isDeactivateAll);
        }

        public string ValidateXmlWithXsd(string xmlString, string xsdFile)
        {
            return oXmlManager.ValidateXmlWithXsd(xmlString, xsdFile);
        }

        public void RollbackExporting(decimal logId, string connStr)
        {
            try
            {
                sqlConn = new SqlConnection(connStr);
                oCmd = new SqlCommand();
                oCmd.Connection = sqlConn;
                oCmd.CommandTimeout = sqlConn.ConnectionTimeout;

                oCmd.Parameters.Add("@log_id", SqlDbType.Decimal).Value = logId;

                oCmd.CommandText = "[Trade].[psp_ft_exp_rollback]";
                oCmd.CommandType = CommandType.StoredProcedure;

                sqlConn.Open();

                oCmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
            }
            finally
            {
                sqlConn.Close();
                sqlConn.Dispose();
            }
        }
    }
}
