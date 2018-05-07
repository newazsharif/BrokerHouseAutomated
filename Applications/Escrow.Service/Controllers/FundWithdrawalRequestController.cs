using Escrow.BOAS.Transaction.Factories;
using Escrow.BOAS.Transaction.Models;
using Escrow.Security.Factories;
using Escrow.Security.Models;
using Escrow.Service.Models;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Escrow.Service.Controllers
{
    [Authorize]
    public class FundWithdrawalRequestController : ApiController
    {
        // GET api/<controller>

        public FundWithdrawalRequestController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public FundWithdrawalRequestController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;

        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IReadOnlyFactory<tblBrokerInformation> brokerFactory;
        private IGenericFactory<tblFundWithdrawalRequest> fndWithdrawalReqFactory;

        int active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "ACTIVE"));

        #endregion

        /// <summary>
        /// Get transaction mode id by transaction mode
        /// </summary>
        /// <param>BrokerName</param>
        /// <param>transaction_mode</param>
        /// <returns>transaction mode id</returns>
        [HttpGet]
        public HttpResponseMessage getTransactionModeId(string BrokerName, string transaction_mode)
        {
            decimal result = CommonUtility.getObjValByObjNameAndDisplayVal("TRANSACTION_MODE", transaction_mode);

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        private string getCurrentDateWiseVoucherNo(DateTime process_date)
        {
            return (DateTimeConfig.FullDateUKtoDateKey(process_date.ToString("dd/MM/yyyy"))).ToString();
        }

        /// <summary>
        /// get maximum voucher no
        /// </summary>
        /// <param></param>
        /// <returns>voucher_no or fail message</returns>
        private string getMaxVoucherNo(string BrokerName)
        {
            try
            {
                brokerFactory = new BrokerFactory();
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

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

        /// <summary>
        /// Get previous voucher no
        /// </summary>
        /// <param></param>
        /// <returns>prev_voucher_no</returns>
        [HttpGet]
        public HttpResponseMessage getPrevVouchNo(string BrokerName, string process_date)
        {
            brokerFactory = new BrokerFactory();
            decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

            string prev_voucher_no = "";

            string voucher_no = getMaxVoucherNo(BrokerName);

            if (voucher_no.Length == 13)
            {
                prev_voucher_no = voucher_no;
            }
            else
            {
                prev_voucher_no = getCurrentDateWiseVoucherNo(Convert.ToDateTime(process_date)) + voucher_no;
            }

            return Request.CreateResponse(HttpStatusCode.OK, prev_voucher_no);
        }

        /// <summary>
        /// Get previous unapprove fund withdrawal request by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>error or success message</returns>
        [HttpGet]
        public HttpResponseMessage getPrevUnapprovedFndWithRecByClientId()
        {
            try
            {
                string client_id = User.Identity.GetUserName();

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                List<tblFundWithdrawalRequest> fundWithdrawRecList = fndWithdrawalReqFactory.GetAll().Where(a => a.client_id == client_id && a.approve_by == null).ToList();

                if (fundWithdrawRecList.Count > 0)
                {
                    string vouchersAndAmounts = "";

                    foreach (tblFundWithdrawalRequest item in fundWithdrawRecList)
                    {
                        vouchersAndAmounts += "Voucher No: " + item.voucher_no + " Amount: " + item.amount.ToString("#.##") + ", ";
                    }

                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, msg = "This Investor already have " + fundWithdrawRecList.Count + " withdrawal request pending " + vouchersAndAmounts + "are you sure you want to save this withdrawal request..." });
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = false });
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Add fund withdrawal request
        /// </summary>
        /// <param name="fndWithdrawalReq">Withdrawal Request model</param>
        /// <returns>success or error message</returns>
        [HttpPost]
        public HttpResponseMessage addFndWithdrawalReq(tblFundWithdrawalRequest fndWithdrawalReq, string BrokerName, string process_date)
        {
            try
            {
                brokerFactory = new BrokerFactory();
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                tblFundWithdrawalRequest obj = new tblFundWithdrawalRequest();
                obj = fndWithdrawalReq;

                if (fndWithdrawalReq.remarks != null && fndWithdrawalReq.remarks != "")
                    obj.remarks = fndWithdrawalReq.remarks.Trim();

                obj.client_id = User.Identity.GetUserName();
                obj.active_status_id = active_status_id;

                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;

                string maxVoucherNo = getMaxVoucherNo(BrokerName);

                string currDateVoucherNo = getCurrentDateWiseVoucherNo(Convert.ToDateTime(process_date));

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
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, voucher_no = obj.voucher_no, prev_voucher_no = (currDateVoucherNo + maxVoucherNo) });
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, voucher_no = obj.voucher_no, prev_voucher_no = maxVoucherNo });
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Get all fund withdrawal request list
        /// </summary>
        /// <param></param>
        /// <returns>fund withdrawal request list in json or error message</returns>
        [HttpGet]
        public HttpResponseMessage getFndWithdrawalReqList(string status)
        {
            try
            {
                string client_id = User.Identity.GetUserName();

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                var obj = (dynamic)null;

                if (status == "Pending")
                {
                    obj = fndWithdrawalReqFactory.GetAll().Where(a => a.approve_by == null && a.client_id == client_id)
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
                            cheque_dt = s.DimDate.FullDateUK,
                            bank_name = s.bank_branch_id != null ? ("Bank: " + s.tblBrokerBankAccount.tblBankBranch.tblBank.bank_name + ", Bank Branch: " + s.tblBrokerBankAccount.tblBankBranch.branch_name + ", Account No: " + s.tblBrokerBankAccount.account_no) : "",
                            s.cheque_no,
                            s.amount
                        })
                        .OrderBy(s => s.request_dt)
                        .ToList();
                }
                else
                {
                    obj = fndWithdrawalReqFactory.GetAll().Where(a => a.approve_by != null && a.client_id == client_id)
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
                            cheque_dt = s.DimDate.FullDateUK,
                            bank_name = s.bank_branch_id != null ? ("Bank: " + s.tblBrokerBankAccount.tblBankBranch.tblBank.bank_name + ", Bank Branch: " + s.tblBrokerBankAccount.tblBankBranch.branch_name + ", Account No: " + s.tblBrokerBankAccount.account_no) : "",
                            s.cheque_no,
                            s.amount
                        })
                        .OrderBy(s => s.request_dt)
                        .ToList();
                }

                object result = obj;

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Get single Fund Withdrawal Request by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>Fund Withdrawal Request model in json or error message</returns>
        [HttpGet]
        public HttpResponseMessage getFndWithdrawalReqById(int id)
        {
            try
            {
                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

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

                return Request.CreateResponse(HttpStatusCode.OK, editFndWithdrawalReq);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Update fund withdrawal request
        /// </summary>
        /// <param name="cashCheqReceive">fund withdrawal request model</param>
        /// <returns>success or error message</returns>
        [HttpPost]
        public HttpResponseMessage updateFndWithdrawalReq(tblFundWithdrawalRequest editFndWithdrawalReq, string BrokerName)
        {
            try
            {
                brokerFactory = new BrokerFactory();
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                tblFundWithdrawalRequest obj = new tblFundWithdrawalRequest();
                obj = editFndWithdrawalReq;

                if (editFndWithdrawalReq.remarks != null && editFndWithdrawalReq.remarks != "")
                    obj.remarks = editFndWithdrawalReq.remarks.Trim();

                obj.active_status_id = active_status_id;

                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;

                fndWithdrawalReqFactory.Edit(obj);
                fndWithdrawalReqFactory.Save();

                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Delete fund withdrawal request
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        [HttpPost]
        public HttpResponseMessage deleteFndWithdrawalReq(int id)
        {
            try
            {
                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                var obj = fndWithdrawalReqFactory.FindBy(b => b.id == id).FirstOrDefault();

                fndWithdrawalReqFactory.Delete(obj);
                fndWithdrawalReqFactory.Save();

                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (Exception ex)
            {
                throw ex;
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