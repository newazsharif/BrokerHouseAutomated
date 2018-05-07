using Escrow.BOAS.BrokerManagement.Factories;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.BOAS.Utility;
using Escrow.BOAS.Web.Models;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.BrokerManagement.Interfaces;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Web.Areas.BrokerManagement.Controllers
{
    public class TraderInvestorMappingController : Controller
    {
        // GET: BrokerManagement/TraderInvestorMapping


         #region global variables

        private IGenericFactory<tblTrader> traderFactory;
        private IGenericFactory<tblInvestor> investorFactory;
        private IInvestorFactory iInvestorFactory;
        //private IGenericFactory<Escrow.BOAS.InvestorManagement.Models.tblInvestor>
        #endregion

        #region load dropdown

        /// <summary>
        /// Get all trader
        /// </summary>
        /// <param></param>
        public JsonResult getTraderList()
        {
            var traderList = DropDown.ddlTrader();
            return Json(traderList, JsonRequestBehavior.AllowGet);
        }

        #endregion


        public TraderInvestorMappingController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public TraderInvestorMappingController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Trader Investor Mapping View
        /// </summary>
        /// <returns>View</returns>
        public ActionResult TraderInvestorMapping()
        {
            return View();
        }

        
        /// <summary>
        /// Getting all investors list
        /// </summary>
        /// <param name="id"></param>
        /// <returns>List</returns>
        public JsonResult LoadInvestors(int id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                investorFactory = new InvestorFactory();

                var investorList = investorFactory.GetAll().Where(a => a.trader_id == id)
                    .Select(s => new
                    {
                       s.client_id,
                       s.bo_code,
                       s.first_holder_name,
                       s.trader_id,
                       trader = s.tblTrader.trader_code
                    }).ToList();

                var jsonResult = Json(new { investorList = investorList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        
        /// <summary>
        /// Getting investors by id
        /// </summary>
        /// <param name="search"></param>
        /// <param name="trader_id"></param>
        /// <returns>List</returns>
        public JsonResult GetSearchInvestors(string search, int trader_id)
        {
            try
            {
                iInvestorFactory = new InvestorFactory();
                var searchInvestorList = iInvestorFactory.getInvestorinfoBySearch(search,trader_id);

                return Json(new { searchInvestorList = searchInvestorList, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
            
        }

        /// <summary>
        /// Updating Investors Trader id
        /// </summary>
        /// <param name="clients"></param>
        /// <param name="traders"></param>
        /// <returns></returns>
        public JsonResult saveTraderInvMap(string[] clients, int[] traders)
        {
           
            investorFactory = new InvestorFactory();            
            try
            {
                for (int i = 0; i < clients.Length; i++)
                {
                    var client = clients[i];
                    var obj = investorFactory.FindBy(a => a.client_id == client).FirstOrDefault();
                    var updated_trader_id = traders[i];
                    obj.trader_id = updated_trader_id;
                    investorFactory.Edit(obj);
                }
                investorFactory.Save();
                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }       
    }
}