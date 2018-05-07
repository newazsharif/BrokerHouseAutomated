using Escrow.BOAS.Charge.Models;
using Escrow.BOAS.Utility;
using Escrow.BOAS.Web.Models;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.Charge.Factories;

///=============================================================
///Created by: Shohid
///Created date: 31/1/2016
///Reason: Sub Account Account Type Setting Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Charge.Controllers
{
    public class SubAccountAccountTypeSettingController : Controller
    {
        // GET: Charge/SubAccountAccountTypeSetting

         public SubAccountAccountTypeSettingController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

         public SubAccountAccountTypeSettingController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IGenericFactory<tblSubAccountAccountTypeSetting> subAccountAccoutntTypeSettingFactory;

        #endregion

        #region load dropdown

        /// <summary>
        /// Get all Transaction On
        /// </summary>
        /// <param></param>
        /// <returns>transaction on list in json</returns>
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
        /// Get all sub account
        /// </summary>
        /// <param></param>
        /// <returns>sub account list in json</returns>
        public JsonResult getSubAccountDdlList()
        {
            var subAccountList = DropDown.ddlInvestorSubAcc();

            return Json(subAccountList, JsonRequestBehavior.AllowGet);
        }


        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult Index()
        {
            return View();
        }

        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditSubAccAccTypeSetting()
        {
            return View();
        }


        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult SubAccAccTypeSetting()
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
        public ActionResult SubAccAccTypeSettingList()
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
        public JsonResult getSubAccAccTypeSettingList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                subAccountAccoutntTypeSettingFactory = new SubAccountAccountTypeSettingFactory();
                var subAccountAccountTypeSetting = subAccountAccoutntTypeSettingFactory.GetAll()
                    .Select(a => new
                {
                    sub_account = a.tblConstantObjectValue3.display_value,
                    a.id,
                    account_type = a.tblConstantObjectValue5.display_value,
                    a.initial_deposit,
                    minimum_balance_on = a.tblConstantObjectValue1.display_value,
                    a.minimum_balance,
                    minimum_balance_is_percentage = a.minimum_balance_is_percentage == 0 ? "N" : "Y",
                    withdraw_limit_on = a.tblConstantObjectValue4.display_value,
                    a.withdraw_limit,
                    withdraw_limit_percentage = a.withdraw_limit_percentage == 0 ? "N" : "Y",
                    loan_ratio = a.loan_ratio == 0 ? "N" : "Y",
                    a.loan_max,
                    loan_on = a.tblConstantObjectValue.display_value,
                    profit_on = a.tblConstantObjectValue2.display_value
                }).OrderBy(a => new { a.id }).ToList();

                var jsonResult = Json(new { subAccountAccountTypeSetting = subAccountAccountTypeSetting, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
                }
            catch(Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add account type Setting
        /// </summary>
        /// <param name="accountTypeSetting">global account type Setting model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult AddSubAccAccTypeSetting(tblSubAccountAccountTypeSetting subAccountTypeSetting)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                subAccountAccoutntTypeSettingFactory = new SubAccountAccountTypeSettingFactory();

                tblSubAccountAccountTypeSetting objSubAccountTypeSetting = new tblSubAccountAccountTypeSetting();

                objSubAccountTypeSetting = subAccountAccoutntTypeSettingFactory.FindBy(a => a.account_type_id == subAccountTypeSetting.account_type_id && a.sub_account_id == subAccountTypeSetting.sub_account_id).FirstOrDefault();

                if (objSubAccountTypeSetting == null)
                {
                    objSubAccountTypeSetting = new tblSubAccountAccountTypeSetting();

                    objSubAccountTypeSetting = subAccountTypeSetting;

                    objSubAccountTypeSetting.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                    objSubAccountTypeSetting.membership_id = membership_id;
                    objSubAccountTypeSetting.changed_user_id = User.Identity.GetUserId();
                    objSubAccountTypeSetting.changed_date = DateTime.Now;
                    objSubAccountTypeSetting.is_dirty = 1;

                    subAccountAccoutntTypeSettingFactory.Add(objSubAccountTypeSetting);
                    subAccountAccoutntTypeSettingFactory.Save();

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
        /// Get single account type setting by account type id
        /// </summary>
        /// <param name="id">account_type_id</param>
        /// <returns>global account type setting model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getSubAccAccTypeSettingById(int id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                subAccountAccoutntTypeSettingFactory = new SubAccountAccountTypeSettingFactory();

                var subAccountAccountTypeSetting = subAccountAccoutntTypeSettingFactory.FindBy(b => b.id == id)
                    .Select(a => new
                    {
                        a.id,
                        a.account_type_id,
                        a.sub_account_id,
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

                return Json(new { subAccountAccountTypeSetting = subAccountAccountTypeSetting, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }



        /// <summary>
        /// Edit sub account account type setting
        /// </summary>
        /// <param name="editAccountTypeSetting">global account type setting model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult UpdateSubAccAccTypeSetting(tblSubAccountAccountTypeSetting editAccountTypeSetting)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                subAccountAccoutntTypeSettingFactory = new SubAccountAccountTypeSettingFactory();

               
                tblSubAccountAccountTypeSetting objSubAccountAccountTypeSetting = new tblSubAccountAccountTypeSetting();

                objSubAccountAccountTypeSetting = subAccountAccoutntTypeSettingFactory.FindBy(a => a.sub_account_id == editAccountTypeSetting.sub_account_id && a.account_type_id == editAccountTypeSetting.account_type_id && a.id != editAccountTypeSetting.id).FirstOrDefault();

                if (objSubAccountAccountTypeSetting == null)
                {
                    objSubAccountAccountTypeSetting = editAccountTypeSetting;

                    objSubAccountAccountTypeSetting.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                    objSubAccountAccountTypeSetting.membership_id = membership_id;
                    objSubAccountAccountTypeSetting.changed_user_id = User.Identity.GetUserId();
                    objSubAccountAccountTypeSetting.changed_date = DateTime.Now;
                    objSubAccountAccountTypeSetting.is_dirty = 1;

                    subAccountAccoutntTypeSettingFactory.Edit(objSubAccountAccountTypeSetting);
                    subAccountAccoutntTypeSettingFactory.Save();

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
        /// Delete account type setting
        /// </summary>
        /// <param name="id">account_type_id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteSubAccAccTypeSetting(int id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                subAccountAccoutntTypeSettingFactory = new SubAccountAccountTypeSettingFactory();

                tblSubAccountAccountTypeSetting objSubAccountAccountTypeSetting = new tblSubAccountAccountTypeSetting();

                objSubAccountAccountTypeSetting = subAccountAccoutntTypeSettingFactory.FindBy(b => b.id == id).FirstOrDefault();

                subAccountAccoutntTypeSettingFactory.Delete(objSubAccountAccountTypeSetting);
                subAccountAccoutntTypeSettingFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (subAccountAccoutntTypeSettingFactory != null)
            {
                subAccountAccoutntTypeSettingFactory.Dispose();
            }

            base.Dispose(disposing);
        }

    }
}