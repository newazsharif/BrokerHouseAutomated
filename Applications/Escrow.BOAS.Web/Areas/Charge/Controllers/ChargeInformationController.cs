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
///Created date: 12/1/2015
///Reason: Charge Information Controller
///=============================================================




namespace Escrow.BOAS.Web.Areas.Charge.Controllers
{
    public class ChargeInformationController : Controller
    {
        // GET: Charge/ChargeInformation

        public ChargeInformationController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ChargeInformationController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IGenericFactory<tblGlobalCharge> globalChargeFactory;

        private IGenericFactory<tblGlobalChargeSlab> globalChargeSlabFactory;

        #endregion

        #region load dropdown


        /// <summary>
        /// Get all charge type
        /// </summary>
        /// <param></param>
        /// <returns>charge type list in json</returns>
        //[Authorize]
        public JsonResult getChargeTypeDdlList()
        {
            var chargeTypeList = DropDown.ddlChargeType();

            return Json(chargeTypeList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Get investor charge information by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>ivestor charge and slab list</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getChargeInfoById(decimal id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                globalChargeFactory = new GlobalChargeFactory();

                var objGlobalCharge = globalChargeFactory.FindBy(b => b.id == id)
                    .Select(a => new
                    {
                        a.id,
                        a.short_code,
                        a.name,
                        a.charge_amount,
                        a.minimum_charge,
                        a.is_percentage,
                        a.charge_type_id,
                        effective_dt = a.DimDate.FullDateUK,
                        a.is_slab,
                        a.income_account_no,
                        a.payable_account_no,
                        a.payable_amount,
                        a.is_payable_percentage,
                        a.membership_id,
                        a.changed_user_id,
                        a.changed_date,
                        a.is_dirty
                    })
                    .FirstOrDefault();

                var objGlobalChargeSlab = (dynamic)null;

                if (objGlobalCharge.is_slab == 1)
                {
                    globalChargeSlabFactory = new GloabalChargeSlabFactory();

                    objGlobalChargeSlab = globalChargeSlabFactory.GetAll()
                        .Where(a => a.global_charge_id == objGlobalCharge.id)
                    .Select(a => new
                    {
                        a.id,
                        a.global_charge_id,
                        a.amount_from,
                        a.amount_to,
                        a.charge_amount,
                        a.is_percentage
                    })
                    .OrderBy(a => a.amount_to)
                    .ToList();
                }
                else
                {
                    List<tblInvestorChargeSlab> obj = new List<tblInvestorChargeSlab>();

                    objGlobalChargeSlab = obj;
                }

                return Json(new { chargeInfo = objGlobalCharge, chargeInfoSlab = objGlobalChargeSlab, success = true }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Update charge information
        /// </summary>
        /// <param name="chargeInfo">global charge model</param>
        /// <param name="chargeInfoSlab">global charge slab model list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult UpdateChargeInfo(tblGlobalCharge chargeInfo, List<tblGlobalChargeSlab> chargeInfoSlab)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    globalChargeFactory = new GlobalChargeFactory();

                    globalChargeSlabFactory = new GloabalChargeSlabFactory();

                    tblGlobalCharge objGlobalCharge = new tblGlobalCharge();

                    chargeInfo.income_account_no = globalChargeFactory.GetAll().Where(a => a.id == chargeInfo.id).Select(a => a.income_account_no).FirstOrDefault();


                    List<tblGlobalChargeSlab> objGlobalChargeSlabList = globalChargeSlabFactory.GetAll().Where(a => a.global_charge_id == chargeInfo.id).ToList();

                    tblGlobalChargeSlab objGlobalChargSlab = null;

                    foreach (tblGlobalChargeSlab item in objGlobalChargeSlabList)
                    {
                        objGlobalChargSlab = new tblGlobalChargeSlab();

                        objGlobalChargSlab = item;

                        globalChargeSlabFactory.Delete(objGlobalChargSlab);
                    }

                    objGlobalCharge = chargeInfo;

                    objGlobalCharge.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                    objGlobalCharge.membership_id = membership_id;
                    objGlobalCharge.changed_user_id = User.Identity.GetUserId();
                    objGlobalCharge.changed_date = DateTime.Now;
                    objGlobalCharge.is_dirty = 1;

                    globalChargeFactory.Edit(objGlobalCharge);
                    globalChargeFactory.Save();


                    if (chargeInfo.is_slab == 1)
                    {
                        tblGlobalChargeSlab objGlobalChargeSlab = null;

                        foreach (tblGlobalChargeSlab item in chargeInfoSlab)
                        {
                            item.is_percentage = objGlobalCharge.is_percentage;
                            item.global_charge_id = objGlobalCharge.id;

                            objGlobalChargeSlab = new tblGlobalChargeSlab();

                            objGlobalChargeSlab = item;

                            globalChargeSlabFactory.Add(objGlobalChargeSlab);
                        }
                    }

                    globalChargeSlabFactory.Save();

                    scope.Complete();

                    return Json(new { success = true });
                }
                catch (Exception ex)
                {
                    System.Transactions.Transaction.Current.Rollback();
                    return Json(new { success = false, errorMessage = ex.Message });
                }
                finally
                {
                    scope.Dispose();
                }
            }
        }

        /// <summary>
        /// Charge Information List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ChargeInfoList()
        {
            return View();
        }

        /// <summary>
        /// Edit Charge Information view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditChargeInfo()
        {
            return View();
        }

        /// <summary>
        /// Get all Charge Information
        /// </summary>
        /// <param></param>
        /// <returns>global charge list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getChargeInfoList()
        {
            try
            {
                globalChargeFactory = new GlobalChargeFactory();

                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var globalCharge = globalChargeFactory.GetAll()
                    .Select(a => new
                    {
                        a.id,
                        a.name,
                        a.short_code,
                        charge_type = a.tblConstantObjectValue.display_value,
                        a.minimum_charge,
                        a.charge_amount,
                        effective_dt = a.DimDate.FullDateUK,
                        a.income_account_no,
                        a.payable_account_no,
                        a.payable_amount,
                        is_percentage = (a.is_percentage == null || a.is_percentage == 0 ? "N" : "Y"),
                        is_slab = (a.is_slab == null || a.is_slab == 0 ? "N" : "Y")
                    }).ToList();

                var jsonResult = Json(new { chargeInfo = globalCharge, success = true }, JsonRequestBehavior.AllowGet);
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
            if (globalChargeFactory != null)
            {
                globalChargeFactory.Dispose();
            }

            if (globalChargeSlabFactory != null)
            {
                globalChargeSlabFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}