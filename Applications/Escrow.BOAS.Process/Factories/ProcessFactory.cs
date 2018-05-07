using Escrow.BOAS.Process.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Configuration;


namespace Escrow.BOAS.Process.Factories
{
    public class ProcessFactory : GenericFactory<ProcessEntities, tblDayProcess>
    {
        public void DayEndProcess(int process_dt, string end_by, decimal membership_id)
        {
            this.Context.psp_day_end(process_dt, end_by, membership_id);
        }

        public void DayEndByCMD(int process_dt, string end_by, decimal membership_id)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("psp_day_end", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@process_dt", SqlDbType.Decimal).Value = process_dt;
                    cmd.Parameters.Add("@end_by", SqlDbType.NVarChar).Value = end_by;
                    cmd.Parameters.Add("@membership_id", SqlDbType.Decimal).Value = membership_id;

                    con.Open();
                    cmd.CommandTimeout = 200;
                    cmd.ExecuteNonQuery();
                    con.Close();
                }

            }
        }

        public void DBBackupProcess(string name, string path)
        {
            //this.Context.psp_db_backup(name, path);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("psp_db_backup", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@name", SqlDbType.VarChar).Value = name;
                    cmd.Parameters.Add("@path", SqlDbType.VarChar).Value = path;

                    con.Open();
                    cmd.CommandTimeout = 1000;
                    cmd.ExecuteNonQuery();
                    con.Close();
                }

            }
        }
    }
}
