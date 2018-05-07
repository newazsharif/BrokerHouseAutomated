using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.BOAS.Transaction.Models;
using Escrow.BOAS.Transaction.Factories;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;
using System.Configuration;


///=============================================================
///Created by: Asif
///Created date: 02/02/2016
///Reason: Fund Transfer Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class FundTransferController : Controller
    {
        // GET: Transaction/FundTransfer
        public FundTransferController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public FundTransferController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        private IGenericFactory<tblFundTransfer> fundTransferFactory;

        #endregion

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Fund Transfer view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FndTransfer()
        {
            return View();
        }

        /// <summary>
        /// Get single investor information by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>investor</returns>
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
        /// Get previous unapprove fund transfer by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>error or success message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getPrevUnapprovedFndTransferByClientId(string id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundTransferFactory = new FundTransferFactory();

                List<tblFundTransfer> fundTransferList = fundTransferFactory.GetAll().Where(a => a.transferor_id == id && a.approve_by == null).ToList();

                if (fundTransferList.Count > 0)
                {
                    return Json(new { success = true, msg = "This Investor already have pending fund transfer are you sure you want to proceed..." }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { success = false }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add fund payment
        /// </summary>
        /// <param name="fundTransfer">fund payment model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult addFundTransfer(tblFundTransfer fundTransfer)
        {
            try
            {
                fundTransferFactory = new FundTransferFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblFundTransfer objFundTransfer = new tblFundTransfer();
                objFundTransfer = fundTransfer;

                if (fundTransfer.remarks != null && fundTransfer.remarks != "")
                    objFundTransfer.remarks = fundTransfer.remarks.Trim();

                decimal active_id = CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active");

                objFundTransfer.active_status_id = Convert.ToInt32(active_id);
                objFundTransfer.membership_id = membership_id;
                objFundTransfer.changed_user_id = User.Identity.GetUserId();
                objFundTransfer.changed_date = DateTime.Now;
                objFundTransfer.is_dirty = 1;

                fundTransferFactory.Add(objFundTransfer);
                fundTransferFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Fund Transfer list view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FundTransferList()
        {
            return View();
        }

        /// <summary>
        /// Get all fund transfer list
        /// </summary>
        /// <param></param>
        /// <returns>fund payment list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getFndTransferList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundTransferFactory = new FundTransferFactory();

                var fundTransferList = fundTransferFactory.GetAll().Where(a => a.approve_by == null && a.approve_date == null)
                    .Select(s => new
                    {
                        s.id,
                        s.transferor_id,
                        s.transferor_balance,
                        s.tranferee_id,
                        s.transferee_balance,
                        transfer_dt = s.DimDate.FullDateUK,
                        value_dt = s.DimDate1.FullDateUK,
                        s.amount,
                        s.charge_amount,
                        s.remarks
                    })
                    .OrderBy(s => s.transfer_dt)
                    .ToList();

                var jsonResult = Json(new { fundTransferList = fundTransferList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Edit Fund Transfer view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditFundTransfer()
        {
            return View();
        }

        /// <summary>
        /// Get single Fund Transfer by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>Fund Transfer model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getFndTransferById(int id)
        {
            try
            {
                fundTransferFactory = new FundTransferFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var editFndTransfer = fundTransferFactory.FindBy(b => b.id == id)
                    .Select(s => new
                    {
                        s.id,
                        s.transferor_id,
                        s.transferor_balance,
                        s.tranferee_id,
                        s.transferee_balance,
                        transfer_dt = s.DimDate.FullDateUK,
                        value_dt = s.DimDate1.FullDateUK,
                        s.amount,
                        s.charge_amount,
                        s.remarks
                    }).FirstOrDefault();

                return Json(new { editFndTransfer = editFndTransfer, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Update fund Transfer
        /// </summary>
        /// <param name="editFndTransfer">fund Transfer model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateFundTransfer(tblFundTransfer editFndTransfer)
        {
            try
            {
                fundTransferFactory = new FundTransferFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblFundTransfer obj = new tblFundTransfer();
                obj = editFndTransfer;

                if (editFndTransfer.remarks != null && editFndTransfer.remarks != "")
                    obj.remarks = editFndTransfer.remarks.Trim();

                decimal active_id = CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active");

                obj.active_status_id = Convert.ToInt32(active_id);
                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;

                fundTransferFactory.Edit(obj);
                fundTransferFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete fund transfer
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteFundTransfer(int id)
        {
            try
            {
                fundTransferFactory = new FundTransferFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var obj = fundTransferFactory.FindBy(b => b.id == id).FirstOrDefault();

                fundTransferFactory.Delete(obj);
                fundTransferFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (fundTransferFactory != null)
            {
                fundTransferFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}