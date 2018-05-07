using Escrow.Utility.Interfaces;
using Escrow.Utility.Factories;
using Escrow.BOAS.InstrumentManagement.Factories;
using System;
using System.Collections.Generic;
using Escrow.BOAS.InstrumentManagement.Models;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.Web.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Escrow.BOAS.Utility;

namespace Escrow.BOAS.Web.Areas.Instrument.Controllers
{
    public class InstrumentReceiveDeliveryController : Controller
    {


        private IGenericFactory<tblInstrumentManualInOut> InstrumentReceiveDeliveryFactory;
        private IGenericFactory<tblInstrument> instrumentFactory;

        public InstrumentReceiveDeliveryController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public InstrumentReceiveDeliveryController(UserManager<ApplicationUser> userManager)
        {
            // TODO: Complete member initialization
            UserManager = userManager;
        }
        public UserManager<ApplicationUser> UserManager { get; private set; }


        // GET: Instrument/InstrumentReceiveDelivery
        public ActionResult Index()
        {
            return View();
        }


        /// <summary>
        /// Created By: Shohid
        /// Created Date : 24/02/1
        /// Purpose : Add Instrument Receive Delivary 
        /// </summary>
        /// <param name="InstrumentReceiveDelivaryManulaInOut "></param>
        /// <returns></returns>
        ////[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult AddInstrumentReceiveDelivery()
        {
            return View();
        }

        #region load dropdown
        /// <summary>
        /// Get all transaction type
        /// </summary>
        /// <param></param>
        /// <returns>transaction type list in json</returns>
        ////[Authorize]
        //[CheckUserSessionAttribute]
        public JsonResult getTransactionTypeDdlList()
        {
            var transactionTypeList = DropDown.ddlTransactionType();

            return Json(transactionTypeList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all Instrument
        /// </summary>
        /// <param></param>
        /// <returns>Instrument list in json</returns>
        ////[Authorize]
        //[CheckUserSessionAttribute]
        public JsonResult getInstrumentDdlList()
        {
            var instrumentList = DropDown.ddlInstrument();

            return Json(instrumentList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        /// <summary>
        /// Get single investor information by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>investor</returns>
        ////[Authorize]
        //[CheckUserSessionAttribute]
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
        /// Get single instrument information by isin
        /// </summary>
        /// <param name="id">istrument_isin</param>
        /// <returns>Instrument</returns>
        //[CheckUserSessionAttribute]
        public JsonResult getFaceValueById(string id)
        {
            try
            {
                instrumentFactory = new InstrumentFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                var faceValueAndId = instrumentFactory.FindBy(b => b.isin == id).Select(
                    a => new
                    {
                        a.face_value,
                        a.id
                    }).FirstOrDefault();
                return Json(new { faceValueAndId = faceValueAndId, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errormessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        //[CheckUserSessionAttribute]
        public ActionResult EditInstrumentReceiveDelivery()
        {
            return View();
        }

        /// <summary>
        /// instrument Receive Delivery view
        /// </summary>
        /// <param name=""></param>
        /// <returns>View </returns>
        [CheckUserSessionAttribute]
        public ActionResult InstrumentReceiveDeliveryList()
        {
            return View();
        }

        /// <summary>
        /// Get instrument Receive Delivery List
        /// </summary>
        /// <param name=""></param>
        /// <returns>All Instrument Receive Delivery </returns>
        [CheckUserSessionAttribute]
        public JsonResult GetAllInstrumentReceiveDelivery()
        {
            try
            {
                InstrumentReceiveDeliveryFactory = new InstrumentReceiveDeliveryFactory();
                instrumentFactory = new InstrumentFactory();

                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                var insRecDel = InstrumentReceiveDeliveryFactory.GetAll().
                    Select(a => new
                    {
                        a.id,
                        a.client_id,
                        a.quantity,
                        a.rate,
                        instrument_name = a.tblInstrument.security_code,
                        transection_type = a.tblConstantObjectValue.display_value,
                        transection_date = a.DimDate.FullDateUK

                        //a.id, a.instrument_name, 
                        //a.isin, a.security_code, 
                        //a.lot, a.face_value, 
                        //group = a.tblConstantObjectValue1.display_value, 
                        //status = a.tblConstantObjectValue3.display_value 
                    });
                return Json(new { insRecDel = insRecDel, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetInstrumentReceiveDeliveryById(int id)
        {
            try
            {
                InstrumentReceiveDeliveryFactory = new InstrumentReceiveDeliveryFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                var EditinsRecDel = InstrumentReceiveDeliveryFactory.FindBy(b => b.id == id).Select(
                    a => new
                    {
                        a.id,
                        a.client_id,
                        a.tblInstrument.isin,
                        //a.transaction_date,
                        a.transaction_type_id,
                        a.quantity,
                        a.reference_no,
                        a.rate
                    }).FirstOrDefault();
                return Json(new { EditinsRecDel = EditinsRecDel, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errormessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Save new instrument Receive Delivery
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult SaveNewInstrumentReceiveDelivery(tblInstrumentManualInOut insManInOut)
        {
            InstrumentReceiveDeliveryFactory = new InstrumentReceiveDeliveryFactory();
            try
            {
                insManInOut.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                insManInOut.changed_user_id = User.Identity.GetUserId();
                insManInOut.changed_date = DateTime.Now;
                insManInOut.is_dirty = 1;
                InstrumentReceiveDeliveryFactory.Add(insManInOut);
                InstrumentReceiveDeliveryFactory.Save();
                return Json(new { success = true });
            }
            catch (Exception ex)
            {

                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult UpdateInstrumentReceiveDelivery(tblInstrumentManualInOut insManInOut)
        {
            try
            {
                InstrumentReceiveDeliveryFactory = new InstrumentReceiveDeliveryFactory();
                tblInstrumentManualInOut obj = new tblInstrumentManualInOut();
                obj = insManInOut;
                obj.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;
                InstrumentReceiveDeliveryFactory.Edit(obj);
                InstrumentReceiveDeliveryFactory.Save();
                return Json(new { success = true });
            }
            catch(Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult DeleteInstrumentReceiveDelivery(int id)
        {
            try
            {
                InstrumentReceiveDeliveryFactory = new InstrumentReceiveDeliveryFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                var obj = InstrumentReceiveDeliveryFactory.FindBy(b => b.id == id).FirstOrDefault();
                InstrumentReceiveDeliveryFactory.Delete(obj);
                InstrumentReceiveDeliveryFactory.Save();
                return Json(new {success = true});
            }
            catch(Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }
    }
}