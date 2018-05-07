using Escrow.BOAS.Utility;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Linq;
using System.Web;
using System.Web.Mvc;
///=============================================================
///Created by: Rifad
///Created date: 13/5/2017
///Reason: Introducer list, add, edit, delete
///=============================================================
namespace Escrow.BOAS.Web.Areas.InvestorManagement.Controllers
{
    public class IntroducerController : Controller
    {
        // GET: InvestorManagement/Introducer
        private IGenericFactory<Escrow.BOAS.InvestorManagement.Models.tblIntroducer> introducerFactory;

        public ActionResult IntroducerList()
        {
            return View();
        }
        public JsonResult GetAllIntroducer()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                introducerFactory = new Escrow.BOAS.InvestorManagement.Factories.IntroducerFactory();

                var introducerList = introducerFactory.GetAll().AsEnumerable()
                    .Select(s => new
                    {
                        id = s.id,
                        ref_code = s.ref_code,
                        introducer_name = s.introducer_name,
                        introducer_type = s.tblConstantObjectValue.display_value,
                        occupation = s.tblConstantObjectValue1.display_value,
                        contact_no = s.contact_no == null ? "": s.contact_no,
                        national_id = s.national_id==null? "":s.national_id,
                        tin = s.tin==null ?"":s.tin,
                        remarks = s.remarks==null?"":s.remarks,
                        commission_percentage = s.commission_percentage,
                        valid_from = s.DimDate.Date.Value.GetDateTimeFormats()[6],
                        valid_to = s.DimDate1.Date.Value.GetDateTimeFormats()[6],
                        active_status_id = s.active_status_id

                    }).ToList();

                return Json(new { success = true, data = introducerList }, JsonRequestBehavior.AllowGet);
            }
            catch (DbEntityValidationException e)
            {
                string errorMessage = string.Empty;

                foreach (var eve in e.EntityValidationErrors)
                {
                    Console.WriteLine("Entity of type \"{0}\" in state \"{1}\" has the following validation errors:",
                        eve.Entry.Entity.GetType().Name, eve.Entry.State);
                    errorMessage = eve.ValidationErrors.FirstOrDefault().ErrorMessage.ToString();
                }
                return Json(new { success = false, errorMessage = errorMessage }, JsonRequestBehavior.AllowGet);

            }
        }
        public JsonResult DeleteIntroducer(Escrow.BOAS.InvestorManagement.Models.tblIntroducer introducerInformation)
        {
            try
            {
                introducerFactory = new Escrow.BOAS.InvestorManagement.Factories.IntroducerFactory();
                var introducer = introducerFactory.GetById(introducerInformation.id);
                introducerFactory.Delete(introducer);
                introducerFactory.Save();
                return Json(new { message = "Successfully Deleted", success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult GetIntroducerType()
        {
            try
            {
                var data = DropDown.ddlIntroducerType();
                return Json(data, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult GetActiveStatus()
        {
            try
            {
                var data = DropDown.ddlActiveStatus();
                return Json(data,JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success= false,errorMessage=ex.Message},JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult GetOccupation()
        {
            try
            {
                var data = DropDown.ddlOccupation();
                return Json(data, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public ActionResult editIntroducer()
        {
            return View();
        }
        public JsonResult GetIntroducerById(int id)
        {
            try
            {
                introducerFactory = new Escrow.BOAS.InvestorManagement.Factories.IntroducerFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                //Escrow.BOAS.InvestorManagement.Models.tblIntroducer introducerTableObj =new Escrow.BOAS.InvestorManagement.Models.tblIntroducer();
                var introducerInformation = introducerFactory.GetAll().AsEnumerable().Where(x => x.id == id)
                    .Select(s => new
                    {
                        id = s.id,
                        ref_code = s.ref_code,
                        introducer_name = s.introducer_name,
                        introducer_type_id = s.introducer_type_id,
                        occupation_id = s.occupation_id,
                        contact_no = s.contact_no,
                        national_id = s.national_id,
                        tin = s.tin,
                        remarks = s.remarks,
                        commission_percentage = s.commission_percentage,
                        valid_from = s.DimDate.Date.Value.GetDateTimeFormats()[5],
                        valid_to = s.DimDate1.Date.Value.GetDateTimeFormats()[5],
                        active_status_id = s.active_status_id

                    }).FirstOrDefault();
                return Json(new { success = true, data = introducerInformation }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }

        }

        public JsonResult UpdateIntroducer(Escrow.BOAS.InvestorManagement.Models.tblIntroducer introducerInformation)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                introducerFactory = new Escrow.BOAS.InvestorManagement.Factories.IntroducerFactory();
                Escrow.BOAS.InvestorManagement.Models.tblIntroducer introducerTableObj = new Escrow.BOAS.InvestorManagement.Models.tblIntroducer();
                introducerTableObj = introducerFactory.FindBy(a => a.introducer_name == introducerInformation.introducer_name && a.ref_code == introducerInformation.ref_code && a.introducer_type_id == introducerInformation.introducer_type_id && a.occupation_id == introducerInformation.occupation_id && a.contact_no == introducerInformation.contact_no && a.national_id == introducerInformation.national_id && a.tin == introducerInformation.tin && a.commission_percentage == introducerInformation.commission_percentage && a.valid_from == introducerInformation.valid_from && a.valid_to == introducerInformation.valid_to).FirstOrDefault();

                if (introducerTableObj == null)
                {
                    introducerInformation.membership_id = membership_id;
                    introducerInformation.changed_user_id = User.Identity.GetUserId();
                    introducerInformation.changed_date = DateTime.Now;
                    introducerInformation.is_dirty = 0;
                    introducerFactory.Edit(introducerInformation);
                    introducerFactory.Save();
                    return Json(new { success = true, data = "Update Successfully" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { success = false, errorMessage = "No Data Changed" }, JsonRequestBehavior.AllowGet);
                }

            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public ActionResult AddNewIntroducer()
        {
            return View();
        }
        public JsonResult NewIntroducer(Escrow.BOAS.InvestorManagement.Models.tblIntroducer introducerInformation)
        {
           
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                introducerFactory = new Escrow.BOAS.InvestorManagement.Factories.IntroducerFactory();
                Escrow.BOAS.InvestorManagement.Models.tblIntroducer introducerTableObj = new Escrow.BOAS.InvestorManagement.Models.tblIntroducer();
                introducerTableObj = introducerFactory.FindBy(a => a.introducer_name == introducerInformation.introducer_name && a.ref_code == introducerInformation.ref_code && a.introducer_type_id == introducerInformation.introducer_type_id && a.occupation_id == introducerInformation.occupation_id && a.contact_no == introducerInformation.contact_no && a.national_id == introducerInformation.national_id && a.tin == introducerInformation.tin && a.commission_percentage == introducerInformation.commission_percentage && a.valid_from == introducerInformation.valid_from && a.valid_to == introducerInformation.valid_to).FirstOrDefault();

                if (introducerTableObj == null)
                {
                //    introducerFactory = new Escrow.BOAS.InvestorManagement.Factories.IntroducerFactory();
                    introducerInformation.membership_id = membership_id;
                    introducerInformation.changed_user_id = User.Identity.GetUserId();
                    introducerInformation.changed_date = DateTime.Now;
                    introducerInformation.is_dirty = 1;
                    introducerFactory.Add(introducerInformation);
                    introducerFactory.Save();
                    return Json(new { success = true, data = "Successfully Submitted" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { success = false, errorMessage = "Something Wrong. Try Again Later" }, JsonRequestBehavior.AllowGet);
                }

            }
            catch (DbEntityValidationException e)
            {
                string errorMessage = string.Empty;    
              
                foreach (var eve in e.EntityValidationErrors)
                {
                    Console.WriteLine("Entity of type \"{0}\" in state \"{1}\" has the following validation errors:",
                        eve.Entry.Entity.GetType().Name, eve.Entry.State);
                    //foreach (var ve in eve.ValidationErrors)
                    //{
                    //    Console.WriteLine("- Property: \"{0}\", Error: \"{1}\"",
                    //        ve.PropertyName, ve.ErrorMessage);
                    //    ex = ve.ErrorMessage;
                    //}
                    errorMessage = eve.ValidationErrors.FirstOrDefault().ErrorMessage.ToString();
                    
                }
                    return Json(new { success = false, errorMessage = errorMessage}, JsonRequestBehavior.AllowGet);
               // throw;
                
            }
        }

    }
}