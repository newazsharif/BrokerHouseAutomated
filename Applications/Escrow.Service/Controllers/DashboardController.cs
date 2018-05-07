using Escrow.BOAS.InvestorManagement.Factories;
using Escrow.BOAS.InvestorManagement.Models;
using Escrow.BOAS.Service.Factories;
using Escrow.BOAS.Service.Models;
using Escrow.Security.Factories;
using Escrow.Security.Models;
using Escrow.Service.Models;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Escrow.Service.Controllers
{
    //[Authorize]
    public class DashboardController : ApiController
    {
        // GET: Dashboard
       
        #region Global Variable

        private IGenericFactory<tblPlaceOrder> placeOrderFactory;
        private IGenericFactory<tblInvestorFundBalance> investorFundBalanceFactory;
        private IGenericFactory<tblInvestorShareBalance> investorShareBalanceFactory;
        IGenericFactory<Escrow.BOAS.InvestorManagement.Models.tblJoinHolder> joinHolderFactory;
        //private Escrow.BOAS.InvestorManagement.Factories.PlaceOrderFactory placeOrderFactory;
        //private IGenericFactory<Escrow.BOAS.AccountingManagement.Models.tblBankBranch> bankBranchFactory;

        #endregion

        public DashboardController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public DashboardController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }


       //[HttpPost]
       // [HttpGet]
        public HttpResponseMessage GetInvestorFundBalanceInfo(string id, string date)
        {
            //tblPlaceOrder placedOrder = new tblPlaceOrder();
            investorFundBalanceFactory = new FundBalanceFactory();
            // string i = id;
            decimal datetime = DateTimeConfig.FullDateUKtoDateKey(date);
            var fundBalance = investorFundBalanceFactory.FindBy(a => a.client_id == id)
                //.OrderByDescending(a => a.client_id)
                .Select(
                a => new
               {
                   a.client_id,
                   a.available_balance,
                   a.sale_receivable,
                   a.un_clear_cheque,
                   a.ledger_balance,
                   a.market_value,
                   a.equity,
                   a.purchase_power,
                   a.loan_ratio,
                   a.realized_gain,
                   a.unrealized_gain,
                   net_gain = a.realized_gain + a.unrealized_gain
               }).ToList();

            return Request.CreateResponse(HttpStatusCode.OK, new { fundBalance });
        }

       // [HttpGet]
        public HttpResponseMessage GetInvestorDashboardInfo(string id, string date)
        {
            placeOrderFactory = new PlaceOrderFactory();
            // string i = id;
            decimal datetime = DateTimeConfig.FullDateUKtoDateKey(date);
            var placedOrder = placeOrderFactory.FindBy(a => a.client_id == id).Where(a => a.order_date == datetime).OrderByDescending(a => a.id).Select(
                a => new
                {
                    a.client_id,
                    a.approve_by,
                    a.approve_date,
                    instrument_id = a.tblInstrument.security_code,
                    a.market_price,
                    a.membership_id,
                    a.negotiable,
                    a.order_date,
                    a.order_type,
                    a.quantity,
                    //status = a.approve_by == null && a.cancel_by == null ? "Pending" : "Placed",
                    status = a.approve_by == null && a.cancel_by == null ? "Pending" :  a.cancel_by == null && a.cancel_date == null ? "Placed" : "Canceled",

                }).ToList();

            return Request.CreateResponse(HttpStatusCode.OK, new { placedOrder });
        }

       // [HttpGet]
        public HttpResponseMessage GetInvestorShareBalanceInfo(string id, string date)
        {
          //  investorShareBalanceFactory = new ShareBalanceFactory();
            InvestorFactory investor = new InvestorFactory();

            // string i = id;
            decimal datetime = DateTimeConfig.FullDateUKtoDateKey(date);

            var selected_investor = investor.GetAll().Where(a => a.client_id == id).FirstOrDefault();

            PortStatementFactory portstatFactory = new PortStatementFactory();
            DataTable dt = new DataTable();
            Decimal m_id = Convert.ToDecimal(selected_investor.membership_id);
            string con_string = ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString;
                       
            dt = portstatFactory.getPortfolioStatement(m_id, selected_investor.changed_user_id, id, DateTime.Now, con_string);
            
         
            var shareBalance = dt.AsEnumerable().Select(m => new ShareBalanceVM()
            {
                instrument_name = m.Field<string>("security_code"),
                ledger_quantity = m.Field<decimal>("market_value"),
                salable_quantity = m.Field<decimal>("salable_quantity"),
                cost_average = m.Field<decimal>("cost_average"),
                cost_value = m.Field<decimal>("cost_value"),
                market_price = m.Field<decimal>("market_price"),
                market_value = m.Field<decimal>("market_value"),

            }).ToList();

            return Request.CreateResponse(HttpStatusCode.OK, new { shareBalance });
        }


        public HttpResponseMessage GetInvestorJointHolderInfo(string id, string date)
        {
            joinHolderFactory = new JoinHolderFactory();
            string imageBase64String = "";
            string signatureBase64String = "";
            try
            {
                var joinHolder = joinHolderFactory.FindBy(a => a.client_id == id).Select(
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
                    a.membership_id,
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
                return Request.CreateResponse(HttpStatusCode.OK, new { joinHolder = joinHolder, ImageData = imageBase64String, SignatureData = signatureBase64String });
                //return Json(new { joinHolder = joinHolder, ImageData = imageBase64String, SignatureData = signatureBase64String, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.Forbidden, ex.Message);
            }
        }
    }
}