using Escrow.BOAS.InvestorManagement.Factories;
using Escrow.BOAS.InvestorManagement.Models;
using Escrow.BOAS.Utility;
using Escrow.Utility.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Escrow.BOAS.AccountingManagement.Factories;
using Escrow.BOAS.Web.Models;
using Microsoft.AspNet.Identity.EntityFramework;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Drawing.Imaging;
using System.Data.Entity.Core.Objects;
using System.Data.Entity;

namespace Escrow.BOAS.Web.Areas.InvestorManagement.Controllers
{

    /// <summary>
    /// Created By: NEwaz SHarif
    /// Created Date: 22/08/15
    /// purpose : Investor Controller
    /// </summary>
    public class InvestorController : Controller
    {
        private IGenericFactory<tblInvestor> investorFactory;
        private IGenericFactory<Escrow.BOAS.AccountingManagement.Models.tblBankBranch> bankBranchFactory;

        //public InvestorController()
        //    : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        //{

        //}

        //public InvestorController(UserManager<ApplicationUser> userManager)
        //{
        //    UserManager = userManager;
        //}
        //public UserManager<ApplicationUser> UserManager { get; private set; }


        
        // GET: InvestorManagement/Investor
        public ActionResult Index()
        {
            return View();
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult InvestorList()
        {
            return View();
        }
        
        /// <summary>
        /// Created By: Newaz Sharif
        /// Created Date : 24/08/15
        /// Purpose : UI Controller for Add new investor
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult AddNewInvestor()
        {
            return View();
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult AddNewInvestorTest()
        {
            return View();
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult EditInvestorTest()
        {
            return View();
        }
        /// <summary>
        /// Created By: Newaz Sharif
        /// Created Date : 30/08/15
        /// Purpose : UI Controller for Edit investor
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
       //[Authorize]
        public ActionResult EditInvestor()
        {
            return View();
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult GetInvestorById(string id)
        {
            try
            {
                investorFactory = new InvestorFactory();
                InvestorImageFactory imageFactory = new InvestorImageFactory();
                var insvestor = investorFactory.FindBy(b => b.client_id == id).Include(i => i.tblInvestorImage).Select(
                a => new
                {
                    a.client_id,
                    a.first_holder_name,
                    a.gender_id,
                    a.bo_refernce_id,
                    a.bo_code,
                    a.birth_date,
                    DOB = a.birth_date == null ? null : DbFunctions.TruncateTime(a.birth_date).ToString(),
                    a.father_name,
                    a.mother_name,
                    a.national_id,
                    a.passport_no,
                    a.nibondhon_no,
                    a.branch_id,
                    a.bank_branch_id,
                    a.tblBankBranch.routing_no,
                    a.bank_id,
                    a.account_type_id,
                    a.operation_type_id,
                    a.sub_account_type_id,
                    a.mailing_address,
                    a.permanent_address,
                    a.thana_id,
                    a.district_id,
                    a.mobile_no,
                    a.phone_no,
                    a.email_address,
                    a.banc_account_no,
                    a.beftn_enabled,
                    a.email_enabled,
                    a.sms_enabled,
                    a.internet_enabled,
                    a.opening_date,
                    Opening_date = a.DimDate.FullDateUK,
                    a.passport_issue_place,
                    a.passport_issue_date,
                    Passport_issue_date = a.passport_issue_date == null ? null : DbFunctions.TruncateTime(a.passport_issue_date).ToString(),
                    a.passport_valid_to_date,
                    Passport_valid_to_date = a.passport_valid_to_date == null ? null : DbFunctions.TruncateTime(a.passport_valid_to_date).ToString(),
                    a.trader_id,
                    a.ipo_type_id,
                    a.trade_type_id,
                    a.omnibus_master_id,
                    a.active_status_id,
                    a.membership_id,
                }).FirstOrDefault();
                string imageBase64String = "";
                string signatureBase64String = "";
                var investorImage = imageFactory.FindBy(b => b.client_id==id).Select(
                    a => new
                    {
                        a.client_id,
                        a.photo,
                        a.signature
                    }).FirstOrDefault();
                if(investorImage != null)
                {
                    if (investorImage.photo != null)
                    {
                        imageBase64String = Convert.ToBase64String(investorImage.photo, 0, investorImage.photo.Length);
                    }
                    if (investorImage.signature != null)
                    {
                        signatureBase64String = Convert.ToBase64String(investorImage.signature, 0, investorImage.signature.Length);
                    }
                }
                
                return Json(new { investor = insvestor, investorImage = investorImage, ImageData = imageBase64String, SignatureData = signatureBase64String, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errormessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult SaveNewInvestor(tblInvestor investor, List<HttpPostedFileBase> file)
        {
            investorFactory = new InvestorFactory();
            InvestorImageFactory imageFactory = new InvestorImageFactory();
            tblInvestorImage investorImage = new tblInvestorImage();
            try
            {
                investor.changed_user_id = User.Identity.GetUserId();
                investor.changed_date = DateTime.Now;
                investor.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                investor.is_dirty = 1;
                investorImage.client_id = investor.client_id;
                if (file != null)
                {
                    if (investor.Imagestatus == "s")
                    {
                        byte[] signature = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(signature, 0, file.First().ContentLength);
                        investorImage.signature = ImageConvert.ResizeImageFile(signature, 300);
                        investorImage.photo = null;
                    }

                    else if (investor.Imagestatus == "p")
                    {
                        byte[] image = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(image, 0, file.First().ContentLength);
                        investorImage.photo = ImageConvert.ResizeImageFile(image, 300);
                        investorImage.signature = null;
                    }
                    else
                    {
                        byte[] image = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(image, 0, file.First().ContentLength);
                        investorImage.photo = ImageConvert.ResizeImageFile(image, 300);

                        byte[] signature = new byte[file.Skip(1).First().ContentLength];
                        file.Skip(1).First().InputStream.Read(signature, 0, file.Skip(1).First().ContentLength);
                        investorImage.signature = ImageConvert.ResizeImageFile(signature, 300);
                    }
                }
                else
                {
                    investorImage.photo = null;
                    investorImage.signature = null;
                }
                
                investor.tblInvestorImage = investorImage;
                
                investorFactory.Add(investor);

                investorFactory.Save(investor);
                return Json(new { success = true });
            }
            catch(Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }

        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult UpdateInvestor(tblInvestor investor,List<HttpPostedFileBase> file)
        {
            investorFactory = new InvestorFactory();
            InvestorImageFactory imageFactory = new InvestorImageFactory();
            tblInvestorImage investorImage = new tblInvestorImage();
            try
            {
                investor.changed_user_id = User.Identity.GetUserId();
                investor.changed_date = DateTime.Now;
                investor.is_dirty = 1;
                investorImage.client_id = investor.client_id;
                if (file != null)
                {
                    if (investor.Imagestatus == "s")
                    {
                        byte[] signature = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(signature, 0, file.First().ContentLength);
                        investorImage.signature = ImageConvert.ResizeImageFile(signature, 300);
                        investorImage.photo = null;
                    }

                    else if (investor.Imagestatus == "p")
                    {
                        byte[] image = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(image, 0, file.First().ContentLength);
                        investorImage.photo = ImageConvert.ResizeImageFile(image, 300);
                        investorImage.signature = null;
                    }
                    else
                    {
                        byte[] image = new byte[file.First().ContentLength];
                        file.First().InputStream.Read(image, 0, file.First().ContentLength);
                        investorImage.photo = ImageConvert.ResizeImageFile(image, 300);

                        byte[] signature = new byte[file.Skip(1).First().ContentLength];
                        file.Skip(1).First().InputStream.Read(signature, 0, file.Skip(1).First().ContentLength);
                        investorImage.signature = ImageConvert.ResizeImageFile(signature, 300);
                    }
                }
                else
                {
                    investorImage.photo = null;
                    investorImage.signature = null;
                }

                investor.national_id = (investor.national_id == "null") ? null : investor.national_id;
                investor.passport_no = (investor.passport_no == "null") ? null : investor.passport_no;
                investor.nibondhon_no = (investor.nibondhon_no == "null") ? null : investor.nibondhon_no;
                investor.father_name = (investor.father_name == "null") ? null : investor.father_name;
                investor.mother_name = (investor.mother_name == "null") ? null : investor.mother_name;
                investor.mailing_address = (investor.mailing_address == "null") ? null : investor.mailing_address;
                investor.permanent_address = (investor.permanent_address == "null") ? null : investor.permanent_address;
                investor.phone_no = (investor.phone_no == "null") ? null : investor.phone_no;
                investor.mobile_no = (investor.mobile_no == "null") ? null : investor.mobile_no;
                investor.email_address = (investor.email_address == "null") ? null : investor.email_address;
                investor.banc_account_no = (investor.banc_account_no == "null") ? null : investor.banc_account_no;
                investor.passport_issue_place = (investor.passport_issue_place == "null") ? null : investor.passport_issue_place;
                investor.bo_code = (investor.bo_code == "null") ? null : investor.bo_code;
                investor.omnibus_master_id = (investor.omnibus_master_id == "null") ? null : investor.omnibus_master_id;

                investor.tblInvestorImage = investorImage;
                //investor.tblInvestorImage.signature = investorImage.signature;
                investorFactory.Edit(investor);
                imageFactory.Edit(investorImage);
                investorFactory.Save();
                imageFactory.Save();
                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }
        /// <summary>
        /// Created By : Newaz Sharif
        /// Created Date : 23/08/2015
        /// purpose : Get the list of all investors
        /// </summary>
        /// <returns>Json</returns>
        [CheckUserSessionAttribute]
         //[Authorize]
        public JsonResult GetAllInvestors()
        {
            investorFactory = new InvestorFactory();
            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
            try
            {
                var investors = investorFactory.GetAll().Where(x=>x.membership_id == membership_id).Select(a => new { a.client_id,
                    a.first_holder_name, 
                    a.bo_code, 
                    operation_type = a.tblConstantObjectValue3.display_value,
                    trader = a.tblTrader.trader_code,
                    account_type = a.tblConstantObjectValue1.display_value, 
                    mobile  = a.mobile_no,
                    ipo_type  = a.tblConstantObjectValue2.display_value }).ToList();

                var jsonResult = Json(new { investors = investors, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch(Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
       
        public JsonResult CheckBo(string bo_code)
        {
            investorFactory = new InvestorFactory();
            string bo = investorFactory.GetAll().Where(a=>a.bo_code == bo_code).Select(x=>x.bo_code).FirstOrDefault();
            string data = "";
            if(bo == bo_code)
            {
                data = "NoAvailable";
            }

            return Json(data,JsonRequestBehavior.AllowGet);

        }
        public JsonResult CheckBranch(string routing_no)
        {
            bankBranchFactory = new Escrow.BOAS.AccountingManagement.Factories.BankBranchFactory();
            var brankBanklist = bankBranchFactory.GetAll().AsEnumerable().Where(a => a.routing_no == routing_no).Select(
                x => new
                {
                    bank_branch_id = x.id,
                    bank_id = x.tblBank.id,
                    routing_no=x.routing_no
                }).FirstOrDefault();
            if (brankBanklist!=null)
            {
            return Json(new { success = true, data = brankBanklist }, JsonRequestBehavior.AllowGet);

            }else{
            return Json(new { success = false, data = "No Router Found" }, JsonRequestBehavior.AllowGet);

            }

        }
        public JsonResult LoadRouter(int bank_branch_id)
        {
            bankBranchFactory = new Escrow.BOAS.AccountingManagement.Factories.BankBranchFactory();
            string bo = bankBranchFactory.GetAll().Where(a => a.id == bank_branch_id).Select(x => x.routing_no).FirstOrDefault();
            return Json(bo, JsonRequestBehavior.AllowGet);

        }

        //[Authorize]
        public JsonResult CheckInvestor(string investor_code)
        {
            investorFactory = new InvestorFactory();
            string investor = investorFactory.GetAll().Where(a => a.client_id == investor_code).Select(x => x.client_id).FirstOrDefault();
            string data = "";
            if (investor == investor_code)
            {
                data = "NoAvailable";
            }

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        
        public JsonResult GetddlThana()
        {
            var data = DropDown.ddlThana();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlDistrict()
        {
            var data = DropDown.ddlDistrict();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlBORef()
        {
            var data = DropDown.ddlDp();
            return Json (data,JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlGender()
        {
            var data = DropDown.ddlGender();
            return Json (data,JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlOpType()
        {
            var data = DropDown.ddlOperationType();
            return Json(data, JsonRequestBehavior.AllowGet);
        }


        public JsonResult GetddlBranch()
        {
            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

            string user_id = User.Identity.GetUserId();

            var data = DropDown.ddlBrokerBranch(user_id, membership_id);
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlBank()
        {
            var data = DropDown.ddlBank();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlBankBranch(int bank_id)
        {
            var data = DropDown.ddlBankBranch(bank_id);
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlBankBranchEdit()
        {
            var data = DropDown.ddlBankBranchEdit();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlInvestorSubAcc()
        {
            var data = DropDown.ddlInvestorSubAcc();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetddlIntroducer()
        {
            var data = DropDown.ddlIntroducer();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        
        public JsonResult GetddlOmnibusMaster()
        {
            var data = DropDown.ddlOmnibusMaster();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlTrader()
        {
            var data = DropDown.ddlTrader();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlTradeType()
        {
            var data = DropDown.ddlTradeType();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlIpoType()
        {
            var data = DropDown.ddlIpoType();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlAcType()
        {
            var data = DropDown.ddlAccountType();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlStatus()
        {
            var data = DropDown.ddlActiveStatus();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        //[Authorize]
        public JsonResult CheckBoForEdit(string client_code, string bo_code)
        {
            investorFactory = new InvestorFactory();
            string bo = investorFactory.GetAll().
                Where(a => a.bo_code == bo_code && a.client_id != client_code).
                Select(x => x.bo_code).FirstOrDefault();
            if (bo == bo_code)
            {
                return Json("NoAvailable",JsonRequestBehavior.AllowGet);
            }
            else
                return Json("Available", JsonRequestBehavior.AllowGet);
        }
        
    }
}