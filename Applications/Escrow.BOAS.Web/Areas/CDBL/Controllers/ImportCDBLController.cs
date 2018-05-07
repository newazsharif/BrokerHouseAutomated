using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Security.Models;
using Escrow.Security.Factories;
using System.Data;
using Escrow.BOAS.CDBL.Factories;
using Escrow.BOAS.CDBL.Interfaces;
using Escrow.BOAS.CDBL.Models;
using Escrow.BOAS.Utility;
using System.Web.Configuration;
using System.IO;
using Escrow.Utility.Interfaces;
using System.Configuration;
using Escrow.Utility.Factories;


///=============================================================
///Created by: Asif
///Created date: 5/10/2015
///Reason: Import CDBL Transaction Files Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.CDBL.Controllers
{
    public class ImportCDBLController : Controller
    {
        // GET: CDBL/ImportCDBL

        #region global variables

        private IXsdDatasetMapper xmlDatasetMapper;

        private string cdbl_file_path = ConfigManager.cdbl_file_path;

        private ITextFileReader textFileReader;

        private ICommonDBFunctionality commonDBFunctionality;

        private ICDBLFileImportFactory cdblFileImportFactory;

        #endregion

        public ImportCDBLController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ImportCDBLController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Import CDBL Transaction Files view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ImportCDBLTransactionFiles()
        {
            return View();
        }

        /// <summary>
        /// Get CDBL transaction files name list
        /// </summary>
        /// <param></param>
        /// <returns>CDBL transaction files name list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getCDBLFileList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                xmlDatasetMapper = new XsdDatasetMapper(Server.MapPath("~/xsdCDBL.xsd"));

                List<CDBLFileModel> CDBLFileList = xmlDatasetMapper.GetTableDisplayNames();

                return Json(new { CDBLFileList = CDBLFileList, cdbl_file_path = cdbl_file_path, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Import CDBL transaction files
        /// </summary>
        /// <param name="selected">Selected file list for import</param>
        /// /// <param name="from_date">from date</param>
        /// /// <param name="to_date">to date</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult importCDBLTransFiles(string[] selected, string from_date, string to_date)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                string[] frmDt = from_date.Split('/');

                from_date = frmDt[1] + "/" + frmDt[0] + "/" + frmDt[2];

                string[] toDt = to_date.Split('/');

                to_date = toDt[1] + "/" + toDt[0] + "/" + toDt[2];

                DateTime fromDate = Convert.ToDateTime(from_date);

                DateTime toDate = Convert.ToDateTime(to_date);

                string filePath = "";

                string dirPath = "";

                bool doesDirExist = false;

                bool doesFileExist = false;

                string fileName = "";

                string msg = "";

                DataTable dt;

                string displayNames = "";

                for (int i = 0; i < selected.Count(); i++)
                {
                    displayNames += selected[i] + ',';

                    xmlDatasetMapper = new XsdDatasetMapper(Server.MapPath("~/xsdCDBL.xsd"));
                    dt = new DataTable();

                    for (var day = fromDate.Date; day.Date <= toDate.Date; day = day.AddDays(1))
                    {
                        dirPath = cdbl_file_path + "/" + day.ToString("ddMMMyyyy");
                        doesDirExist = Directory.Exists(dirPath);

                        if (doesDirExist)
                        {
                            fileName = xmlDatasetMapper.GetFileName(selected[i], true);
                            filePath = dirPath + "/" + fileName;

                            doesFileExist = System.IO.File.Exists(filePath);

                            if (doesFileExist)
                            {
                                if (i == 0 || selected[i] != selected[i - 1])
                                {
                                    dt = xmlDatasetMapper.GetTable(selected[i]);
                                }

                                textFileReader = new TextFileReader();

                                msg = textFileReader.ReadCDBLFile(filePath, ref dt, 1, '~', day.ToString("dd-MMM-yyyy").ToUpper());
                            }
                        }
                    }
                    if (dt.Rows.Count > 0)
                    {
                        dt.TableName = "[Escrow.BOAS].[CDBL].[" + dt.TableName.Substring(dt.TableName.LastIndexOf('_') + 1) + "]";

                        commonDBFunctionality = new CommonDBFunctionality();

                        bool isSuccess = commonDBFunctionality.sqlBulkCopy(dt, ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);
                    }
                }

                cdblFileImportFactory = new CDBLFileImportFactory();

                List<ssp_CDBL_invalid_data_list_Result> errorList = cdblFileImportFactory.getInvalidDataList(displayNames);

                if (errorList.Count > 0)
                {
                    return Json(new { success = false, errorList = errorList, errorType = "list" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { success = true }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (cdblFileImportFactory != null)
            {
                cdblFileImportFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}