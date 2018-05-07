using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;
using System.Security.Cryptography;
using System.Text;

namespace Escrow.BOAS.Web
{
    public static class CommonUtility
    {
        #region global variables

        private static Escrow.BOAS.InvestorManagement.Interfaces.IInvestorFactory investorFactory;

        private static IGenericFactory<Escrow.BOAS.Configuration.Models.tblConstantObjectValue> constantObjectValueFactory;

        #endregion

        public static Escrow.BOAS.InvestorManagement.Models.tblInvestor getInvestorInfoById(string id, decimal branch)
        {
            try
            {
                investorFactory = new Escrow.BOAS.InvestorManagement.Factories.InvestorFactory();

                Escrow.BOAS.InvestorManagement.Models.tblInvestor investor = investorFactory.getInvestorInfoByClientId(id,branch);

                return investor;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                investorFactory.Dispose();
            }
        }

        public static Escrow.BOAS.InvestorManagement.Models.tblInvestor getInvestorInfoById(string id)
        {
            try
            {
                investorFactory = new Escrow.BOAS.InvestorManagement.Factories.InvestorFactory();

                Escrow.BOAS.InvestorManagement.Models.tblInvestor investor = investorFactory.getInvestorInfoByClientId(id);

                return investor;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                investorFactory.Dispose();
            }
        }

        public static decimal getObjValByObjNameAndDisplayVal(string objectName, string displayValue)
        {
            try
            {
                constantObjectValueFactory = new Escrow.BOAS.Configuration.Factories.ConstantObjectValueFactory();

                decimal object_value_id = constantObjectValueFactory.GetAll().Where(a => a.tblConstantObject.object_name.ToUpper() == objectName.ToUpper() && a.display_value.ToUpper() == displayValue.ToUpper()).Select(a => a.object_value_id).FirstOrDefault();

                return object_value_id;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                constantObjectValueFactory.Dispose();
            }
        }

        public static string GetMd5Hash(string input)
        {
            MD5 md5Hash = MD5.Create();
            // Convert the input string to a byte array and compute the hash. 
            byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));

            // Create a new Stringbuilder to collect the bytes 
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data  
            // and format each one as a hexadecimal string. 
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            // Return the hexadecimal string. 
            return sBuilder.ToString();
        }
    }
}