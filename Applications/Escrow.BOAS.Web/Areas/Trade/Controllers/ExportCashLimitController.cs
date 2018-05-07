using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;
using Escrow.BOAS.Trade.Interfaces;
using Escrow.BOAS.Trade.Factories;
using System.Data;
using System.Configuration;
using System.IO;
using Escrow.BOAS.Trade.Models;


///=============================================================
///Created by: Asif
///Created date: 8/12/2015
///Reason: Export Cash Limit Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Trade.Controllers
{
    public class ExportCashLimitController : Controller
    {
        // GET: Trade/ExportCashLimit

        #region global variables

        private IExportCashLimitFactory exportCashLimitFactory;

        private IExportUtilityFactory exportUtilityFactory;

        private IOmnibusImportLogFactory importLogFactory;

        #endregion

        public ExportCashLimitController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ExportCashLimitController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Export Cash Limit view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ExpCashLimit()
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

                var importCashLimitList = importLogFactory.getImportLogListByType("limits", membership_id, true);

                return Json(new { importCashLimitList = importCashLimitList, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Export Cash Limit List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ExpCashLimitList()
        {
            return View();
        }

        /// <summary>
        /// Export cash limit to server as xml file
        /// </summary>
        /// <returns>exportLogList or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getCsLimitList()
        {
            try
            {
                exportUtilityFactory = new ExportUtilityFactory();

                var exportLogList = exportUtilityFactory.GetExportLogList("limits", SessionManger.BrokerOfLoggedInUser(Session).membership_id);

                return Json(new { success = true, exportLogList = exportLogList }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Export cash limit to server as xml file
        /// </summary>
        /// <param name="expCsLimit">Export Cash Limit Model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult expCsLimitToServer(ExportCashLimitModel expCsLimit, string[] selected)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                
                string omb_ids = "";
                string branch_ids = string.Empty;

                if (selected != null)
                {
                    for (int i = 0; i < selected.Length; i++)
                    {
                        omb_ids += selected[i] + ",";
                    }
                }

                string broker_s_name = SessionManger.BrokerOfLoggedInUser(Session).short_name.ToUpper();

                bool isMorning = false;

                bool isDeactivateAll = false;

                if(expCsLimit.file_for.Trim() == "Morning")
                {
                    isMorning = true;
                }

                if(expCsLimit.is_deactive_all == 1)
                {
                    isDeactivateAll = true;
                }

                string fileName = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy")) + DateTime.Now.ToString("-hhmmss-") + "Clients-" + broker_s_name + ".xml";

                exportCashLimitFactory = new ExportCashLimitFactory();

                DataSet ds = exportCashLimitFactory.getCashLimits(expCsLimit.export_dt, isMorning, isDeactivateAll, omb_ids, fileName, branch_ids, membership_id, ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);

                string xmlString = exportCashLimitFactory.ConvertToCashLimitXMLString(ds, isMorning, isDeactivateAll);

                string errorMessage = exportCashLimitFactory.ValidateXmlWithXsd(xmlString, Server.MapPath("~/Files/XSDFiles/Flextrade-BOS-Clients.xsd"));

                if (errorMessage.Length == 0)
                {
                    ExportFile(fileName, xmlString);
                    return Json(new { success = true });
                }
                else
                {
                    int log_id = Convert.ToInt32(ds.Tables[0].Rows[0]["log_id"]);
                    exportCashLimitFactory.RollbackExporting(log_id, ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);

                    var jsonResult = Json(new { success = false, errorMessage = errorMessage }, JsonRequestBehavior.AllowGet);
                    jsonResult.MaxJsonLength = int.MaxValue;
                    return jsonResult;
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        private void ExportFile(string fileName, string xmlString)
        {
            try
            {
                StreamWriter sw = System.IO.File.CreateText(Server.MapPath(Path.Combine("~/Files/ExportedFiles/", fileName)));
                sw.Write(xmlString);
                sw.Close();

                GenerateAndExportControlFile(Server.MapPath(Path.Combine("~/Files/ExportedFiles/")), fileName, xmlString);
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }

        public void GenerateAndExportControlFile(string Location, string fileName, string content)
        {
            string hash = CommonUtility.GetMd5Hash(content);

            string xmlString = @"<Control Hash=""" + hash + @""" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xsi:noNamespaceSchemaLocation=""Flextrade-BOS-Control.xsd"" Method=""MD5"" />";

            StreamWriter sw = System.IO.File.CreateText(Path.Combine(Location, fileName.Insert(fileName.LastIndexOf(".xml"), "-ctrl")));
            sw.Write(xmlString);
            sw.Close();
        }
    }
}