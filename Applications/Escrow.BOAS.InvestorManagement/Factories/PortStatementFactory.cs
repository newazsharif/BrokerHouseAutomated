
using Escrow.BOAS.InvestorManagement.Interfaces;
using Escrow.BOAS.InvestorManagement.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.InvestorManagement.Factories
{
    public class PortStatementFactory : GenericFactory<InvestorEntities, tblInvestor>,IPortStatementFactory
    {
        #region global variables

        SqlConnection sqlConn;
        SqlCommand cmd;

        #endregion


        public DataTable getPortfolioStatement(decimal membership_id, string changed_user_id, string client_id, DateTime date, string connStr)
        {
            sqlConn = new SqlConnection(connStr);

            DataTable dt = new DataTable();
            try
            {
                using (SqlCommand cmd = new SqlCommand("[Investor].[rsp_client_portfolio_statement_as_on]", sqlConn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@MEMBERSHIP_ID", SqlDbType.Decimal).Value = membership_id;
                    cmd.Parameters.Add("@user_id", SqlDbType.VarChar).Value = changed_user_id;
                    cmd.Parameters.Add("@CLIENT_ID", SqlDbType.VarChar).Value = client_id;
                    cmd.Parameters.Add("@REPORT_DATE", SqlDbType.Date).Value = date;

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
    }
}
