using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.BOAS.Configuration.Models;
using Escrow.BOAS.InvestorManagement.Factories;
using Escrow.BOAS.InvestorManagement.Models;
using Escrow.BOAS.InstrumentManagement.Factories;
using Escrow.BOAS.InstrumentManagement.Models;
using Escrow.BOAS.Configuration.Factories;
using Escrow.BOAS.Utility;
using Escrow.Security.Factories;
using Escrow.Security.Models;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Web
{
    public static class DropDown
    {
        #region global variables

        private static IGenericFactory<Escrow.BOAS.Configuration.Models.tblConstantObjectValue> constantObjectValueFactory;

        private static IGenericFactory<Escrow.BOAS.Configuration.Models.tblConstantObject> constantObjectFactory;

        private static Escrow.BOAS.BrokerManagement.Interfaces.IBrokerBranchFactory brokerBranchFactory;

        private static IGenericFactory<Escrow.BOAS.BrokerManagement.Models.tblBrokerBankAccount> brokerBankAccountFactory;

        private static IGenericFactory<Escrow.BOAS.AccountingManagement.Models.tblBank> bankFactory;

        private static IGenericFactory<Escrow.BOAS.AccountingManagement.Models.tblBankBranch> bankBranchFactory;

        private static IGenericFactory<Escrow.BOAS.BrokerManagement.Models.tblDepositoryPerticipant> depositoryFactory;

        private static IGenericFactory<Escrow.BOAS.BrokerManagement.Models.tblTrader> traderFactory;

        private static IGenericFactory<Escrow.BOAS.Charge.Models.tblGlobalCharge> globalChargeFactory;

        private static IGenericFactory<Escrow.BOAS.BrokerManagement.Models.tblEmployee> employeeFactory;

        private static IGenericFactory<Escrow.Security.Models.AspNetUser> userFactory;

        private static IGenericFactory<Escrow.BOAS.InstrumentManagement.Models.tblInstrument> instrumentFactory;

        private static IGenericFactory<tblBrokerUser> brokerUserFactory;

        private static IGenericFactory<tblBrokerInformation> brokerInformationFactory;

        private static IGenericFactory<tblUIModule> UIModuleFactory;
        private static IGenericFactory<tblAction> actionFactory;
        private static IGenericFactory<tblController> controllerFactory; 
        #endregion

        private static dynamic getConsObjValListByObjName(string objectName)
        {
            try
            {
                constantObjectValueFactory = new Escrow.BOAS.Configuration.Factories.ConstantObjectValueFactory();

                var obj = constantObjectValueFactory.GetAll().Where(a => a.tblConstantObject.object_name.ToUpper() == objectName.ToUpper()).OrderBy(a => a.sorting_order)
                    .Select(a => new 
                    { 
                        value = a.object_value_id, 
                        text = a.display_value 
                    }).ToList();

                return obj;
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

        public static dynamic ddlBroker()
        {
            brokerInformationFactory = new BrokerInformationFactory();
            var obj = brokerInformationFactory.GetAll().Select(a => new
            {
                value = a.membership_id,
                text = a.short_name
            }).ToList();
            return obj;
        }


        public static dynamic ddlController(decimal module_id)
        {
            controllerFactory = new ControllerFactory();
            var obj = controllerFactory.FindBy(a => a.ui_module_id == module_id).Select(a => new
            {
                value = a.id,
                text = a.name
            }).ToList();
            return obj;
        }
        public static dynamic ddlModule()
        {
            UIModuleFactory = new ModuleFactory();
            var obj = UIModuleFactory.GetAll().Where(a=>!a.id_name.ToUpper().EndsWith("REPORTS")).Select(a => new
            {
                value = a.id,
                text = a.name
            }).ToList();
            return obj;
        }

        public static dynamic ddlModuleForReport()
        {
            UIModuleFactory = new ModuleFactory();
            var obj = UIModuleFactory.GetAll().Where(a => a.id_name.ToUpper().EndsWith("REPORTS")).Select(a => new
            {
                value = a.id,
                text = a.name
            }).ToList();
            return obj;
        }
        public static dynamic ddlConsObj()
        {
            constantObjectFactory = new ConstantObjectFactory();

            var obj = constantObjectFactory.GetAll()
                .Select(a => new 
                { 
                    value = a.object_id, 
                    text = a.object_name 
                }).ToList();

            return obj;
        }

        public static dynamic ddlGender()
        {
            var obj = getConsObjValListByObjName("GENDER");

            return obj;
        }

        public static dynamic ddlDepartment()
        {
            var obj = getConsObjValListByObjName("DEPARTMENT");

            return obj;
        }

        public static dynamic ddlDesignation()
        {
            var obj = getConsObjValListByObjName("DESIGNATION");

            return obj;
        }

        public static dynamic ddlActiveStatus()
        {
            var obj = getConsObjValListByObjName("ACTIVE_STATUS");

            return obj;
        }

        public static dynamic ddlInstrumentSector()
        {
            var obj = getConsObjValListByObjName("INSTRUMENT_SECTOR");
            return obj;
        }

        public static dynamic ddlInstrumentType()
        {
            var obj = getConsObjValListByObjName("INSTRUMENT_TYPE");
            return obj; 
        }

        public static dynamic ddlDepositoryCompany()
        {
            var obj = getConsObjValListByObjName("DEPOSITORY_COMPANY");
            return obj;
        }

        public static dynamic ddlInstrumentGroup()
        {
            var obj = getConsObjValListByObjName("INSTRUMENT_GROUP");
            return obj;
        }

        public static dynamic ddlTransactionMode()
        {
            var obj = getConsObjValListByObjName("TRANSACTION_MODE");
            return obj;
        }

        public static dynamic ddlTransactionType()
        {
            var obj = getConsObjValListByObjName("TRANSACTION_TYPE");
            return obj;
        }

        public static dynamic ddlChargeType()
        {
            var obj = getConsObjValListByObjName("CHARGE_TYPE");
            return obj;
        }

        public static dynamic ddlTransactionOn()
        {
            var obj = getConsObjValListByObjName("TRANSACTION_ON");
            return obj;
        }

        public static dynamic ddlBrokerBranch(string user_id, decimal membership_id)
        {
            try
            {
                brokerBranchFactory = new Escrow.BOAS.BrokerManagement.Factories.BrokerBranchFactory();

                var obj = brokerBranchFactory.getBrokerByUserAndMember(user_id, membership_id)
                    .Select(a => new 
                    { 
                        value = a.id, 
                        text = a.name 
                    }).ToList();

                return obj;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                brokerBranchFactory.Dispose();
            }
        }

        public static dynamic ddlInstrument()
        {
            try
            {
                instrumentFactory = new Escrow.BOAS.InstrumentManagement.Factories.InstrumentFactory();

                var obj = instrumentFactory.GetAll()
                    .Select(a => new
                    {
                        value = a.isin,
                        text = a.security_code
                    }).ToList();

                return obj;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                instrumentFactory.Dispose();
            }
        }

        public static dynamic ddlTrader()
        {
            try
            {
                traderFactory = new Escrow.BOAS.BrokerManagement.Factories.TraderFactory();
                var obj = traderFactory.GetAll()
                .Select(a=> new
                {
                    value = a.id,
                    text = a.trader_code
                }).ToList();

                return obj;
            }
            catch(Exception ex)
            {
                throw ex;
            }

            
        }

        public static dynamic ddlBank()
        {
            try
            {
                bankFactory = new Escrow.BOAS.AccountingManagement.Factories.BankFactory();

                var obj = bankFactory.GetAll()
                    .Select(a => new
                    {
                        value = a.id,
                        text = a.bank_name
                    }).ToList();

                return obj;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                bankFactory.Dispose();
            }
        }

        public static dynamic ddlBrokerBankAccount(decimal membership_id)
        {
            try
            {
                brokerBankAccountFactory = new Escrow.BOAS.BrokerManagement.Factories.BrokerBankAccountFactory();

                var obj = brokerBankAccountFactory.GetAll().Where(a => a.membership_id == membership_id).OrderByDescending(a => a.is_default)
                    .Select(a => new
                    {
                        value = a.id,
                        text = "Bank: " + a.tblBankBranch.tblBank.bank_name + ", Bank Branch: " + a.tblBankBranch.branch_name + ", Account No: " + a.account_no
                    }).ToList();

                return obj;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                brokerBankAccountFactory.Dispose();
            }
        }

        public static dynamic ddlBankBranch(int id)
        {
            try
            {
                bankBranchFactory = new Escrow.BOAS.AccountingManagement.Factories.BankBranchFactory();
                var obj = bankBranchFactory.GetAll()
                    .Select(a => new
                    {
                        value = a.id,
                        text = a.branch_name,
                        bank = a.bank_id
                    }).Where(b => b.bank == id).ToList();

                return obj;
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                bankBranchFactory.Dispose();
            }
        }

        public static dynamic ddlIntroducer()
        {
            Escrow.BOAS.InvestorManagement.Factories.IntroducerFactory introducerFactory = new Escrow.BOAS.InvestorManagement.Factories.IntroducerFactory();
            try
            {
                var obj = introducerFactory.GetAll()
                    .Select(a => new
                    {
                        value = a.id,
                        text = a.introducer_name,
                    }).ToList();

                return obj;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                introducerFactory.Dispose();
            }
        }

        public static dynamic ddlOmnibusMaster()
        {
            Escrow.BOAS.InvestorManagement.Factories.OmnibusFactory omnibusFactory = new Escrow.BOAS.InvestorManagement.Factories.OmnibusFactory();
            try
            {
                var obj = omnibusFactory.GetAll()
                    .Select(a => new
                    {
                        value = a.omnibus_id,
                        text = a.name,
                    }).ToList();

                return obj;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                omnibusFactory.Dispose();
            }
        }

        public static dynamic ddlBankBranchEdit()
        {
            try
            {
                bankBranchFactory = new Escrow.BOAS.AccountingManagement.Factories.BankBranchFactory();
                var obj = bankBranchFactory.GetAll()
                    .Select(a => new
                    {
                        value = a.id,
                        text = a.branch_name,
                        bank = a.bank_id
                    }).ToList();

                return obj;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                bankBranchFactory.Dispose();
            }
        }

        public static dynamic ddlDp()
        {
            try
            {
                depositoryFactory = new Escrow.BOAS.BrokerManagement.Factories.DepositoryParticipateFactory();
                var obj = depositoryFactory.GetAll()
                    .Select(a=> new 
                    {
                        value = a.id,
                        text = a.bo_reference_no
                    }).ToList();
                return obj;
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                depositoryFactory.Dispose();
            }
        }

        public static dynamic ddlAccountType()
        {
            var obj = getConsObjValListByObjName("INVESTOR_ACC_TYPE");
            return obj;
        }
        public static dynamic ddlStockExchange()
        {
            var obj = getConsObjValListByObjName("STOCK_EXCHANGE");
            return obj;
        }

        public static dynamic ddlOperationType()
        {
            var obj = getConsObjValListByObjName("INVESTOR_OPERATION_TYPE");
            return obj;
        }

        public static dynamic ddlDistrict()
        {
            var obj = getConsObjValListByObjName("DISTRICT");
            return obj;
        }

        public static dynamic ddlThana()
        {
            var obj = getConsObjValListByObjName("THANA");
            return obj;
        }

        public static dynamic ddlTradeType()
        {
            var obj = getConsObjValListByObjName("TRADE_TYPE");
            return obj;
        }

        public static dynamic ddlIpoType()
        {
            var obj = getConsObjValListByObjName("IPO_TYPE");
            return obj;
        }
        public static dynamic ddlNonTradingType()
        {
            var obj = getConsObjValListByObjName("NON_TRADING_DAY_TYPE");
            return obj;
        }

        public static dynamic ddlInvestorSubAcc()
        {
            var obj = getConsObjValListByObjName("INVESTOR_SUB_ACC");
            return obj;
        } 

        public static dynamic ddlCharge()
        {
            try
            {
                globalChargeFactory = new Escrow.BOAS.Charge.Factories.GlobalChargeFactory();

                var obj = globalChargeFactory.GetAll()
                    .Select(a => new
                    {
                        value = a.id,
                        text = a.name
                    }).ToList();

                return obj;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                globalChargeFactory.Dispose();
            }
        }

        public static dynamic ddlUsers(decimal membershipId)
        {
            var obj = brokerUserFactory.FindBy(c => c.membership_id == membershipId).Select(
                a => new
                {
                    text = a.AspNetUser.UserName,
                    value = a.UserId
                }).ToList();
            return obj;
        }
        public static dynamic ddlEmployee()
        {
            try
            {
                employeeFactory = new Escrow.BOAS.BrokerManagement.Factories.EmployeeInformationFactory();

                var obj = employeeFactory.GetAll()
                    .Select(a => new
                    {
                        value = a.id,
                        text = a.name
                    }).ToList();

                return obj;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                employeeFactory.Dispose();
            }
        }

        public static dynamic ddlUser()
        {
            try
            {
                userFactory = new Escrow.Security.Factories.UserFactory();

                var obj = userFactory.GetAll()
                    .Select(a => new
                    {
                        value = a.Id,
                        text = a.UserName
                    }).ToList();

                return obj;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                userFactory.Dispose();
            }
        }

    }
}