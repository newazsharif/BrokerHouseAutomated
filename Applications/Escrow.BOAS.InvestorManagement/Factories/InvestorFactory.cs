using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.Utility.Factories;
using Escrow.BOAS.InvestorManagement.Models;
using Escrow.BOAS.InvestorManagement.Interfaces;
using System.Transactions;
using Escrow.BOAS.Configuration.Factories;
using System.Data.SqlClient;

namespace Escrow.BOAS.InvestorManagement.Factories
{
    public class InvestorFactory : GenericFactory<InvestorEntities, tblInvestor>, IInvestorFactory
    {
        public List<string> GetInvestorByRange(string cds)
        {
            return this.Context.udfSpliter(cds).ToList();
        }
        public tblInvestor getInvestorInfoByClientId(string client_id)
        {
            tblInvestor investor = new tblInvestor();

            var _investor = (from tinv in this.Context.tblInvestors
                             join tcovas in this.Context.tblConstantObjectValues on tinv.active_status_id equals tcovas.object_value_id
                             join broker_b in this.Context.tblBrokerBranches on tinv.branch_id equals broker_b.id
                             join vaiats in this.Context.vw_all_investors_account_type_setting on tinv.client_id equals vaiats.client_id                             
                             into vaiatss

                             from vaiats in vaiatss.DefaultIfEmpty()
                             join vaic in this.Context.vw_all_investors_charges on tinv.client_id equals vaic.client_id
                             into vaics
                             from vaic in vaics.DefaultIfEmpty()
                             join tii in this.Context.tblInvestorImages on tinv.client_id equals tii.client_id
                             into tiis
                             from tii in tiis.DefaultIfEmpty()
                             join tjh in this.Context.tblJoinHolders on tinv.client_id equals tjh.client_id
                             into tjhs
                             from tjh in tjhs.DefaultIfEmpty()
                             join tcovat in this.Context.tblConstantObjectValues on tinv.account_type_id equals tcovat.object_value_id
                             into tcovats
                             from tcovat in tcovats.DefaultIfEmpty()
                             join tcovot in this.Context.tblConstantObjectValues on tinv.operation_type_id equals tcovot.object_value_id
                             into tcovots
                             from tcovot in tcovots.DefaultIfEmpty()

                             where tinv.client_id == client_id
                             
                             select new
                             {
                                 tinv.client_id,
                                 tinv.first_holder_name,
                                 tii.photo,
                                 tii.signature,
                                 broker_branch = broker_b.name,
                                 broker_branch_id = tinv.branch_id,
                                 available_balance = (vaiats.available_balance == null ? 0 : vaiats.available_balance),
                                 ledger_balance = (vaiats.ledger_balance == null ? 0 : vaiats.ledger_balance),
                                 purchase_power = (vaiats.purchase_power == null ? 0 : vaiats.purchase_power),
                                 vaiats.withdraw_limit_on_name,
                                 withdrawable_amount = (vaiats.withdrawable_amount == null ? 0 : vaiats.withdrawable_amount),
                                 tinv.active_status_id,
                                 active_status = tcovas.display_value,
                                 tinv.account_type_id,
                                 tinv.operation_type_id,
                                 tinv.bo_code,
                                 tinv.national_id,
                                 tinv.father_name,
                                 tinv.mother_name,
                                 tinv.email_address,
                                 tinv.mobile_no,
                                 tinv.membership_id,
                                 account_type = tcovat.display_value,
                                 operation_type = tcovot.display_value,
                                 tjh.join_holder_name,
                                 join_holders_photo = tjh.photo,
                                 join_holders_signature = tjh.signature,
                                 charge_rate = (vaic.charge_amount == null ? 0 : vaic.charge_amount),
                                 is_charge_percentage = (vaic.is_percentage == 0 ? false : true),
                                 minimum_charge = (vaic.minimum_charge == null ? 0 : vaic.minimum_charge)
                             }).FirstOrDefault();

            if (_investor != null && _investor.client_id == client_id)
            {
                investor.first_holder_name = _investor.first_holder_name;
                investor.photo = _investor.photo;
                investor.signature = _investor.signature;
                investor.available_balance = _investor.available_balance;
                investor.ledger_balance = _investor.ledger_balance;
                investor.purchase_power = _investor.purchase_power;
                investor.withdraw_limit_on_name = _investor.withdraw_limit_on_name;
                investor.withdrawable_amount = _investor.withdrawable_amount;
                investor.active_status_id = _investor.active_status_id;
                investor.active_status = _investor.active_status;
                investor.account_type_id = _investor.account_type_id;
                investor.account_type = _investor.account_type;
                investor.operation_type = _investor.operation_type;
                investor.join_holder_name = _investor.join_holder_name;
                investor.join_holders_photo = _investor.join_holders_photo;
                investor.join_holders_signature = _investor.join_holders_signature;
                investor.charge_rate = _investor.charge_rate;
                investor.is_charge_percentage = _investor.is_charge_percentage;
                investor.minimum_charge = _investor.minimum_charge;
                investor.broker_branch = _investor.broker_branch;
                investor.broker_branch_id = _investor.broker_branch_id;
                investor.bo_code = _investor.bo_code;
                investor.national_id = _investor.national_id;
                investor.father_name = _investor.father_name;
                investor.mother_name = _investor.mother_name;
                investor.email_address = _investor.email_address;
                investor.mobile_no = _investor.mobile_no;
                investor.membership_id = _investor.membership_id;
                return investor;
            }
            else
            {
                return null;
            }
        }


        //public tblInvestor getInvestorInfoByClientId(string client_id, decimal broker_id)
        //{
        //    tblInvestor investor = new tblInvestor();

        //    var _investor = (from tinv in this.Context.tblInvestors
        //                     join tcovas in this.Context.tblConstantObjectValues on tinv.active_status_id equals tcovas.object_value_id
        //                     join broker_b in this.Context.tblBrokerBranches on tinv.branch_id equals broker_b.id
        //                     join vaiats in this.Context.vw_all_investors_account_type_setting on tinv.client_id equals vaiats.client_id
        //                     into vaiatss

        //                     from vaiats in vaiatss.DefaultIfEmpty()
        //                     join vaic in this.Context.vw_all_investors_charges on tinv.client_id equals vaic.client_id
        //                     into vaics
        //                     from vaic in vaics.DefaultIfEmpty()
        //                     join tii in this.Context.tblInvestorImages on tinv.client_id equals tii.client_id
        //                     into tiis
        //                     from tii in tiis.DefaultIfEmpty()
        //                     join tjh in this.Context.tblJoinHolders on tinv.client_id equals tjh.client_id
        //                     into tjhs
        //                     from tjh in tjhs.DefaultIfEmpty()
        //                     join tcovat in this.Context.tblConstantObjectValues on tinv.account_type_id equals tcovat.object_value_id
        //                     into tcovats
        //                     from tcovat in tcovats.DefaultIfEmpty()
        //                     join tcovot in this.Context.tblConstantObjectValues on tinv.operation_type_id equals tcovot.object_value_id
        //                     into tcovots
        //                     from tcovot in tcovots.DefaultIfEmpty()

        //                     where tinv.client_id == client_id && tinv.membership_id == broker_id

        //                     select new
        //                     {
        //                         tinv.client_id,
        //                         tinv.first_holder_name,
        //                         tii.photo,
        //                         tii.signature,
        //                         broker_branch = broker_b.name,
        //                         broker_branch_id = tinv.branch_id,
        //                         available_balance = (vaiats.available_balance == null ? 0 : vaiats.available_balance),
        //                         ledger_balance = (vaiats.ledger_balance == null ? 0 : vaiats.ledger_balance),
        //                         purchase_power = (vaiats.purchase_power == null ? 0 : vaiats.purchase_power),
        //                         vaiats.withdraw_limit_on_name,
        //                         withdrawable_amount = (vaiats.withdrawable_amount == null ? 0 : vaiats.withdrawable_amount),
        //                         tinv.active_status_id,
        //                         active_status = tcovas.display_value,
        //                         tinv.account_type_id,
        //                         tinv.operation_type_id,
        //                         tinv.bo_code,
        //                         tinv.national_id,
        //                         tinv.father_name,
        //                         tinv.mother_name,
        //                         tinv.email_address,
        //                         tinv.mobile_no,
        //                         tinv.membership_id,
        //                         account_type = tcovat.display_value,
        //                         operation_type = tcovot.display_value,
        //                         tjh.join_holder_name,
        //                         join_holders_photo = tjh.photo,
        //                         join_holders_signature = tjh.signature,
        //                         charge_rate = (vaic.charge_amount == null ? 0 : vaic.charge_amount),
        //                         is_charge_percentage = (vaic.is_percentage == 0 ? false : true),
        //                         minimum_charge = (vaic.minimum_charge == null ? 0 : vaic.minimum_charge)
        //                     }).FirstOrDefault();

        //    if (_investor != null && _investor.client_id == client_id)
        //    {
        //        investor.first_holder_name = _investor.first_holder_name;
        //        investor.photo = _investor.photo;
        //        investor.signature = _investor.signature;
        //        investor.available_balance = _investor.available_balance;
        //        investor.ledger_balance = _investor.ledger_balance;
        //        investor.purchase_power = _investor.purchase_power;
        //        investor.withdraw_limit_on_name = _investor.withdraw_limit_on_name;
        //        investor.withdrawable_amount = _investor.withdrawable_amount;
        //        investor.active_status_id = _investor.active_status_id;
        //        investor.active_status = _investor.active_status;
        //        investor.account_type_id = _investor.account_type_id;
        //        investor.account_type = _investor.account_type;
        //        investor.operation_type = _investor.operation_type;
        //        investor.join_holder_name = _investor.join_holder_name;
        //        investor.join_holders_photo = _investor.join_holders_photo;
        //        investor.join_holders_signature = _investor.join_holders_signature;
        //        investor.charge_rate = _investor.charge_rate;
        //        investor.is_charge_percentage = _investor.is_charge_percentage;
        //        investor.minimum_charge = _investor.minimum_charge;
        //        investor.broker_branch = _investor.broker_branch;
        //        investor.broker_branch_id = _investor.broker_branch_id;
        //        investor.bo_code = _investor.bo_code;
        //        investor.national_id = _investor.national_id;
        //        investor.father_name = _investor.father_name;
        //        investor.mother_name = _investor.mother_name;
        //        investor.email_address = _investor.email_address;
        //        investor.mobile_no = _investor.mobile_no;
        //        investor.membership_id = _investor.membership_id;
        //        return investor;
        //    }
        //    else
        //    {
        //        return null;
        //    }
        //}

        
        public tblInvestor getInvestorInfoByClientId(string client_id, decimal branch_id)
        {
            tblInvestor investor = new tblInvestor();

            var _investor = (from tinv in this.Context.tblInvestors
                             join tcovas in this.Context.tblConstantObjectValues on tinv.active_status_id equals tcovas.object_value_id
                             join vaiats in this.Context.vw_all_investors_account_type_setting on tinv.client_id equals vaiats.client_id
                             into vaiatss
                             from vaiats in vaiatss.DefaultIfEmpty()
                             join vaic in this.Context.vw_all_investors_charges on tinv.client_id equals vaic.client_id
                             into vaics
                             from vaic in vaics.DefaultIfEmpty()
                             join tii in this.Context.tblInvestorImages on tinv.client_id equals tii.client_id
                             into tiis
                             from tii in tiis.DefaultIfEmpty()
                             join tjh in this.Context.tblJoinHolders on tinv.client_id equals tjh.client_id
                             into tjhs
                             from tjh in tjhs.DefaultIfEmpty()
                             join tcovat in this.Context.tblConstantObjectValues on tinv.account_type_id equals tcovat.object_value_id
                             into tcovats
                             from tcovat in tcovats.DefaultIfEmpty()
                             join tcovot in this.Context.tblConstantObjectValues on tinv.operation_type_id equals tcovot.object_value_id
                             into tcovots
                             from tcovot in tcovots.DefaultIfEmpty()
                             where tinv.client_id == client_id && tinv.branch_id == branch_id
                             select new
                             {
                                 tinv.client_id,
                                 tinv.branch_id,
                                 tinv.first_holder_name,
                                 tii.photo,
                                 tii.signature,
                                 available_balance = (vaiats.available_balance == null ? 0 : vaiats.available_balance),
                                 ledger_balance = (vaiats.ledger_balance == null ? 0 : vaiats.ledger_balance),
                                 purchase_power = (vaiats.purchase_power == null ? 0 : vaiats.purchase_power),
                                 vaiats.withdraw_limit_on_name,
                                 withdrawable_amount = (vaiats.withdrawable_amount == null ? 0 : vaiats.withdrawable_amount),
                                 tinv.active_status_id,
                                 active_status = tcovas.display_value,
                                 tinv.account_type_id,
                                 tinv.operation_type_id,
                                 account_type = tcovat.display_value,
                                 operation_type = tcovot.display_value,
                                 tjh.join_holder_name,
                                 join_holders_photo = tjh.photo,
                                 join_holders_signature = tjh.signature,
                                 charge_rate = (vaic.charge_amount == null ? 0 : vaic.charge_amount),
                                 is_charge_percentage = (vaic.is_percentage == 0 ? false : true),
                                 minimum_charge = (vaic.minimum_charge == null ? 0 : vaic.minimum_charge)
                             }).FirstOrDefault();

            if (_investor != null && _investor.client_id == client_id)
            {
                investor.first_holder_name = _investor.first_holder_name;
                investor.photo = _investor.photo;
                investor.signature = _investor.signature;
                investor.available_balance = _investor.available_balance;
                investor.ledger_balance = _investor.ledger_balance;
                investor.purchase_power = _investor.purchase_power;
                investor.withdraw_limit_on_name = _investor.withdraw_limit_on_name;
                investor.withdrawable_amount = _investor.withdrawable_amount;
                investor.active_status_id = _investor.active_status_id;
                investor.active_status = _investor.active_status;
                investor.account_type_id = _investor.account_type_id;
                investor.account_type = _investor.account_type;
                investor.operation_type = _investor.operation_type;
                investor.join_holder_name = _investor.join_holder_name;
                investor.join_holders_photo = _investor.join_holders_photo;
                investor.join_holders_signature = _investor.join_holders_signature;
                investor.charge_rate = _investor.charge_rate;
                investor.is_charge_percentage = _investor.is_charge_percentage;
                investor.minimum_charge = _investor.minimum_charge;

                return investor;
            }
            else
            {
                return null;
            }
        }


        public override void Save(tblInvestor investor)
        {
            ConstantObjectValueFactory conFactory = new ConstantObjectValueFactory();
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    base.Save();
                    decimal object_value_id = this.Context.tblConstantObjectValues.Where(a => a.display_value == "Account Opening Fee").Select(a => a.object_value_id).FirstOrDefault();
                    base.Context.psp_investor_financial_transaction(investor.client_id, object_value_id, investor.membership_id, investor.changed_user_id);
                    scope.Complete();
                  }
                catch (Exception ex)
                {
                    Transaction.Current.Rollback();
                    throw ex;
                }
                    finally
                {
                    scope.Dispose();
                }
           }
        }
    }
}
