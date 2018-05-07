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
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;


///=============================================================
///Created by: Asif
///Created date: 6/9/2015
///Reason: Fund Withdrawal Request Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class FundWithdrawalRequestController : Controller
    {
        // GET: Transaction/FundWithdrawalRequest
        
        #region global variables

        private IGenericFactory<tblFundWithdrawalRequest> fndWithdrawalReqFactory;

        #endregion

        public FundWithdrawalRequestController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public FundWithdrawalRequestController(UserManager<ApplicationUser> userManager)
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
        /// Get all broker bank account
        /// </summary>
        /// <param></param>
        /// <returns>broker bank account list in json</returns>
        //[Authorize]
        public JsonResult getBrokerBankAccountDdlList()
        {
            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

            var brokerBankAccountList = DropDown.ddlBrokerBankAccount(membership_id);

            return Json(brokerBankAccountList, JsonRequestBehavior.AllowGet);
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
        /// Get all bank branch
        /// </summary>
        /// <param></param>
        /// <returns>bank branch list in json</returns>
        //[Authorize]
        public JsonResult getBankBranchDdlList(int id)
        {
            var bankBranchList = DropDown.ddlBankBranch(id);

            return Json(bankBranchList, JsonRequestBehavior.AllowGet);
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

        //[Authorize]
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
        private string getMaxVoucherNo()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                decimal id = fndWithdrawalReqFactory.GetAll().Any() ? fndWithdrawalReqFactory.GetAll().Max(a => a.id) : 0;

                string prev_voucher_no = "00000";
                if (id != 0)
                {
                    prev_voucher_no = fndWithdrawalReqFactory.GetAll().Where(a => a.id == id).Select(a => a.voucher_no).FirstOrDefault();
                }

                return prev_voucher_no;
            }
            catch (Exception ex)
            {
                return "fail";
            }
        }

        
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Fund Withdrawal Request view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FndWithdrawalRequest()
        {
            return View();
        }

        /// <summary>
        /// Get previous voucher no
        /// </summary>
        /// <param></param>
        /// <returns>prev_voucher_no</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
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
        /// Get previous unapprove fund withdrawal request by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>error or success message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getPrevUnapprovedFndWithRecByClientId(string id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                List<tblFundWithdrawalRequest> fundWithdrawRecList = fndWithdrawalReqFactory.GetAll().Where(a => a.client_id == id && a.approve_by == null).ToList();

                if (fundWithdrawRecList.Count > 0)
                {
                    string vouchersAndAmounts = "";

                    foreach (tblFundWithdrawalRequest item in fundWithdrawRecList)
                    {
                        vouchersAndAmounts += "Voucher No: " + item.voucher_no + " Amount: " + item.amount.ToString("#.##") + ", ";
                    }

                    return Json(new { success = true, msg = "This Investor already have " + fundWithdrawRecList.Count + " withdrawal request pending " + vouchersAndAmounts + "are you sure you want to save this withdrawal request..." }, JsonRequestBehavior.AllowGet);
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
        /// Add fund withdrawal request
        /// </summary>
        /// <param name="fndWithdrawalReq">Withdrawal Request model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult addFndWithdrawalReq(tblFundWithdrawalRequest fndWithdrawalReq)
        {
            try
            {
                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                if (fndWithdrawalReqFactory.GetAll().Any(a => a.bank_branch_id == fndWithdrawalReq.bank_branch_id && a.cheque_no == fndWithdrawalReq.cheque_no) && fndWithdrawalReq.cheque_no != null)
                {
                    return Json(new { success = false, errorMessage = "This cheque already is in use!!!" });
                }
                else
                {
                    fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                    tblFundWithdrawalRequest obj = new tblFundWithdrawalRequest();
                    obj = fndWithdrawalReq;

                    if (fndWithdrawalReq.remarks != null && fndWithdrawalReq.remarks != "")
                        obj.remarks = fndWithdrawalReq.remarks.Trim();

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

                    fndWithdrawalReqFactory.Add(obj);
                    fndWithdrawalReqFactory.Save();

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
        /// Fund Withdrawal Request list view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FndWithdrawalReqList()
        {
            return View();
        }

        /// <summary>
        /// Get all fund withdrawal request list
        /// </summary>
        /// <param></param>
        /// <returns>fund withdrawal request list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getFndWithdrawalReqList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                var fndWithdrawalReqList = fndWithdrawalReqFactory.GetAll().Where(a => a.approve_by == null && a.is_dirty == 1)
                    .Select(s => new
                    {
                        s.id,
                        request_dt = s.DimDate1.FullDateUK,
                        effective_dt = s.DimDate2.FullDateUK,
                        s.voucher_no,
                        branch = s.tblBrokerBranch.name,
                        s.client_id,
                        s.tblInvestor.bo_code,
                        s.tblInvestor.first_holder_name,
                        transaction_mode = s.tblConstantObjectValue.display_value,
                        //s.tblBankBranch.tblBank.bank_name,
                        cheque_dt = s.DimDate.FullDateUK,
                        //bank_name = s.bank_branch_id!= null ? ("Bank: " + s.tblBankBranch.tblBank.bank_name)
                        bank_name = s.bank_branch_id != null ? ("Bank: " + s.tblBrokerBankAccount.tblBankBranch.tblBank.bank_name + ", Bank Branch: " + s.tblBrokerBankAccount.tblBankBranch.branch_name + ", Account No: " + s.tblBrokerBankAccount.account_no) : "",
                        s.cheque_no,
                        s.amount
                    })
                    .OrderBy(s => s.request_dt)
                    .ToList();

                var jsonResult = Json(new { fndWithdrawalReqList = fndWithdrawalReqList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Edit Fund Withdrawal Request view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditFndWithdrawalReq()
        {
            return View();
        }

        /// <summary>
        /// Get single Fund Withdrawal Request by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>Fund Withdrawal Request model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getFndWithdrawalReqById(int id)
        {
            try
            {
                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var editFndWithdrawalReq = fndWithdrawalReqFactory.FindBy(b => b.id == id)
                    .Select(s => new
                    {
                        s.id,
                        s.voucher_no,
                        s.client_id,
                        s.transaction_mode_id,
                        s.cheque_no,
                        cheque_dt = s.DimDate.FullDateUK,
                        bank_id = (s.tblBankBranch.bank_id == null ? 0 : s.tblBankBranch.bank_id),
                        s.bank_branch_id,
                        s.amount,
                        request_dt = s.DimDate1.FullDateUK,
                        effective_dt = s.DimDate2.FullDateUK,
                        s.broker_branch_id,
                        s.remarks
                    }).FirstOrDefault();

                return Json(new { editFndWithdrawalReq = editFndWithdrawalReq, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Update fund withdrawal request
        /// </summary>
        /// <param name="cashCheqReceive">fund withdrawal request model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateFndWithdrawalReq(tblFundWithdrawalRequest editFndWithdrawalReq)
        {
            try
            {
                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                if (fndWithdrawalReqFactory.GetAll().Any(a => a.bank_branch_id == editFndWithdrawalReq.bank_branch_id && a.cheque_no == editFndWithdrawalReq.cheque_no && a.id != editFndWithdrawalReq.id) && editFndWithdrawalReq.cheque_no != null)
                {
                    return Json(new { success = false, errorMessage = "This cheque already is in use!!!" });
                }
                else
                {
                    fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                    tblFundWithdrawalRequest obj = new tblFundWithdrawalRequest();
                    obj = editFndWithdrawalReq;

                    if (editFndWithdrawalReq.remarks != null && editFndWithdrawalReq.remarks != "")
                        obj.remarks = editFndWithdrawalReq.remarks.Trim();

                    obj.membership_id = membership_id;
                    obj.changed_user_id = User.Identity.GetUserId();
                    obj.changed_date = DateTime.Now;
                    obj.is_dirty = 1;

                    fndWithdrawalReqFactory.Edit(obj);
                    fndWithdrawalReqFactory.Save();

                    return Json(new { success = true });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete fund withdrawal request
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteFndWithdrawalReq(int id)
        {
            try
            {
                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var obj = fndWithdrawalReqFactory.FindBy(b => b.id == id).FirstOrDefault();

                fndWithdrawalReqFactory.Delete(obj);
                fndWithdrawalReqFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (fndWithdrawalReqFactory != null)
            {
                fndWithdrawalReqFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}