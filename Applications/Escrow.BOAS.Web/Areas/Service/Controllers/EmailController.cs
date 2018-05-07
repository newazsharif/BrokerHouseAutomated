using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.BOAS.InvestorManagement;
//using Escrow.BOAS.Configuration.Factories;
using Escrow.Utility.Interfaces;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Data;
using Escrow.BOAS.Utility;
using System.Configuration;
using Escrow.BOAS.Transaction.Factories;
using Escrow.BOAS.InvestorManagement.Interfaces;
using Escrow.BOAS.BrokerManagement.Factories;
using Escrow.BOAS.InvestorManagement.Factories;
using System.Data.SqlClient;
using Microsoft.AspNet.Identity;
using Escrow.BOAS.Web.Models;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Reporting.WebForms;
//using tblConstantObject = Escrow.BOAS.Configuration.Models.tblConstantObject;
using System.Collections;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Xml;
using System.Net.Sockets;
using Escrow.BOAS.Web.Utility;
using System.Threading.Tasks;
using System.Threading;
using System.ComponentModel;
using System.Web.Helpers;


namespace Escrow.BOAS.Web.Areas.Service.Controllers
{
    public class EmailController : Controller
    {
        #region global variables

        private IGenericFactory<tblInvestor> portStatementFactory;
        private IPortStatementFactory spPortStateFactory;

        #endregion

        private IGenericFactory<tblBrokerBranch> BrokerBranchFactory;
        private IGenericFactory<tblTrader> TraderFactory;
        private IGenericFactory<Escrow.BOAS.Configuration.Models.tblConstantObjectValue> ConstantObjectValueFactory;
        private Escrow.BOAS.InvestorManagement.Factories.InvestorFactory investorFactory;

        public EmailController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public EmailController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }
        // GET: Service/Email

        [CheckUserSessionAttribute]
        public ActionResult Email()
        {
            return View();
        }

        public JsonResult GetAllBranch()
        {
            BrokerBranchFactory = new BrokerBranchFactory();
            var result = BrokerBranchFactory.GetAll().Select(a => new
            {
                a.id,
                a.name,
                selected = false
            }).ToList();
            return Json(new { success = true, result }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetAllTrader()
        {
            TraderFactory = new TraderFactory();
            var result = TraderFactory.GetAll().Select(a => new
            {
                a.id,
                a.trader_code,
                selected = false
            }).ToList();
            return Json(new { success = true, result }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetAllSubAccount()
        {
            ConstantObjectValueFactory = new Escrow.BOAS.Configuration.Factories.ConstantObjectValueFactory();
            var result =
                ConstantObjectValueFactory.GetAll()
                    .Where(a => a.tblConstantObject.object_name.ToUpper() == "INVESTOR_SUB_ACC")
                    .Select(a => new
                    {
                        a.display_value,
                        a.object_value_id,
                        selected = false
                    }).ToList();

            return Json(new { success = true, result }, JsonRequestBehavior.AllowGet);
        }

         [CheckUserSessionAttribute]
        public JsonResult SearchInvestor(decimal[] branches, decimal[] traders, decimal[] subAccs, string investors)
        {
            investorFactory = new Escrow.BOAS.InvestorManagement.Factories.InvestorFactory();

            try
            {
                var allInvestors = investorFactory.GetAll().Where(a => a.email_enabled == 1).Select(
                    a => new
                    {
                        a.client_id,
                        a.email_address,
                        a.branch_id,
                        a.trader_id,
                        a.sub_account_type_id,
                        selected = false
                    }).ToList();

                if (branches != null)
                {
                    if (branches.Length != 0)
                    {
                        var branchList = branches.ToList();
                        allInvestors = (from all in allInvestors
                                        join branch in branchList on all.branch_id equals branch
                                        select all).ToList();
                    }
                }

                if (traders != null)
                {
                    if (traders.Length != 0)
                    {
                        var traderList = traders.ToList();
                        allInvestors = (from all in allInvestors
                                        join trader in traderList on all.trader_id equals trader
                                        select all).ToList();
                    }
                }

                if (subAccs != null)
                {
                    if (subAccs.Length != 0)
                    {
                        var subAccList = subAccs.ToList();
                        allInvestors = (from all in allInvestors
                                        join subAcc in subAccList on all.sub_account_type_id equals subAcc
                                        select all).ToList();
                    }
                }
                if (investors != null)
                {
                    if (investors != "")
                    {
                        var investorByRange = investorFactory.GetInvestorByRange(investors).ToList();

                        allInvestors = (from all in allInvestors
                                        join investor in investorByRange on all.client_id equals investor
                                        select all).ToList();
                    }
                }

                var jsonResult = Json(new { result = allInvestors, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception exception)
            {
                return Json(new { result = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        [CheckUserSessionAttribute]
        [HttpPost]
        [ValidateInput(false)]
         public JsonResult SendMail(string[] SelectedInvestors, string[] MailAddress, string CC, string BCC, string SUB, string MSG, string PORT, string CL, string IL, string TCS, string FromDate, string ToDate, List<HttpPostedFileBase> file) //, string Port, string CL, string IL, string TCS
            {
                //string From_dt = Convert.ToDateTime(FromDate).ToString("yyyy-MM-dd");
                //string tt_dt = Convert.ToDateTime(ToDate).ToString("yyyy-MM-dd");
                string[] fd_parts = FromDate.Split('-');
                string From_dt = fd_parts[2] + "-" + fd_parts[1] + "-" + fd_parts[0];
            string[] dt_parts = ToDate.Split('/');
            string to_dt = dt_parts[2] + "-" + dt_parts[1] + "-" + dt_parts[0];
            string txtFileName = DateTime.Now.ToString("dd-MM-yyyy-HH-mm-ss");
            int mail_counter = 0;
            string path = "";
            if (file != null)
            {
                var link = "attachment.pdf";
                path = Path.Combine(Server.MapPath("~/App_Data"), link);
                System.IO.File.Exists(path);
                file.First().SaveAs(path);

            }

            Parallel.For(0, SelectedInvestors.Length, i => 
              {
                  if (PORT == "t")
                  {
                      SaveReport("rptClientPortfolioStatementAsOn", SelectedInvestors[i].ToString(), From_dt, to_dt);
                  }
                  if (CL == "t")
                  {
                      SaveReport("rptClientLedger", SelectedInvestors[i].ToString(), From_dt, to_dt);
                  }
                  if (IL == "t")
                  {
                      SaveReport("rptInstrumentLedgerClientWise", SelectedInvestors[i].ToString(), From_dt, to_dt);
                  }
                  if (TCS == "t")
                  {
                      SaveReport("rptTrdConfirmationStatementClientWise", SelectedInvestors[i].ToString(), From_dt, to_dt);
                  }
              });


            //for (int i = 0; i < 10; i++)
            //{               

                Parallel.For(0, SelectedInvestors.Length, j =>
                {

                int tryAgain = 5;
                bool failed = false;
                do
                {
                    try
                    {
                        failed = false;                   
                        string smtpAddress = ConfigManager.smtp_address;
                        int portNumber = 587;
                        bool enableSSL = true;                     
                        string emailFrom = ConfigManager.email_from;
                        string password = ConfigManager.email_password;

                        string report_path = ConfigManager.auto_generated_report_path;

                        using (MailMessage mail = new MailMessage())
                        {

                            mail.From = new MailAddress(emailFrom);
                            mail.To.Add(MailAddress[j].ToString());
                            if (CC != "" && CC != null)
                            {
                                mail.CC.Add(CC);
                            }
                            if (BCC != "" && BCC != null)
                            {
                                mail.Bcc.Add(BCC);
                            }
                            mail.Subject = SUB + "";
                            mail.Body = MSG + "";
                            mail.IsBodyHtml = true;
                            if (file != null)
                            {
                                mail.Attachments.Add(new Attachment(path));
                            }
                            if (PORT == "t")
                            {
                                mail.Attachments.Add(new Attachment(report_path + SelectedInvestors[j] + "-rptClientPortfolioStatementAsOn.pdf"));
                            }
                            if (CL == "t")
                            {
                                mail.Attachments.Add(new Attachment(report_path + SelectedInvestors[j] + "-rptClientLedger.pdf"));
                            }
                            if (IL == "t")
                            {
                                mail.Attachments.Add(new Attachment(report_path + SelectedInvestors[j] + "-rptInstrumentLedgerClientWise.pdf"));
                            }
                            if (TCS == "t")
                            {
                                mail.Attachments.Add(new Attachment(report_path + SelectedInvestors[j] + "-rptTrdConfirmationStatementClientWise.pdf"));
                            }

                            using (SmtpClient smtp = new SmtpClient(smtpAddress, portNumber))
                            {

                                smtp.UseDefaultCredentials = true;
                                smtp.Credentials = new NetworkCredential(emailFrom, password);
                                smtp.EnableSsl = enableSSL;
                                smtp.Timeout = Int32.Parse(ConfigManager.smtp_timeout); 
                                //smtp.SendCompleted += SendCompletedCallback;
                                smtp.Send(mail);
                                CreateLog(txtFileName, SelectedInvestors[j].ToString()+"-"+MailAddress[j].ToString() + "-Success");
                            }

                        }
                    }
                    catch (Exception ex)
                    {
                        failed = true;
                        tryAgain--;
                        Thread.Sleep(120000); // Sleep 2 min
                        if(tryAgain == 0)
                        {
                            CreateLog(txtFileName, SelectedInvestors[j].ToString() + "-" + MailAddress[j].ToString() + "-Failed");
                        }
                    }
                } while (failed && tryAgain != 0);

                if (mail_counter % 10 == 0 && mail_counter != 0)
                    {                      
                        Thread.Sleep(180000);
                    }
                });
         //   }

            ClearFolder(ConfigManager.auto_generated_report_path);

            var results = MailStatus(txtFileName);
            List<string> clients = new List<string>();
            List<string> emails = new List<string>();
            List<string> status = new List<string>();
           
             List<EmailVM> result = new List<EmailVM>();
            foreach (string st in results)
            {
                string[] parts = st.Split('-');
                EmailVM em = new EmailVM();
                em.client_id = parts[0];
                em.email_address = parts[1];
                em.status = parts[2];
                result.Add(em);
            }

            return Json(new { results = result, success = true }, JsonRequestBehavior.AllowGet);
        }

        public List<string> MailStatus(string filename)
        {
            string filePath = ConfigManager.mail_log_file_path;
            filePath = @filePath + filename;
           
            var result = System.IO.File.ReadAllLines(filePath).ToList();

            return result;           
        }

        public void CreateLog(string filename, string log)
        {         
            string filePath = ConfigManager.mail_log_file_path;
            filePath = @filePath + filename;
            FileInfo fi = new FileInfo(filePath);
            if(fi.Exists)
            {
                FileStream fs1 = new FileStream(filePath, FileMode.Append);
                StreamWriter sw1 = new StreamWriter(fs1); ;
                sw1.WriteLine(log);
                sw1.Close();
            }
            else
            {
                FileStream fs = new FileStream(filePath, FileMode.Create);
                StreamWriter sw = new StreamWriter(fs); ;
                sw.WriteLine(log);
                sw.Close();
            }               
          
        }

        private void ClearFolder(string FolderName)
        {
            DirectoryInfo dir = new DirectoryInfo(FolderName);

            foreach (FileInfo fi in dir.GetFiles())
            {
                fi.IsReadOnly = false;
                fi.Delete();
            }

            foreach (DirectoryInfo di in dir.GetDirectories())
            {
                ClearFolder(di.FullName);
                di.Delete();
            }
        }

        public void SaveReport(string id, string to, string FromDate, string ToDate)
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
            reportViewer.ServerReport.ReportPath = ConfigManager.report_path + id;
            reportViewer.ServerReport.SetParameters(GetParametersServer(id, to,FromDate, ToDate));

            string outputPath = ConfigManager.auto_generated_report_path + to + "-" + id + ".pdf";

            string mimeType;
            string encoding;
            string extension;
            string[] streams;
            Warning[] warnings;
            byte[] pdfBytes = reportViewer.ServerReport.Render("PDF", string.Empty, out mimeType, out encoding, out extension, out streams, out warnings);


            // save the file
            using (FileStream fs = new FileStream(outputPath, FileMode.Create))
            {
                fs.Write(pdfBytes, 0, pdfBytes.Length);
                fs.Close();
            }
        }

        private ReportParameterCollection GetParametersServer(string id, string client_id, string FromDate, string ToDate)
        {
            if (id == "rptClientLedger" || id == "rptInstrumentLedgerClientWise" || id == "rptTrdConfirmationStatementClientWise")
            {
                ReportParameterCollection reportParameters = new ReportParameterCollection();
                string cname = SessionManger.BrokerOfLoggedInUser(Session).Name;
                string add = SessionManger.BrokerOfLoggedInUser(Session).mail_address;
                string mid = SessionManger.BrokerOfLoggedInUser(Session).membership_id.ToString();
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
                string cname = SessionManger.BrokerOfLoggedInUser(Session).Name;
                string add = SessionManger.BrokerOfLoggedInUser(Session).mail_address;
                string mid = SessionManger.BrokerOfLoggedInUser(Session).membership_id.ToString();
                string user = User.Identity.GetUserId().ToString();
               // string dt = DateTime.Now.ToString("MM/dd/yyyy");
                reportParameters.Add(new ReportParameter("rptCompanyName", cname));
                reportParameters.Add(new ReportParameter("rptCompanyAddress", add));
                reportParameters.Add(new ReportParameter("membership_id", mid));
                reportParameters.Add(new ReportParameter("user_id", user));
                reportParameters.Add(new ReportParameter("client_id", client_id));
                reportParameters.Add(new ReportParameter("report_date", ToDate));
                return reportParameters;
            }

        }



        public byte[] GetReport(string id, string to, string FromDate, string ToDate)
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
            reportViewer.ServerReport.ReportPath = ConfigManager.report_path + id;
            reportViewer.ServerReport.SetParameters(GetParametersServer(id, to, FromDate, ToDate));

            string outputPath = ConfigManager.auto_generated_report_path + to + "-" + id + ".pdf";

            string mimeType;
            string encoding;
            string extension;
            string[] streams;
            Warning[] warnings;
            byte[] pdfBytes = reportViewer.ServerReport.Render("PDF", string.Empty, out mimeType, out encoding, out extension, out streams, out warnings);

            return pdfBytes;
            // save the file
            //using (FileStream fs = new FileStream(outputPath, FileMode.Create))
            //{
            //    fs.Write(pdfBytes, 0, pdfBytes.Length);
            //    fs.Close();
            //}
        }

    }
}