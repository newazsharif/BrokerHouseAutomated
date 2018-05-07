using Escrow.BOAS.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Escrow.BOAS.Web.Areas.Service.Controllers
{
    public class ExportExcelForSMSController : Controller
    {
        // GET: Service/ExportExcelForSMS
        public ActionResult Index()
        {
            return View();
        }

        [CheckUserSessionAttribute]
        public ActionResult ExcelExportForSMS()
        {
            return View();
        }

        public JsonResult SetExcelExportForSMS()
        {
            var data = ConfigManager.sms_excel_file_path;
            return Json(new { data = data, success = true }, JsonRequestBehavior.AllowGet);
        }

        [CheckUserSessionAttribute]
        public JsonResult ExportExcelFileForSMS(string oCode, string fileName)
        {
            try
            {
                var connectionString = ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString;
                using (var conn = new SqlConnection(connectionString))
                using (var command = new SqlCommand("[psp_export_sms]", conn)
                {
                    CommandType = CommandType.StoredProcedure
              
                })
                {
                    command.Parameters.Add(new SqlParameter("@OCode", oCode));
                    command.Parameters.Add(new SqlParameter("@fileName", fileName));
                    conn.Open();
                    command.ExecuteNonQuery();
                    conn.Close();
                }
                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {                
               return Json(new { success = false }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}