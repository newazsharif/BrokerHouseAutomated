using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Transaction.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;
using System.Transactions;
using Escrow.BOAS.Transaction.Interfaces;
using System.Data;
using System.Data.SqlClient;

namespace Escrow.BOAS.Transaction.Factories
{
    public class FundReceiveFactory : GenericFactory<TransactionEntities, tblFundReceive>, IFundReceiveFactory
    {
        #region global variables

        SqlConnection sqlConn;
        SqlCommand cmd;

        #endregion

        public override void Save(string id, decimal financial_ledger_type_id, decimal membership_id, string changed_user_id)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    base.Save();
                    this.Context.psp_investor_financial_transaction(id, financial_ledger_type_id, membership_id, changed_user_id);
                    scope.Complete();
                }
                catch (Exception ex)
                {
                    System.Transactions.Transaction.Current.Rollback();
                    throw ex;
                }
                finally
                {
                    scope.Dispose();
                }
            }
        }

        public DataTable getMoneyReceipt(string voucher_no, decimal membership_id, string changed_user_id, string connStr)
        {
            sqlConn = new SqlConnection(connStr);

            DataTable dt = new DataTable();
            try
            {
                using (SqlCommand cmd = new SqlCommand("[Transaction].[rsp_money_receipt]", sqlConn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@membership_id", SqlDbType.Decimal).Value = membership_id;
                    cmd.Parameters.Add("@user_id", SqlDbType.VarChar).Value = changed_user_id;
                    cmd.Parameters.Add("@voucher_no", SqlDbType.VarChar).Value = voucher_no;

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
