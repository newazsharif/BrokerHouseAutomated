using Escrow.BOAS.Service.Factories;
using Escrow.BOAS.Service.Models;
using Escrow.BOAS.Web.Utility;
using Escrow.Security.Factories;
using Escrow.Security.Models;
using Escrow.Service.Models;
using Escrow.Service.Utility;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
//using Escrow.BOAS.Web;

namespace Escrow.Service.Controllers
{
   // [Authorize]
    public class ReportController : ApiController
    {

        public ReportController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ReportController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;

        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region Global Variable

        private IReadOnlyFactory<tblBrokerInformation> brokerFactory;
        private IGenericFactory<tblPlaceOrder> placeOrderFactory;

        #endregion

        [HttpGet]
        public HttpResponseMessage ViewReport(string client_id, string Broker, string report_id, string date)
        {
            try
            {
                byte[] report = SaveReport(report_id, client_id, date, date, Broker);

                HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
                response.Content = new ByteArrayContent(report);
                response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                return response;
            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.ExpectationFailed, ex.Message);
            }
        }


        public byte[] SaveReport(string id, string to, string FromDate, string ToDate, string BrokerName)
        {

            ReportViewer reportViewer = new ReportViewer();
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

            reportViewer.ServerReport.ReportServerUrl = new Uri(ConfigManager.report_server_url);
            reportViewer.ServerReport.ReportPath =ConfigManager.report_path + id;
            reportViewer.ServerReport.SetParameters(GetParametersServer(id, to, FromDate, ToDate, BrokerName));

        //    string outputPath = Escrow.BOAS.Utility.ConfigManager.auto_generated_report_path + to + "-" + id + ".pdf";

            string mimeType;
            string encoding;
            string extension;
            string[] streams;
            Warning[] warnings;
            byte[] pdfBytes = reportViewer.ServerReport.Render("PDF", string.Empty, out mimeType, out encoding, out extension, out streams, out warnings);


            // save the file
            //using (FileStream fs = new FileStream(outputPath, FileMode.Create))
            //{
            //    fs.Write(pdfBytes, 0, pdfBytes.Length);
            //    fs.Close();
            //}

            return pdfBytes;
        }

        private ReportParameterCollection GetParametersServer(string id, string client_id, string FromDate, string ToDate, string BrokerName)
        {
            if (id == "rptClientLedger" || id == "rptInstrumentLedgerClientWise" || id == "rptTrdConfirmationStatementClientWise")
            {
                ReportParameterCollection reportParameters = new ReportParameterCollection();
                brokerFactory = new BrokerFactory();

                string cname = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.Name).FirstOrDefault().ToString();
                string add = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.mail_address).FirstOrDefault().ToString();
                string mid = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault().ToString();
                string user = User.Identity.GetUserId().ToString();
                //DateTime processDate = dayProcessFactory.GetAll().OrderByDescending(a => a.process_date).Select(a => a.DimDate.Date).FirstOrDefault() ?? DateTime.Now;
                //string dt = processDate.ToString("MM/dd/yyyy");
                reportParameters.Add(new ReportParameter("rptCompanyName", cname));
                reportParameters.Add(new ReportParameter("rptCompanyAddress", add));
                reportParameters.Add(new ReportParameter("membership_id", mid));
                reportParameters.Add(new ReportParameter("user_id", user));
                reportParameters.Add(new ReportParameter("client_id", client_id));
                reportParameters.Add(new ReportParameter("from_dt", FromDate));
                reportParameters.Add(new ReportParameter("to_dt", ToDate));

                return reportParameters;
            }
            else
            {
                ReportParameterCollection reportParameters = new ReportParameterCollection();
                brokerFactory = new BrokerFactory();
                string cname = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.Name).FirstOrDefault().ToString();
                string add = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.mail_address).FirstOrDefault().ToString();
                string mid = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault().ToString();
                string user = User.Identity.GetUserId().ToString();
               // DateTime dt = Convert.ToDateTime(ToDate);
                string[] words = ToDate.Split('/');
                string dt = words[2] + "-" + words[1] + "-" + words[0];
                reportParameters.Add(new ReportParameter("rptCompanyName", cname));
                reportParameters.Add(new ReportParameter("rptCompanyAddress", add));
                reportParameters.Add(new ReportParameter("membership_id", mid));
                reportParameters.Add(new ReportParameter("user_id", user));
                reportParameters.Add(new ReportParameter("client_id", client_id));
                reportParameters.Add(new ReportParameter("report_date", dt));
                return reportParameters;
            }

        }

    }
}