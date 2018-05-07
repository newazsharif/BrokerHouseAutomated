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
using Microsoft.Reporting.WebForms;
using System.IO;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using Escrow.BOAS.BrokerManagement.Factories;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.Security;
using Escrow.Security.Factories;


///=============================================================
///Created by: Asif
///Created date: 23/8/2015
///Reason: Cash And Cheque Receive Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class CashChequeReceiveController : Controller
    {
        #region global variables

        private IGenericFactory<tblFundReceive> fundReceiveFactory;

        private IFundReceiveFactory spFundRecFactory;

        #endregion

        public CashChequeReceiveController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public CashChequeReceiveController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region load dropdown

        /// <summary>
        /// Get all transaction mode
        /// </summary>
        /// <param></param>
        /// <returns>transaction mode list in json</returns>
        //[Authorize]
        public JsonResult getTransactionModeDdlList()
        {
            var transactionModeList = DropDown.ddlTransactionMode();

            return Json(transactionModeList, JsonRequestBehavior.AllowGet);
        }


        /// <summary>
        /// Get all bank
        /// </summary>
        /// <param></param>
        /// <returns>bank list in json</returns>
        //[Authorize]
        public JsonResult getBankDdlList()
        {
            var bankList = DropDown.ddlBank();

            return Json(bankList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all broker branch
        /// </summary>
        /// <param></param>
        /// <returns>broker branch list in json</returns>
        //[Authorize]
        public JsonResult getBranchDdlList()
        {
            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

            string user_id = User.Identity.GetUserId();

            var branchList = DropDown.ddlBrokerBranch(user_id, membership_id);

            return Json(branchList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        private string getCurrentDateWiseVoucherNo()
        {
            return (DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"))).ToString();
        }

        /// <summary>
        /// get maximum voucher no
        /// </summary>
        /// <param></param>
        /// <returns>voucher_no or fail message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        private string getMaxVoucherNo()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundReceiveFactory = new FundReceiveFactory();

                decimal id = fundReceiveFactory.GetAll().Any() ? fundReceiveFactory.GetAll().Max(a => a.id) : 0;

                string prev_voucher_no = "00000";
                if (id != 0)
                {
                    prev_voucher_no = fundReceiveFactory.GetAll().Where(a => a.id == id).Select(a => a.voucher_no).FirstOrDefault();
                }

                return prev_voucher_no;
            }
            catch (Exception ex)
            {
                return "fail";
            }
        }

        // GET: Transaction/CashChequeReceive
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Cash And Cheque Receive view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult CashAndChequeReceive()
        {
            return View();
        }

        /// <summary>
        /// Get previous voucher no
        /// </summary>
        /// <param></param>
        /// <returns>prev_voucher_no</returns>
        //[Authorize]
        public JsonResult getPrevVouchNo()
        {
            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

            string prev_voucher_no = "";

            string voucher_no = getMaxVoucherNo();

            if (voucher_no.Length == 13)
            {
                prev_voucher_no = voucher_no;
            }
            else
            {
                prev_voucher_no = getCurrentDateWiseVoucherNo() + voucher_no;
            }

            return Json(prev_voucher_no, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get single investor information by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>investor</returns>
        //[Authorize]
        //[HttpGet]
        //[CheckUserSessionAttribute]
        //public JsonResult getInvestorInfoById(string id)
        //{
        //    try
        //    {
        //        decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

        //        Escrow.BOAS.InvestorManagement.Models.tblInvestor investor = CommonUtility.getInvestorInfoById(id);

        //        if (investor != null)
        //        {
        //            string invImageBase64String = "";
        //            string invSignatureBase64String = "";
        //            string joinHolderImageBase64String = "";
        //            string joinHolderSignatureBase64String = "";

        //            if (investor.photo != null)
        //            {
        //                invImageBase64String = Convert.ToBase64String(investor.photo, 0, investor.photo.Length);
        //            }
        //            if (investor.signature != null)
        //            {
        //                invSignatureBase64String = Convert.ToBase64String(investor.signature, 0, investor.signature.Length);
        //            }

        //            if (investor.join_holders_photo != null)
        //            {
        //                joinHolderImageBase64String = Convert.ToBase64String(investor.join_holders_photo, 0, investor.join_holders_photo.Length);
        //            }
        //            if (investor.join_holders_signature != null)
        //            {
        //                joinHolderSignatureBase64String = Convert.ToBase64String(investor.join_holders_signature, 0, investor.join_holders_signature.Length);
        //            }

        //            if (investor.active_status.ToUpper() == "ACTIVE")
        //            {
        //                return Json(new { investor = investor, invPic = invImageBase64String, invSignature = invSignatureBase64String, invJoinHolderPic = joinHolderImageBase64String, invJoinHolderSignature = joinHolderSignatureBase64String, success = true }, JsonRequestBehavior.AllowGet);
        //            }
        //            else
        //            {
        //                return Json(new { success = false, errorMessage = investor.active_status + " Investor" }, JsonRequestBehavior.AllowGet);
        //            }
        //        }
        //        else
        //        {
        //            return Json(new { success = false, errorMessage = "Invalid Investor" }, JsonRequestBehavior.AllowGet);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return Json(new { success = false, errorMessage = ex.Message });
        //    }
        //}

        [CheckUserSessionAttribute]
        public JsonResult getInvestorInfoById(string id, decimal branch)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                string user_id = User.Identity.GetUserId();

                SpecialSecurity security = new SpecialSecurity();
                if (!security.IsPermitted(id, user_id))
                {
                    return Json(new { success = false, errorMessage = "You do not have permission to operate this investor" }, JsonRequestBehavior.AllowGet);
                }

                Escrow.BOAS.InvestorManagement.Models.tblInvestor investor = CommonUtility.getInvestorInfoById(id,branch);

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
        /// Get previous unapprove fund receive by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>error or success message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getPrevUnapprovedFndRecByClientId(string id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundReceiveFactory = new FundReceiveFactory();

                List<tblFundReceive> fundReceiveList = fundReceiveFactory.GetAll().Where(a => a.client_id == id && a.approve_by == null).ToList();

                if(fundReceiveList.Count > 0)
                {
                    string vouchersAndAmounts = "";

                    foreach (tblFundReceive item in fundReceiveList)
                    {
                        vouchersAndAmounts += "Voucher No: " + item.voucher_no + " Amount: " + item.amount.ToString("#.##") + ", ";
                    }

                    return Json(new { success = true, msg = "This Investor already have " + fundReceiveList.Count + " receive pending " + vouchersAndAmounts + "are you sure you want to save this fund receive..." }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { success = false }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add cash and cheque receive
        /// </summary>
        /// <param name="cashCheqReceive">cash and cheque receive model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult addCashCheqReceive(tblFundReceive cashCheqReceive)
        {
            try
            {
                fundReceiveFactory = new FundReceiveFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                if (fundReceiveFactory.GetAll().Any(a => a.bank_id == cashCheqReceive.bank_id && a.cheque_no == cashCheqReceive.cheque_no) && cashCheqReceive.cheque_no != null)
                {
                    return Json(new { success = false, errorMessage = "This cheque already is in use!!!" });
                }
                else
                {
                    fundReceiveFactory = new FundReceiveFactory();
                    
                    tblFundReceive obj = new tblFundReceive();
                    obj = cashCheqReceive;

                    if (cashCheqReceive.remarks != null && cashCheqReceive.remarks != "")
                        obj.remarks = cashCheqReceive.remarks.Trim();

                    obj.membership_id = membership_id;
                    obj.changed_user_id = User.Identity.GetUserId();
                    obj.changed_date = DateTime.Now;
                    obj.is_dirty = 1;

                    string maxVoucherNo = getMaxVoucherNo();

                    string currDateVoucherNo = getCurrentDateWiseVoucherNo();

                    bool isFirstTime = true;

                    if (maxVoucherNo.Length == 13)
                    {
                        if (maxVoucherNo.Substring(0, 8) == currDateVoucherNo)
                        {
                            obj.voucher_no = (Convert.ToInt64(maxVoucherNo) + 1).ToString();
                            isFirstTime = false;
                        }
                        else
                        {
                            obj.voucher_no = currDateVoucherNo + "00001";
                            isFirstTime = false;
                        }
                    }
                    else
                    {
                        obj.voucher_no = currDateVoucherNo + "00001";
                    }

                    fundReceiveFactory.Add(obj);
                    fundReceiveFactory.Save();

                    if (isFirstTime)
                    {
                        return Json(new { success = true, voucher_no = obj.voucher_no, prev_voucher_no = (currDateVoucherNo + maxVoucherNo) });
                    }
                    else
                    {
                        return Json(new { success = true, voucher_no = obj.voucher_no, prev_voucher_no = maxVoucherNo });
                    }
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Cash And Cheque Receive list view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult CashAndChequeReceiveList()
        {
            return View();
        }

        /// <summary>
        /// Get all cash and cheque receive list
        /// </summary>
        /// <param></param>
        /// <returns>cash and cheque receive list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getCashCheqRecList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundReceiveFactory = new FundReceiveFactory();
                //BrokerBranchFactory brokerBranchFactory = new BrokerBranchFactory();
                UserEmployeeMappingFactory userEmployeeMappingFactory = new UserEmployeeMappingFactory();

                string user_id = User.Identity.GetUserId();
                decimal branch_id =
                    userEmployeeMappingFactory.GetAll()
                        .Where(a => a.user_id == user_id)
                        .Select(x => x.tblEmployee.branch_id)
                        .FirstOrDefault();
                
                BrokerUserFactory userFactory = new BrokerUserFactory();
                decimal isAdmin = userFactory.GetAll().FirstOrDefault(x => x.UserId == user_id).is_admin;

                var cashCheqRecList = fundReceiveFactory.GetAll().Where(a=>a.approve_by == null && a.deposit_by == null && a.clear_by == null && a.dishonor_by == null && (isAdmin == 1 || a.broker_branch_id == branch_id))
                    .Select(s => new
                    {
                        s.id,
                        receive_dt = s.DimDate.FullDateUK,
                        s.voucher_no,
                        branch = s.tblBrokerBranch.name,
                        s.client_id,
                        s.tblInvestor.bo_code,
                        s.tblInvestor.first_holder_name,
                        transaction_mode = s.tblConstantObjectValue.display_value,
                        s.tblBank.bank_name,
                        cheque_dt = s.DimDate6.FullDateUK,
                        s.cheque_no,
                        s.amount
                    })
                    .OrderBy(s=>s.receive_dt)
                    .ToList();

                var jsonResult = Json(new { cashCheqRecList = cashCheqRecList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Edit Cash And Cheque Receive view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditCashAndChequeReceive()
        {
            return View();
        }

        /// <summary>
        /// Get single Cash And Cheque Receive by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>Cash And Cheque Receive model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getCashCheqRecById(int id)
        {
            try
            {
                fundReceiveFactory = new FundReceiveFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var editCashCheqReceive = fundReceiveFactory.FindBy(b => b.id == id)
                    .Select(s => new
                    {
                        s.id,
                        s.voucher_no,
                        s.client_id,
                        s.transaction_mode_id,
                        s.cheque_no,
                        cheque_dt = s.DimDate6.FullDateUK,
                        s.bank_id,
                        s.bank_branch_name,
                        s.amount,
                        s.doc_ref_no,
                        receive_dt = s.DimDate.FullDateUK,
                        value_dt = s.DimDate1.FullDateUK,
                        s.broker_branch_id,
                        s.remarks
                    }).FirstOrDefault();

                return Json(new { editCashCheqReceive = editCashCheqReceive, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Update cash and cheque receive
        /// </summary>
        /// <param name="cashCheqReceive">cash and cheque receive model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateCashCheqReceive(tblFundReceive editCashCheqReceive)
        {
            try
            {
                fundReceiveFactory = new FundReceiveFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                if (fundReceiveFactory.GetAll().Any(a => a.bank_id == editCashCheqReceive.bank_id && a.cheque_no == editCashCheqReceive.cheque_no && a.id != editCashCheqReceive.id) && editCashCheqReceive.cheque_no != null)
                {
                    return Json(new { success = false, errorMessage = "This cheque already is in use!!!" });
                }
                else
                {
                    fundReceiveFactory = new FundReceiveFactory();

                    tblFundReceive obj = new tblFundReceive();
                    obj = editCashCheqReceive;

                    if (editCashCheqReceive.remarks != null && editCashCheqReceive.remarks != "")
                        obj.remarks = editCashCheqReceive.remarks.Trim();

                    obj.membership_id = membership_id;
                    obj.changed_user_id = User.Identity.GetUserId();
                    obj.changed_date = DateTime.Now;
                    obj.is_dirty = 1;

                    fundReceiveFactory.Edit(obj);
                    fundReceiveFactory.Save();

                    return Json(new { success = true });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete cash and cheque receive
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteCashChequeReceive(int id)
        {
            try
            {
                fundReceiveFactory = new FundReceiveFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var obj = fundReceiveFactory.FindBy(b => b.id == id).FirstOrDefault();

                fundReceiveFactory.Delete(obj);
                fundReceiveFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }



        /// <summary>
        /// Show Report
        /// </summary>
        /// <param name="voucher_no"> voucher_no </param>
        /// <returns>Show Report</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult printMoneyReceipt(string voucher_no)
        {
            LocalReport lr = new LocalReport();

            string path = Path.Combine(Server.MapPath("~/Reports/rptMoneyReceipt.rdlc"));
            if (System.IO.File.Exists(path))
            {
                lr.ReportPath = path;
            }

            DataTable dt = new DataTable();

            spFundRecFactory = new FundReceiveFactory();

            dt = spFundRecFactory.getMoneyReceipt(voucher_no, SessionManger.BrokerOfLoggedInUser(Session).membership_id, User.Identity.GetUserId(), ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);

            ReportParameterCollection reportParameters = new ReportParameterCollection();

            reportParameters.Add(new ReportParameter("rptCompanyName", SessionManger.BrokerOfLoggedInUser(Session).Name + ""));
            reportParameters.Add(new ReportParameter("rptCompanyAddress", SessionManger.BrokerOfLoggedInUser(Session).mail_address + ""));
            reportParameters.Add(new ReportParameter("rptReportName", "MONEY RECEIPT"));

            lr.SetParameters(reportParameters);
            ReportDataSource rd;

            rd = new ReportDataSource("DataSet1", dt);

            lr.DataSources.Add(rd);

            string reportType = "pdf";
            string mimeType;
            string encoding;
            string fileNameExtension;
            string deviceInfo =

            "<DeviceInfo>" +
            "  <OutputFormat>" + "pdf" + "</OutputFormat>" +
            "</DeviceInfo>";

            Warning[] warnings;
            string[] streams;
            byte[] renderedBytes;

            renderedBytes = lr.Render(
                reportType,
                deviceInfo,
                out mimeType,
                out encoding,
                out fileNameExtension,
                out streams,
                out warnings);

            return File(renderedBytes, mimeType);
        }

        protected override void Dispose(bool disposing)
        {
            if (fundReceiveFactory != null)
            {
                fundReceiveFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}