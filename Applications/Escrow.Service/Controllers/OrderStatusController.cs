using Escrow.BOAS.Service.Factories;
using Escrow.BOAS.Service.Models;
using Escrow.Security.Factories;
using Escrow.Security.Models;
using Escrow.Service.Models;
using Escrow.Service.Utility;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Escrow.Service.Controllers
{
    [Authorize]
    public class OrderStatusController : ApiController
    {
        // GET api/<controller>

        public OrderStatusController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public OrderStatusController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;

        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region Global Variable

        private IReadOnlyFactory<tblBrokerInformation> brokerFactory;
        private IGenericFactory<tblPlaceOrder> placeOrderFactory;

        #endregion

        [HttpGet]
        public HttpResponseMessage getOrderStatusList(string BrokerName, string order_type, string status)
        {
            try
            {
                brokerFactory = new BrokerFactory();
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

                placeOrderFactory = new PlaceOrderFactory();
                string client_id = User.Identity.GetUserName();

                var obj = (dynamic)null;

                if(order_type == "Both")
                {
                    if (status == "All")
                    {
                        obj = placeOrderFactory.GetAll().Where(a => a.membership_id == membership_id && a.membership_id == membership_id && a.client_id == client_id)
                            .Select(a => new
                            {
                                a.client_id,
                                a.tblInvestor.first_holder_name,
                                a.tblInstrument.security_code,
                                a.order_type,
                                a.quantity,
                                a.market_price,
                                a.negotiable,
                                order_dt = a.order_date,
                                order_date = a.DimDate.FullDateUK,
                                is_placed = a.approve_date == null ? "No" : "Yes",
                                approve_date = a.DimDate.FullDateUK
                            }).OrderByDescending(a => a.order_dt).ToList();
                    }
                    else if (status == "Pending")
                    {
                        obj = placeOrderFactory.GetAll().Where(a => a.membership_id == membership_id && a.membership_id == membership_id && a.client_id == client_id && a.approve_date == null && a.cancel_date == null && a.cancel_by == null)
                            .Select(a => new
                            {
                                a.client_id,
                                a.tblInvestor.first_holder_name,
                                a.tblInstrument.security_code,
                                a.order_type,
                                a.quantity,
                                a.market_price,
                                a.negotiable,
                                order_dt = a.order_date,
                                order_date = a.DimDate.FullDateUK,
                                is_placed = a.approve_date == null ? "No" : "Yes",
                                approve_date = a.DimDate.FullDateUK
                            }).OrderByDescending(a => a.order_dt).ToList();
                    }
                    else if (status == "Placed")
                    {
                        obj = placeOrderFactory.GetAll().Where(a => a.membership_id == membership_id && a.membership_id == membership_id && a.client_id == client_id && a.approve_date != null && a.cancel_by == null && a.cancel_date == null)
                            .Select(a => new
                            {
                                a.client_id,
                                a.tblInvestor.first_holder_name,
                                a.tblInstrument.security_code,
                                a.order_type,
                                a.quantity,
                                a.market_price,
                                a.negotiable,
                                order_dt = a.order_date,
                                order_date = a.DimDate.FullDateUK,
                                is_placed = a.approve_date == null ? "No" : "Yes",
                                approve_date = a.DimDate.FullDateUK
                            }).OrderByDescending(a => a.order_dt).ToList();
                    }
                    else if (status == "Canceled")
                    {
                        obj = placeOrderFactory.GetAll().Where(a => a.membership_id == membership_id && a.membership_id == membership_id && a.client_id == client_id && a.cancel_date != null)
                            .Select(a => new
                            {
                                a.client_id,
                                a.tblInvestor.first_holder_name,
                                a.tblInstrument.security_code,
                                a.order_type,
                                a.quantity,
                                a.market_price,
                                a.negotiable,
                                order_dt = a.order_date,
                                order_date = a.DimDate.FullDateUK,
                                is_placed = a.approve_date == null ? "No" : "Yes",
                                approve_date = a.DimDate.FullDateUK
                            }).OrderByDescending(a => a.order_dt).ToList();
                    }
                }
                else if (order_type != "Both")
                {
                    if (status == "All")
                    {
                        obj = placeOrderFactory.GetAll().Where(a => a.membership_id == membership_id && a.membership_id == membership_id && a.client_id == client_id && a.order_type == order_type)
                            .Select(a => new
                            {
                                a.client_id,
                                a.tblInvestor.first_holder_name,
                                a.tblInstrument.security_code,
                                a.order_type,
                                a.quantity,
                                a.market_price,
                                a.negotiable,
                                order_dt = a.order_date,
                                order_date = a.DimDate.FullDateUK,
                                is_placed = a.approve_date == null ? "No" : "Yes",
                                approve_date = a.DimDate.FullDateUK
                            }).OrderByDescending(a => a.order_dt).ToList();
                    }
                    else if (status == "Pending")
                    {
                        obj = placeOrderFactory.GetAll().Where(a => a.membership_id == membership_id && a.membership_id == membership_id && a.client_id == client_id && a.order_type == order_type && a.approve_date == null && a.cancel_by == null && a.cancel_date == null)
                            .Select(a => new
                            {
                                a.client_id,
                                a.tblInvestor.first_holder_name,
                                a.tblInstrument.security_code,
                                a.order_type,
                                a.quantity,
                                a.market_price,
                                a.negotiable,
                                order_dt = a.order_date,
                                order_date = a.DimDate.FullDateUK,
                                is_placed = a.approve_date == null ? "No" : "Yes",
                                approve_date = a.DimDate.FullDateUK
                            }).OrderByDescending(a => a.order_dt).ToList();
                    }
                    else if (status == "Placed")
                    {
                        obj = placeOrderFactory.GetAll().Where(a => a.membership_id == membership_id && a.membership_id == membership_id && a.client_id == client_id && a.order_type == order_type && a.approve_date != null && a.cancel_date == null && a.cancel_by == null)
                            .Select(a => new
                            {
                                a.client_id,
                                a.tblInvestor.first_holder_name,
                                a.tblInstrument.security_code,
                                a.order_type,
                                a.quantity,
                                a.market_price,
                                a.negotiable,
                                order_dt = a.order_date,
                                order_date = a.DimDate.FullDateUK,
                                is_placed = a.approve_date == null ? "No" : "Yes",
                                approve_date = a.DimDate.FullDateUK
                            }).OrderByDescending(a => a.order_dt).ToList();
                    }
                    else if (status == "Canceled")
                    {
                        obj = placeOrderFactory.GetAll().Where(a => a.membership_id == membership_id && a.membership_id == membership_id && a.client_id == client_id && a.order_type == order_type && a.cancel_date != null)
                            .Select(a => new
                            {
                                a.client_id,
                                a.tblInvestor.first_holder_name,
                                a.tblInstrument.security_code,
                                a.order_type,
                                a.quantity,
                                a.market_price,
                                a.negotiable,
                                order_dt = a.order_date,
                                order_date = a.DimDate.FullDateUK,
                                is_placed = a.approve_date == null ? "No" : "Yes",
                                approve_date = a.DimDate.FullDateUK
                            }).OrderByDescending(a => a.order_dt).ToList();
                    }

                }

                object result = obj;

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        [HttpGet]
        public HttpResponseMessage getPendingOrderList(string BrokerName)
        {
            try
            {
                brokerFactory = new BrokerFactory();
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

                placeOrderFactory = new PlaceOrderFactory();
                string client_id = User.Identity.GetUserName();

                var obj = (dynamic)null;
                obj = placeOrderFactory.GetAll().Where(a => a.membership_id == membership_id && a.membership_id == membership_id && a.client_id == client_id && a.approve_date == null && a.cancel_by==null && a.cancel_date==null)
                            .Select(a => new
                            {
                                a.client_id,
                                a.tblInvestor.first_holder_name,
                                a.tblInstrument.security_code,
                                a.order_type,
                                a.quantity,
                                a.market_price,
                                a.negotiable,
                                order_id = a.id,
                                order_dt = a.order_date,
                                order_date = a.DimDate.FullDateUK,
                                is_placed = a.approve_date == null ? "No" : "Yes",
                                approve_date = a.DimDate.FullDateUK
                            }).OrderByDescending(a => a.order_dt).ToList();
                    
         

                object result = obj;

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        [HttpPost]
        public HttpResponseMessage orderCancel(string Broker, string date, string[] selected)
        {
            try
            {
                brokerFactory = new BrokerFactory();
                //decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id; // , string[] Quantity, string[] Orderdate, string[] OrderType, string BrokerName, string date
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == Broker).Select(a => a.membership_id).FirstOrDefault();
                placeOrderFactory = new PlaceOrderFactory();

                tblPlaceOrder obj = null;

                for (int i = 0; i < selected.Length; i++)
                {
                    obj = new tblPlaceOrder();

                    decimal id = Convert.ToDecimal(selected[i]);
                    //decimal instrument_id = Convert.ToDecimal(Instrum[i]);
                    //decimal quantity = Convert.ToDecimal(Quantity[i]);
                    //decimal order_date = Convert.ToDecimal(Orderdate[i]);
                    //string order_type = Convert.ToString(OrderType[i]);


                    obj = placeOrderFactory.FindBy(a => a.id == id).FirstOrDefault();

                    obj.cancel_by = User.Identity.GetUserId();
                    obj.cancel_date = DateTimeConfig.FullDateUKtoDateKey(date);
                    obj.is_dirty = 1;

                    placeOrderFactory.Edit(obj);

                }
                placeOrderFactory.Save();

                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.Forbidden, ex.Message);
            }
        }
    }
}