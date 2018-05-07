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


///Created By : Newaz
///Creted Date : 6/10/15
///Reason : Instrument management Controller
///


namespace Escrow.BOAS.Web.Areas.Instrument.Controllers
{
    public class InstrumentController : Controller
    {
        private IGenericFactory<tblInstrument> instrumentFactory;
        private IGenericFactory<tblConstantObjectValue> constantObjectValueFactory;
        


        public InstrumentController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public InstrumentController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }


        // GET: Instrument/Instrument

        
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult NewInstrument()
        {
            return View();
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult InstrumentList()
        {
            return View();
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult EditInstrument()
        {
            return View();
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult GetInstrumentById(int id)
        {
            try
            {
                instrumentFactory = new InstrumentFactory();
                decimal  membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                var instrument = instrumentFactory.FindBy(b => b.id == id).Select(
                    a => new
                    {
                        a.id,
                        a.instrument_name,
                        a.instument_type_id,
                        a.is_foreign,
                        a.face_value,
                        a.group_id,
                        a.is_marginable, 
                        a.isin,
                        a.lot,
                        a.membership_id,
                        a.paid_up_capital,
                        a.premium,
                        a.sector_id,
                        a.security_code,
                        a.discount,
                        a.depository_company_id,
                        a.current_pe,
                        a.current_nav,
                        a.current_eps,
                        a.authorized_capital,
                        a.active_status_id,
                        a.closed_price
                    }).FirstOrDefault();
                return Json(new { instrument = instrument, success = true },JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                return Json(new { success = false, errormessage = ex.Message },JsonRequestBehavior.AllowGet);
            }
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        /// <summary>
        /// Created By: Newaz
        /// Created Date : 15/08/15
        /// Purpose : Update Instrument process
        /// </summary>
        /// <param name="instrument"></param>
        /// <returns></returns>
        
        public JsonResult UpdateInstrument(tblInstrument instrument)
        {
            try
            {
                instrumentFactory = new InstrumentFactory();
                
                tblInstrument obj = new tblInstrument();
                obj = instrument;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                obj.is_dirty = 1;
                instrumentFactory.Edit(obj);
                instrumentFactory.Save();
                return Json(new { success = true });
                
            }
            catch(Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }

        }

        [CheckUserSessionAttribute]
        //[Authorize]
        /// <summary>
        /// Created By: Newaz Sharif
        /// Created Date : 18/08/15
        /// Purpose : Get json data of all instruments
        /// </summary>
        /// <returns>json</returns>
        public JsonResult GetAllInstrument()
        {
            try
            {
                instrumentFactory = new InstrumentFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                var instruments = instrumentFactory.GetAll().Where(x=>x.membership_id==membership_id).Select(a => new { a.id,a.instrument_name, a.isin, a.security_code, a.lot, a.face_value,group=a.tblConstantObjectValue1.display_value,status = a.tblConstantObjectValue3.display_value });
                return Json(new { instruments = instruments, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }

           
        }

        /// <summary>
        /// Check duplicate isin
        /// </summary>
        /// <param name="isin"></param>
        /// <returns></returns>
        public JsonResult CheckIsinAvailable(string isin)
        {
            instrumentFactory = new InstrumentFactory();
            //tblInstrument _tblInstrument = new tblInstrument();
            string message="";
            try
            {
                var available = instrumentFactory.GetAll().Where(x=>x.isin == isin).FirstOrDefault();
                if(available!= null)
                {
                    message = "true";
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    message = "false";
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            catch(Exception ex)
            {
                return Json(ex.Message, JsonRequestBehavior.AllowGet);
            }
        }


        [CheckUserSessionAttribute]
        //[Authorize]
        /// <summary>
        /// 
        /// </summary>
        /// <param name="instrument"></param>
        /// <returns></returns>
        public JsonResult AddNewInstrument(tblInstrument instrument)
        {
            instrumentFactory = new InstrumentFactory();
            try
            {
                instrument.changed_user_id = User.Identity.GetUserId();
                instrument.changed_date = DateTime.Now; 
                instrument.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                instrument.is_dirty = 1;
                //tblInstrument obj = new tblInstrument();
                //obj = instrument;
                instrumentFactory.Add(instrument);
                instrumentFactory.Save();
                return Json(new { Success = true });
            }
            catch(Exception ex)
            {
                return Json (new{Success = false, errorMessage = ex.Message}, JsonRequestBehavior.AllowGet);
            }
            
        }

        public JsonResult GetddlSector()
        {
            var data = DropDown.ddlInstrumentSector();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlType()
        {
            var data = DropDown.ddlInstrumentType();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlDepositoryCompany()
        {
            var data = DropDown.ddlDepositoryCompany();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlGroups()
        {
            var data = DropDown.ddlInstrumentGroup();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        
        public JsonResult GetStatus()
        {
            var data = DropDown.ddlActiveStatus();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult CheckIsin(string isin)
        {
            instrumentFactory = new InstrumentFactory();
            string data = instrumentFactory.GetAll().Where(a => a.isin == isin).Select(x => x.isin).FirstOrDefault();
            if (data == isin)
            {
                return Json("NoAvailable", JsonRequestBehavior.AllowGet);
            }
            else
                return Json("Available", JsonRequestBehavior.AllowGet);
        }

        public JsonResult CheckSecurityCode(string SecurityCode)
        {
            instrumentFactory = new InstrumentFactory();
            string security = instrumentFactory.GetAll()
                .Where(a => a.security_code == SecurityCode)
                .Select(a => a.security_code).FirstOrDefault();
            if(security == SecurityCode)
            {
                return Json("NoAvailable", JsonRequestBehavior.AllowGet);
            }
            else
                return Json("Available", JsonRequestBehavior.AllowGet);
        }

        public JsonResult CheckIsinForEdit(string security_code,string isin)
        {
            instrumentFactory = new InstrumentFactory();
            string data = instrumentFactory.GetAll()
                .Where(a => a.isin == isin && a.security_code!=security_code)
                .Select(x => x.isin).FirstOrDefault();
            if (data == isin)
            {
                return Json("NoAvailable", JsonRequestBehavior.AllowGet);
            }
            else
                return Json("Available", JsonRequestBehavior.AllowGet);
        }

        
    }
}