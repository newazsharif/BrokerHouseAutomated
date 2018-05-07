using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Xml.Linq;
using System.Xml.Schema;

namespace Escrow.Utility
{
    public class XMLManager
    {
        public string ValidateXmlWithXsd(string xmlString, string xsdFile)
        {
            Stream xmlStream = ConvertStringToStream(xmlString);
            XmlSchemaSet schemas = new XmlSchemaSet();
            string errorMessage = string.Empty;
            try
            {
                schemas.Add("", xsdFile);
                XDocument custOrdDoc = XDocument.Load(xmlStream);
                custOrdDoc.Validate(schemas, (o, err) =>
                {
                    errorMessage += err.Message + "\n\n";
                });
            }
            catch (Exception ex)
            {
                errorMessage += ex.Message;
            }


            return errorMessage.Trim();
        }
        public string ValidateXmlWithXsd(Stream xmlStream, string xsdFile)
        {
            XmlSchemaSet schemas = new XmlSchemaSet();
            string errorMessage = string.Empty;
            try
            {
                schemas.Add("", xsdFile);
                XDocument custOrdDoc = XDocument.Load(xmlStream);
                custOrdDoc.Validate(schemas, (o, err) =>
                {
                    errorMessage += err.Message + "\n\n";
                });
            }
            catch (Exception ex)
            {
                errorMessage += ex.Message;
            }


            return errorMessage.Trim();
        }

        public string ConvertToClientsXMLString(System.Data.DataSet ds, bool isMorning, bool isDeactivateAll)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(@"<?xml version=""1.0"" encoding=""utf-8""?>");
                sb.AppendLine();
                sb.AppendLine();
                if (isMorning == true)
                    sb.AppendLine(@"<Clients ProcessingMode=""BatchInsertOrUpdate"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" ");
                else sb.AppendLine(@"<Clients ProcessingMode=""BatchInsertOrUpdate"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" ");
                sb.AppendLine(@"xsi:noNamespaceSchemaLocation=""Flextrade-BOS-Clients.xsd"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">");
                sb.AppendLine();
                sb.AppendLine();
                if (isMorning == true && isDeactivateAll == true) sb.AppendLine(@"<DeactivateAllClients />");

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    if (row["investor_st"].ToString().Trim() == "1") GenerateRegister(row, sb);
                    if (row["investor_st"].ToString().Trim() == "2") GenerateSuspend(row, sb);
                    if (row["investor_st"].ToString().Trim() == "3") GenerateDeactivate(row, sb);
                }
                ConvertToLimitsXMLString(ds.Tables[1], sb);
                sb.AppendLine("</Clients>");
                return sb.ToString();
            }
            catch (Exception)
            {

                throw;
            }
        }
        private void ConvertToLimitsXMLString(DataTable dt, StringBuilder sb)
        {
            try
            {
                foreach (DataRow row in dt.Rows)
                {
                    sb.AppendLine("<Limits>");
                    sb.AppendLine("<ClientCode>" + row["ClientCode"].ToString().Trim() + "</ClientCode>");
                    sb.AppendLine("<Cash>" + row["Cash"].ToString().Trim() + "</Cash>");
                    if (row["acc_Type_S_Name"].ToString().Trim().ToLower() == "m" && Convert.ToDecimal(row["MarginRatio"].ToString().Trim()) != 0)
                        sb.AppendLine("<Margin  " + "MarginRatio=\"" + row["MarginRatio"].ToString() + "\"" + "/>");
                    else if (row["acc_Type_S_Name"].ToString().Trim().ToLower() == "m")
                        sb.AppendLine("<Margin/>");
                    if (Convert.ToDecimal(row["MaxCapitalBuy"].ToString().Trim()) != 0) sb.AppendLine("<MaxCapitalBuy>" + row["MaxCapitalBuy"].ToString().Trim() + "</MaxCapitalBuy>");
                    if (Convert.ToDecimal(row["MaxCapitalSell"].ToString().Trim()) != 0) sb.AppendLine("<MaxCapitalSell>" + row["MaxCapitalSell"].ToString().Trim() + "</MaxCapitalSell>");
                    if (Convert.ToDecimal(row["TotalTransaction"].ToString().Trim()) != 0) sb.AppendLine("<TotalTransaction>" + row["TotalTransaction"].ToString().Trim() + "</TotalTransaction>");
                    if (Convert.ToDecimal(row["NetTransaction"].ToString().Trim()) != 0) sb.AppendLine("<NetTransaction>" + row["NetTransaction"].ToString().Trim() + "</NetTransaction>");
                    sb.AppendLine("</Limits>");
                    sb.AppendLine();
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
        private void GenerateRegister(DataRow row, StringBuilder sb)
        {
            try
            {
                sb.AppendLine("<Register>");
                //sb.AppendLine("<BranchID>" + row["BranchID"].ToString().Trim() + "</BranchID>");
                sb.AppendLine("<ClientCode>" + row["ClientCode"].ToString().Trim() + "</ClientCode>");
                sb.AppendLine("<DealerID>" + row["DealerID"].ToString().Trim() + "</DealerID>");
                sb.AppendLine("<BOID>" + row["BOID"].ToString().Trim() + "</BOID>");
                sb.AppendLine("<WithNetAdjustment>" + row["WithNetAdjustment"].ToString().Trim() + "</WithNetAdjustment>");
                //sb.AppendLine("<Name>" + row["Name"].ToString().Trim() + "</Name>");
                sb.AppendLine("<Name>" + "<![CDATA[" + row["Name"].ToString().Trim() + "]]>" + "</Name>");
                sb.AppendLine("<ShortName>" + "<![CDATA[" + row["ShortName"].ToString().Trim() + "]]>" + "</ShortName>");
                sb.AppendLine("<Address>" + "<![CDATA[" + row["Address"].ToString().Trim() + "]]>" + "</Address>");
                sb.AppendLine("<Tel>" + "<![CDATA[" + row["Tel"].ToString().Trim() + "]]>" + "</Tel>");
                sb.AppendLine("<ICNo>" + row["ICNo"].ToString().Trim() + "</ICNo>");
                sb.AppendLine("<AccountType>" + "<![CDATA[" + row["AccountType"].ToString().Trim() + "]]>" + "</AccountType>");
                sb.AppendLine("<ShortSellingAllowed>" + row["ShortSellingAllowed"].ToString().Trim() + "</ShortSellingAllowed>");
                sb.AppendLine("</Register>");
                sb.AppendLine();
            }
            catch (Exception)
            {

                throw;
            }
        }
        private void GenerateSuspend(DataRow row, StringBuilder sb)
        {
            try
            {
                sb.AppendLine("<Suspend>");
                //sb.AppendLine("<BranchID>" + row["BranchID"].ToString().Trim() + "</BranchID>");
                sb.AppendLine("<ClientCode>" + row["ClientCode"].ToString().Trim() + "</ClientCode>");
                sb.AppendLine("<Buy_Suspend>" + row["Buy_Suspend"].ToString().Trim() + "</Buy_Suspend>");
                sb.AppendLine("<Sell_Suspend>" + row["Sell_Suspend"].ToString().Trim() + "</Sell_Suspend>");
                sb.AppendLine("<Remark>" + row["Suspend_Remark"].ToString().Trim() + "</Remark>");
                sb.AppendLine("</Suspend>");
                sb.AppendLine();
            }
            catch (Exception)
            {

                throw;
            }
        }
        private void GenerateDeactivate(DataRow row, StringBuilder sb)
        {
            try
            {
                sb.AppendLine("<Deactivate>");
                //sb.AppendLine("<BranchID>" + row["BranchID"].ToString().Trim() + "</BranchID>");
                sb.AppendLine("<ClientCode>" + row["ClientCode"].ToString().Trim() + "</ClientCode>");
                sb.AppendLine("</Deactivate>");
                sb.AppendLine();
            }
            catch (Exception)
            {

                throw;
            }
        }
        public string ConvertToPositionXMLString(DataSet ds, bool isMorning)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                // DataTable dt = new DataTable();
                sb.Append(@"<?xml version=""1.0"" encoding=""utf-8""?>");
                sb.AppendLine();
                sb.AppendLine();
                if (isMorning == true)
                    sb.AppendLine(@"<Positions ProcessingMode=""BatchInsertOrUpdate"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" ");
                else sb.AppendLine(@"<Positions ProcessingMode=""IncrementQuantity"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" ");
                sb.AppendLine(@"xsi:noNamespaceSchemaLocation=""Flextrade-BOS-Positions.xsd"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">");
                sb.AppendLine();
                if (ds.Tables.Count > 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        sb.AppendLine("<InsertOne>");
                        // sb.AppendLine("<BranchID>" + row["BranchID"].ToString().Trim() + "</BranchID>");
                        sb.AppendLine("<ClientCode>" + row["ClientCode"].ToString().Trim() + "</ClientCode>");
                        sb.AppendLine("<SecurityCode>" + "<![CDATA[" + row["SecurityCode"].ToString().Trim() + "]]>" + "</SecurityCode>");
                        sb.AppendLine("<ISIN>" + "<![CDATA[" + row["ISIN"].ToString().Trim() + "]]>" + "</ISIN>");
                        sb.AppendLine("<Quantity>" + row["Quantity"].ToString().Trim() + "</Quantity>");
                        sb.AppendLine("<TotalCost>" + row["TotalCost"].ToString().Trim() + "</TotalCost>");
                        sb.AppendLine("<PositionType>" + row["PositionType"].ToString().Trim() + "</PositionType>");
                        sb.AppendLine("</InsertOne>");
                        sb.AppendLine();
                    }
                }
                sb.AppendLine("</Positions>");
                return sb.ToString();
            }
            catch (Exception)
            {

                throw;

            }
        }
        private Stream ConvertStringToStream(string str)
        {
            MemoryStream stream = new MemoryStream();
            StreamWriter writer = new StreamWriter(stream);
            writer.Write(str);
            writer.Flush();
            stream.Position = 0;
            return stream;
        }

        public string ConvertXMLTradesToString(Stream xmlFile)
        {
            StringBuilder sb = new StringBuilder();
            DataSet ds = new DataSet();
            ds.ReadXml(xmlFile);
            if (ds.Tables.Count == 0) throw new Exception("Record not found");
            DataTable dt = ds.Tables[0];
            DataRow[] rows = dt.Select("Action='EXEC' and (Status='PF' or Status='FILL')", "RefOrderID asc, ExecID asc,  Status desc");
            foreach (DataRow row in rows)
            {
                sb.Append(row["RefOrderID"].ToString());
                sb.Append("~");
                sb.Append(row["SecurityCode"].ToString());
                sb.Append("~");
                sb.Append(row["ISIN"].ToString());
                sb.Append("~");
                sb.Append(row["TraderDealerID"].ToString());
                sb.Append("~");
                sb.Append(row["Side"].ToString());
                sb.Append("~");
                sb.Append(row["Quantity"].ToString());
                sb.Append("~");
                sb.Append(row["Price"].ToString());
                sb.Append("~");
                sb.Append(row["Date"].ToString().Substring(6, 2) + "-" + row["Date"].ToString().Substring(4, 2) + "-" + row["Date"].ToString().Substring(0, 4));
                sb.Append("~");
                sb.Append(row["Time"].ToString());
                sb.Append("~");
                sb.Append((row["Board"].ToString().ToUpper() == "BUYIN" || row["Board"].ToString().ToUpper() == "DEBT" || row["CompulsorySpot"].ToString() == "Y" ? "S" : row["Board"].ToString().ToUpper().Substring(0, 1)));
                sb.Append("~");
                sb.Append((row["FillType"].ToString().ToUpper() == "FILL" ? "F" : "P"));
                sb.Append("~");
                sb.Append("N");
                sb.Append("~");
                sb.Append("N");
                sb.Append("~");
                sb.Append(row["ClientCode"].ToString());
                sb.Append("~");
                sb.Append(row["BOID"].ToString());
                sb.Append("~");
                sb.Append(DateTime.Now.ToString("yyyyMMdd") + "0 " + row["ExecID"].ToString());
                sb.Append("~");
                sb.Append(row["CompulsorySpot"].ToString());
                sb.Append("~");
                sb.Append(row["Category"].ToString());

                sb.AppendLine();
            }

            return sb.ToString();
        }
        //public string ConvertXMLClosedPriceTsoString(Stream xmlFile)
        //{
        //    StringBuilder sb = new StringBuilder();
        //    DataSet ds = new DataSet();
        //    ds.ReadXml(xmlFile);
        //    if (ds.Tables.Count == 0) throw new Exception("Record not found");
        //    DataTable dt = ds.Tables[0];
        //    DBManager oDbManager = new DBManager();
        //    oDbManager.BulkCopy(dt);
        //    DataRow[] rows = dt.Select("AssetClass not in ('IN','TB')", "SecurityCode asc");
        //    foreach (DataRow row in rows)
        //    {
        //        sb.Append(row["TradeDate"].ToString().Substring(0, 4) + "-" + row["TradeDate"].ToString().Substring(4, 2) + "-" + row["TradeDate"].ToString().Substring(6, 2));
        //        sb.Append(",");
        //        sb.Append(row["ISIN"].ToString());
        //        sb.Append(",");
        //        sb.Append(row["SecurityCode"].ToString());
        //        sb.Append(",");
        //        sb.Append(row["Category"].ToString());
        //        sb.Append(",");
        //        sb.Append(row["Close"].ToString());

        //        sb.AppendLine();
        //    }

        //    return sb.ToString();
        //}
    }
}
