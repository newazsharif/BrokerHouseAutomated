using Escrow.BOAS.Web.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml;
using System.Web.Mvc.Html;
using Microsoft.Reporting.WebForms;
using System.IO;
using Escrow.BOAS.Configuration.Models;
using Escrow.BOAS.Configuration.Factories;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.BOAS.BrokerManagement.Factories;
using Escrow.Utility.Interfaces;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using Escrow.BOAS.Utility;
using System.Web.UI.WebControls;
using System.Security.Principal;
using System.Net;
using Escrow.BOAS.Web.Utility;


///=============================================================
///Created by: Asif
///Created date: 8/11/2015
///Reason: Report Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Reports.Controllers
{
    public class ReportController : Controller
    {
        // GET: Reports/Report

        public ReportController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ReportController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region global variables

        SqlConnection sqlConn;
        SqlCommand cmd;

        #endregion

        #region load dropdown

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
        /// Get all account type of investor
        /// </summary>
        /// <param></param>
        /// <returns>account list in json</returns>
        public JsonResult getddlInvestorAccType()
        {
            var investorAccountTypeList = DropDown.ddlAccountType();
            return Json(investorAccountTypeList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all sub account type of investor
        /// </summary>
        /// <param></param>
        /// <returns>sub account list in json</returns>
        public JsonResult getddlInvestorSubAccType()
        {
            var investorSubAccountTypeList = DropDown.ddlInvestorSubAcc();
            return Json(investorSubAccountTypeList, JsonRequestBehavior.AllowGet);
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


        public JsonResult getddlChargeTypelist()
        {
            var chargeTypeList = DropDown.ddlCharge();
            return Json(chargeTypeList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all transaction mode
        /// </summary>
        /// <param></param>
        /// <returns>transaction mode list in json</returns>
        //[Authorize]
        public JsonResult getTransactionModeDdlList()
        {
            var transactionModeList = DropDown.ddlTransactionMode();

            return Json(transactionModeList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Dynamic Report
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        public ActionResult DynamicReport()
        {
            return View();
        }

        /// <summary>
        /// Get report view from xml
        /// </summary>
        /// <param name="ViewId">Report ID</param>
        /// <returns>dynamic report view model in json or error message</returns>
        //[Authorize]
        public JsonResult getDynamicView(string ViewId)
        {
            try
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(Server.MapPath("~/ReportView.xml"));

                List<DynamicViewModel> dynamicViews = new List<DynamicViewModel>();
                XmlElement root = doc.DocumentElement;

                DynamicViewModel dynamicView;

                string header = "";
                string title = "";
                string reportName = "";
                string reportDataSource = "";
                string spName = "";

                foreach (XmlNode Viewnode in root.ChildNodes)
                {
                    if (Viewnode.Attributes["id"].Value.Equals(ViewId))
                    {
                        ViewBag.Title = Viewnode.Attributes["title"].Value;
                        header = Viewnode.Attributes["header"].Value;
                        title = Viewnode.Attributes["title"].Value;
                        reportName = Viewnode.Attributes["reportName"].Value;
                        reportDataSource = Viewnode.Attributes["reportDataSource"].Value;
                        spName = Viewnode.Attributes["spName"].Value;
                        foreach (XmlNode node in Viewnode)
                        {
                            if (node.Attributes["type"].Value == "daterange")
                            {
                                dynamicView = new DynamicViewModel();

                                dynamicView.field_id = "from_dt";
                                dynamicView.field_label = "From";
                                dynamicView.field_type = node.Attributes["type"].Value;
                                dynamicView.field_value = node.Attributes["value"].Value;
                                dynamicView.max = node.Attributes["max"].Value;
                                dynamicView.min = node.Attributes["min"].Value;
                                dynamicView.is_field_required = Convert.ToBoolean(node.Attributes["require"].Value);

                                dynamicViews.Add(dynamicView);

                                dynamicView = new DynamicViewModel();

                                dynamicView.field_id = "to_dt";
                                dynamicView.field_label = "To";
                                dynamicView.field_type = node.Attributes["type"].Value;
                                dynamicView.field_value = node.Attributes["value"].Value;
                                dynamicView.max = node.Attributes["max"].Value;
                                dynamicView.min = node.Attributes["min"].Value;
                                dynamicView.is_field_required = Convert.ToBoolean(node.Attributes["require"].Value);

                                dynamicViews.Add(dynamicView);
                            }
                            else
                            {
                                dynamicView = new DynamicViewModel();

                                dynamicView.field_id = node.Attributes["id"].Value;
                                dynamicView.field_label = node.Attributes["name"].Value;
                                dynamicView.field_type = node.Attributes["type"].Value;
                                dynamicView.field_value = node.Attributes["value"].Value;
                                dynamicView.max = node.Attributes["max"].Value;
                                dynamicView.min = node.Attributes["min"].Value;
                                dynamicView.is_field_required = Convert.ToBoolean(node.Attributes["require"].Value);

                                if (node.Attributes["type"].Value == "number")
                                {
                                    dynamicView.number_type = node.Attributes["numberType"].Value;
                                }

                                dynamicViews.Add(dynamicView);
                            }
                        }
                    }
                }

                return Json(new { dynamicView = dynamicViews, title = title, header = header, reportName = reportName, reportDataSource = reportDataSource, spName = spName, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Show Report
        /// </summary>
        /// <param name="field_id"> Name of the report and sp parameters with comma sperated </param>
        /// <param name="field_value">Value of the report and sp parameters with comma sperated</param>
        /// <param name="field_type">Type of the report and sp parameters with comma sperated</param>
        /// <param name="reportName">Name of the report with extension</param>
        /// <param name="reportDataSource">Name of the report data source</param>
        /// <param name="spName">Procedure name</param>
        /// <param name="rptTitle">Report Title</param>
        /// <returns>Show Report</returns>
        //[Authorize]
        public ActionResult showReport(string field_id, string field_value, string field_type, string reportName, string reportDataSource, string spName, string rptTitle)
        {
            LocalReport lr = new LocalReport();

            string[] params_id = field_id.Split(',');
            string[] params_value = field_value.Split(',');
            string[] params_type = field_type.Split(',');

            string path = Path.Combine(Server.MapPath("~/Reports"), reportName);
            if (System.IO.File.Exists(path))
            {
                lr.ReportPath = path;
            }



            IGenericFactory<tblEmployee> employeeFactory = new EmployeeInformationFactory();

            string connStr = ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString;
            sqlConn = new SqlConnection(connStr);

            DataTable dt = new DataTable();
            try
            {
                using (SqlCommand cmd = new SqlCommand(spName, sqlConn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@membership_id", SqlDbType.Decimal).Value = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                    for (int i = 1; i < params_id.Length; i++)
                    {
                        if (params_type[i] == "textbox")
                        {
                            if (string.IsNullOrEmpty(params_value[i]) || params_value[i] == "undefined" || params_value[i] == "")
                            {
                                cmd.Parameters.Add("@" + params_id[i], SqlDbType.VarChar).Value = DBNull.Value;
                            }
                            else
                            {
                                cmd.Parameters.Add("@" + params_id[i], SqlDbType.VarChar).Value = params_value[i];
                            }
                        }
                        else if (params_type[i] == "date" || params_type[i] == "daterange")
                        {
                            if (string.IsNullOrEmpty(params_value[i]) || params_value[i] == "undefined" || params_value[i] == "")
                            {
                                cmd.Parameters.Add("@" + params_id[i], SqlDbType.Decimal).Value = 0;
                            }
                            else
                            {
                                cmd.Parameters.Add("@" + params_id[i], SqlDbType.Decimal).Value = Convert.ToDecimal(params_value[i]);
                            }
                        }
                        else if (params_type[i] == "dropdown")
                        {
                            if (string.IsNullOrEmpty(params_value[i]) || params_value[i] == "undefined" || params_value[i] == "")
                            {
                                cmd.Parameters.Add("@" + params_id[i], SqlDbType.Decimal).Value = 0;
                            }
                            else
                            {
                                cmd.Parameters.Add("@" + params_id[i], SqlDbType.Decimal).Value = Convert.ToDecimal(params_value[i]);
                            }
                        }
                        else if (params_type[i] == "number")
                        {
                            if (string.IsNullOrEmpty(params_value[i]) || params_value[i] == "undefined" || params_value[i] == "")
                            {
                                cmd.Parameters.Add("@" + params_id[i], SqlDbType.Decimal).Value = 0;
                            }
                            else
                            {
                                cmd.Parameters.Add("@" + params_id[i], SqlDbType.Decimal).Value = Convert.ToDecimal(params_value[i]);
                            }
                        }
                    }

                    sqlConn.Open();

                    using (var da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            catch (Exception)
            {
            }
            finally
            {
                sqlConn.Close();
                sqlConn.Dispose();
            }

            var temp = employeeFactory.GetAll().ToList();

            ReportParameterCollection reportParameters = new ReportParameterCollection();

            reportParameters.Add(new ReportParameter("rptCompanyName", SessionManger.BrokerOfLoggedInUser(Session).Name + ""));
            reportParameters.Add(new ReportParameter("rptCompanyAddress", SessionManger.BrokerOfLoggedInUser(Session).mail_address + ""));
            reportParameters.Add(new ReportParameter("rptReportName", rptTitle + ""));

            for (int i = 1; i < params_id.Length; i++)
            {
                if (params_type[i] == "textbox")
                {
                    reportParameters.Add(new ReportParameter(params_id[i], params_value[i] + ""));
                }
                else if (params_type[i] == "date" || params_type[i] == "daterange")
                {
                    reportParameters.Add(new ReportParameter(params_id[i], DateTimeConfig.DateKeytoFullDateUK(params_value[i]) + ""));
                }
                else if (params_type[i] == "number")
                {
                    reportParameters.Add(new ReportParameter(params_id[i], params_value[i] + ""));
                }
            }

            lr.SetParameters(reportParameters);
            ReportDataSource rd;

            rd = new ReportDataSource(reportDataSource, dt);

            lr.DataSources.Add(rd);

            string reportType = "pdf";
            string mimeType;
            string encoding;
            string fileNameExtension;
            string deviceInfo =

            "<DeviceInfo>" +
            "  <OutputFormat>" + "pdf" + "</OutputFormat>" +
            "</DeviceInfo>";

            Warning[] warnings;
            string[] streams;
            byte[] renderedBytes;

            renderedBytes = lr.Render(
                reportType,
                deviceInfo,
                out mimeType,
                out encoding,
                out fileNameExtension,
                out streams,
                out warnings);

            return File(renderedBytes, mimeType);
        }
        [CheckUserSessionAttribute]
        public ActionResult ViewReport(string id)
        {

            ReportViewer reportViewer = new ReportViewer();
           // reportViewer.Reset(); 
            reportViewer.ProcessingMode = ProcessingMode.Remote;
            reportViewer.SizeToReportContent = true;
            
            //reportViewer.ShowPrintButton = true;
            string reportNetworkUserId = ConfigManager.report_network_user_id;
            string reportNetworkPass = ConfigManager.report_network_password;
            if (reportNetworkUserId != null)
            {
                IReportServerCredentials irsc = new CustomReportCredentials(reportNetworkUserId, reportNetworkPass, "");
                reportViewer.ServerReport.ReportServerCredentials = irsc;
            }

                       
            //reportViewer.Width = Unit.Pixel(400);
            //reportViewer.Height = Unit.Pixel(500);

            reportViewer.ServerReport.ReportServerUrl = new Uri(ConfigManager.report_server_url);
            reportViewer.ServerReport.ReportPath = ConfigManager.report_path + id ;
            reportViewer.ServerReport.SetParameters(GetParametersServer());

            
            ViewBag.ReportViewer = reportViewer;

            return View();
        }

        private ReportParameterCollection GetParametersServer()
        {
            ReportParameterCollection reportParameters = new ReportParameterCollection();

            reportParameters.Add(new ReportParameter("rptCompanyName", SessionManger.BrokerOfLoggedInUser(Session).Name));
            reportParameters.Add(new ReportParameter("rptCompanyAddress", SessionManger.BrokerOfLoggedInUser(Session).mail_address));
            reportParameters.Add(new ReportParameter("membership_id", SessionManger.BrokerOfLoggedInUser(Session).membership_id.ToString()));
            reportParameters.Add(new ReportParameter("user_id", User.Identity.GetUserId().ToString()));
            return reportParameters;
        }
    }

}