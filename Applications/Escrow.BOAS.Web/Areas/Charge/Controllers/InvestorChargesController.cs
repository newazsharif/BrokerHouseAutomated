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
///Created date: 3/1/2015
///Reason: Investor Charges Controller
///=============================================================




namespace Escrow.BOAS.Web.Areas.Charge.Controllers
{
    public class InvestorChargesController : Controller
    {
        // GET: Charge/InvestorCharges

        public InvestorChargesController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public InvestorChargesController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IGenericFactory<tblInvestorCharge> investorChargeFactory;

        private IGenericFactory<tblInvestorChargeSlab> investorChargeSlabFactory;

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

        #endregion

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Investor Charges view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult InvCharges()
        {
            return View();
        }

        /// <summary>
        /// Get single investor information by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>investor</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
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

        /// <summary>
        /// Get investor charge information by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>ivestor charge and slab list</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getInvChargeById(decimal id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                investorChargeFactory = new InvestorChargeFactory();

                var objInvCharge = investorChargeFactory.FindBy(b => b.id == id)
                    .Select(a => new
                    {
                        a.id,
                        a.client_id,
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

                var objInvChargeSlab = (dynamic)null;

                if(objInvCharge.is_slab == 1)
                {
                    investorChargeSlabFactory = new InvestorChargeSlabFactory();

                    objInvChargeSlab = investorChargeSlabFactory.GetAll()
                        .Where(a => a.investor_charge_id == objInvCharge.id)
                    .Select(a => new
                    {
                        a.id,
                        a.investor_charge_id,
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
                    List<tblInvestorChargeSlab> obj = new List<tblInvestorChargeSlab>();

                    objInvChargeSlab = obj;
                }

                return Json(new { invCharges = objInvCharge, invChargeSlab = objInvChargeSlab, success = true }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add investor charges
        /// </summary>
        /// <param name="invCharges">investor charge model</param>
        /// <param name="invChargeSlabs">investor charge slab model list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult AddInvestorCharges(tblInvestorCharge invCharges, List<tblInvestorChargeSlab> invChargeSlabs)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    investorChargeFactory = new InvestorChargeFactory();

                    tblInvestorCharge objInvCharge = investorChargeFactory.FindBy(a => a.global_charge_id == invCharges.global_charge_id && a.client_id == invCharges.client_id).FirstOrDefault();

                    if (objInvCharge != null)
                    {
                        return Json(new { success = false, errorMessage = "This Investor with " + objInvCharge.tblGlobalCharge.name + " already exists..." });
                    }
                    else
                    {
                        objInvCharge = invCharges;

                        objInvCharge.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                        objInvCharge.membership_id = membership_id;
                        objInvCharge.changed_user_id = User.Identity.GetUserId();
                        objInvCharge.changed_date = DateTime.Now;
                        objInvCharge.is_dirty = 1;

                        investorChargeFactory.Add(objInvCharge);
                        investorChargeFactory.Save();


                        if (invCharges.is_slab == 1)
                        {
                            tblInvestorChargeSlab objInvChargeSlab = null;

                            investorChargeSlabFactory = new InvestorChargeSlabFactory();

                            foreach (tblInvestorChargeSlab item in invChargeSlabs)
                            {
                                item.is_percentage = objInvCharge.is_percentage;
                                item.investor_charge_id = objInvCharge.id;

                                objInvChargeSlab = new tblInvestorChargeSlab();

                                objInvChargeSlab = item;

                                investorChargeSlabFactory.Add(objInvChargeSlab);
                            }

                            investorChargeSlabFactory.Save();
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
        /// Update investor charges
        /// </summary>
        /// <param name="invCharges">investor charge model</param>
        /// <param name="invChargeSlabs">investor charge slab model list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult UpdateInvestorCharges(tblInvestorCharge invCharges, List<tblInvestorChargeSlab> invChargeSlabs)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    investorChargeFactory = new InvestorChargeFactory();

                    investorChargeSlabFactory = new InvestorChargeSlabFactory();

                    tblInvestorCharge objInvCharge = investorChargeFactory.FindBy(a => a.global_charge_id == invCharges.global_charge_id && a.client_id == invCharges.client_id && a.id != invCharges.id).FirstOrDefault();
                    

                    if (objInvCharge != null)
                    {
                        return Json(new { success = false, errorMessage = "This Investor with " + objInvCharge.tblGlobalCharge.name + " already exists..." });
                    }
                    else
                    {
                        List<tblInvestorChargeSlab> objInvChargeSlabList = investorChargeSlabFactory.GetAll().Where(a => a.investor_charge_id == invCharges.id).ToList();

                        tblInvestorChargeSlab objInvChargSlab = null;

                        foreach (tblInvestorChargeSlab item in objInvChargeSlabList)
                        {
                            objInvChargSlab = new tblInvestorChargeSlab();

                            objInvChargSlab = item;

                            investorChargeSlabFactory.Delete(objInvChargSlab);
                        }

                        objInvCharge = invCharges;

                        objInvCharge.active_status_id = Convert.ToInt32(CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active"));
                        objInvCharge.membership_id = membership_id;
                        objInvCharge.changed_user_id = User.Identity.GetUserId();
                        objInvCharge.changed_date = DateTime.Now;
                        objInvCharge.is_dirty = 1;

                        investorChargeFactory.Edit(objInvCharge);
                        investorChargeFactory.Save();


                        if (invCharges.is_slab == 1)
                        {
                            tblInvestorChargeSlab objInvChargeSlab = null;

                            foreach (tblInvestorChargeSlab item in invChargeSlabs)
                            {
                                item.is_percentage = objInvCharge.is_percentage;
                                item.investor_charge_id = objInvCharge.id;

                                objInvChargeSlab = new tblInvestorChargeSlab();

                                objInvChargeSlab = item;

                                investorChargeSlabFactory.Add(objInvChargeSlab);
                            }
                        }

                        investorChargeSlabFactory.Save();

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
        /// Investor Charges List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult InvChargesList()
        {
            return View();
        }

        /// <summary>
        /// Edit Investor Charges view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditInvCharges()
        {
            return View();
        }

        /// <summary>
        /// Get all Investor Charges
        /// </summary>
        /// <param></param>
        /// <returns>Investor Charges list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getInvChargesList()
        {
            try
            {
                investorChargeFactory = new InvestorChargeFactory();

                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var invCharges = investorChargeFactory.GetAll()
                    .Select(a => new
                    {
                        a.id,
                        a.client_id,
                        charge_name = a.tblGlobalCharge.name,
                        a.minimum_charge,
                        a.charge_amount,
                        is_percentage = (a.is_percentage == null || a.is_percentage == 0 ? "N" : "Y"),
                        is_slab = (a.is_slab == null || a.is_slab == 0 ? "N" : "Y")
                    }).ToList();

                var jsonResult = Json(new { invCharges = invCharges, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Delete investor charge
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteInvCharges(int id)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    investorChargeFactory = new InvestorChargeFactory();

                    decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    tblInvestorCharge objInvCharge = investorChargeFactory.FindBy(b => b.id == id).FirstOrDefault();

                    if (objInvCharge.is_slab == null || objInvCharge.is_slab == 0)
                    {
                        investorChargeFactory.Delete(objInvCharge);
                        investorChargeFactory.Save();
                    }
                    else
                    {
                        investorChargeSlabFactory = new InvestorChargeSlabFactory();

                        List<tblInvestorChargeSlab> objInvChargeSlabList = investorChargeSlabFactory.GetAll().Where(a => a.investor_charge_id == objInvCharge.id).ToList();

                        tblInvestorChargeSlab objInvChargSlab = null;

                        foreach (tblInvestorChargeSlab item in objInvChargeSlabList)
                        {
                            objInvChargSlab = new tblInvestorChargeSlab();

                            objInvChargSlab = item;

                            investorChargeSlabFactory.Delete(objInvChargSlab);
                        }

                        investorChargeSlabFactory.Save();


                        investorChargeFactory.Delete(objInvCharge);
                        investorChargeFactory.Save();
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
            if (investorChargeFactory != null)
            {
                investorChargeFactory.Dispose();
            }

            if (investorChargeSlabFactory != null)
            {
                investorChargeSlabFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}