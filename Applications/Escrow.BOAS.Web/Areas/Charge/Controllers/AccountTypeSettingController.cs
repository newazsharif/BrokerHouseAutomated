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
///Created date: 26/1/2015
///Reason: Global Account Type Setting Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Charge.Controllers
{
    public class AccountTypeSettingController : Controller
    {
        // GET: Charge/AccountTypeSetting

        public AccountTypeSettingController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public AccountTypeSettingController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IGenericFactory<tblGlobalAccountTypeSetting> globalAccountTypeSettingFactory;

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

        
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Account Type Setting List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult AccTypeSettingList()
        {
            return View();
        }

        /// <summary>
        /// Get all account type setting
        /// </summary>
        /// <param></param>
        /// <returns>account type setting list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getAccTypeSettingList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                globalAccountTypeSettingFactory = new GlobalAccountTypeSettingFactory();

                var accountTypeSetting = globalAccountTypeSettingFactory.GetAll()
                    .Select(a => new
                    {
                        id = a.account_type_id,
                        account_type = a.tblConstantObjectValue4.display_value,
                        a.initial_deposit,
                        minimum_balance_on = a.tblConstantObjectValue1.display_value,
                        a.minimum_balance,
                        minimum_balance_is_percentage = a.minimum_balance_is_percentage == 0 ? "N" : "Y",
                        withdraw_limit_on = a.tblConstantObjectValue3.display_value,
                        a.withdraw_limit,
                        withdraw_limit_percentage = a.withdraw_limit_percentage == 0 ? "N" : "Y",
                        loan_ratio = a.loan_ratio == 0 ? "N" : "Y",
                        a.loan_max,
                        loan_on = a.tblConstantObjectValue.display_value,
                        profit_on = a.tblConstantObjectValue2.display_value
                    }).OrderBy(a => new { a.id }).ToList();

                var jsonResult = Json(new { accountTypeSetting = accountTypeSetting, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add Account Type Setting view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult AccTypeSetting()
        {
            return View();
        }

        /// <summary>
        /// Add account type Setting
        /// </summary>
        /// <param name="accountTypeSetting">global account type Setting model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult AddAccTypeSetting(tblGlobalAccountTypeSetting accountTypeSetting)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                globalAccountTypeSettingFactory = new GlobalAccountTypeSettingFactory();

                tblGlobalAccountTypeSetting objAccountTypeSetting = new tblGlobalAccountTypeSetting();

                objAccountTypeSetting = globalAccountTypeSettingFactory.FindBy(a => a.account_type_id == accountTypeSetting.account_type_id).FirstOrDefault();

                if (objAccountTypeSetting == null)
                {
                    objAccountTypeSetting = new tblGlobalAccountTypeSetting();

                    objAccountTypeSetting = accountTypeSetting;

                    objAccountTypeSetting.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                    objAccountTypeSetting.membership_id = membership_id;
                    objAccountTypeSetting.changed_user_id = User.Identity.GetUserId();
                    objAccountTypeSetting.changed_date = DateTime.Now;
                    objAccountTypeSetting.is_dirty = 1;

                    globalAccountTypeSettingFactory.Add(objAccountTypeSetting);
                    globalAccountTypeSettingFactory.Save();

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
        /// Edit Account Type Setting view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditAccTypeSetting()
        {
            return View();
        }

        /// <summary>
        /// Get single account type setting by account type id
        /// </summary>
        /// <param name="id">account_type_id</param>
        /// <returns>global account type setting model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getAccTypeSettingById(int id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                globalAccountTypeSettingFactory = new GlobalAccountTypeSettingFactory();

                var accountTypeSetting = globalAccountTypeSettingFactory.FindBy(b => b.account_type_id == id)
                    .Select(a => new
                    {
                        a.account_type_id,
                        account_type = a.tblConstantObjectValue4.display_value,
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

                return Json(new { accountTypeSetting = accountTypeSetting, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit account type setting
        /// </summary>
        /// <param name="editAccountTypeSetting">global account type setting model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult UpdateAccTypeSetting(tblGlobalAccountTypeSetting editAccountTypeSetting)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                globalAccountTypeSettingFactory = new GlobalAccountTypeSettingFactory();

                tblGlobalAccountTypeSetting objAccountTypeSetting = new tblGlobalAccountTypeSetting();

                objAccountTypeSetting = editAccountTypeSetting;

                objAccountTypeSetting.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                objAccountTypeSetting.membership_id = membership_id;
                objAccountTypeSetting.changed_user_id = User.Identity.GetUserId();
                objAccountTypeSetting.changed_date = DateTime.Now;
                objAccountTypeSetting.is_dirty = 1;

                globalAccountTypeSettingFactory.Edit(objAccountTypeSetting);
                globalAccountTypeSettingFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete account type setting
        /// </summary>
        /// <param name="id">account_type_id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteAccTypeSetting(int id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                globalAccountTypeSettingFactory = new GlobalAccountTypeSettingFactory();

                tblGlobalAccountTypeSetting objAccountTypeSetting = new tblGlobalAccountTypeSetting();

                objAccountTypeSetting = globalAccountTypeSettingFactory.FindBy(b => b.account_type_id == id).FirstOrDefault();

                globalAccountTypeSettingFactory.Delete(objAccountTypeSetting);
                globalAccountTypeSettingFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (globalAccountTypeSettingFactory != null)
            {
                globalAccountTypeSettingFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}