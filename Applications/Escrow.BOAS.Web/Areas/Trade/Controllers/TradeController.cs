using Escrow.BOAS.InstrumentManagement.Factories;
using Escrow.BOAS.Trade.Factories;
using Escrow.BOAS.Trade.Interfaces;
using Escrow.BOAS.Trade.Models;
using Escrow.BOAS.Transaction.Factories;
using Escrow.BOAS.Utility;
using Escrow.BOAS.Web.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml;

namespace Escrow.BOAS.Web.Areas.Trade.Controllers
{
    public class TradeController : Controller
    {
        private ICommonDBFunctionality commonDBFunctionality;
        private IGenericFactory<tblNonTradingMaster> tradeMasterFactory;
        private IGenericFactory<tblNonTradingDetail> tradeDetailsFactory;


        //public TradeController(UserManager<ApplicationUser> userManager)
        //{
        //    UserManager = userManager;
        //}

        public UserManager<ApplicationUser> UserManager { get; private set; }
        //IGenericFactory<Escrow.BOAS.Trade.Models.tblNonTradingDetail> nonTradingDetailFactory;
        //IGenericFactory<Escrow.BOAS.Trade.Models.tblNonTradingMaster> nonTradingMasterFactory;
        private ITradeFactory nonTradingMasterFactory;
        private TradeFactory tradeFactory;
        private ConstantObjectValueFactory constantObjectValueFactory;

        [CheckUserSessionAttribute]
        //[Authorize] 
        public ActionResult ListNonTradingDay()
        {
            return View();
        }
        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose : View for Creating non trade day
        /// </summary>
        /// <returns>View</returns>
        /// 
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult CreateNonTradingDay()
        {
            return View();
        }

        public ActionResult NonTradingDayList()
        {
            return View();
        }

        public JsonResult GetAllNonTradingDay()
        {
            try
            {
                tradeMasterFactory = new TradeMasterFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                var nonTradingDays = tradeMasterFactory.GetAll().Where(x => x.membership_id == membership_id)
                    .Select(a => new
                    {
                        from_date = a.DimDate.FullDateUK,
                        to_date = a.DimDate1.FullDateUK,
                        a.remarks,
                        a.input_info,
                        type = a.tblConstantObjectValue.display_value,
                        Id = a.Id,

                    });
                return Json(new { nonTradingDays = nonTradingDays, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }


        }


        // Created By: Rifad
        // Date: 3-5-2017
        /// Purpose: Get all Non trading day list
        public JsonResult GetDetailNonTradingDayById(int Id)
        {
            try
            {
                tradeDetailsFactory = new TradeDetailFactory();
                var nonTradingDayDetails = tradeDetailsFactory.GetAll().AsEnumerable().Where(x => x.master_id == Id)
                    .Select(a => new
                    {

                        non_trading_date = a.DimDate.Date.Value.GetDateTimeFormats()[7],
                        master_id=a.master_id,
                        Id = a.Id
                    }).ToList();
                return Json(new { nonTradingDayDetails = nonTradingDayDetails, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult DeleteNonTradingDayById(int Id)
        {
            try
            {
                tradeDetailsFactory = new TradeDetailFactory();
                var trade = tradeDetailsFactory.GetById(Id);
                tradeDetailsFactory.Delete(trade);
                tradeDetailsFactory.Save();
                return Json(new { message = "Successfully Deleted", success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult DeleteNonTradingMasterById(int Id)
        {
            try
            {
                tradeMasterFactory = new TradeMasterFactory();
                var trade = tradeMasterFactory.GetById(Id);
                tradeMasterFactory.Delete(trade);
                tradeMasterFactory.Save();
                return Json(new { message = "Successfully Deleted", success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }



        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose: Partial view for On demand
        /// </summary>
        /// <returns>partialview</returns>
        public PartialViewResult _OnDemandPartial()
        {
            return PartialView();
        }
        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose: Partial view for On demand
        /// </summary>
        /// <returns>partialview</returns>
        public PartialViewResult _WeeklyPartial()
        {
            return PartialView();
        }
        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose: Partial view for On demand
        /// </summary>
        /// <returns>partialview</returns>
        public PartialViewResult _YearlyPartial()
        {
            return PartialView();
        }

        //[Authorize]
        public ActionResult CreateClosePriceFile()
        {
            return View();
        }
        [CheckUserSessionAttribute]
        public ActionResult CreateTradeFile()
        {
            return View();
        }

        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose : Dropdown for nontrading Day type
        /// </summary>
        /// <returns>Json</returns>
        public JsonResult GetddlNonTradingDayType()
        {
            var data = DropDown.ddlNonTradingType();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public ActionResult EditLoadedData()
        {
            return View();
        }
        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose : Insert Non Trading day for database
        /// </summary>
        /// <param name="nonTradingMaster"></param>
        /// <returns>Json</returns>
        /// 
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult SaveNewNonTradingDay(tblNonTradingMaster nonTradingMaster)
        {
            constantObjectValueFactory = new ConstantObjectValueFactory();
            nonTradingMaster.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
            nonTradingMaster.active_status_id = constantObjectValueFactory.FindBy(x => x.display_value.ToUpper() == "ACTIVE").FirstOrDefault().object_value_id;

            nonTradingMaster.changed_user_id = User.Identity.GetUserId();
            nonTradingMasterFactory = new TradeMasterFactory();
            try
            {
                nonTradingMasterFactory.InsertNonTradingDay(nonTradingMaster);
                return Json(new { NonTradingDay = "Successfully Saved Data", success = true });
            }
            catch (Exception ex)
            {
                return Json(ex.Message, JsonRequestBehavior.AllowGet);
            }

        }

        /// <summary>
        /// Created By: Newaz Sharif
        /// Purpose : Insert Close Price data to temp table
        /// </summary>
        /// <param name="link"></param>
        /// <returns></returns>
        /// 
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult UploadPriceFile(List<HttpPostedFileBase> file)
        {
            try
            {
                var link = "ClosePricefile";
                string path = Path.Combine(Server.MapPath("~/App_Data"), link);
                System.IO.File.Exists(path);
                DataSet ds = new DataSet();
                file.First().SaveAs(path);
                //ds.ReadXml(path);
                ds.ReadXml(path);
                ds.Tables[0].TableName = "Trade.tmpClosePriceData";


                foreach (DataTable dt in ds.Tables)
                {
                    BulkCopy(dt);
                }

                //var invalidInvestor = BulkCopy(ds.Tables[0]);

                return Json(new { data = ds.Tables[0].Rows[0][4].ToString(), success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { data = "failed", errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetddlStockExchange()
        {
            var data = DropDown.ddlStockExchange();
            return Json(new { data = data, success = true }, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Created by: Newaz Sharif
        /// Purpose : Make Bukl copy for Trade data
        /// </summary>
        /// <param name="dt"></param>
        /// 
        [CheckUserSessionAttribute]
        //[Authorize]
        public void BulkCopy(DataTable dt)
        {

            SqlCommand oCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);
            oCmd.Connection = sqlConn;
            //oCmd.CommandTimeout = sqlConn.ConnectionTimeout;

            //dt.TableName = "";
            try
            {
                using (oCmd)
                {
                    oCmd.CommandText = "DELETE FROM " + dt.TableName;
                    sqlConn.Open();
                    oCmd.ExecuteNonQuery();
                    sqlConn.Close();
                }
                //a = dt.Rows[0][4].ToString();           
                if (dt.Rows.Count > 0) // if Datatable filled with data
                {
                    // insert into temp table using sqlbulkcopy
                    DataTable dtCloned = dt.Clone();
                    dtCloned.Columns[0].DataType = typeof(object);
                    dtCloned.Columns[1].DataType = typeof(object);
                    dtCloned.Columns[2].DataType = typeof(object);
                    dtCloned.Columns[3].DataType = typeof(object);
                    dtCloned.Columns[4].DataType = typeof(object);
                    dtCloned.Columns[5].DataType = typeof(object);


                    dtCloned.Columns[6].DataType = typeof(object);
                    dtCloned.Columns[7].DataType = typeof(object);
                    dtCloned.Columns[8].DataType = typeof(object);
                    dtCloned.Columns[9].DataType = typeof(object);
                    dtCloned.Columns[10].DataType = typeof(object);
                    dtCloned.Columns[11].DataType = typeof(object);
                    dtCloned.Columns[12].DataType = typeof(object);
                    foreach (DataRow row in dt.Rows)
                    {
                        dtCloned.ImportRow(row);
                    }


                    using (SqlBulkCopy bulkcopy = new SqlBulkCopy(sqlConn))
                    {
                        bulkcopy.DestinationTableName = dtCloned.TableName;
                        bulkcopy.BatchSize = dtCloned.Rows.Count;

                        sqlConn.Open();
                        bulkcopy.WriteToServer(dtCloned);
                        bulkcopy.Close();
                        sqlConn.Close();
                    }

                }


            }
            catch (Exception ex)
            {
                throw;
            }
        }
        /// <summary>
        /// Created By : Newaz Sharif
        /// Purpose : Insert Trade data for database
        /// </summary>
        /// <param name="closingPrice"></param>
        /// <returns></returns>
        /// 

        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult ExecuteClosePrice(tblClosingPrice closingPrice)
        {
            ClosePriceFactory closePricefactory = new ClosePriceFactory();
            closingPrice.changed_user_id = User.Identity.GetUserId();
            closingPrice.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
            try
            {
                closePricefactory.ClosePriceExecute(closingPrice);
                return Json(new { data = "Successfully Saved Data", success = true });
            }
            catch (Exception ex)
            {
                return Json(ex.Message, JsonRequestBehavior.AllowGet);
            }

        }
        /// <summary>
        /// Created By : Newaz Sharif
        /// Purpose : check if given close price file already executed
        /// </summary>
        /// <param name="checkId"></param>
        /// <returns></returns>
        public JsonResult isFileAlreadyExecuted(int checkId)
        {
            ClosePriceFactory closePricefactory = new ClosePriceFactory();
            bool isExecuted = false;
            double date = closePricefactory.GetAll()
                .Where(a => a.trans_dt == checkId)
                .Select(x => x.trans_dt).Count();
            if (date != 0)
            {
                isExecuted = true;
            }
            else
            {
                isExecuted = false;
            }
            return Json(new { executed = isExecuted, success = true }, JsonRequestBehavior.AllowGet);
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult UploadTradeFile(List<HttpPostedFileBase> file, decimal stock_exchange_id)
        {
            try
            {
                ConstantObjectValueFactory constantObjectValueFactory = new ConstantObjectValueFactory();
                string stock_exchange = constantObjectValueFactory.GetAll().Where(a => a.object_value_id == stock_exchange_id).Select(a => a.display_value).FirstOrDefault();
                if (stock_exchange.ToUpper() == "DHAKA STOCK EXCHANGE LIMITED")
                {
                    var link = "Tradefile";
                    string path = Path.Combine(Server.MapPath("~/App_Data"), link);
                    System.IO.File.Exists(path);
                    DataSet ds = new DataSet();
                    file.First().SaveAs(path);
                    //ds.ReadXml(path);
                    ds.ReadXml(path);
                    ds.Tables[0].TableName = "Trade.tmpTradeData";

                    List<psp_upload_trade_Result> invalidInvestors = BulkCopyForTrade(ds.Tables[0]);
                    //foreach (DataTable dt in ds.Tables)
                    //{
                    //    BulkCopyForTrade(dt);
                    //}
                    return Json(new { data = ds.Tables[0].Rows[0][10].ToString(), invalidInvestors = invalidInvestors, success = true }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { data = "failed", errorMessage = "CSE is not Available now!!" }, JsonRequestBehavior.AllowGet);
                }


            }
            catch (Exception ex)
            {
                return Json(new { data = "failed", errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public List<psp_upload_trade_Result> BulkCopyForTrade(DataTable dt)
        {

            SqlCommand oCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);
            oCmd.Connection = sqlConn;
            //oCmd.CommandTimeout = sqlConn.ConnectionTimeout;

            //dt.TableName = "";
            try
            {
                using (oCmd)
                {
                    oCmd.CommandText = "TRUNCATE TABLE " + dt.TableName;
                    sqlConn.Open();
                    oCmd.ExecuteNonQuery();
                    sqlConn.Close();
                }
                //a = dt.Rows[0][4].ToString();           
                if (dt.Rows.Count > 0) // if Datatable filled with data
                {
                    // insert into temp table using sqlbulkcopy
                    DataTable dtCloned = dt.Clone();
                    dtCloned.Columns[0].DataType = typeof(object);
                    dtCloned.Columns[1].DataType = typeof(object);
                    dtCloned.Columns[2].DataType = typeof(object);
                    dtCloned.Columns[3].DataType = typeof(object);
                    dtCloned.Columns[4].DataType = typeof(object);
                    dtCloned.Columns[5].DataType = typeof(object);
                    dtCloned.Columns[6].DataType = typeof(object);
                    dtCloned.Columns[7].DataType = typeof(object);
                    dtCloned.Columns[8].DataType = typeof(object);
                    dtCloned.Columns[9].DataType = typeof(object);
                    dtCloned.Columns[10].DataType = typeof(object);
                    dtCloned.Columns[11].DataType = typeof(object);
                    dtCloned.Columns[12].DataType = typeof(object);
                    dtCloned.Columns[13].DataType = typeof(object);
                    dtCloned.Columns[14].DataType = typeof(object);
                    dtCloned.Columns[15].DataType = typeof(object);
                    dtCloned.Columns[16].DataType = typeof(object);
                    dtCloned.Columns[17].DataType = typeof(object);
                    dtCloned.Columns[18].DataType = typeof(object);
                    dtCloned.Columns[19].DataType = typeof(object);
                    dtCloned.Columns[20].DataType = typeof(object);
                    dtCloned.Columns[21].DataType = typeof(object);
                    dtCloned.Columns[22].DataType = typeof(object);
                    dtCloned.Columns[23].DataType = typeof(object);

                    foreach (DataRow row in dt.Rows)
                    {
                        dtCloned.ImportRow(row);
                    }

                    using (SqlBulkCopy bulkcopy = new SqlBulkCopy(sqlConn))
                    {
                        bulkcopy.DestinationTableName = dtCloned.TableName;
                        bulkcopy.BatchSize = dtCloned.Rows.Count;

                        sqlConn.Open();
                        bulkcopy.WriteToServer(dtCloned);
                        bulkcopy.Close();
                        sqlConn.Close();
                    }

                    TmpTradeFactory tmpTradeFactory = new TmpTradeFactory();
                    List<psp_upload_trade_Result> errorList = new List<psp_upload_trade_Result>();
                    errorList = tmpTradeFactory.getInvestorError();
                    if (errorList.Count > 1)
                    {
                        tmpTradeFactory.Truncate("Trade.tmpTradeData ");
                    }

                    else if (errorList.Count == 0)
                        errorList = null;
                    return errorList;

                }
                return null;

            }


            catch
            {
                throw;
            }
        }



        public JsonResult isTradeUploaded()
        {
            TmpTradeFactory tempTradeFactory = new TmpTradeFactory();
            int rowcount = 0;
            try
            {
                rowcount = tempTradeFactory.GetAll().Count();
                if (rowcount > 0)
                {
                    return Json(true, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(false, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult LoadTradeList(decimal stock_exchange_id)
        {
            TmpTradeFactory tempTradeFactory = new TmpTradeFactory();
            ConstantObjectValueFactory conFactory = new ConstantObjectValueFactory();
            string stock_exchange_value = conFactory.GetAll().Where(a => a.object_value_id == stock_exchange_id).Select(a => a.display_value).FirstOrDefault();
            if (stock_exchange_value.ToUpper() == "DHAKA STOCK EXCHANGE LIMITED")
            {
                try
                {
                    var data = tempTradeFactory.GetAll().ToList();
                    return Json(new { data = data, success = true }, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    return Json(new { data = ex.Message }, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return null;
            }



        }

        public JsonResult isTradeFileAlreadyExecuted(decimal checkId)
        {
            tradeFactory = new TradeFactory();
            bool isExecuted = false;
            int date = tradeFactory.GetAll()
                .Where(a => a.Date == checkId)
                .Select(x => x.Date).Count();
            if (date != 0)
            {
                isExecuted = true;
            }
            else
            {
                isExecuted = false;
            }
            return Json(new { executed = isExecuted, success = true }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult ExecuteTradeFile(tblTradeData tradeData)
        {
            tradeFactory = new TradeFactory();
            tradeData.changed_user_id = User.Identity.GetUserId();
            tradeData.membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
            try
            {
                tradeFactory.ExecuteTradeFile(tradeData);
                return Json(new { data = "Successfully Executed", success = true });
            }
            catch (System.Data.Entity.Core.EntityCommandExecutionException sqx)
            {
                return Json(sqx.InnerException.Message, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

                return Json(ex.Message, JsonRequestBehavior.AllowGet);
            }

        }
        public JsonResult GetTradeFileDate()
        {
            TmpTradeFactory tmpTradeFactory = new TmpTradeFactory();
            try
            {
                var data = tmpTradeFactory.GetAll().Select(a => a.Date).FirstOrDefault();
                return Json(new { data = data, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(ex.Message);
            }



        }
        public JsonResult CheckInvestor(string investor_code)
        {
            InvestorFactory investorFactory = new InvestorFactory();
            var investor = CommonUtility.getInvestorInfoById(investor_code);
            string data = "";

            if (investor == null)
            {
                data = "Not Exists!!!";
            }
            else
            {
                if (investor.active_status.ToUpper() == "ACTIVE")
                {
                    data = "Available";
                }
                else
                    data = "Investor code not active!!!";
            }
            //else
            //    data = "Not Exists!!!";


            return Json(data, JsonRequestBehavior.AllowGet);
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult UpdateInvestorTrade(int id, string client_code)
        {
            TmpTradeFactory tmpTrade = new TmpTradeFactory();
            InvestorFactory investorFactory = new InvestorFactory();

            tmpTradeData tmpTradedata = tmpTrade.GetById(Convert.ToDecimal(id));
            try
            {
                tmpTradedata.ClientCode = client_code;
                tmpTradedata.BoId = investorFactory.GetAll().Where(x => x.client_id == client_code).Select(x => x.bo_code).FirstOrDefault();
                tmpTrade.Edit(tmpTradedata);
                tmpTrade.Save();
                return Json("Edited Successfully", JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

                return Json(ex.Message, JsonRequestBehavior.AllowGet);
            }

        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult ReverseTradeFile(decimal date, decimal stock_exchange_id)
        {
            tradeFactory = new TradeFactory();

            try
            {
                tradeFactory.ReveseTradeFile(date, stock_exchange_id, SessionManger.BrokerOfLoggedInUser(Session).membership_id, User.Identity.GetUserId());
                return Json("Trade Reversed Successfully!!!", JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(ex.Message, JsonRequestBehavior.AllowGet);
            }

        }


    }
}