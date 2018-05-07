using Escrow.BOAS.Web.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.Utility.Interfaces;
using Escrow.Utility.Factories;
using System.Configuration;
using Escrow.BOAS.Trade.Interfaces;
using Escrow.BOAS.Trade.Factories;
using Escrow.BOAS.Utility;


///=============================================================
///Created by: Asif
///Created date: 27/12/2015
///Reason: Import Cash Limit Controller
///=============================================================


namespace Escrow.BOAS.Web.Areas.Trade.Controllers
{
    public class ImportCashLimitController : Controller
    {
        // GET: Trade/ImportCashLimit

        #region global variables

        private ICommonDBFunctionality commonDBFunctionality;

        private IImportCashLimitFactory importCashLimitFactory;

        private IOmnibusImportLogFactory importLogFactory;

        private DataTable tblLimits
        {
            get
            {
                DataTable dt = new DataTable("Trade.tblFTOmnibusLimitsTemp");
                dt.Columns.Add(new DataColumn("client_code"));
                dt.Columns.Add(new DataColumn("boid"));
                dt.Columns.Add(new DataColumn("client_name"));
                dt.Columns.Add(new DataColumn("client_type"));
                dt.Columns.Add(new DataColumn("buy_limit"));
                dt.Columns.Add(new DataColumn("panic_withdraw"));
                dt.Columns.Add(new DataColumn("timest"));
                return dt;
            }
        }

        #endregion

        public ImportCashLimitController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ImportCashLimitController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region load dropdown


        /// <summary>
        /// Get all omnibus master
        /// </summary>
        /// <param></param>
        /// <returns>omnibus master list in json</returns>
        //[Authorize]
        public JsonResult getOmnibusMasterDdlList()
        {
            var omnibusMasterList = DropDown.ddlOmnibusMaster();

            return Json(omnibusMasterList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Import Cash Limit view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ImpCashLimit()
        {
            return View();
        }

        /// <summary>
        /// Upload cash limits from text to temporary table
        /// </summary>
        /// <param name="file">text file</param>
        /// <returns>success or error list</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult uploadCashLimitFromText(HttpPostedFileBase file, decimal import_dt, string omnibus_master_id)
        {
            try
            {
                DataTable dt = ConvertToDatatable(file.InputStream);

                if(dt == null || dt.Rows.Count == 0)
                {
                    return Json(new { success = false, errorMsg = "Record not found" }, JsonRequestBehavior.AllowGet);
                }
                else
                {

                    DataColumn newColumn = new DataColumn("membership_id", typeof(System.Decimal));
                    newColumn.DefaultValue = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                    dt.Columns.Add(newColumn);

                    newColumn = new DataColumn("omnibus_master_id", typeof(System.String));
                    newColumn.DefaultValue = omnibus_master_id;
                    dt.Columns.Add(newColumn);

                    commonDBFunctionality = new CommonDBFunctionality();

                    bool isSuccess = commonDBFunctionality.sqlBulkCopy(dt, ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);

                    if(isSuccess)
                    {
                        importCashLimitFactory = new ImportCashLimitFactory();

                        string errorMsg = importCashLimitFactory.UploadCashLimitsFile(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString, SessionManger.BrokerOfLoggedInUser(Session).membership_id, import_dt, omnibus_master_id);

                        if(errorMsg.Trim().Length > 0)
                        {
                            return Json(new { success = false, errorMsg = errorMsg }, JsonRequestBehavior.AllowGet);
                        }
                        else
                        {
                            return Json(new { success = true }, JsonRequestBehavior.AllowGet);
                        }
                    }
                    else
                    {
                        return Json(new { success = false, errorMsg = "Failed to Upload Please Try Again" }, JsonRequestBehavior.AllowGet);
                    }
                }
            }
            catch (Exception ex)
            {
                return Json(new { errorMsg = ex.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        public DataTable ConvertToDatatable(Stream strm)
        {
            DataTable dt = tblLimits;
            DataRow row = null;
            char cSplit = char.MinValue;

            cSplit = '~';
            try
            {
                StreamReader sr = new StreamReader(strm);
                string[] value = null;


                int lineNumber = 0;
                string error = string.Empty;
                while (!sr.EndOfStream)
                {
                    value = sr.ReadLine().Split(cSplit);
                    lineNumber += 1;
                    if (value.Length == dt.Columns.Count)
                    {
                        row = dt.NewRow();
                        row.ItemArray = value;
                        dt.Rows.Add(row);
                    }
                    else
                    {

                        error += lineNumber.ToString() + ", ";
                    }
                }
                if (error.Length > 2)
                {
                    error = error.Remove(error.Length - 2);
                    throw new Exception("Error found in line numbers: " + error);
                }
                return dt;
            }
            catch
            {
                throw;
            }
        }

        /// <summary>
        /// Import cash limits from temp to main table
        /// </summary>
        /// <param name="import_dt">import date</param>
        /// <param name="omnibus_master_id">omnibus master id</param>
        /// <param name="file_name">name of the text file</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult importCashLimits(decimal import_dt, string omnibus_master_id, string file_name)
        {
            try
            {
                importCashLimitFactory = new ImportCashLimitFactory();

                importCashLimitFactory.importCashLimits(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString, SessionManger.BrokerOfLoggedInUser(Session).membership_id, import_dt, file_name, omnibus_master_id, User.Identity.GetUserId(), DateTime.Now);

                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Import Cash Limit List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ImpCashLimitList()
        {
            return View();
        }

        /// <summary>
        /// Get all import cash Limit
        /// </summary>
        /// <param></param>
        /// <returns>import cash Limit list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getImpCashLimitList()
        {
            try
            {
                importLogFactory = new OmnibusImportLogFactory();

                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var importCashLimitList = importLogFactory.getImportLogListByType("limits", membership_id, false);

                return Json(new { importCashLimitList = importCashLimitList, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}