using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.BOAS.Transaction.Models;
using Escrow.BOAS.Transaction.Factories;
using Escrow.BOAS.Transaction.Interfaces;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;
using Escrow.Utility.Factories;
using System.Data.OleDb;
using System.Data;
using System.IO;
using System.Data.SqlClient;
using System.Configuration;


///=============================================================
///Created by: Asif
///Created date: 9/9/2015
///Reason: On Demand Charge Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class OnDemandChargeController : Controller
    {
        // GET: Transaction/OnDemandCharge
        
        #region global variables

        private IForceChargeApplyFactory forceChargeApplyFactory;

        private ICommonDBFunctionality commonDBFunctionality;

        OleDbConnection excelConnection;

        #endregion

        public OnDemandChargeController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public OnDemandChargeController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region load dropdown


        /// <summary>
        /// Get all charge
        /// </summary>
        /// <param></param>
        /// <returns>charge list in json</returns>
        //[Authorize]
        public JsonResult getChargeDdlList()
        {
            var chargeList = DropDown.ddlCharge();

            return Json(chargeList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all transaction type
        /// </summary>
        /// <param></param>
        /// <returns>transaction type list in json</returns>
        //[Authorize]
        public JsonResult getTransactionTypeDdlList()
        {
            var transactionTypeList = DropDown.ddlTransactionType();

            return Json(transactionTypeList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        public ActionResult Index()
        {
            return View();
        }

        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult OnDemandCharges()
        {
            return View();
        }

        /// <summary>
        /// Get single investor information by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>investor</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getInvestorInfoById(string id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                Escrow.BOAS.InvestorManagement.Models.tblInvestor investor = CommonUtility.getInvestorInfoById(id);

                if (investor != null)
                {
                    string invImageBase64String = "";
                    string invSignatureBase64String = "";
                    string joinHolderImageBase64String = "";
                    string joinHolderSignatureBase64String = "";

                    if (investor.photo != null)
                    {
                        invImageBase64String = Convert.ToBase64String(investor.photo, 0, investor.photo.Length);
                    }
                    if (investor.signature != null)
                    {
                        invSignatureBase64String = Convert.ToBase64String(investor.signature, 0, investor.signature.Length);
                    }

                    if (investor.join_holders_photo != null)
                    {
                        joinHolderImageBase64String = Convert.ToBase64String(investor.join_holders_photo, 0, investor.join_holders_photo.Length);
                    }
                    if (investor.join_holders_signature != null)
                    {
                        joinHolderSignatureBase64String = Convert.ToBase64String(investor.join_holders_signature, 0, investor.join_holders_signature.Length);
                    }

                    if (investor.active_status.ToUpper() == "ACTIVE")
                    {
                        return Json(new { investor = investor, invPic = invImageBase64String, invSignature = invSignatureBase64String, invJoinHolderPic = joinHolderImageBase64String, invJoinHolderSignature = joinHolderSignatureBase64String, success = true }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new { success = false, errorMessage = investor.active_status + " Investor" }, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    return Json(new { success = false, errorMessage = "Invalid Investor" }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Upload on demand charge from excel to temporary table
        /// </summary>
        /// <param name="file">excel file</param>
        /// <returns>success or error list</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult uploadChargeFromExcel(HttpPostedFileBase file)
        {
            try
            {
                MemoryStream target = new MemoryStream();
                file.InputStream.CopyTo(target);
                byte[] data = target.ToArray();

                var filename = System.IO.Path.GetTempFileName();
                System.IO.File.WriteAllBytes(filename, data);

                excelConnection = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filename + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"");
                excelConnection.Open();

                OleDbCommand cmd = new OleDbCommand();
                OleDbDataAdapter oleda = new OleDbDataAdapter();

                cmd.Connection = excelConnection;
                cmd.CommandType = CommandType.Text;
                DataSet dataset = new DataSet();

                cmd.CommandText = "SELECT [INVESTOR CODE] AS client_id,[BO CODE] AS bo_code, [AMOUNT] AS amount, [REMARKS] AS remarks FROM [Sheet1$]";

                oleda = new OleDbDataAdapter(cmd);
                oleda.Fill(dataset, "[Escrow.BOAS].[Transaction].[tblForceChargeApplyTemp]");

                DataTable dt = dataset.Tables[0];

                DataColumn newColumn = new DataColumn("is_processed", typeof(System.Decimal));
                newColumn.DefaultValue = 0;
                dt.Columns.Add(newColumn);

                commonDBFunctionality = new CommonDBFunctionality();

                bool isSuccess = commonDBFunctionality.sqlBulkCopy(dt, ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);

                if (isSuccess)
                {
                    forceChargeApplyFactory = new ForceChargeApplyFactory();

                    List<ssp_on_dem_char_xl_upl_err_Result> errorResult = forceChargeApplyFactory.getOnDemandChargeExcelUploadError();

                    if (errorResult.Count > 0)
                    {
                        return Json(new { success = false, errorList = errorResult, errorType = "list" });
                    }
                    else
                    {
                        return Json(new { success = true });
                    }
                }
                else
                {
                    return Json(new { success = false, errorMsg = "Failed to Upload Please Try Again", errorType = "msg" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { errorMsg = ex.Message, success = false });
            }
            finally
            {
                OleDbConnection.ReleaseObjectPool();
            }

        }

        /// <summary>
        /// get all on demand charge from temporary table
        /// </summary>
        /// <returns>upload list</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getExcelUploadList()
        {
            try
            {
                forceChargeApplyFactory = new ForceChargeApplyFactory();

                List<ssp_on_dem_char_upl_Result> uploadList = forceChargeApplyFactory.getOnDemandChargeUploadList();

                return Json(new { success = true, uploadList = uploadList }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { errorMessage = ex.Message, success = false });
            }
            finally
            {
                OleDbConnection.ReleaseObjectPool();
            }

        }

        /// <summary>
        /// get all on demand charge from temporary table which are already processed
        /// </summary>
        /// <returns>processed list</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getAlreadyProcessedList(decimal charge_id, decimal transaction_type_id, decimal transaction_date)
        {
            try
            {
                forceChargeApplyFactory = new ForceChargeApplyFactory();

                List<ssp_already_processed_on_dem_char_Result> processedList = forceChargeApplyFactory.getOnDemandChargeProcessedListFormExcel(charge_id, transaction_type_id, transaction_date);

                if (processedList.Count > 0)
                {
                    return Json(new { success = true, processedList = processedList }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { success = false }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { errorMessage = ex.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                OleDbConnection.ReleaseObjectPool();
            }

        }

        /// <summary>
        /// Import from temp to on demand charge
        /// </summary>
        /// <param name="fundPayment">force charge apply model</param>
        /// <param name="isUpdProcessedData">is update already processed data</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult importExcelData(tblForceChargeApply OnDemChar, bool isUpdProcessedData)
        {
            try
            {
                forceChargeApplyFactory = new ForceChargeApplyFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                decimal is_upd_processed_client = 0;

                if(isUpdProcessedData)
                {
                    is_upd_processed_client = 1;
                }

                tblForceChargeApply obj = new tblForceChargeApply();
                obj = OnDemChar;

                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;

                forceChargeApplyFactory.insertOnDemandChargeFromExcel(obj, is_upd_processed_client);

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add on demand charge
        /// </summary>
        /// <param name="fundPayment">force charge apply model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult addSingleInvOnDemandCharge(tblForceChargeApply OnDemChar)
        {
            try
            {
                forceChargeApplyFactory = new ForceChargeApplyFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                if (forceChargeApplyFactory.GetAll().Any(a => a.client_id == OnDemChar.client_id && a.charge_id == OnDemChar.charge_id && a.transaction_type_id == OnDemChar.transaction_type_id && a.transaction_date == OnDemChar.transaction_date))
                {
                    return Json(new { success = false, errorMessage = "This investor already charged!!!" });
                }
                else
                {
                    forceChargeApplyFactory = new ForceChargeApplyFactory();

                    tblForceChargeApply obj = new tblForceChargeApply();
                    obj = OnDemChar;

                    if (OnDemChar.remarks != null && OnDemChar.remarks != "")
                        obj.remarks = OnDemChar.remarks.Trim();

                    obj.membership_id = membership_id;
                    obj.changed_user_id = User.Identity.GetUserId();
                    obj.changed_date = DateTime.Now;
                    obj.is_dirty = 1;

                    forceChargeApplyFactory.Add(obj);
                    forceChargeApplyFactory.Save();

                    return Json(new { success = true, serial_no = obj.id });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add on demand charge
        /// </summary>
        /// <param name="fundPayment">force charge apply model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult addAllOnDemandCharge(tblForceChargeApply OnDemChar)
        {
            try
            {
                forceChargeApplyFactory = new ForceChargeApplyFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblForceChargeApply obj = new tblForceChargeApply();
                obj = OnDemChar;

                if (OnDemChar.remarks != null && OnDemChar.remarks != "")
                    obj.remarks = OnDemChar.remarks.Trim();

                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;

                forceChargeApplyFactory.insertAllInvestorOnDemandCharge(OnDemChar);

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// On Demand Charge List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult OnDemandChargeList()
        {
            return View();
        }

        /// <summary>
        /// Get all on demand charge
        /// </summary>
        /// <param></param>
        /// <returns>on demand charge list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getOnDemandChargeList()
        {
            try
            {
                forceChargeApplyFactory = new ForceChargeApplyFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var onDemandChargeList = forceChargeApplyFactory.GetAll().Where(a => a.approve_by == null)
                    .Select(a => new
                    {
                        transaction_dt = a.DimDate.FullDateUK,
                        a.tblInvestor.first_holder_name,
                        transaction_type = a.tblConstantObjectValue.display_value,
                        charge = a.tblGlobalCharge.name,
                        value_dt = a.DimDate1.FullDateUK,
                        a.amount,
                        a.remarks
                    }).OrderByDescending(a => a.transaction_dt)
                    .ToList();

                var jsonResult = Json(new { onDemandChargeList = onDemandChargeList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (forceChargeApplyFactory != null)
            {
                forceChargeApplyFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}