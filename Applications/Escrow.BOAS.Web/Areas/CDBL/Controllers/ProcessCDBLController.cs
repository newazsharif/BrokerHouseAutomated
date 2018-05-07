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
///Created date: 13/10/2015
///Reason: Process CDBL Transaction Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.CDBL.Controllers
{
    public class ProcessCDBLController : Controller
    {
        // GET: CDBL/ProcessCDBL
        

        #region global variables

        private IXsdDatasetMapper xmlDatasetMapper;

        private string cdbl_file_path = ConfigManager.cdbl_file_path;

        private ICDBLProcessFactory cdblProcessFactory;

        #endregion

        public ProcessCDBLController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ProcessCDBLController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Process CDBL Transaction view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ProcessCDBLTransaction()
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
        /// Process CDBL transaction
        /// </summary>
        /// <param name="selected">Selected file list for process</param>
        /// /// <param name="from_date">from date</param>
        /// /// <param name="to_date">to date</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult processCDBLTrans(string[] selected, string from_date, string to_date)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                string[] frmDt = from_date.Split('/');

                from_date = frmDt[1] + "/" + frmDt[0] + "/" + frmDt[2];

                string[] toDt = to_date.Split('/');

                to_date = toDt[1] + "/" + toDt[0] + "/" + toDt[2];

                string display_names = "";

                foreach(string str in selected)
                {
                    display_names += str + ',';
                }

                cdblProcessFactory = new CDBLProcessFactory();

                List<ssp_CDBL_invalid_data_list_process_Result> errorList = cdblProcessFactory.getInvalidDataListForProcess(display_names);

                if (errorList.Count > 0)
                {
                    return Json(new { success = false, errorList = errorList, errorType = "list" }, JsonRequestBehavior.AllowGet);
                }
                else
                {

                    cdblProcessFactory = new CDBLProcessFactory();

                    string msg = cdblProcessFactory.ProcessCdbl(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString, display_names, from_date, to_date, membership_id, User.Identity.GetUserId(), DateTime.Now, 1);

                    if (msg == "success")
                    {
                        return Json(new { success = true }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new { success = false, errorMessage = msg }, JsonRequestBehavior.AllowGet);
                    }
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (cdblProcessFactory != null)
            {
                cdblProcessFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}