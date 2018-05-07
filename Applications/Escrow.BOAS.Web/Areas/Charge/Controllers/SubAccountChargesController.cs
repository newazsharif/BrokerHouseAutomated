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
///Created date: 13/1/2015
///Reason: Sub Account Charges Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Charge.Controllers
{
    public class SubAccountChargesController : Controller
    {
        // GET: Charge/SubAccountCharges

        public SubAccountChargesController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public SubAccountChargesController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IGenericFactory<tblSubAccountCharge> subAccountChargeFactory;

        private IGenericFactory<tblSubAccountChargeSlab> subAccountChargeSlabFactory;

        #endregion

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
        /// Get all sub account
        /// </summary>
        /// <param></param>
        /// <returns>sub account list in json</returns>
        //[Authorize]
        public JsonResult getSubAccountDdlList()
        {
            var subAccountList = DropDown.ddlInvestorSubAcc();

            return Json(subAccountList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Sub Account Charges view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult SubAccCharges()
        {
            return View();
        }

        /// <summary>
        /// Get sub account charge information by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>sub account charge and slab list</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getSubAccChargeById(decimal id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                subAccountChargeFactory = new SubAccountChargeFactory();

                var objSubAccCharge = subAccountChargeFactory.FindBy(b => b.id == id)
                    .Select(a => new
                    {
                        a.id,
                        a.sub_account_id,
                        a.global_charge_id,
                        a.charge_amount,
                        a.is_percentage,
                        a.is_slab,
                        a.minimum_charge,
                        a.active_status_id,
                        a.membership_id,
                        a.changed_user_id,
                        a.changed_date,
                        a.is_dirty
                    })
                    .FirstOrDefault();

                var objSubAccChargeSlab = (dynamic)null;

                if (objSubAccCharge.is_slab == 1)
                {
                    subAccountChargeSlabFactory = new SubAccountChargeSlabFactory();

                    objSubAccChargeSlab = subAccountChargeSlabFactory.GetAll()
                        .Where(a => a.sub_account_charge_id == objSubAccCharge.id)
                    .Select(a => new
                    {
                        a.id,
                        a.sub_account_charge_id,
                        a.amount_from,
                        a.amount_to,
                        a.charge_amount,
                        a.is_percentage
                    })
                    .OrderBy(a=>a.amount_to)
                    .ToList();
                }
                else
                {
                    List<tblSubAccountChargeSlab> obj = new List<tblSubAccountChargeSlab>();

                    objSubAccChargeSlab = obj;
                }

                return Json(new { subAccCharge = objSubAccCharge, subAccChargeSlab = objSubAccChargeSlab, success = true }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add sub account charges
        /// </summary>
        /// <param name="subAccCharge">sub account charge model</param>
        /// <param name="subAccChargeSlab">sub account charge slab model list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult AddSubAccCharges(tblSubAccountCharge subAccCharge, List<tblSubAccountChargeSlab> subAccChargeSlab)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    subAccountChargeFactory = new SubAccountChargeFactory();

                    tblSubAccountCharge objSubAccCharge = subAccountChargeFactory.FindBy(a => a.global_charge_id == subAccCharge.global_charge_id && a.sub_account_id == subAccCharge.sub_account_id).FirstOrDefault();

                    if (objSubAccCharge != null)
                    {
                        return Json(new { success = false, errorMessage = "This Charge with " + objSubAccCharge.tblGlobalCharge.name + " and " + objSubAccCharge.tblConstantObjectValue.display_value + " already exists..." });
                    }
                    else
                    {
                        objSubAccCharge = subAccCharge;

                        objSubAccCharge.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                        objSubAccCharge.membership_id = membership_id;
                        objSubAccCharge.changed_user_id = User.Identity.GetUserId();
                        objSubAccCharge.changed_date = DateTime.Now;
                        objSubAccCharge.is_dirty = 1;

                        subAccountChargeFactory.Add(objSubAccCharge);
                        subAccountChargeFactory.Save();


                        if (objSubAccCharge.is_slab == 1)
                        {
                            tblSubAccountChargeSlab objSubAccChargeSlab = null;

                            subAccountChargeSlabFactory = new SubAccountChargeSlabFactory();

                            foreach (tblSubAccountChargeSlab item in subAccChargeSlab)
                            {
                                item.is_percentage = objSubAccCharge.is_percentage;
                                item.sub_account_charge_id = objSubAccCharge.id;

                                objSubAccChargeSlab = new tblSubAccountChargeSlab();

                                objSubAccChargeSlab = item;

                                subAccountChargeSlabFactory.Add(objSubAccChargeSlab);
                            }

                            subAccountChargeSlabFactory.Save();
                        }

                        scope.Complete();

                        return Json(new { success = true });
                    }
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
        /// Update sub account charges
        /// </summary>
        /// <param name="subAccCharge">sub account charge model</param>
        /// <param name="subAccChargeSlab">sub account charge slab model list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult UpdateSubAccCharges(tblSubAccountCharge subAccCharge, List<tblSubAccountChargeSlab> subAccChargeSlab)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    subAccountChargeFactory = new SubAccountChargeFactory();

                    subAccountChargeSlabFactory = new SubAccountChargeSlabFactory();

                    tblSubAccountCharge objSubAccCharge = subAccountChargeFactory.FindBy(a => a.global_charge_id == subAccCharge.global_charge_id && a.sub_account_id == subAccCharge.sub_account_id && a.id != subAccCharge.id).FirstOrDefault();


                    if (objSubAccCharge != null)
                    {
                        return Json(new { success = false, errorMessage = "This Charge with " + objSubAccCharge.tblGlobalCharge.name + " and " + objSubAccCharge.tblConstantObjectValue.display_value + " already exists..." });
                    }
                    else
                    {
                        List<tblSubAccountChargeSlab> objSubAccChargeSlabList = subAccountChargeSlabFactory.GetAll().Where(a => a.sub_account_charge_id == subAccCharge.id).ToList();

                        tblSubAccountChargeSlab objSubAccChargSlab = null;

                        foreach (tblSubAccountChargeSlab item in objSubAccChargeSlabList)
                        {
                            objSubAccChargSlab = new tblSubAccountChargeSlab();

                            objSubAccChargSlab = item;

                            subAccountChargeSlabFactory.Delete(objSubAccChargSlab);
                        }

                        objSubAccCharge = subAccCharge;

                        objSubAccCharge.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                        objSubAccCharge.membership_id = membership_id;
                        objSubAccCharge.changed_user_id = User.Identity.GetUserId();
                        objSubAccCharge.changed_date = DateTime.Now;
                        objSubAccCharge.is_dirty = 1;

                        subAccountChargeFactory.Edit(objSubAccCharge);
                        subAccountChargeFactory.Save();


                        if (subAccCharge.is_slab == 1)
                        {
                            tblSubAccountChargeSlab objSubAccChargeSlab = null;

                            foreach (tblSubAccountChargeSlab item in subAccChargeSlab)
                            {
                                item.is_percentage = objSubAccCharge.is_percentage;
                                item.sub_account_charge_id = objSubAccCharge.id;

                                objSubAccChargeSlab = new tblSubAccountChargeSlab();

                                objSubAccChargeSlab = item;

                                subAccountChargeSlabFactory.Add(objSubAccChargeSlab);
                            }
                        }

                        subAccountChargeSlabFactory.Save();

                        scope.Complete();

                        return Json(new { success = true });
                    }
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
        /// Sub Account Charges List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult SubAccChargesList()
        {
            return View();
        }

        /// <summary>
        /// Edit Sub Account Charges view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditSubAccCharges()
        {
            return View();
        }

        /// <summary>
        /// Get all Sub Account Charges
        /// </summary>
        /// <param></param>
        /// <returns>Sub Account Charges list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getSubAccChargesList()
        {
            try
            {
                subAccountChargeFactory = new SubAccountChargeFactory();

                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var subAccCharge = subAccountChargeFactory.GetAll()
                    .Select(a => new
                    {
                        a.id,
                        sub_account = a.tblConstantObjectValue.display_value,
                        charge_name = a.tblGlobalCharge.name,
                        a.minimum_charge,
                        a.charge_amount,
                        is_percentage = (a.is_percentage == null || a.is_percentage == 0 ? "N" : "Y"),
                        is_slab = (a.is_slab == null || a.is_slab == 0 ? "N" : "Y")
                    }).ToList();

                var jsonResult = Json(new { subAccCharge = subAccCharge, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Delete sub account charge
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteSubAccCharges(int id)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    subAccountChargeFactory = new SubAccountChargeFactory();

                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    tblSubAccountCharge objSubAccCharge = subAccountChargeFactory.FindBy(b => b.id == id).FirstOrDefault();

                    if (objSubAccCharge.is_slab == null || objSubAccCharge.is_slab == 0)
                    {
                        subAccountChargeFactory.Delete(objSubAccCharge);
                        subAccountChargeFactory.Save();
                    }
                    else
                    {
                        subAccountChargeSlabFactory = new SubAccountChargeSlabFactory();

                        List<tblSubAccountChargeSlab> objSubAccChargeSlabList = subAccountChargeSlabFactory.GetAll().Where(a => a.sub_account_charge_id == objSubAccCharge.id).ToList();

                        tblSubAccountChargeSlab objSubAccChargSlab = null;

                        foreach (tblSubAccountChargeSlab item in objSubAccChargeSlabList)
                        {
                            objSubAccChargSlab = new tblSubAccountChargeSlab();

                            objSubAccChargSlab = item;

                            subAccountChargeSlabFactory.Delete(objSubAccChargSlab);
                        }

                        subAccountChargeSlabFactory.Save();


                        subAccountChargeFactory.Delete(objSubAccCharge);
                        subAccountChargeFactory.Save();
                    }

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

        protected override void Dispose(bool disposing)
        {
            if (subAccountChargeFactory != null)
            {
                subAccountChargeFactory.Dispose();
            }

            if (subAccountChargeSlabFactory != null)
            {
                subAccountChargeSlabFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}