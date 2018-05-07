using Escrow.Utility.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Escrow.Service
{
    public static class CommonUtility
    {
        #region global variables

        private static Escrow.BOAS.InvestorManagement.Interfaces.IInvestorFactory investorFactory;

        private static IGenericFactory<Escrow.BOAS.Configuration.Models.tblConstantObjectValue> constantObjectValueFactory;

        #endregion

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
    }
}