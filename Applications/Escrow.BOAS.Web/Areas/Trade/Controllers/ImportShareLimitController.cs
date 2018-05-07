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
///Created date: 28/12/2015
///Reason: Import Share Limit Controller
///=============================================================


namespace Escrow.BOAS.Web.Areas.Trade.Controllers
{
    public class ImportShareLimitController : Controller
    {
        // GET: Trade/ImportShareLimit

        #region global variables

        private ICommonDBFunctionality commonDBFunctionality;

        private IImportShareLimitFactory importShareLimitFactory;

        private IOmnibusImportLogFactory importLogFactory;

        private DataTable tblPositions
        {
            get
            {
                DataTable dt = new DataTable("Trade.tblFTOmnibusPositionsTemp");
                dt.Columns.Add(new DataColumn("isin"));
                dt.Columns.Add(new DataColumn("com_s_name"));
                dt.Columns.Add(new DataColumn("boid"));
                dt.Columns.Add(new DataColumn("f_join_holder_name"));
                dt.Columns.Add(new DataColumn("current_balance"));
                dt.Columns.Add(new DataColumn("free_balance"));
                dt.Columns.Add(new DataColumn("investor_code"));
                dt.Columns.Add(new DataColumn("trd_dt"));
                return dt;
            }
        }

        #endregion

        public ImportShareLimitController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ImportShareLimitController(UserManager<ApplicationUser> userManager)
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
        public ActionResult ImpShareLimit()
        {
            return View();
        }

        /// <summary>
        /// Upload share limits from text to temporary table
        /// </summary>
        /// <param name="file">text file</param>
        /// <returns>success or error list</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult uploadShareLimitFromText(HttpPostedFileBase file, decimal import_dt, string omnibus_master_id)
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

                    DataColumn newColumn = new DataColumn("branch_id", typeof(System.Decimal));
                    newColumn.DefaultValue = DBNull.Value;
                    dt.Columns.Add(newColumn);

                    newColumn = new DataColumn("omnibus_master_id", typeof(System.String));
                    newColumn.DefaultValue = omnibus_master_id;
                    dt.Columns.Add(newColumn);

                    newColumn = new DataColumn("membership_id", typeof(System.Decimal));
                    newColumn.DefaultValue = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                    dt.Columns.Add(newColumn);

                    commonDBFunctionality = new CommonDBFunctionality();

                    bool isSuccess = commonDBFunctionality.sqlBulkCopy(dt, ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);

                    if(isSuccess)
                    {
                        importShareLimitFactory = new ImportShareLimitFactory();

                        string errorMsg = importShareLimitFactory.UploadShareLimitsFile(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString, SessionManger.BrokerOfLoggedInUser(Session).membership_id, import_dt, file.FileName, omnibus_master_id);

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
            DataTable dt = tblPositions;
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
        /// Import share limits from temp to main table
        /// </summary>
        /// <param name="import_dt">import date</param>
        /// <param name="omnibus_master_id">omnibus master id</param>
        /// <param name="file_name">name of the text file</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult importShareLimits(decimal import_dt, string omnibus_master_id, string file_name)
        {
            try
            {
                importShareLimitFactory = new ImportShareLimitFactory();

                importShareLimitFactory.importShareLimits(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString, SessionManger.BrokerOfLoggedInUser(Session).membership_id, import_dt, file_name, omnibus_master_id);

                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Import Share Limit List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ImpShareLimitList()
        {
            return View();
        }

        /// <summary>
        /// Get all import share Limit
        /// </summary>
        /// <param></param>
        /// <returns>import share Limit list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getImpShareLimitList()
        {
            try
            {
                importLogFactory = new OmnibusImportLogFactory();

                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var importShareLimitList = importLogFactory.getImportLogListByType("positions", membership_id, false);

                return Json(new { importShareLimitList = importShareLimitList, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}