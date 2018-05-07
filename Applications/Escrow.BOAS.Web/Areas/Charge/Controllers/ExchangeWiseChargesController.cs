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
///Created date: 19/1/2015
///Reason: Exchange Wise Charges Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Charge.Controllers
{
    public class ExchangeWiseChargesController : Controller
    {
        // GET: Charge/ExchangeWiseCharges

        public ExchangeWiseChargesController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ExchangeWiseChargesController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IGenericFactory<tblExchangeCharge> exchangeChargeFactory;

        private IGenericFactory<tblExchangeChargeSlab> exchangeChargeSlabFactory;

        #endregion

        #region load dropdown

        /// <summary>
        /// Get all stock exchange
        /// </summary>
        /// <param></param>
        /// <returns>stock exchange list in json</returns>
        public JsonResult getStockExchangeDdlList()
        {
            var stockExchangeList = DropDown.ddlStockExchange();

            return Json(stockExchangeList, JsonRequestBehavior.AllowGet);
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
        /// Exchange Wise Charge view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ExchangeCharges()
        {
            return View();
        }

        /// <summary>
        /// Get exchange wise charge information by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>exchange wise charge and slab list</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getExchangeWiseChargeById(decimal id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                exchangeChargeFactory = new ExchangeChargeFactory();

                var objExchangeWiseCharge = exchangeChargeFactory.FindBy(b => b.id == id)
                    .Select(a => new
                    {
                        a.id,
                        a.exchange_id,
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

                var objExchangeWiseChargeSlab = (dynamic)null;

                if (objExchangeWiseCharge.is_slab == 1)
                {
                    exchangeChargeSlabFactory = new ExchangeChargeSlabFactory();

                    objExchangeWiseChargeSlab = exchangeChargeSlabFactory.GetAll()
                        .Where(a => a.exchange_charge_id == objExchangeWiseCharge.id)
                    .Select(a => new
                    {
                        a.id,
                        a.exchange_charge_id,
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
                    List<tblExchangeChargeSlab> obj = new List<tblExchangeChargeSlab>();

                    objExchangeWiseChargeSlab = obj;
                }

                return Json(new { exchangeWiseCharge = objExchangeWiseCharge, exchangeWiseChargeSlab = objExchangeWiseChargeSlab, success = true }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add exchange wise charges
        /// </summary>
        /// <param name="exchangeWiseCharge">exchange wise charge model</param>
        /// <param name="exchangeWiseChargeSlab">exchange wise charge slab model list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult AddExchangeWiseCharges(tblExchangeCharge exchangeWiseCharge, List<tblExchangeChargeSlab> exchangeWiseChargeSlab)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    exchangeChargeFactory = new ExchangeChargeFactory();

                    tblExchangeCharge objExchangeWiseCharge = exchangeChargeFactory.FindBy(a => a.global_charge_id == exchangeWiseCharge.global_charge_id && a.exchange_id == exchangeWiseCharge.exchange_id).FirstOrDefault();

                    if (objExchangeWiseCharge != null)
                    {
                        return Json(new { success = false, errorMessage = "This Charge with " + objExchangeWiseCharge.tblGlobalCharge.name + " and " + objExchangeWiseCharge.tblConstantObjectValue.display_value + " already exists..." });
                    }
                    else
                    {
                        objExchangeWiseCharge = exchangeWiseCharge;

                        objExchangeWiseCharge.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                        objExchangeWiseCharge.membership_id = membership_id;
                        objExchangeWiseCharge.changed_user_id = User.Identity.GetUserId();
                        objExchangeWiseCharge.changed_date = DateTime.Now;
                        objExchangeWiseCharge.is_dirty = 1;

                        exchangeChargeFactory.Add(objExchangeWiseCharge);
                        exchangeChargeFactory.Save();


                        if (objExchangeWiseCharge.is_slab == 1)
                        {
                            tblExchangeChargeSlab objExchangeWiseChargeSlab = null;

                            exchangeChargeSlabFactory = new ExchangeChargeSlabFactory();

                            foreach (tblExchangeChargeSlab item in exchangeWiseChargeSlab)
                            {
                                item.is_percentage = objExchangeWiseCharge.is_percentage;
                                item.exchange_charge_id = objExchangeWiseCharge.id;

                                objExchangeWiseChargeSlab = new tblExchangeChargeSlab();

                                objExchangeWiseChargeSlab = item;

                                exchangeChargeSlabFactory.Add(objExchangeWiseChargeSlab);
                            }

                            exchangeChargeSlabFactory.Save();
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
        /// Update exchange wise charges
        /// </summary>
        /// <param name="exchangeWiseCharge">exchange wise charge model</param>
        /// <param name="exchangeWiseChargeSlab">exchange wise charge slab model list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult UpdateExchangeWiseCharges(tblExchangeCharge exchangeWiseCharge, List<tblExchangeChargeSlab> exchangeWiseChargeSlab)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    exchangeChargeFactory = new ExchangeChargeFactory();

                    exchangeChargeSlabFactory = new ExchangeChargeSlabFactory();

                    tblExchangeCharge objExchangeWiseCharge = exchangeChargeFactory.FindBy(a => a.global_charge_id == exchangeWiseCharge.global_charge_id && a.exchange_id == exchangeWiseCharge.exchange_id && a.id != exchangeWiseCharge.id).FirstOrDefault();


                    if (objExchangeWiseCharge != null)
                    {
                        return Json(new { success = false, errorMessage = "This Charge with " + objExchangeWiseCharge.tblGlobalCharge.name + " and " + objExchangeWiseCharge.tblConstantObjectValue.display_value + " already exists..." });
                    }
                    else
                    {
                        List<tblExchangeChargeSlab> objExchangeWiseChargeSlabList = exchangeChargeSlabFactory.GetAll().Where(a => a.exchange_charge_id == exchangeWiseCharge.id).ToList();

                        tblExchangeChargeSlab objExchangeWiseChargSlab = null;

                        foreach (tblExchangeChargeSlab item in objExchangeWiseChargeSlabList)
                        {
                            objExchangeWiseChargSlab = new tblExchangeChargeSlab();

                            objExchangeWiseChargSlab = item;

                            exchangeChargeSlabFactory.Delete(objExchangeWiseChargSlab);
                        }

                        objExchangeWiseCharge = exchangeWiseCharge;

                        objExchangeWiseCharge.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                        objExchangeWiseCharge.membership_id = membership_id;
                        objExchangeWiseCharge.changed_user_id = User.Identity.GetUserId();
                        objExchangeWiseCharge.changed_date = DateTime.Now;
                        objExchangeWiseCharge.is_dirty = 1;

                        exchangeChargeFactory.Edit(objExchangeWiseCharge);
                        exchangeChargeFactory.Save();


                        if (exchangeWiseCharge.is_slab == 1)
                        {
                            tblExchangeChargeSlab objExchangeWiseChargeSlab = null;

                            foreach (tblExchangeChargeSlab item in exchangeWiseChargeSlab)
                            {
                                item.is_percentage = objExchangeWiseCharge.is_percentage;
                                item.exchange_charge_id = objExchangeWiseCharge.id;

                                objExchangeWiseChargeSlab = new tblExchangeChargeSlab();

                                objExchangeWiseChargeSlab = item;

                                exchangeChargeSlabFactory.Add(objExchangeWiseChargeSlab);
                            }
                        }

                        exchangeChargeSlabFactory.Save();

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
        /// Exchange Wise Charges List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ExchangeWiseChargesList()
        {
            return View();
        }

        /// <summary>
        /// Edit Exchange Wise Charges view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditExchangeWiseCharges()
        {
            return View();
        }

        /// <summary>
        /// Get all Exchange Wise Charges
        /// </summary>
        /// <param></param>
        /// <returns>Exchange Wise Charges list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getExchangeWiseChargesList()
        {
            try
            {
                exchangeChargeFactory = new ExchangeChargeFactory();

                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var exchangeWiseCharge = exchangeChargeFactory.GetAll()
                    .Select(a => new
                    {
                        a.id,
                        security_market = a.tblConstantObjectValue.display_value,
                        charge_name = a.tblGlobalCharge.name,
                        a.minimum_charge,
                        a.charge_amount,
                        is_percentage = (a.is_percentage == null || a.is_percentage == 0 ? "N" : "Y"),
                        is_slab = (a.is_slab == null || a.is_slab == 0 ? "N" : "Y")
                    }).ToList();

                var jsonResult = Json(new { exchangeWiseCharge = exchangeWiseCharge, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Delete exchange wise charge
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteExchangeWiseCharges(int id)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    exchangeChargeFactory = new ExchangeChargeFactory();

                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    tblExchangeCharge objExchangeWiseCharge = exchangeChargeFactory.FindBy(b => b.id == id).FirstOrDefault();

                    if (objExchangeWiseCharge.is_slab == null || objExchangeWiseCharge.is_slab == 0)
                    {
                        exchangeChargeFactory.Delete(objExchangeWiseCharge);
                        exchangeChargeFactory.Save();
                    }
                    else
                    {
                        exchangeChargeSlabFactory = new ExchangeChargeSlabFactory();

                        List<tblExchangeChargeSlab> objExchangeWiseChargeSlabList = exchangeChargeSlabFactory.GetAll().Where(a => a.exchange_charge_id == objExchangeWiseCharge.id).ToList();

                        tblExchangeChargeSlab objExchangeWiseChargSlab = null;

                        foreach (tblExchangeChargeSlab item in objExchangeWiseChargeSlabList)
                        {
                            objExchangeWiseChargSlab = new tblExchangeChargeSlab();

                            objExchangeWiseChargSlab = item;

                            exchangeChargeSlabFactory.Delete(objExchangeWiseChargSlab);
                        }

                        exchangeChargeSlabFactory.Save();


                        exchangeChargeFactory.Delete(objExchangeWiseCharge);
                        exchangeChargeFactory.Save();
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
            if (exchangeChargeFactory != null)
            {
                exchangeChargeFactory.Dispose();
            }

            if (exchangeChargeSlabFactory != null)
            {
                exchangeChargeSlabFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}