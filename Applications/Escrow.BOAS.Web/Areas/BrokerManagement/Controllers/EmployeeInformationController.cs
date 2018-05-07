using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.BOAS.BrokerManagement.Factories;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;
using System.Data.Entity;


///=============================================================
///Created by: Asif
///Created date: 5/8/2015
///Reason: Employee Information Controller
///=============================================================


///=============================================================
///Created by: Asif
///Created date: 18/8/2015
///Reason: list, edit, delete, add
///=============================================================

namespace Escrow.BOAS.Web.Areas.BrokerManagement.Controllers
{
    public class EmployeeInformationController : Controller
    {

        #region global variables

        private IGenericFactory<tblEmployee> employeeFactory;

        #endregion

        public EmployeeInformationController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public EmployeeInformationController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region load dropdown

        /// <summary>
        /// Get all gender
        /// </summary>
        /// <param></param>
        /// <returns>gender list in json</returns>
        public JsonResult getGenderDdlList()
        {
            var genderList = DropDown.ddlGender();

            return Json(genderList, JsonRequestBehavior.AllowGet);
        }

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
        /// Get all designation
        /// </summary>
        /// <param></param>
        /// <returns>designation list in json</returns>
        public JsonResult getDesigDdlList()
        {
            var designationList = DropDown.ddlDesignation();

            return Json(designationList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all department
        /// </summary>
        /// <param></param>
        /// <returns>department list in json</returns>
        public JsonResult getDepDdlList()
        {
            var departmentList = DropDown.ddlDepartment();

            return Json(departmentList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all active status
        /// </summary>
        /// <param></param>
        /// <returns>active status list in json</returns>
        public JsonResult getActiveStatusDdlList()
        {
            var activeStatusList = DropDown.ddlActiveStatus();

            return Json(activeStatusList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        // GET: BrokerManagement/EmployeeInformation
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Employee Information List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        
        [CheckUserSessionAttribute]
        public ActionResult EmployeeInformationList()
        {
            return View();
        }

        /// <summary>
        /// Get all employee
        /// </summary>
        /// <param></param>
        /// <returns>employee list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getEmployeeList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                employeeFactory = new EmployeeInformationFactory();

                var employeeList = employeeFactory.GetAll()
                    .Select(s => new 
                    { 
                        s.id, 
                        s.employee_code, 
                        s.name, 
                        designation = s.tblConstantObjectValue1.display_value, 
                        department = s.tblConstantObjectValue.display_value, 
                        joining_date = s.DimDate.FullDateUK, 
                        branch = s.tblBrokerBranch.name, 
                        s.contact_no, 
                        s.email_address 
                    }).ToList();

                var jsonResult = Json(new { employeeList = employeeList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Add new employee view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult NewEmployeeInformation()
        {
            return View();
        }

        /// <summary>
        /// Add new employee value
        /// </summary>
        /// <param name="employeeInformation">employee model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult addEmployeeInformation(tblEmployee employeeInformation, HttpPostedFileBase file)
        {
            try
            {
                employeeFactory = new EmployeeInformationFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblEmployee obj = new tblEmployee();

                obj = employeeFactory.FindBy(a => a.name == employeeInformation.name && a.father_name == employeeInformation.father_name && a.mother_name == employeeInformation.mother_name && a.birth_date == employeeInformation.birth_date && a.national_id == employeeInformation.national_id).FirstOrDefault();

                if (obj == null)
                {
                    employeeFactory = new EmployeeInformationFactory();
                    obj = new tblEmployee();

                    obj = employeeInformation;
                    if (employeeInformation.mailing_address != null && employeeInformation.mailing_address != "")
                        obj.mailing_address = employeeInformation.mailing_address.Trim();

                    if (employeeInformation.permanent_address != null && employeeInformation.permanent_address != "")
                        obj.permanent_address = employeeInformation.permanent_address.Trim();

                    if (file != null)
                    {
                        byte[] image = new byte[file.ContentLength];
                        file.InputStream.Read(image, 0, file.ContentLength);
                        obj.photo = ImageConvert.ResizeImageFile(image, 300);
                    }
                    else
                    {
                        obj.photo = null;
                    }

                    obj.membership_id = membership_id;
                    obj.changed_user_id = User.Identity.GetUserId();
                    obj.changed_date = DateTime.Now;
                    obj.is_dirty = 1;

                    employeeFactory.Add(obj);
                    employeeFactory.Save();

                    return Json(new { success = true });
                }
                else
                {
                    return Json(new { success = false, errorMessage = "This employee already exists!!!!" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit employee view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditEmployeeInformation()
        {
            return View();
        }

        /// <summary>
        /// Get single employee by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>employee model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getEmployeeById(int id)
        {
            try
            {
                employeeFactory = new EmployeeInformationFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var editEmployeeInformation = employeeFactory.FindBy(b => b.id == id)
                    .Select(a => new 
                    { 
                        a.id, 
                        a.employee_code, 
                        a.name, 
                        a.father_name,
                        a.mother_name,
                        a.gender_id,
                        dob = a.birth_date == null ? null : DbFunctions.TruncateTime(a.birth_date).ToString(),
                        a.contact_no, 
                        a.email_address,
                        a.branch_id,
                        a.national_id,
                        a.designation_id,
                        a.department_id,
                        joining_date = a.DimDate.FullDateUK,
                        release_date = a.DimDate1.FullDateUK,
                        a.mailing_address,
                        a.permanent_address,
                        a.active_status_id,
                        a.photo
                    }).FirstOrDefault();

                string imageBase64String = "";

                if (editEmployeeInformation.photo != null)
                {
                    imageBase64String = Convert.ToBase64String(editEmployeeInformation.photo, 0, editEmployeeInformation.photo.Length);
                }

                return Json(new { editEmployeeInformation = editEmployeeInformation, ImageData = imageBase64String, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit employee
        /// </summary>
        /// <param name="editEmployeeInformation">employee model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult updateEmployeeInformation(tblEmployee editEmployeeInformation, HttpPostedFileBase file)
        {
            try
            {
                employeeFactory = new EmployeeInformationFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblEmployee obj = new tblEmployee();

                obj = employeeFactory.FindBy(a => a.name == editEmployeeInformation.name && a.father_name == editEmployeeInformation.father_name && a.mother_name == editEmployeeInformation.mother_name && a.birth_date == editEmployeeInformation.birth_date && a.national_id == editEmployeeInformation.national_id && a.id != editEmployeeInformation.id).FirstOrDefault();

                if (obj == null)
                {
                    employeeFactory = new EmployeeInformationFactory();
                    obj = new tblEmployee();

                    obj = editEmployeeInformation;
                    if (editEmployeeInformation.mailing_address != null && editEmployeeInformation.mailing_address != "" && editEmployeeInformation.mailing_address != "null")
                        obj.mailing_address = editEmployeeInformation.mailing_address.Trim();
                    else
                        obj.mailing_address = null;

                    if (editEmployeeInformation.permanent_address != null && editEmployeeInformation.permanent_address != "" && editEmployeeInformation.permanent_address != "null")
                        obj.permanent_address = editEmployeeInformation.permanent_address.Trim();
                    else
                        obj.permanent_address = null;

                    if (editEmployeeInformation.father_name == "null")
                        obj.father_name = null;

                    if (editEmployeeInformation.mother_name == "null")
                        obj.mother_name = null;

                    if (editEmployeeInformation.contact_no == "null")
                        obj.contact_no = null;

                    if (editEmployeeInformation.email_address == "null")
                        obj.email_address = null;

                    if (file != null)
                    {
                        byte[] image = new byte[file.ContentLength];
                        file.InputStream.Read(image, 0, file.ContentLength);
                        obj.photo = ImageConvert.ResizeImageFile(image, 300);
                    }
                    else
                    {
                        obj.photo = null;
                    }

                    obj.membership_id = membership_id;
                    obj.changed_user_id = User.Identity.GetUserId();
                    obj.changed_date = DateTime.Now;
                    obj.is_dirty = 1;


                    employeeFactory.Edit(obj);
                    employeeFactory.Save();

                    return Json(new { success = true });
                }
                else
                {
                    return Json(new { success = false, errorMessage = "This employee already exists!!!!" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete employee
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteEmployee(int id)
        {
            try
            {
                employeeFactory = new EmployeeInformationFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var obj = employeeFactory.FindBy(b => b.id == id).FirstOrDefault();

                employeeFactory.Delete(obj);
                employeeFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (employeeFactory != null)
            {
                employeeFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}