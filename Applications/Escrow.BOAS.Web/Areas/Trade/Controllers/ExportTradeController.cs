using Escrow.BOAS.Trade.Factories;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.Utility;

namespace Escrow.BOAS.Web.Areas.Trade.Controllers
{
    public class ExportTradeController : Controller
    {
        // GET: Trade/ExportTrade
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ExportOmnibusTrade()
        {
            return View();
        }

        public JsonResult LoadExportPath()
        {
            return Json(ConfigManager.trade_export_file_path, JsonRequestBehavior.AllowGet);
        }


        public JsonResult GetddlStockExchange()
        {
            var data = DropDown.ddlStockExchange();
            return Json(new { data = data, success = true }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetddlOmnibusMaster()
        {
            var data = DropDown.ddlOmnibusMaster();
            return Json(new { data = data, success = true }, JsonRequestBehavior.AllowGet);
        }

        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult ExportOmnibusTradeData(decimal stock_exchange_id, decimal trd_dt, string omnibus_master_id, string isTxtOrXml)
        {
            TradeFactory tradeFactory = new TradeFactory();
            List<string> exportList = new List<string>();
            if (omnibus_master_id == "undefined")
            {
                omnibus_master_id = null;
            }
            exportList = tradeFactory.ExportOmnibusTrade(stock_exchange_id, trd_dt,omnibus_master_id, isTxtOrXml);

            if (exportList.Count == 0)
            {
                return Json(new { message = "No data to generate file" }, JsonRequestBehavior.AllowGet);
            }

            else
            {
                string filePath = ConfigManager.trade_export_file_path;
                filePath = filePath + SessionManger.LoggedInTime(Session).ToString("yyyyMMdd").ToString()+"_Omnibus_Trades.txt";
                FileStream fs = new FileStream(filePath, FileMode.Create);
                StreamWriter f1 = new StreamWriter(fs);
                
                int i = 0;
                foreach (var s in exportList)
                {
                    f1.WriteLine(s);
                    f1.Flush();
                    i++;
                }
                f1.Close();
                return Json(new { success = true, message = "File exported Successfully" }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}