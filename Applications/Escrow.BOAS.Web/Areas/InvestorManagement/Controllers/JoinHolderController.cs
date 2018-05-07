using Escrow.BOAS.InvestorManagement.Models;
using Escrow.BOAS.Utility;
using Escrow.Utility.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Escrow.BOAS.InvestorManagement.Factories;
using System.IO;
using Escrow.BOAS.Web.Models;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Data.Entity;

namespace Escrow.BOAS.Web.Areas.InvestorManagement.Controllers
{
    public class JoinHolderController : Controller
    {
        IGenericFactory<Escrow.BOAS.InvestorManagement.Models.tblJoinHolder> joinHolderFactory;
        IGenericFactory<Escrow.BOAS.InvestorManagement.Models.tblInvestor> investorFactory;


        public JoinHolderController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public JoinHolderController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }
        // GET: InvestorManagement/JoinHolder

        public ActionResult Index()
        {
            return View();
        }


        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose: Action method for adding new join holder
        /// </summary>
        /// <returns>View</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult AddNewJoinHolder()
        {
            return View();
        }


        /// <summary>
        ///  Created By: Newaz Sharif
        ///  Purpose: Action method for edit join holder
        /// </summary>
        /// <param name="client_id"></param>
        /// <returns></returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditJoinHolder(string client_id)
        {
            return View();
        }


        /// <summary>
        /// Purpose :  Get All join holder to show ion a list
        /// </summary>
        /// <returns>JoinHolder</returns>
        //[Authorize]
        public JsonResult GetAllJoinHolder()
        {
            joinHolderFactory = new JoinHolderFactory();
            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
            try
            {
                var joinHolders = joinHolderFactory.GetAll().Where(x=>x.membership_id == membership_id).Select(a => new
                {
                    a.client_id,
                    a.join_holder_name,
                    bo_code = a.tblInvestor.bo_code,
                    gender = a.tblConstantObjectValue.display_value,


                }).ToList();
                return Json(new { joinHolders = joinHolders, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        /// <summary>
        /// Save investor information
        /// </summary>

        /// <returns>Json</returns>

        //[HttpPost]
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult SaveNewJoinHolder(tblJoinHolder joinHolder, List<HttpPostedFileBase> file)
        {
            joinHolderFactory = new JoinHolderFactory();
            try
            {
                joinHolder.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                joinHolder.changed_user_id = User.Identity.GetUserId();
                joinHolder.changed_date = DateTime.Now;
                joinHolder.is_dirty = 1;

                if (file != null)
                {
                    if (joinHolder.Imagestatus == "s")
                    {
                        byte[] signature = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(signature, 0, file.First().ContentLength);
                        joinHolder.signature = ImageConvert.ResizeImageFile(signature, 300);
                        joinHolder.photo = null;
                    }

                    else if (joinHolder.Imagestatus == "p")
                    {
                        byte[] image = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(image, 0, file.First().ContentLength);
                        joinHolder.photo = ImageConvert.ResizeImageFile(image, 300);
                        joinHolder.signature = null;
                    }
                    else
                    {
                        byte[] image = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(image, 0, file.First().ContentLength);
                        joinHolder.photo = ImageConvert.ResizeImageFile(image, 300);

                        byte[] signature = new byte[file.Skip(1).First().ContentLength];
                        file.Skip(1).First().InputStream.Read(signature, 0, file.Skip(1).First().ContentLength);
                        joinHolder.signature = ImageConvert.ResizeImageFile(signature, 300);
                    }
                }
                else
                {
                    joinHolder.photo = null;
                    joinHolder.signature = null;
                }

                joinHolderFactory.Add(joinHolder);
                joinHolderFactory.Save();

                return Json(new { joinHolder = "Successfully Saved Data", success = true });

            }
            catch (Exception ex)
            {
                return Json(new { data = ex.Message, success = false });
            }

        }

        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose: Load a JoinHolder Information
        /// </summary>
        /// <param name="client_id"></param>
        /// <returns>json</returns>
        [CheckUserSessionAttribute]
       //[Authorize]
        public JsonResult LoadJoinHolderById(string client_id)
        {
            joinHolderFactory = new JoinHolderFactory();
            string imageBase64String = "";
            string signatureBase64String = "";
            try
            {
                var joinHolder = joinHolderFactory.FindBy(a => a.client_id == client_id).Select(
                a => new
                {
                    a.client_id,
                    DOB = a.birth_date == null ? null : DbFunctions.TruncateTime(a.birth_date).ToString(),
                    a.active_status_id,
                    a.father_name,
                    a.gender_id,
                    a.join_holder_name,
                    a.mother_name,
                    a.photo,
                    a.signature,
                    a.membership_id
                }).FirstOrDefault();

                if (joinHolder != null)
                {
                    if (joinHolder.photo != null)
                    {
                        imageBase64String = Convert.ToBase64String(joinHolder.photo, 0, joinHolder.photo.Length);
                    }
                    if (joinHolder.signature != null)
                    {
                        signatureBase64String = Convert.ToBase64String(joinHolder.signature, 0, joinHolder.signature.Length);
                    }
                }

                return Json(new { joinHolder = joinHolder, ImageData = imageBase64String, SignatureData = signatureBase64String, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { errorMessage = ex.Message, success = true }, JsonRequestBehavior.AllowGet);
            }

        }

        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose: Update a joinholder
        /// </summary>
        /// <param name="editJoinHolder"></param>
        /// <param name="file"></param>
        /// <returns>json</returns>
        /// 
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult UpdateJoinHolder(tblJoinHolder editJoinHolder, List<HttpPostedFileBase> file)
        {
            joinHolderFactory = new JoinHolderFactory();
            try
            {
                editJoinHolder.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                editJoinHolder.changed_user_id = User.Identity.GetUserId();
                editJoinHolder.changed_date = DateTime.Now;
                editJoinHolder.is_dirty = 1;

                if (file != null)
                {
                    if (editJoinHolder.Imagestatus == "s")
                    {
                        byte[] signature = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(signature, 0, file.First().ContentLength);
                        editJoinHolder.signature = ImageConvert.ResizeImageFile(signature, 300);
                        editJoinHolder.photo = null;
                    }

                    else if (editJoinHolder.Imagestatus == "p")
                    {
                        byte[] image = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(image, 0, file.First().ContentLength);
                        editJoinHolder.photo = ImageConvert.ResizeImageFile(image, 300);
                        editJoinHolder.signature = null;
                    }
                    else
                    {
                        byte[] image = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(image, 0, file.First().ContentLength);
                        editJoinHolder.photo = ImageConvert.ResizeImageFile(image, 300);

                        byte[] signature = new byte[file.Skip(1).First().ContentLength];
                        file.Skip(1).First().InputStream.Read(signature, 0, file.Skip(1).First().ContentLength);
                        editJoinHolder.signature = ImageConvert.ResizeImageFile(signature, 300);
                    }
                }
                else
                {
                    editJoinHolder.photo = null;
                    editJoinHolder.signature = null;
                }
                editJoinHolder.join_holder_name = (editJoinHolder.join_holder_name == "null") ? null : editJoinHolder.join_holder_name;
                editJoinHolder.mother_name = (editJoinHolder.mother_name == "null") ? null : editJoinHolder.mother_name;
                editJoinHolder.father_name = (editJoinHolder.father_name == "null") ? null : editJoinHolder.father_name;

                joinHolderFactory.Edit(editJoinHolder);
                joinHolderFactory.Save();
                return Json(new { joinHolder = "Successfully Saved Data", success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        //[Authorize]
        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose: Load all JoinHolder
        /// </summary>
        /// <returns></returns>
        /// 
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult JoinHolderList()
        {
            return View();
        }

        /// <summary>
        /// Get single Join Holder by client id
        /// </summary>
        /// <param name="id">client_id</param>
        /// <returns>investor</returns>
        /// 
        
        public JsonResult getInvestorInfoById(string id)
        {

            joinHolderFactory = new JoinHolderFactory();
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                Escrow.BOAS.InvestorManagement.Models.tblInvestor investor = CommonUtility.getInvestorInfoById(id);

                string JoinHolderUnique = joinHolderFactory.GetAll()
                    .Where(a => a.client_id == id)
                    .Select(a => a.client_id).FirstOrDefault();
                if (JoinHolderUnique == null)
                {
                    if (investor != null)
                    {
                        if (investor.active_status.ToUpper() != "ACTIVE")
                        {
                            return Json(new { success = false, errorMessage = investor.active_status + " Investor" }, JsonRequestBehavior.AllowGet);
                        }
                        else if (investor.operation_type.ToUpper() != "JOINT HOLDERS")
                        {
                            return Json(new { success = false, errorMessage = "Not a Join Holder" }, JsonRequestBehavior.AllowGet);
                        }
                        else
                        {
                            return Json(new { investor = investor, success = true }, JsonRequestBehavior.AllowGet);
                        }
                    }
                    else
                    {
                        return Json(new { success = false, errorMessage = "Invalid Investor" }, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    return Json(new { success = false, errorMessage = "Investor Already Joined" }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }
        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose: Get Inverstor information for validation
        /// </summary>
        /// <returns></returns>
       
        public JsonResult GetInvestorInfo(string client_code)
        {
            investorFactory = new InvestorFactory();
            try
            {
                var investor = investorFactory.GetAll().
                    Where(a => a.client_id == client_code &&
                    a.operation_type_id == 94
                    && a.active_status_id == 47).
                    Select(x => new
                {
                    x.first_holder_name,
                    x.bo_code
                });
                return Json(new { data = investor, success = true });

            }
            catch
            {
                return Json(new { success = false });
            }
        }
       
        public JsonResult GetInvestorInfowithoutJoin(string client_code)
        {
            investorFactory = new InvestorFactory();
            try
            {
                var investor = investorFactory.GetAll().
                    Where(a => a.client_id == client_code
                    && a.active_status_id == 47).
                    Select(x => new
                    {
                        x.first_holder_name,
                        x.bo_code
                    });
                return Json(new { data = investor, success = true });

            }
            catch
            {
                return Json(new { success = false });
            }
        }
        public JsonResult GetddlGender()
        {
            var data = DropDown.ddlGender();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlStatus()
        {
            var data = DropDown.ddlActiveStatus();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetddlInvestorSubAcc()
        {
            var data = DropDown.ddlInvestorSubAcc();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        
    }
}