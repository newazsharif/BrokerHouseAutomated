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
///Reason: Branch Account Type Setting Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Charge.Controllers
{
    public class BranchAccountTypeSettingController : Controller
    {
        // GET: Charge/BranchAccountTypeSetting

        public BranchAccountTypeSettingController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public BranchAccountTypeSettingController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IGenericFactory<tblBranchAccountTypeSetting> branchAccountTypeSettingFactory;

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

        /// <summary>
        /// Get all broker branch
        /// </summary>
        /// <param></param>
        /// <returns>broker branch list in json</returns>
        public JsonResult getBranchDdlList()
        {
            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

            string user_id = User.Identity.GetUserId();

            var branchList = DropDown.ddlBrokerBranch(user_id, membership_id);

            return Json(branchList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Branch Account Type Setting List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult BranchAccTypeSettingList()
        {
            return View();
        }

        /// <summary>
        /// Get all branch account type setting
        /// </summary>
        /// <param></param>
        /// <returns>branch account type setting list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getBranchAccTypeSettingList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                branchAccountTypeSettingFactory = new BranchAccountTypeSettingFactory();

                var branchAccTypeSetting = branchAccountTypeSettingFactory.GetAll()
                    .Select(a => new
                    {
                        a.id,
                        branch = a.tblBrokerBranch.name,
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

                var jsonResult = Json(new { branchAccTypeSetting = branchAccTypeSetting, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add Branch Account Type Setting view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult BranchAccTypeSetting()
        {
            return View();
        }

        /// <summary>
        /// Add branch account type Setting
        /// </summary>
        /// <param name="branchAccTypeSetting">branch account type Setting model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult AddBranchAccTypeSetting(tblBranchAccountTypeSetting branchAccTypeSetting)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                branchAccountTypeSettingFactory = new BranchAccountTypeSettingFactory();

                tblBranchAccountTypeSetting objBranchAccTypeSetting = new tblBranchAccountTypeSetting();

                objBranchAccTypeSetting = branchAccountTypeSettingFactory.FindBy(a => a.account_type_id == branchAccTypeSetting.account_type_id && a.branch_id == branchAccTypeSetting.branch_id).FirstOrDefault();

                if (objBranchAccTypeSetting == null)
                {
                    objBranchAccTypeSetting = new tblBranchAccountTypeSetting();

                    objBranchAccTypeSetting = branchAccTypeSetting;

                    objBranchAccTypeSetting.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                    objBranchAccTypeSetting.membership_id = membership_id;
                    objBranchAccTypeSetting.changed_user_id = User.Identity.GetUserId();
                    objBranchAccTypeSetting.changed_date = DateTime.Now;
                    objBranchAccTypeSetting.is_dirty = 1;

                    branchAccountTypeSettingFactory.Add(objBranchAccTypeSetting);
                    branchAccountTypeSettingFactory.Save();

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
        /// Edit Branch Account Type Setting view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditBranchAccTypeSetting()
        {
            return View();
        }

        /// <summary>
        /// Get single branch account type setting by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>branch account type setting model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getBranchAccTypeSettingById(int id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                branchAccountTypeSettingFactory = new BranchAccountTypeSettingFactory();

                var branchAccTypeSetting = branchAccountTypeSettingFactory.FindBy(b => b.id == id)
                    .Select(a => new
                    {
                        a.id,
                        a.branch_id,
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

                return Json(new { branchAccTypeSetting = branchAccTypeSetting, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit branch account type setting
        /// </summary>
        /// <param name="editBranchAccTypeSetting">branch account type setting model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult UpdateBranchAccTypeSetting(tblBranchAccountTypeSetting editBranchAccTypeSetting)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                branchAccountTypeSettingFactory = new BranchAccountTypeSettingFactory();

                tblBranchAccountTypeSetting objBranchAccTypeSetting = new tblBranchAccountTypeSetting();

                objBranchAccTypeSetting = branchAccountTypeSettingFactory.FindBy(a => a.account_type_id == editBranchAccTypeSetting.account_type_id && a.branch_id == editBranchAccTypeSetting.branch_id && a.id != editBranchAccTypeSetting.id).FirstOrDefault();

                if (objBranchAccTypeSetting == null)
                {
                    objBranchAccTypeSetting = new tblBranchAccountTypeSetting();

                    objBranchAccTypeSetting = editBranchAccTypeSetting;

                    objBranchAccTypeSetting.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                    objBranchAccTypeSetting.membership_id = membership_id;
                    objBranchAccTypeSetting.changed_user_id = User.Identity.GetUserId();
                    objBranchAccTypeSetting.changed_date = DateTime.Now;
                    objBranchAccTypeSetting.is_dirty = 1;

                    branchAccountTypeSettingFactory.Edit(objBranchAccTypeSetting);
                    branchAccountTypeSettingFactory.Save();

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
        /// Delete branch account type setting
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteBranchAccTypeSetting(int id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                branchAccountTypeSettingFactory = new BranchAccountTypeSettingFactory();

                tblBranchAccountTypeSetting objBranchAccTypeSetting = new tblBranchAccountTypeSetting();

                objBranchAccTypeSetting = branchAccountTypeSettingFactory.FindBy(b => b.id == id).FirstOrDefault();

                branchAccountTypeSettingFactory.Delete(objBranchAccTypeSetting);
                branchAccountTypeSettingFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (branchAccountTypeSettingFactory != null)
            {
                branchAccountTypeSettingFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}