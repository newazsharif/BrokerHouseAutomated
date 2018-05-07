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
///Created date: 18/1/2015
///Reason: Branch Wise Charges Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Charge.Controllers
{
    public class BranchWiseChargesController : Controller
    {
        // GET: Charge/BranchWiseCharges

        public BranchWiseChargesController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public BranchWiseChargesController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IGenericFactory<tblBranchCharge> branchChargeFactory;

        private IGenericFactory<tblBranchChargeSlab> branchChargeSlabFactory;

        #endregion

        #region load dropdown

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

        #endregion

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Branch Wise Charge view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult BranchCharges()
        {
            return View();
        }

        /// <summary>
        /// Get branch wise charge information by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>branch wise charge and slab list</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getBranchWiseChargeById(decimal id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                branchChargeFactory = new BranchChargeFactory();

                var objBranchWiseCharge = branchChargeFactory.FindBy(b => b.id == id)
                    .Select(a => new
                    {
                        a.id,
                        a.branch_id,
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

                var objBranchWiseChargeSlab = (dynamic)null;

                if (objBranchWiseCharge.is_slab == 1)
                {
                    branchChargeSlabFactory = new BranchChargeSlabFactory();

                    objBranchWiseChargeSlab = branchChargeSlabFactory.GetAll()
                        .Where(a => a.branch_charge_id == objBranchWiseCharge.id)
                    .Select(a => new
                    {
                        a.id,
                        a.branch_charge_id,
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
                    List<tblBranchChargeSlab> obj = new List<tblBranchChargeSlab>();

                    objBranchWiseChargeSlab = obj;
                }

                return Json(new { branchWiseCharge = objBranchWiseCharge, branchWiseChargeSlab = objBranchWiseChargeSlab, success = true }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add branch wise charges
        /// </summary>
        /// <param name="branchWiseCharge">branch wise charge model</param>
        /// <param name="branchWiseChargeSlab">branch wise charge slab model list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult AddBranchWiseCharges(tblBranchCharge branchWiseCharge, List<tblBranchChargeSlab> branchWiseChargeSlab)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    branchChargeFactory = new BranchChargeFactory();

                    tblBranchCharge objBranchWiseCharge = branchChargeFactory.FindBy(a => a.global_charge_id == branchWiseCharge.global_charge_id && a.branch_id == branchWiseCharge.branch_id).FirstOrDefault();

                    if (objBranchWiseCharge != null)
                    {
                        return Json(new { success = false, errorMessage = "This Charge with " + objBranchWiseCharge.tblGlobalCharge.name + " and " + objBranchWiseCharge.tblBrokerBranch.name + " already exists..." });
                    }
                    else
                    {
                        objBranchWiseCharge = branchWiseCharge;

                        objBranchWiseCharge.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                        objBranchWiseCharge.membership_id = membership_id;
                        objBranchWiseCharge.changed_user_id = User.Identity.GetUserId();
                        objBranchWiseCharge.changed_date = DateTime.Now;
                        objBranchWiseCharge.is_dirty = 1;

                        branchChargeFactory.Add(objBranchWiseCharge);
                        branchChargeFactory.Save();


                        if (objBranchWiseCharge.is_slab == 1)
                        {
                            tblBranchChargeSlab objBranchWiseChargeSlab = null;

                            branchChargeSlabFactory = new BranchChargeSlabFactory();

                            foreach (tblBranchChargeSlab item in branchWiseChargeSlab)
                            {
                                item.is_percentage = objBranchWiseCharge.is_percentage;
                                item.branch_charge_id = objBranchWiseCharge.id;

                                objBranchWiseChargeSlab = new tblBranchChargeSlab();

                                objBranchWiseChargeSlab = item;

                                branchChargeSlabFactory.Add(objBranchWiseChargeSlab);
                            }

                            branchChargeSlabFactory.Save();
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
        /// Update branch wise charges
        /// </summary>
        /// <param name="branchWiseCharge">branch wise charge model</param>
        /// <param name="branchWiseChargeSlab">branch wise charge slab model list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult UpdateBranchWiseCharges(tblBranchCharge branchWiseCharge, List<tblBranchChargeSlab> branchWiseChargeSlab)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    branchChargeFactory = new BranchChargeFactory();

                    branchChargeSlabFactory = new BranchChargeSlabFactory();

                    tblBranchCharge objBranchWiseCharge = branchChargeFactory.FindBy(a => a.global_charge_id == branchWiseCharge.global_charge_id && a.branch_id == branchWiseCharge.branch_id && a.id != branchWiseCharge.id).FirstOrDefault();


                    if (objBranchWiseCharge != null)
                    {
                        return Json(new { success = false, errorMessage = "This Charge with " + objBranchWiseCharge.tblGlobalCharge.name + " and " + objBranchWiseCharge.tblBrokerBranch.name + " already exists..." });
                    }
                    else
                    {
                        List<tblBranchChargeSlab> objBranchWiseChargeSlabList = branchChargeSlabFactory.GetAll().Where(a => a.branch_charge_id == branchWiseCharge.id).ToList();

                        tblBranchChargeSlab objBranchWiseChargSlab = null;

                        foreach (tblBranchChargeSlab item in objBranchWiseChargeSlabList)
                        {
                            objBranchWiseChargSlab = new tblBranchChargeSlab();

                            objBranchWiseChargSlab = item;

                            branchChargeSlabFactory.Delete(objBranchWiseChargSlab);
                        }

                        objBranchWiseCharge = branchWiseCharge;

                        objBranchWiseCharge.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                        objBranchWiseCharge.membership_id = membership_id;
                        objBranchWiseCharge.changed_user_id = User.Identity.GetUserId();
                        objBranchWiseCharge.changed_date = DateTime.Now;
                        objBranchWiseCharge.is_dirty = 1;

                        branchChargeFactory.Edit(objBranchWiseCharge);
                        branchChargeFactory.Save();


                        if (branchWiseCharge.is_slab == 1)
                        {
                            tblBranchChargeSlab objBranchWiseChargeSlab = null;

                            foreach (tblBranchChargeSlab item in branchWiseChargeSlab)
                            {
                                item.is_percentage = objBranchWiseCharge.is_percentage;
                                item.branch_charge_id = objBranchWiseCharge.id;

                                objBranchWiseChargeSlab = new tblBranchChargeSlab();

                                objBranchWiseChargeSlab = item;

                                branchChargeSlabFactory.Add(objBranchWiseChargeSlab);
                            }
                        }

                        branchChargeSlabFactory.Save();

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
        /// Branch Wise Charges List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult BranchWiseChargesList()
        {
            return View();
        }

        /// <summary>
        /// Edit Branch Wise Charges view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditBranchWiseCharges()
        {
            return View();
        }

        /// <summary>
        /// Get all Branch Wise Charges
        /// </summary>
        /// <param></param>
        /// <returns>Branch Wise Charges list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getBranchWiseChargesList()
        {
            try
            {
                branchChargeFactory = new BranchChargeFactory();

                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var branchWiseCharge = branchChargeFactory.GetAll()
                    .Select(a => new
                    {
                        a.id,
                        branch = a.tblBrokerBranch.name,
                        charge_name = a.tblGlobalCharge.name,
                        a.minimum_charge,
                        a.charge_amount,
                        is_percentage = (a.is_percentage == null || a.is_percentage == 0 ? "N" : "Y"),
                        is_slab = (a.is_slab == null || a.is_slab == 0 ? "N" : "Y")
                    }).ToList();

                var jsonResult = Json(new { branchWiseCharge = branchWiseCharge, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Delete branch wise charge
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteBranchWiseCharges(int id)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    branchChargeFactory = new BranchChargeFactory();

                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    tblBranchCharge objBranchWiseCharge = branchChargeFactory.FindBy(b => b.id == id).FirstOrDefault();

                    if (objBranchWiseCharge.is_slab == null || objBranchWiseCharge.is_slab == 0)
                    {
                        branchChargeFactory.Delete(objBranchWiseCharge);
                        branchChargeFactory.Save();
                    }
                    else
                    {
                        branchChargeSlabFactory = new BranchChargeSlabFactory();

                        List<tblBranchChargeSlab> objBranchWiseChargeSlabList = branchChargeSlabFactory.GetAll().Where(a => a.branch_charge_id == objBranchWiseCharge.id).ToList();

                        tblBranchChargeSlab objBranchWiseChargSlab = null;

                        foreach (tblBranchChargeSlab item in objBranchWiseChargeSlabList)
                        {
                            objBranchWiseChargSlab = new tblBranchChargeSlab();

                            objBranchWiseChargSlab = item;

                            branchChargeSlabFactory.Delete(objBranchWiseChargSlab);
                        }

                        branchChargeSlabFactory.Save();


                        branchChargeFactory.Delete(objBranchWiseCharge);
                        branchChargeFactory.Save();
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
            if (branchChargeFactory != null)
            {
                branchChargeFactory.Dispose();
            }

            if (branchChargeSlabFactory != null)
            {
                branchChargeSlabFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}