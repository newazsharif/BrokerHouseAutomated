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

namespace Escrow.BOAS.Web.Areas.InvestorManagement.Controllers
{
    public class OmnibusController : Controller
    {
        private IGenericFactory<Escrow.BOAS.InvestorManagement.Models.tblOmnibu> omnibusFactory;

        // GET: InvestorManagement/Omnibus
        public ActionResult OmnibusList()
        {
            return View();
        }
        public JsonResult GetAllOmnibus()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                omnibusFactory = new Escrow.BOAS.InvestorManagement.Factories.OmnibusFactory();

                var omnibusList = omnibusFactory.GetAll().AsEnumerable()
                    .Select(s => new
                    {
                        omnibus_id = s.omnibus_id,
                        name = s.name,
                        short_name = s.short_name,
                        contact_person = s.contact_person,
                        contact_no = s.contact_no,
                        address = s.address,
                        email = s.email,
                        active_status = s.tblConstantObjectValue.display_value,
                        is_dirty = s.is_dirty,

                    }).ToList();

                return Json(new { success = true, data = omnibusList }, JsonRequestBehavior.AllowGet);
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
                return Json(data, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public ActionResult AddNewOmnibus()
        {
            return View();
        }
        public JsonResult NewOmnibus(Escrow.BOAS.InvestorManagement.Models.tblOmnibu omnibusInformation)
        {

            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                omnibusFactory = new Escrow.BOAS.InvestorManagement.Factories.OmnibusFactory();
                Escrow.BOAS.InvestorManagement.Models.tblOmnibu omnibusTableObj = new Escrow.BOAS.InvestorManagement.Models.tblOmnibu();
                omnibusTableObj = omnibusFactory.FindBy(a => a.name == omnibusInformation.name && a.short_name == omnibusInformation.short_name).FirstOrDefault();

                if (omnibusTableObj == null)
                {

                    omnibusInformation.membership_id = membership_id;
                    omnibusInformation.changed_user_id = User.Identity.GetUserId();
                    omnibusInformation.changed_date = DateTime.Now;
                    omnibusInformation.is_dirty = 1;
                    omnibusFactory.Add(omnibusInformation);
                    omnibusFactory.Save();
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
                    errorMessage = eve.ValidationErrors.FirstOrDefault().ErrorMessage.ToString();
                }
                return Json(new { success = false, errorMessage = errorMessage }, JsonRequestBehavior.AllowGet);

            }
        }
        public ActionResult editOmnibus()
        {
            return View();
        }
        public JsonResult GetOmnibusById(string id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                omnibusFactory = new Escrow.BOAS.InvestorManagement.Factories.OmnibusFactory();
                Escrow.BOAS.InvestorManagement.Models.tblOmnibu omnibusTableObj = new Escrow.BOAS.InvestorManagement.Models.tblOmnibu();
                var introducerInformation = omnibusFactory.GetAll().AsEnumerable().Where(x => x.omnibus_id == id)
                    .Select(s => new
                    {
                        omnibus_id = s.omnibus_id,
                        name = s.name,
                        short_name = s.short_name,
                        contact_person = s.contact_person,
                        contact_no = s.contact_no,
                        address = s.address,
                        email = s.email,
                        active_status_id = s.active_status_id,
                        is_dirty = s.is_dirty,
                    }).FirstOrDefault();
                return Json(new { success = true, data = introducerInformation }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }

        }

        public JsonResult UpdateOmnibus(Escrow.BOAS.InvestorManagement.Models.tblOmnibu omnibusInformation)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                omnibusFactory = new Escrow.BOAS.InvestorManagement.Factories.OmnibusFactory();
                Escrow.BOAS.InvestorManagement.Models.tblOmnibu omnibusTableObj = new Escrow.BOAS.InvestorManagement.Models.tblOmnibu();
                omnibusTableObj = omnibusFactory.FindBy(a => a.omnibus_id == omnibusInformation.omnibus_id && a.name == omnibusInformation.name && a.short_name == omnibusInformation.short_name && a.active_status_id == omnibusInformation.active_status_id && a.address == omnibusInformation.address && a.contact_no == omnibusInformation.contact_no && a.contact_person == omnibusInformation.contact_person && a.email==omnibusInformation.email).FirstOrDefault();

                if (omnibusTableObj == null)
                {
                    omnibusInformation.membership_id = membership_id;
                    omnibusInformation.changed_user_id = User.Identity.GetUserId();
                    omnibusInformation.changed_date = DateTime.Now;
                    omnibusInformation.is_dirty = 0;
                    omnibusFactory.Edit(omnibusInformation);
                    omnibusFactory.Save();
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
        public JsonResult DeleteOmnibus(Escrow.BOAS.InvestorManagement.Models.tblOmnibu omnibusInformation)
        {
            try
            {
                omnibusFactory = new Escrow.BOAS.InvestorManagement.Factories.OmnibusFactory();
                var omnibus = omnibusFactory.GetById(omnibusInformation.omnibus_id);
                omnibusFactory.Delete(omnibus);
                omnibusFactory.Save();
                return Json(new { message = "Successfully Deleted", success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}