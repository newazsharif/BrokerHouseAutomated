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
///Created date: 10/10/2015
///Reason: Search CDBL Transaction Controller
///=============================================================


namespace Escrow.BOAS.Web.Areas.CDBL.Controllers
{
    public class SearchCDBLController : Controller
    {
        // GET: CDBL/SearchCDBL

        #region global variables

        private ICDBLFileSearchFactory cdblFileSearchFactory;

        private IXsdDatasetMapper xmlDatasetMapper;

        #endregion

        public SearchCDBLController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public SearchCDBLController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region load dropdown

        /// <summary>
        /// Get all instrument
        /// </summary>
        /// <param></param>
        /// <returns>instrument list in json</returns>
        //[Authorize]
        public JsonResult getInstrumentDdlList()
        {
            var instrumentList = DropDown.ddlInstrument();

            return Json(instrumentList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all active status
        /// </summary>
        /// <param></param>
        /// <returns>active status list in json</returns>
        //[Authorize]
        public JsonResult getActiveStatusDdlList()
        {
            var activeStatusList = DropDown.ddlActiveStatus();

            return Json(activeStatusList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Search CDBL Transaction view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult SearchCDBLTransaction()
        {
            return View();
        }

        /// <summary>
        /// Get all active status
        /// </summary>
        /// <param></param>
        /// <returns>active status list in json</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getTransactionTypeForSrhCdblDdlList()
        {

            xmlDatasetMapper = new XsdDatasetMapper(Server.MapPath("~/xsdCDBL.xsd"));

            List<CDBLFileModel> CDBLFileList = xmlDatasetMapper.GetTableDisplayNames();

            var transactionTypeList = CDBLFileList
                .Select(a => new
                {
                    value = a.id,
                    text = a.name
                }).ToList();

            return Json(transactionTypeList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get CDBL Table For Search
        /// </summary>
        /// <param></param>
        /// <returns>datarow and table column list in json</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getCDBLTableForShr(string display_name, string from_date, string to_date, string isin, string client_id, string bo_code)
        {

            string[] frmDt = from_date.Split('/');

            from_date = frmDt[1] + "/" + frmDt[0] + "/" + frmDt[2];

            string[] toDt = to_date.Split('/');

            to_date = toDt[1] + "/" + toDt[0] + "/" + toDt[2];

            cdblFileSearchFactory = new CDBLFileSearchFactory();

            xmlDatasetMapper = new XsdDatasetMapper(Server.MapPath("~/xsdCDBL.xsd"));

            string tableName = "[CDBL].[" + xmlDatasetMapper.GetFileName(display_name, false) + "]";

            DataTable dt = new DataTable();

            dt = cdblFileSearchFactory.GetCDBLFileSearch(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString, tableName, display_name, from_date, to_date, isin, client_id, bo_code);

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    if (!col.ColumnName.Contains("column"))
                    row.Add(col.ColumnName.Replace("_"," "), dr[col]);
                }
                rows.Add(row);
            }

            List<string> colNames = new List<string>();

            foreach (DataColumn col in dt.Columns)
            {
                if (!col.ColumnName.Contains("column"))
                colNames.Add(col.ColumnName.Replace("_", " "));
            }

            var jsonResult = Json(new { colNames = colNames, rows = rows }, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }

        /// <summary>
        /// Update Rights rate using unit price
        /// </summary>
        /// <param></param>
        /// <returns>active status list in json</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateBonusRightsUnitPrice(string unit_price, string from_date, string to_date, string isin, string client_id, string bo_code)
        {
            try
            {
                string[] frmDt = from_date.Split('/');

                from_date = frmDt[1] + "/" + frmDt[0] + "/" + frmDt[2];

                string[] toDt = to_date.Split('/');

                to_date = toDt[1] + "/" + toDt[0] + "/" + toDt[2];

                cdblFileSearchFactory = new CDBLFileSearchFactory();

                cdblFileSearchFactory.UpdateRightsUnitPrice(from_date, to_date, isin, client_id, bo_code, unit_price);

                return Json(new { success = true });
            }
            catch (Exception ex)
            {

                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Update Rights rate using market price
        /// </summary>
        /// <param></param>
        /// <returns>active status list in json</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateBonusRightsMarketPrice(string from_date, string to_date, string isin, string client_id, string bo_code)
        {
            try
            {
                string[] frmDt = from_date.Split('/');

                from_date = frmDt[1] + "/" + frmDt[0] + "/" + frmDt[2];

                string[] toDt = to_date.Split('/');

                to_date = toDt[1] + "/" + toDt[0] + "/" + toDt[2];

                cdblFileSearchFactory = new CDBLFileSearchFactory();

                cdblFileSearchFactory.UpdateRightsMarketPrice(from_date, to_date, isin, client_id, bo_code);

                return Json(new { success = true });
            }
            catch (Exception ex)
            {

                return Json(new { success = false, errorMessage = ex.Message });
            }
        }
    }
}