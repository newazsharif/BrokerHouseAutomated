using Escrow.BOAS.Process.Factories;
using Escrow.BOAS.Utility;
using Escrow.BOAS.Web.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.InvestorManagement.Factories;
using Escrow.BOAS.InvestorManagement.Models;
using tblInvestor = Escrow.BOAS.BrokerManagement.Models.tblInvestor;

namespace Escrow.BOAS.Web.Areas.ProcessManagement.Controllers
{
    public class ActivityProcessController : Controller
    {
        // GET: ProcessManagement/ActivityProcess

        private InvestorImageFactory investorImageFactory;
        private JoinHolderFactory joinHolderFactory;
        ProcessFactory processFactory;
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult DataBackup()
        {
            return View();
        }

        public ActionResult UploadImagesAndSignature()
        {
            return View();
        }

        public JsonResult Upload()
        {
            try
            {
                UploadInvestorsImage();
                UploadInvestorsSignature();
                UploadJoinHoldersImage();
                UploadImagesAndSignature();
                return Json(new { success = true, message = "successfully Uploaded Images and Signatures" },JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                
                return Json(new { success = false, errorMessage = exception.Message },JsonRequestBehavior.AllowGet);
            }
            
        }
        /// <summary>
        /// Author : newaz Sharif
        /// Date : 24th july 2016
        /// </summary>
        public void UploadInvestorsImage()
        {
            try
            {
                string filePath = ConfigManager.image_upload_path+"Investors/Images/";
                string[] allFileNames = Directory.GetFiles(filePath, "*.jpg");
                
                if (allFileNames.Length > 0)
                {
                    investorImageFactory = new InvestorImageFactory();

                    foreach (var file in allFileNames)
                    {

                        FileStream stream = new FileStream(file, FileMode.Open, FileAccess.Read);
                        BinaryReader br = new BinaryReader(stream);
                        Byte[] bytes = br.ReadBytes((Int32)stream.Length);
                        br.Close();
                        stream.Close();
                        string boId = file.Substring(file.LastIndexOf('/') + 1);
                        boId = boId.Remove(boId.LastIndexOf('.'));
                        boId = boId.Remove(boId.Length - 4);
                        tblInvestorImage investorImage = new tblInvestorImage();

                        investorImage = investorImageFactory.FindBy(a => a.tblInvestor.bo_code == boId).FirstOrDefault();
                        if (investorImage != null)
                        {
                            investorImage.photo = ImageConvert.ResizeImageFile(bytes, 100);
                            //investorImageFactory = new InvestorFactory();
                            investorImageFactory.Edit(investorImage);
                        }
                    }
                    investorImageFactory.Save();

                }
                
            }
            catch (Exception exception)
            {
                
                throw exception;
            }
        }
        /// <summary>
        /// Author : Newaz Shaif
        /// Date : 24th july 2016
        /// </summary>
        public void UploadInvestorsSignature()
        {
            try
            {
                string filePath = ConfigManager.image_upload_path + "Investors/Signatures/";
                string[] allFileNames = Directory.GetFiles(filePath, "*.jpg");
                if (allFileNames.Length > 0)
                {
                    
                    investorImageFactory = new InvestorImageFactory();
                    foreach (var file in allFileNames)
                    {

                        FileStream stream = new FileStream(file, FileMode.Open, FileAccess.Read);
                        BinaryReader br = new BinaryReader(stream);
                        Byte[] bytes = br.ReadBytes((Int32) stream.Length);
                        br.Close();
                        stream.Close();
                        string boId = file.Substring(file.LastIndexOf('/') + 1);
                        boId = boId.Remove(boId.LastIndexOf('.'));
                        boId = boId.Remove(boId.Length - 4);
                        tblInvestorImage investorImage = new tblInvestorImage();
                        investorImage = investorImageFactory.FindBy(a=>a.tblInvestor.bo_code == boId).FirstOrDefault();
                        if (investorImage != null)
                        {
                            investorImage.signature = ImageConvert.ResizeImageFile(bytes, 150);
                            investorImageFactory.Edit(investorImage);
                        }
                    //investorImageFactory = new InvestorFactory();
                        
                    }
                    investorImageFactory.Save();
                }
            }
            catch (Exception exception)
            {
                
                throw exception;
            }
            
        }
        public void UploadJoinHoldersImage()
        {
            try
            {
                string filePath = ConfigManager.image_upload_path + "JointHolders/Images/";
                string[] allFileNames = Directory.GetFiles(filePath, "*.jpg");
                
                if (allFileNames.Length > 0)
                {
                    joinHolderFactory = new JoinHolderFactory();
                    foreach (var file in allFileNames)
                    {

                        FileStream stream = new FileStream(file, FileMode.Open, FileAccess.Read);
                        BinaryReader br = new BinaryReader(stream);
                        Byte[] bytes = br.ReadBytes((Int32) stream.Length);
                        br.Close();
                        stream.Close();
                        string boId = file.Substring(file.LastIndexOf('/') + 1);
                        boId = boId.Remove(boId.LastIndexOf('.'));
                        tblJoinHolder jointHolderImage = new tblJoinHolder();

                        jointHolderImage = joinHolderFactory.FindBy(a => a.tblInvestor.bo_code == boId).FirstOrDefault();
                        if (jointHolderImage != null)
                        {
                            jointHolderImage.photo = ImageConvert.ResizeImageFile(bytes, 100);
                        }
                        //investorImageFactory = new InvestorFactory();
                        joinHolderFactory.Edit(jointHolderImage);
                    }
                    joinHolderFactory.Save();
                }
            }
            catch (Exception exception)
            {

                throw exception;
            }
        }

        public void UploadJoinHoldersSignature()
        {
            try
            {
                string filePath = ConfigManager.image_upload_path + "JointHolders/Signatures/";
                string[] allFileNames = Directory.GetFiles(filePath, "*.jpg");
                
                if (allFileNames.Length > 0)
                {
                    joinHolderFactory = new JoinHolderFactory();
                    foreach (var file in allFileNames)
                    {

                        FileStream stream = new FileStream(file, FileMode.Open, FileAccess.Read);
                        BinaryReader br = new BinaryReader(stream);
                        Byte[] bytes = br.ReadBytes((Int32) stream.Length);
                        br.Close();
                        stream.Close();
                        string boId = file.Substring(file.LastIndexOf('/') + 1);
                        boId = boId.Remove(boId.LastIndexOf('.'));
                        tblJoinHolder joinHolderImage = new tblJoinHolder();

                        joinHolderImage = joinHolderFactory.FindBy(a => a.tblInvestor.bo_code == boId).FirstOrDefault();
                        if (joinHolderImage != null)
                        {
                            joinHolderImage.signature = ImageConvert.ResizeImageFile(bytes, 100);
                            //investorImageFactory = new InvestorFactory();
                            joinHolderFactory.Edit(joinHolderImage);
                        }
                    }
                    joinHolderFactory.Save();
                }
            }
            catch (Exception exception)
            {

                throw exception;
            }

        }
        public JsonResult InitialLoad()
        {
            return Json(ConfigManager.bk_file_path, JsonRequestBehavior.AllowGet);
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult ExecuteBackup(string name,string path)
        {
            processFactory = new ProcessFactory();
            try
            {

                
                processFactory.DBBackupProcess(name,path);

                
                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
           
        }
        
    }
}