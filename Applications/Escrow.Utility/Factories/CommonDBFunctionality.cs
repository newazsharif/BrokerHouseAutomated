using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.Utility.Interfaces;
using System.Data.SqlClient;
using System.Data;


namespace Escrow.Utility.Factories
{
    public class CommonDBFunctionality: ICommonDBFunctionality
    {

        #region global variables

        SqlConnection sqlConn;
        SqlCommand cmd;

        #endregion

        public bool sqlBulkCopy(DataTable dt, string connStr)
        {
            try
            {
                sqlConn = new SqlConnection(connStr);
                cmd = new SqlCommand();
                cmd.Connection = sqlConn;
                //cmd.CommandTimeout = sqlConn.ConnectionTimeout;

                using (cmd)
                {
                    cmd.CommandText = "TRUNCATE TABLE " + dt.TableName;
                    sqlConn.Open();
                    cmd.ExecuteNonQuery();
                    sqlConn.Close();
                }
                if (dt.Rows.Count > 0)
                {
                    using (SqlBulkCopy bulkcopy = new SqlBulkCopy(sqlConn))
                    {
                        bulkcopy.DestinationTableName = dt.TableName;
                        bulkcopy.BatchSize = dt.Rows.Count;
                        sqlConn.Open();
                        bulkcopy.WriteToServer(dt);
                        bulkcopy.Close();
                        sqlConn.Close();
                    }
                }

                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}
