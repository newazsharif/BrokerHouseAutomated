using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.Security.Factories;
using Escrow.Security.Models;
using Escrow.Utility.Interfaces;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Escrow.BOAS.InstrumentManagement.Factories;
using Escrow.BOAS.Trade.Models;
using Escrow.BOAS.Trade.Factories;
using Microsoft.AspNet.Identity;
using Escrow.BOAS.Web.Models;
using Microsoft.AspNet.Identity.EntityFramework;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.BOAS.BrokerManagement.Factories;
using System.Data.OleDb;
using System.Transactions;
using System.Threading.Tasks;

namespace Escrow.BOAS.Web.Areas.SystemManagement.Controllers
{
    public class BrokerController : Controller
    {
        // GET: SystemManagement/Broker
        private IGenericFactory<tblBrokerInformation> brokerFactory;
        private IGenericFactory<Escrow.BOAS.BrokerManagement.Models.tblBrokerImage> brokerImageFactory;


        public BrokerController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public BrokerController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }
        public UserManager<ApplicationUser> UserManager { get; private set; }

        /// <summary>
        /// Author  : SHOHID
        /// Purpose : Setup new broker view
        /// </summary>
        /// <returns>view</returns>
        public ActionResult NewBroker()
        {
            return View();
        }

        #region
        public JsonResult GetddlStatus()
        {
            var data = DropDown.ddlActiveStatus();
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlStockExchange()
        {
            var data = DropDown.ddlStockExchange();
            return Json(new { data = data, success = true }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        /// <summary>
        /// Author  : SHOHID
        /// Purpose : Checking broker is available or not
        /// </summary>
        /// <param name="membership_id"></param>
        /// <returns></returns>
        public JsonResult CheckBroker(decimal membership_id)
        {
            //decimal m_id = Decimal.Parse(membership_id);
            brokerFactory = new BrokerInformationFactory();
            decimal broker = brokerFactory.GetAll().Where(a => a.membership_id == membership_id).Select(x => x.membership_id).FirstOrDefault();
            string data = "";
            if (broker == membership_id)
            {
                data = "NoAvailable";
            }

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public async Task<ActionResult> CheckUser(AspNetUser model)
        {
            if (ModelState.IsValid)
            {
                //Need to remove after code complete
                //brokerUserFactory = new BrokerUserFactory();
                //brokerUserFactory.Delete(bu => bu.AspNetUser.UserName == model.UserName);
                //brokerUserFactory.Save();

                var results = await UserManager.FindByNameAsync(model.UserName);
                if (results != null)
                {
                    return Json(new { success = false, errorMessage = "This User Name Already Exists" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { success = true, successMessage = "Username Available" });
                }
            }
            else
            {                
                return Json(new { success = false, errorMessage = "Model is not Valid" }, JsonRequestBehavior.AllowGet);

            }
        }

        /// <summary>
        /// Author  : SHOHID
        /// Purpose : Save new Broker
        /// </summary>
        /// <param name="broker"></param>
        /// <param name="Imagestatus"></param>
        /// <param name="file"></param>
        /// <returns></returns>
        public JsonResult AddNewBroker(tblBrokerInformation broker,string Imagestatus, List<HttpPostedFileBase> file)
        {
            brokerFactory = new BrokerInformationFactory();
            brokerImageFactory = new BrokerImagesFactory();
           // tblBrokerInformation broker_info = new tblBrokerInformation();
            Escrow.BOAS.BrokerManagement.Models.tblBrokerImage broker_image = new Escrow.BOAS.BrokerManagement.Models.tblBrokerImage();
            //using (TransactionScope scope = new TransactionScope())
            //{
                try
                {
                    //broker_info = broker;
                    broker.changed_date = DateTime.Now;
                    broker.changed_user_id = User.Identity.GetUserId();
                    broker.is_dirty = false;

                    broker_image.membership_id = broker.membership_id;
                    broker_image.active_status_id = broker.active_status_id;
                    if (broker.changed_user_id == null)
                    {
                        broker.changed_user_id = "1bf1c0e7-fa04-4266-9ce4-d20d6516737a";
                        broker_image.changed_user_id = "1bf1c0e7-fa04-4266-9ce4-d20d6516737a";
                    }
                    else
                    {
                        broker_image.changed_user_id = broker.changed_user_id;
                    }

                    broker_image.changed_date = broker.changed_date;
                    broker_image.is_dirty = 0;
                    if (file != null)
                    {
                        if (Imagestatus == "l")
                        {
                            byte[] logo = new byte[file.First().ContentLength];
                            file.First().InputStream.Read(logo, 0, file.First().ContentLength);
                            broker_image.report_logo = ImageConvert.ResizeImageFile(logo, 300);
                            broker_image.report_header_image = null;
                        }
                        else if (Imagestatus == "h")
                        {
                            byte[] header_image = new byte[file.First().ContentLength];
                            file.First().InputStream.Read(header_image, 0, file.First().ContentLength);
                            broker_image.report_header_image = ImageConvert.ResizeImageFile(header_image, 300);
                            broker_image.report_logo = null;
                        }
                        else
                        {
                            //byte[] logo = new byte[file.First().ContentLength];
                            //file.First().InputStream.Read(logo, 0, file.First().ContentLength);
                            //broker_image.report_header_image = ImageConvert.ResizeImageFile(logo, 300);

                            //byte[] header_image = new byte[file.Skip(1).First().ContentLength];
                            //file.Skip(1).First().InputStream.Read(header_image, 0, file.Skip(1).First().ContentLength);
                            //broker_image.report_logo = ImageConvert.ResizeImageFile(header_image, 300);
                           

                            byte[] h = new byte[file.First().ContentLength];
                            file.Skip(1).First().InputStream.Read(h, 0, file.First().ContentLength);
                            broker_image.report_header_image = ImageConvert.ResizeImageFile(h, 300);

                            byte[] l = new byte[file.Skip(1).First().ContentLength];
                            file.First().InputStream.Read(l, 0, file.Skip(1).First().ContentLength);
                            broker_image.report_logo = ImageConvert.ResizeImageFile(l, 300);

                        }
                    }
                    else
                    {
                        broker_image.report_logo = null;
                        broker_image.report_header_image = null;
                    }

                    brokerFactory.Add(broker);
                    brokerImageFactory.Add(broker_image);
                    brokerImageFactory.Save(broker_image);
                    brokerFactory.Save(broker);
                   // scope.Complete();
                    return Json(new { success = true }, JsonRequestBehavior.AllowGet);
                    
                }
                catch (Exception ex)
                {
                    //brokerImageFactory.
                    //System.Transactions.Transaction.Current.Rollback();
                    return Json(new { data = "failed", errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
                }
            //    finally
            //    {
            //        scope.Dispose();
            //    }
            //}          
        }

        /// <summary>
        /// Author  : SHOHID
        /// Purpose : Read Cash limit data from xml file
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public JsonResult UploadCashLimitFile(List<HttpPostedFileBase> file, decimal membership_id)
        {
            try
            {
                var link = "CashLimitfile";
                string path = Path.Combine(Server.MapPath("~/App_Data"), link);
                System.IO.File.Exists(path);
                DataSet ds = new DataSet();
                file.First().SaveAs(path);
                //ds.ReadXml(path);
                ds.ReadXml(path);
                ds.Tables[0].TableName = "broker.tblInitialClints";
                ds.Tables[0].Columns.Add("membership_id", typeof(object));
                ds.Tables[1].TableName = "broker.tblInitialRegister";
                ds.Tables[1].Columns.Add("membership_id", typeof(object));
                ds.Tables[2].TableName = "broker.tblInitialCashLimits";
                ds.Tables[2].Columns.Add("membership_id", typeof(object));

                foreach (DataTable dt in ds.Tables)
                {
                    if(dt.Columns.Contains("ProcessingMode"))
                    {
                        BulkCopyForClintsAndCash(dt, membership_id);
                    }
                    else if (dt.Columns.Contains("Name"))
                    {
                        BulkCopyForRegister(dt, membership_id);
                    }
                    else if (dt.Columns.Contains("Cash"))
                    {
                        BulkCopyForClintsAndCash(dt, membership_id);
                    }
                }

                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { data = "failed", errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Author  : SHOHID
        /// Purpose : Bulk Copy of Cash limit file register table
        /// </summary>
        /// <param name="dt"></param>
        private void BulkCopyForRegister(DataTable dt, decimal membership_id)
        {
            SqlCommand oCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);
            oCmd.Connection = sqlConn;          
            try
            {
                //using (oCmd)
                //{
                //    oCmd.CommandText = "DELETE FROM " + dt.TableName;
                //    sqlConn.Open();
                //    oCmd.ExecuteNonQuery();
                //    sqlConn.Close();
                //}
                if (dt.Rows.Count > 0) // if Datatable filled with data
                {
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
                    
                    foreach (DataRow row in dt.Rows)
                    {
                        row["membership_id"] = membership_id;
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
        /// Author  : SHOHID
        /// Purpose : Bulk Copy of Clints And Cash Table
        /// </summary>
        /// <param name="dt"></param>
        private void BulkCopyForClintsAndCash(DataTable dt, decimal membership_id)
        {
            SqlCommand oCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);
            oCmd.Connection = sqlConn;
            //oCmd.CommandTimeout = sqlConn.ConnectionTimeout;

            //dt.TableName = "";
            try
            {
                //using (oCmd)
                //{
                //    oCmd.CommandText = "DELETE FROM " + dt.TableName;
                //    sqlConn.Open();
                //    oCmd.ExecuteNonQuery();
                //    sqlConn.Close();
                //}
                if (dt.Rows.Count > 0) // if Datatable filled with data
                {
                    DataTable dtCloned = dt.Clone();
                    dtCloned.Columns[0].DataType = typeof(object);
                    dtCloned.Columns[1].DataType = typeof(object);
                    dtCloned.Columns[2].DataType = typeof(object);

              

                    foreach (DataRow row in dt.Rows)
                    {
                        row["membership_id"] = membership_id;
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
        /// Author  : SHOHID
        /// Purpose : Read Share Limit data from xml file
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public JsonResult UploadShareLimitFile(List<HttpPostedFileBase> file, decimal membership_id)
        {
            try
            {
                var link = "ShareLimitfile";
                string path = Path.Combine(Server.MapPath("~/App_Data"), link);
                System.IO.File.Exists(path);
                DataSet ds = new DataSet();
                file.First().SaveAs(path);
                //ds.ReadXml(path);
                ds.ReadXml(path);
                ds.Tables[0].TableName = "broker.tblInitialPositions";
                ds.Tables[0].Columns.Add("membership_id", typeof(object));
                ds.Tables[1].TableName = "broker.tblInitialShareLimits";
                ds.Tables[1].Columns.Add("membership_id", typeof(object));


                foreach (DataTable dt in ds.Tables)
                {
                    if(dt.Columns.Contains("ProcessingMode"))
                    {
                        BulkCopyForPosition(dt,membership_id);
                    }
                    else
                    {
                        BulkCopyForShareLimit(dt, membership_id);
                    }
                }

                return Json(new {success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { data = "failed", errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Author : SHOHID
        /// Purpose: Bulk Copy of Share limit table
        /// </summary>
        /// <param name="dt"></param>
        private void BulkCopyForShareLimit(DataTable dt, decimal membership_id)
        {
            SqlCommand oCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);
            oCmd.Connection = sqlConn;
            //oCmd.CommandTimeout = sqlConn.ConnectionTimeout;

            //dt.TableName = "";
            try
            {
                //using (oCmd)
                //{
                //    oCmd.CommandText = "DELETE FROM " + dt.TableName;
                //    sqlConn.Open();
                //    oCmd.ExecuteNonQuery();
                //    sqlConn.Close();
                //}
                if (dt.Rows.Count > 0) // if Datatable filled with data
                {
                    DataTable dtCloned = dt.Clone();
                    dtCloned.Columns[0].DataType = typeof(object);
                    dtCloned.Columns[1].DataType = typeof(object);
                    dtCloned.Columns[2].DataType = typeof(object);
                    dtCloned.Columns[3].DataType = typeof(object);
                    dtCloned.Columns[4].DataType = typeof(object);
                    dtCloned.Columns[5].DataType = typeof(object);
                    dtCloned.Columns[6].DataType = typeof(object);

                    foreach (DataRow row in dt.Rows)
                    {
                        row["membership_id"] = membership_id;
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
        /// Author  : SHoHID
        /// Purpose : Bulk Copy of Position table
        /// </summary>
        /// <param name="dt"></param>
        private void BulkCopyForPosition(DataTable dt, decimal membership_id)
        {
            SqlCommand oCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);
            oCmd.Connection = sqlConn;
            //oCmd.CommandTimeout = sqlConn.ConnectionTimeout;

            //dt.TableName = "";
            try
            {
                //using (oCmd)
                //{
                //    oCmd.CommandText = "DELETE FROM " + dt.TableName;
                //    sqlConn.Open();
                //    oCmd.ExecuteNonQuery();
                //    sqlConn.Close();
                //}            
                if (dt.Rows.Count > 0) // if Datatable filled with data
                {                  
                    DataTable dtCloned = dt.Clone();
                    dtCloned.Columns[0].DataType = typeof(object);
                    dtCloned.Columns[1].DataType = typeof(object);
                   
                    foreach (DataRow row in dt.Rows)
                    {
                        row["membership_id"] = membership_id;
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
        /// Author  : SHOHID
        /// Purpose : Read Price file data from xml
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public JsonResult UploadPriceFile(List<HttpPostedFileBase> file, decimal membership_id)
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
                ds.Tables[0].TableName = "broker.tblInitialClosePrice";
                ds.Tables[0].Columns.Add("membership_id", typeof(object));

                foreach (DataTable dt in ds.Tables)
                {
                   // dt.Columns.Add("membership_id", membership_id);
                    BulkCopy(dt, membership_id);
                }         

                return Json(new { data = ds.Tables[0].Rows[0][4].ToString(), success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { data = "failed", errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Author  : SHOHID
        /// Purpose : Read trade file data from xml file
        /// </summary>
        /// <param name="file"></param>
        /// <param name="stock_exchange_id"></param>
        /// <returns></returns>
        public JsonResult UploadTradeFile(List<HttpPostedFileBase> file, decimal stock_exchange_id, decimal membership_id)
        {
            try
            {
                ConstantObjectValueFactory constantObjectValueFactory = new ConstantObjectValueFactory();
                string stock_exchange = constantObjectValueFactory.GetAll().Where(a => a.object_value_id == stock_exchange_id).Select(a => a.display_value).FirstOrDefault();
                if (stock_exchange == "DHAKA STOCK EXCHANGE LIMITED")
                {
                    var link = "Tradefile";
                    string path = Path.Combine(Server.MapPath("~/App_Data"), link);
                    System.IO.File.Exists(path);
                    DataSet ds = new DataSet();
                    file.First().SaveAs(path);
                    //ds.ReadXml(path);
                    ds.ReadXml(path);
                    ds.Tables[0].TableName = "broker.tblInitialTrade";
                    ds.Tables[0].Columns.Add("membership_id", typeof(object));

                    List<psp_upload_initial_trade_Result> invalidInvestors = BulkCopyForTrade(ds.Tables[0],membership_id);
                
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
        
        /// <summary>
        /// Author  : SHOHID
        /// Purpose : Read Client Receivable Payable data from excel file
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public JsonResult UploadClientRecPayFile(List<HttpPostedFileBase> file)
        {
            try
            {
                var link = "ClientRecPayfile";
                string path = Path.Combine(Server.MapPath("~/App_Data"), link);
                System.IO.File.Exists(path);
                DataSet ds = new DataSet();
                file.First().SaveAs(path);

                SqlConnection sqlConn = new SqlConnection();
                sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);
                string conString = String.Format(@"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Excel 12.0 Xml;HDR=YES;IMEX=1;TypeGuessRows=0;ImportMixedTypes=Text;Jet OLEDB:Max Buffer Size=256;");

                using (OleDbConnection excel_con = new OleDbConnection(conString))
                {
                    excel_con.Open();
                    
                    DataTable dtExcelData = new DataTable();

                    using (OleDbCommand cmd = new OleDbCommand("Select * from [Sheet1$]", excel_con))
                    {                       
                        using (OleDbDataReader dReader = cmd.ExecuteReader())
                        {
                            using (SqlBulkCopy sqlBulk = new SqlBulkCopy(sqlConn))
                            {
                                sqlConn.Open();
                                //Give your Destination table name 
                                sqlBulk.DestinationTableName = "broker.tblInitialClientReceivablePayable";
                                sqlBulk.WriteToServer(dReader);
                                sqlConn.Close();
                            }
                        }
                    }                   
                }

                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { data = "failed", errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Author  : SHOHID
        /// Purpose : Bulk Copy of Close price table
        /// </summary>
        /// <param name="dt"></param>
        public void BulkCopy(DataTable dt, decimal membership_id)
        {

            SqlCommand oCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);
            oCmd.Connection = sqlConn;
            //oCmd.CommandTimeout = sqlConn.ConnectionTimeout;

            //dt.TableName = "";
            try
            {
                //using (oCmd)
                //{
                //    oCmd.CommandText = "DELETE FROM " + dt.TableName;
                //    sqlConn.Open();
                //    oCmd.ExecuteNonQuery();
                //    sqlConn.Close();
                //}
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
                    //dtCloned.Columns[13].DefaultValue = membership_id;
                    foreach (DataRow row in dt.Rows)
                    {
                        
                        row["membership_id"] = membership_id;
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
        /// Author  : SHOHID
        /// Purpose : Bulk Copy of Trade data
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        public List<psp_upload_initial_trade_Result> BulkCopyForTrade(DataTable dt, decimal membership_id)
        {

            SqlCommand oCmd = new SqlCommand();
            SqlConnection sqlConn = new SqlConnection();
            sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString);
            oCmd.Connection = sqlConn;
            
            try
            {
                //using (oCmd)
                //{
                //    oCmd.CommandText = "TRUNCATE TABLE " + dt.TableName;
                //    sqlConn.Open();
                //    oCmd.ExecuteNonQuery();
                //    sqlConn.Close();
                //}               
                if (dt.Rows.Count > 0) // if Datatable filled with data
                {                   
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
                        row["membership_id"] = membership_id;
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

                    BrokerInitialTradeFactory initialTradeFactory = new BrokerInitialTradeFactory();
                    List<psp_upload_initial_trade_Result> errorList = new List<psp_upload_initial_trade_Result>();
                    errorList = initialTradeFactory.getInvestorError();
                    if (errorList.Count > 1)
                    {
                        //initialTradeFactory.Truncate("broker.tblInitialTrade");
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
    }
}