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
using System.Configuration;
using Escrow.BOAS.BrokerManagement.Factories;
using Escrow.Security;
using Escrow.Security.Factories;


///=============================================================
///Created by: Asif
///Created date: 23/8/2015
///Reason: Fund Payment Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class FundPaymentController : Controller
    {
        // GET: Transaction/FundPayment
        
        #region global variables

        private IGenericFactory<tblFundWithdraw> fundPaymentFactory;

        private IGenericFactory<tblFundWithdrawalRequest> fndWithdrawalReqFactory;

        #endregion

        public FundPaymentController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public FundPaymentController(UserManager<ApplicationUser> userManager)
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
        private string getMaxVoucherNo()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundPaymentFactory = new FundPaymentFactory();

                decimal id = fundPaymentFactory.GetAll().Any() ? fundPaymentFactory.GetAll().Max(a => a.id) : 0;

                string prev_voucher_no = "00000";
                if (id != 0)
                {
                    prev_voucher_no = fundPaymentFactory.GetAll().Where(a => a.id == id).Select(a => a.voucher_no).FirstOrDefault();
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
        /// Fund Payment view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FndPayment()
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

        public JsonResult getBalanceCheckType()
        {
            string balance_check_type = ConfigManager.balance_check_type;

            if (balance_check_type != null)
            {
                return Json(new { success = true, balance_check_type = balance_check_type }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { success = false, errorMessage = "Balance check type not set yet!!!!" }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Get single investor information by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>investor</returns>
        [CheckUserSessionAttribute]
        public JsonResult getInvestorInfoById(string id)
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
        /// Get previous unapprove fund receive by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>error or success message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getPrevUnapprovedFndPaymentByClientId(string id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundPaymentFactory = new FundPaymentFactory();

                List<tblFundWithdraw> fundPaymentList = fundPaymentFactory.GetAll().Where(a => a.client_id == id && a.approve_by == null).ToList();

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                List<tblFundWithdrawalRequest> fundWithdrawRecList = fndWithdrawalReqFactory.GetAll().Where(a => a.client_id == id && a.approve_by != null && a.is_dirty == 1).ToList();

                string vouchersAndAmountsForPayment = "";
                string vouchersAndAmountsForPaymentRequest = "";

                if (fundPaymentList.Count > 0)
                {
                    foreach (tblFundWithdraw item in fundPaymentList)
                    {
                        vouchersAndAmountsForPayment += "Voucher No: " + item.voucher_no + " Amount: " + item.amount.ToString("#.##") + ", ";
                    }
                }

                if (fundWithdrawRecList.Count > 0)
                {
                    foreach (tblFundWithdrawalRequest item in fundWithdrawRecList)
                    {
                        vouchersAndAmountsForPaymentRequest += "Voucher No: " + item.voucher_no + " Amount: " + item.amount.ToString("#.##") + ", ";
                    }
                }

                if(vouchersAndAmountsForPayment != "" && vouchersAndAmountsForPaymentRequest != "")
                {
                    return Json(new { success = true, msg = "This Investor already have " + fundPaymentList.Count + " payment pending " + vouchersAndAmountsForPayment + "and " + fundWithdrawRecList.Count + " payment request process pending " + vouchersAndAmountsForPaymentRequest + " are you sure you want to save this fund payment..." }, JsonRequestBehavior.AllowGet);
                }
                else if (vouchersAndAmountsForPayment != "")
                {
                    return Json(new { success = true, msg = "This Investor already have " + fundPaymentList.Count + " payment pending " + vouchersAndAmountsForPayment + "are you sure you want to save this fund payment..." }, JsonRequestBehavior.AllowGet);
                }
                else if (vouchersAndAmountsForPaymentRequest != "")
                {
                    return Json(new { success = true, msg = "This Investor already have " + fundWithdrawRecList.Count + " payment request process pending " + vouchersAndAmountsForPaymentRequest + "are you sure you want to save this fund payment..." }, JsonRequestBehavior.AllowGet);
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
        /// Add fund payment
        /// </summary>
        /// <param name="fundPayment">fund payment model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult addFundPayment(tblFundWithdraw fundPayment)
        {
            try
            {
                fundPaymentFactory = new FundPaymentFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                if (fundPaymentFactory.GetAll().Any(a => a.bank_branch_id == fundPayment.bank_branch_id && a.cheque_no == fundPayment.cheque_no) && fundPayment.cheque_no != null)
                {
                    return Json(new { success = false, errorMessage = "This cheque already is in use!!!" });
                }
                else
                {
                    fundPaymentFactory = new FundPaymentFactory();

                    tblFundWithdraw obj = new tblFundWithdraw();
                    obj = fundPayment;

                    if (fundPayment.remarks != null && fundPayment.remarks != "")
                        obj.remarks = fundPayment.remarks.Trim();

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

                    fundPaymentFactory.Add(obj);
                    fundPaymentFactory.Save();

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
        /// Fund Payment list view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FundPaymentList()
        {
            return View();
        }

        /// <summary>
        /// Get all fund payment list
        /// </summary>
        /// <param></param>
        /// <returns>fund payment list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getFndPaymentList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundPaymentFactory = new FundPaymentFactory();

                UserEmployeeMappingFactory userEmployeeMappingFactory = new UserEmployeeMappingFactory();

                string user_id = User.Identity.GetUserId();
                decimal branch_id =
                    userEmployeeMappingFactory.GetAll()
                        .Where(a => a.user_id == user_id)
                        .Select(x => x.tblEmployee.branch_id)
                        .FirstOrDefault();

                BrokerUserFactory userFactory = new BrokerUserFactory();
                decimal isAdmin = userFactory.GetAll().FirstOrDefault(x => x.UserId == user_id).is_admin;

                var fundPaymentList = fundPaymentFactory.GetAll().Where(a => a.approve_by == null && a.is_dirty == 1 && (isAdmin == 1 || a.broker_branch_id == branch_id))
                    .Select(s => new
                    {
                        s.id,
                        payment_dt = s.DimDate1.FullDateUK,
                        s.voucher_no,
                        branch = s.tblBrokerBranch.name,
                        s.client_id,
                        s.tblInvestor.bo_code,
                        s.tblInvestor.first_holder_name,
                        transaction_mode = s.tblConstantObjectValue.display_value,
                        bank_name = s.bank_branch_id != null ? ("Bank: " + s.tblBrokerBankAccount.tblBankBranch.tblBank.bank_name + ", Bank Branch: " + s.tblBrokerBankAccount.tblBankBranch.branch_name + ", Account No: " + s.tblBrokerBankAccount.account_no) : "",
                        cheque_dt = s.DimDate.FullDateUK,
                        s.cheque_no,
                        s.amount
                    })
                    .OrderBy(s => s.payment_dt)
                    .ToList();

                var jsonResult = Json(new { fundPaymentList = fundPaymentList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Edit Fund Payment view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditFundPayment()
        {
            return View();
        }

        /// <summary>
        /// Get single Fund Payment by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>Fund Payment model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getFndPaymentById(int id)
        {
            try
            {
                fundPaymentFactory = new FundPaymentFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var editFndPayment = fundPaymentFactory.FindBy(b => b.id == id)
                    .Select(s => new
                    {
                        s.id,
                        s.voucher_no,
                        s.client_id,
                        s.transaction_mode_id,
                        s.cheque_no,
                        cheque_dt = s.DimDate.FullDateUK,
                        s.bank_branch_id,
                        s.amount,
                        payment_dt = s.DimDate1.FullDateUK,
                        value_dt = s.DimDate2.FullDateUK,
                        s.broker_branch_id,
                        s.remarks
                    }).FirstOrDefault();

                return Json(new { editFndPayment = editFndPayment, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Update fund payment
        /// </summary>
        /// <param name="editFndPayment">fund payment model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateFundPayment(tblFundWithdraw editFndPayment)
        {
            try
            {
                fundPaymentFactory = new FundPaymentFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                if (fundPaymentFactory.GetAll().Any(a => a.bank_branch_id == editFndPayment.bank_branch_id && a.cheque_no == editFndPayment.cheque_no && a.id != editFndPayment.id) && editFndPayment.cheque_no != null)
                {
                    return Json(new { success = false, errorMessage = "This cheque already is in use!!!" });
                }
                else
                {
                    fundPaymentFactory = new FundPaymentFactory();

                    tblFundWithdraw obj = new tblFundWithdraw();
                    obj = editFndPayment;

                    if (editFndPayment.remarks != null && editFndPayment.remarks != "")
                        obj.remarks = editFndPayment.remarks.Trim();

                    obj.membership_id = membership_id;
                    obj.changed_user_id = User.Identity.GetUserId();
                    obj.changed_date = DateTime.Now;
                    obj.is_dirty = 1;

                    fundPaymentFactory.Edit(obj);
                    fundPaymentFactory.Save();

                    return Json(new { success = true });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete fund payment
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteFundPayment(int id)
        {
            try
            {
                fundPaymentFactory = new FundPaymentFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var obj = fundPaymentFactory.FindBy(b => b.id == id).FirstOrDefault();

                fundPaymentFactory.Delete(obj);
                fundPaymentFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (fundPaymentFactory != null)
            {
                fundPaymentFactory.Dispose();
            }

            if (fndWithdrawalReqFactory != null)
            {
                fndWithdrawalReqFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}