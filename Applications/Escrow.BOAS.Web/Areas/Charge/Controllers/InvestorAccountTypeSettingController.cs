using Escrow.BOAS.Utility;
using Escrow.BOAS.Web.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.Charge.Models;
using Escrow.BOAS.Charge.Factories;
using Escrow.Utility.Interfaces;
using System.Data.Entity.Validation;
using System.Transactions;


///=============================================================
///Created by: Asif
///Created date: 31/1/2015
///Reason: Investor Account Type Setting Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Charge.Controllers
{
    public class InvestorAccountTypeSettingController : Controller
    {
        // GET: Charge/InvestorAccountTypeSetting

        public InvestorAccountTypeSettingController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public InvestorAccountTypeSettingController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IGenericFactory<tblInvestorAccountTypeSetting> investorAccountTypeSettingFactory;

        #endregion

        #region load dropdown

        /// <summary>
        /// Get all Transaction On
        /// </summary>
        /// <param></param>
        /// <returns>transaction on list in json</returns>
        //[Authorize]
        public JsonResult getTransactionOnDdlList()
        {
            var transactionOnList = DropDown.ddlTransactionOn();

            return Json(transactionOnList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all account type of investor
        /// </summary>
        /// <param></param>
        /// <returns>account list in json</returns>
        public JsonResult getddlInvestorAccType()
        {
            var investorAccountTypeList = DropDown.ddlAccountType();
            return Json(investorAccountTypeList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        /// <summary>
        /// Get single investor information by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>investor</returns>
        
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

        
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Investor Account Type Setting List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult InvAccTypeSettingList()
        {
            return View();
        }

        /// <summary>
        /// Get all investor account type setting
        /// </summary>
        /// <param></param>
        /// <returns>investor account type setting list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getInvAccTypeSettingList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                investorAccountTypeSettingFactory = new InvestorAccountTypeSettingFactory();

                var invAccTypeSetting = investorAccountTypeSettingFactory.GetAll()
                    .Select(a => new
                    {
                        a.id,
                        a.client_id,
                        account_type = a.tblConstantObjectValue.display_value,
                        a.initial_deposit,
                        minimum_balance_on = a.tblConstantObjectValue2.display_value,
                        a.minimum_balance,
                        minimum_balance_is_percentage = a.minimum_balance_is_percentage == 0 ? "N" : "Y",
                        withdraw_limit_on = a.tblConstantObjectValue4.display_value,
                        a.withdraw_limit,
                        withdraw_limit_percentage = a.withdraw_limit_percentage == 0 ? "N" : "Y",
                        loan_ratio = a.loan_ratio == 0 ? "N" : "Y",
                        a.loan_max,
                        loan_on = a.tblConstantObjectValue1.display_value,
                        profit_on = a.tblConstantObjectValue3.display_value
                    }).OrderBy(a => new { a.id }).ToList();

                var jsonResult = Json(new { invAccTypeSetting = invAccTypeSetting, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add Investor Account Type Setting view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult InvAccTypeSetting()
        {
            return View();
        }

        /// <summary>
        /// Add investor account type Setting
        /// </summary>
        /// <param name="invAccTypeSetting">investor account type Setting model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult AddInvAccTypeSetting(tblInvestorAccountTypeSetting invAccTypeSetting)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                investorAccountTypeSettingFactory = new InvestorAccountTypeSettingFactory();

                tblInvestorAccountTypeSetting objInvAccTypeSetting = new tblInvestorAccountTypeSetting();

                objInvAccTypeSetting = investorAccountTypeSettingFactory.FindBy(a => a.account_type_id == invAccTypeSetting.account_type_id && a.client_id == invAccTypeSetting.client_id).FirstOrDefault();

                if (objInvAccTypeSetting == null)
                {
                    objInvAccTypeSetting = new tblInvestorAccountTypeSetting();

                    objInvAccTypeSetting = invAccTypeSetting;

                    objInvAccTypeSetting.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                    objInvAccTypeSetting.membership_id = membership_id;
                    objInvAccTypeSetting.changed_user_id = User.Identity.GetUserId();
                    objInvAccTypeSetting.changed_date = DateTime.Now;
                    objInvAccTypeSetting.is_dirty = 1;

                    investorAccountTypeSettingFactory.Add(objInvAccTypeSetting);
                    investorAccountTypeSettingFactory.Save();

                    return Json(new { success = true });
                }
                else
                {
                    return Json(new { success = false, errorMessage = "This setting already exists!!!!" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit Investor Account Type Setting view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditInvAccTypeSetting()
        {
            return View();
        }

        /// <summary>
        /// Get single investor account type setting by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>investor account type setting model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getInvAccTypeSettingById(int id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                investorAccountTypeSettingFactory = new InvestorAccountTypeSettingFactory();

                var invAccTypeSetting = investorAccountTypeSettingFactory.FindBy(b => b.id == id)
                    .Select(a => new
                    {
                        a.id,
                        a.client_id,
                        a.account_type_id,
                        a.initial_deposit,
                        a.minimum_balance_on,
                        a.minimum_balance,
                        a.minimum_balance_is_percentage,
                        a.withdraw_limit_on,
                        a.withdraw_limit,
                        a.withdraw_limit_percentage,
                        a.loan_ratio,
                        a.loan_max,
                        a.loan_on,
                        a.profit_on
                    }).FirstOrDefault();

                return Json(new { invAccTypeSetting = invAccTypeSetting, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit investor account type setting
        /// </summary>
        /// <param name="editInvAccTypeSetting">investor account type setting model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult UpdateInvAccTypeSetting(tblInvestorAccountTypeSetting editInvAccTypeSetting)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                investorAccountTypeSettingFactory = new InvestorAccountTypeSettingFactory();

                tblInvestorAccountTypeSetting objInvAccTypeSetting = new tblInvestorAccountTypeSetting();

                objInvAccTypeSetting = investorAccountTypeSettingFactory.FindBy(a => a.account_type_id == editInvAccTypeSetting.account_type_id && a.client_id == editInvAccTypeSetting.client_id && a.id != editInvAccTypeSetting.id).FirstOrDefault();

                if (objInvAccTypeSetting == null)
                {
                    objInvAccTypeSetting = new tblInvestorAccountTypeSetting();

                    objInvAccTypeSetting = editInvAccTypeSetting;

                    objInvAccTypeSetting.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                    objInvAccTypeSetting.membership_id = membership_id;
                    objInvAccTypeSetting.changed_user_id = User.Identity.GetUserId();
                    objInvAccTypeSetting.changed_date = DateTime.Now;
                    objInvAccTypeSetting.is_dirty = 1;

                    investorAccountTypeSettingFactory.Edit(objInvAccTypeSetting);
                    investorAccountTypeSettingFactory.Save();

                    return Json(new { success = true });
                }
                else
                {
                    return Json(new { success = false, errorMessage = "This setting already exists!!!!" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete investor account type setting
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteInvAccTypeSetting(int id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                investorAccountTypeSettingFactory = new InvestorAccountTypeSettingFactory();

                tblInvestorAccountTypeSetting objInvAccTypeSetting = new tblInvestorAccountTypeSetting();

                objInvAccTypeSetting = investorAccountTypeSettingFactory.FindBy(b => b.id == id).FirstOrDefault();

                investorAccountTypeSettingFactory.Delete(objInvAccTypeSetting);
                investorAccountTypeSettingFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (investorAccountTypeSettingFactory != null)
            {
                investorAccountTypeSettingFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}