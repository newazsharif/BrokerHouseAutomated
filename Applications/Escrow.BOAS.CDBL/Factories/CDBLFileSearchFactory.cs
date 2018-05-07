using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.CDBL.Interfaces;
using System.Data;
using System.Data.SqlClient;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;
using Escrow.BOAS.CDBL.Models;

namespace Escrow.BOAS.CDBL.Factories
{
    public class CDBLFileSearchFactory : GenericFactory<CDBLEntities, psp_export_pay_in_pay_out_Result>, ICDBLFileSearchFactory
    {
        #region global variables

        SqlConnection sqlConn;
        SqlCommand cmd;

        #endregion

        public DataTable GetCDBLFileSearch(string connStr, string tableName, string displayName, string fromDate, string toDate, string isin, string clientId, string boCode)
        {
            sqlConn = new SqlConnection(connStr);

            DataTable dt = new DataTable();
            try
            {
                using (SqlCommand cmd = new SqlCommand("CDBL.ssp_cdbl_search", sqlConn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 200;

                    cmd.Parameters.Add("@table_name", SqlDbType.VarChar).Value = tableName;

                    cmd.Parameters.Add("@display_name", SqlDbType.VarChar).Value = displayName;

                    cmd.Parameters.Add("@from_date", SqlDbType.VarChar).Value = fromDate;

                    cmd.Parameters.Add("@to_date", SqlDbType.VarChar).Value = toDate;

                    if (string.IsNullOrEmpty(isin) || isin == "undefined")
                        cmd.Parameters.Add("@isin", SqlDbType.VarChar).Value = DBNull.Value;
                    else
                        cmd.Parameters.Add("@isin", SqlDbType.VarChar).Value = isin;

                    if (string.IsNullOrEmpty(clientId) || clientId == "undefined")
                        cmd.Parameters.Add("@cliend_id", SqlDbType.VarChar).Value = DBNull.Value;
                    else
                        cmd.Parameters.Add("@cliend_id", SqlDbType.VarChar).Value = clientId;

                    if (string.IsNullOrEmpty(boCode) || boCode == "undefined")
                        cmd.Parameters.Add("@bo_code", SqlDbType.VarChar).Value = DBNull.Value;
                    else
                        cmd.Parameters.Add("@bo_code", SqlDbType.VarChar).Value = boCode;

                    sqlConn.Open();

                    using (var da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }

                    sqlConn.Close();
                    sqlConn.Dispose();
                }

                return dt;
            }
            catch (Exception)
            {
                sqlConn.Close();
                sqlConn.Dispose();

                return dt;
            }
        }

        public void UpdateRightsMarketPrice(string fromDate, string toDate, string isin, string clientId, string boCode)
        {
            try
            {
                if (string.IsNullOrEmpty(isin) || isin == "undefined")
                    isin = "";

                if (string.IsNullOrEmpty(clientId) || clientId == "undefined")
                    clientId = "";

                if (string.IsNullOrEmpty(boCode) || boCode == "undefined")
                    boCode = "";

                this.Context.usp_rights_market_price(fromDate, toDate, isin, clientId, boCode);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void UpdateRightsUnitPrice(string fromDate, string toDate, string isin, string clientId, string boCode, string unitPrice)
        {
            try
            {
                if (string.IsNullOrEmpty(isin) || isin == "undefined")
                    isin = "";

                if (string.IsNullOrEmpty(clientId) || clientId == "undefined")
                    clientId = "";

                if (string.IsNullOrEmpty(boCode) || boCode == "undefined")
                    boCode = "";

                this.Context.usp_rights_unit_price(fromDate, toDate, isin, clientId, boCode, unitPrice);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
