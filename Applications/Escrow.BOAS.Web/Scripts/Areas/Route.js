    angular.module('myApp', ['ngRoute', 'smart-table', 'ngAnimate', 'ivh.treeview', 'ui.bootstrap', 'ngFileUpload', 'ngTinyScrollbar', 'fancyboxplus', 'blockUI', 'anguFixedHeaderTable', 'textAngular'])
.config(function ($routeProvider, $locationProvider, blockUIConfig) {


    var id = ':ViewId';
    $routeProvider
        .when('/',
        {
            templateUrl: 'Home/Index'
        })

        .when('/Index',
        {
            templateUrl: 'Home/Index'
        })

        .when('/RedirectToMain',
        {
            templateUrl: 'Home/RedirectToMain'
        })
         .when('/Error',
        {
            
            controller: function()
            {
                toastr.error('sdsddad');
                //$location.path('/Index');

            },
            //templateUrl: $location.path()
            template: 'You do not have permission'
        })

        .when('/Login',
        {
            templateUrl: 'Account/Login'
        })
        .when('/LogOff',
        {
            templateUrl: 'Account/LogOff'
        })

        // route for Configuration module

        //Constant Object
        .when('/ConstantObject', {
            templateUrl: '/Configuration/ConstantObject/ConstantObjectList',
            controller: 'ConstantObjectController'

        })
        .when('/AddNewConstant', {
            templateUrl: 'Configuration/ConstantObject/NewConstantObject',
            controller: 'ConstantObjectController'

        })
        .when('/EditConstant/:object_id', {
            templateUrl: 'Configuration/ConstantObject/EditConstantObject',
            controller: 'ConstantObjectController'

        })

        //Constant Object Value
        .when('/ConstantObjectValue', {
            templateUrl: 'Configuration/ConstantObjectValue/ConstantObjectValueList',
            controller: 'ConstantObjectValueController'

        })
        .when('/AddNewConstantValue', {
            templateUrl: 'Configuration/ConstantObjectValue/NewConstantObjectValue',
            controller: 'ConstantObjectValueController'

        })
        .when('/EditConstantValue/:object_value_id', {
            templateUrl: 'Configuration/ConstantObjectValue/EditConstantObjectValue',
            controller: 'ConstantObjectValueController'

        })

        //Broker Branch
        .when('/BrokerBranch', {
            templateUrl: 'Configuration/BrokerBranch/BrokerBranchList',
            controller: 'BrokerBranchController'

        })
        .when('/EditBroker/:id', {
            templateUrl: 'Configuration/BrokerBranch/EditBrokerBranch',
            controller: 'BrokerBranchController'

        })
        .when('/AccountMap', {
            templateUrl: 'Configuration/AccountMapping/AccountMap',
            controller: 'AccountMappingController'

        })


        // route for Broker Management module

        //added by: rifad
        // date: 6-5-2017
        //Employee
        .when('/EmployeeInformation', {
            templateUrl: 'BrokerManagement/EmployeeInformation/EmployeeInformationList',
            controller: 'EmployeeInformationController'
        })
        .when('/AddNewEmployeeInformation', {
            templateUrl: 'BrokerManagement/EmployeeInformation/NewEmployeeInformation',
            controller: 'EmployeeInformationController'
        })
        .when('/EditEmployee/:id', {
            templateUrl: 'BrokerManagement/EmployeeInformation/EditEmployeeInformation',
            controller: 'EmployeeInformationController'
        })
        //added by: rifad
        // date: 7-5-2017
        //Bank
       .when('/BankList', {
           templateUrl: 'BrokerManagement/BankInformation/BankList',
           controller: 'BankInformationController'
       })
       .when('/AddNewBankInformation', {
              templateUrl: 'BrokerManagement/BankInformation/NewBankInformation',
              controller: 'BankInformationController'
          })
        .when('/editBankInfomation/:id', {
            templateUrl: 'BrokerManagement/BankInformation/editBankInfomation',
            controller: 'BankInformationController'
        })
        //added by: rifad
        // date: 10-5-2017
        // Branch
         .when('/BranchList/:id', {
             ///id bank id
             templateUrl: 'BrokerManagement/BankInformation/BranchList',
             controller: 'BankInformationController'

         })
        .when('/editBranch/:id', {
            // id branch id
            templateUrl: 'BrokerManagement/BankInformation/editBranchInfomation',
            controller: 'BankInformationController'

        })
         .when('/AddBranch/:id', {
             // id bank id
             templateUrl: 'BrokerManagement/BankInformation/AddBranch',
             controller: 'BankInformationController'

         })


        ///end
        //Trader
        .when('/TraderInformationList', {
            templateUrl: '/BrokerManagement/TraderInformation/TraderInformationList',
            controller: 'TraderInformationController'
        })
        .when('/NewTraderInformation', {
            templateUrl: 'BrokerManagement/TraderInformation/NewTrdaerInformation',
            controller: 'TraderInformationController'

        })
        .when('/EditTrader/:id', {
            templateUrl: 'BrokerManagement/TraderInformation/EditTraderInformation',
            controller: 'TraderInformationController'

        })


        //User Employee Mapping
        .when('/UserEmployeeMappingList', {
            templateUrl: '/BrokerManagement/UserEmployeeMapping/UserEmpMapList',
            controller: 'UserEmployeeMappingController'

        })
        .when('/NewUserEmployeeMapping', {
            templateUrl: 'BrokerManagement/UserEmployeeMapping/NewUserEmpMap',
            controller: 'UserEmployeeMappingController'

        })
        .when('/EditUserEmployeeMapping/:id', {
            templateUrl: 'BrokerManagement/UserEmployeeMapping/EditUserEmpMap',
            controller: 'UserEmployeeMappingController'

        })

        //Trader Investor Mapping
        .when('/TraderInvestorMapping', {
            templateUrl: '/BrokerManagement/TraderInvestorMapping/TraderInvestorMapping',
            controller: 'TraderInvestorMappingController'

        })




        // route for Charge module


        //Charge Information
        .when('/ChargeInformationList', {
            templateUrl: 'Charge/ChargeInformation/ChargeInfoList',
            controller: 'ChargeInformationController'

        })
        .when('/EditChargeInformation/:id', {
            templateUrl: 'Charge/ChargeInformation/EditChargeInfo',
            controller: 'ChargeInformationController'

        })

        //Investor Charges
        .when('/InvestorCharges', {
            templateUrl: 'Charge/InvestorCharges/InvCharges',
            controller: 'InvestorChargesController'

        })
        .when('/InvestorChargesList', {
            templateUrl: 'Charge/InvestorCharges/InvChargesList',
            controller: 'InvestorChargesController'

        })
        .when('/EditInvestorCharges/:id', {
            templateUrl: 'Charge/InvestorCharges/EditInvCharges',
            controller: 'InvestorChargesController'

        })

        //Sub Account Charges
        .when('/SubAccountCharges', {
            templateUrl: 'Charge/SubAccountCharges/SubAccCharges',
            controller: 'SubAccountChargesController'

        })
        .when('/SubAccountChargesList', {
            templateUrl: 'Charge/SubAccountCharges/SubAccChargesList',
            controller: 'SubAccountChargesController'

        })
        .when('/EditSubAccountCharges/:id', {
            templateUrl: 'Charge/SubAccountCharges/EditSubAccCharges',
            controller: 'SubAccountChargesController'

        })

        //Branch Wise Charges
        .when('/BranchWiseCharges', {
            templateUrl: 'Charge/BranchWiseCharges/BranchCharges',
            controller: 'BranchWiseChargesController'

        })
        .when('/BranchWiseChargesList', {
            templateUrl: 'Charge/BranchWiseCharges/BranchWiseChargesList',
            controller: 'BranchWiseChargesController'

        })
        .when('/EditBranchWiseCharges/:id', {
            templateUrl: 'Charge/BranchWiseCharges/EditBranchWiseCharges',
            controller: 'BranchWiseChargesController'

        })

        //Exchange Wise Charges
        .when('/ExchangeWiseCharges', {
            templateUrl: 'Charge/ExchangeWiseCharges/ExchangeCharges',
            controller: 'ExchangeWiseChargesController'

        })
        .when('/ExchangeWiseChargesList', {
            templateUrl: 'Charge/ExchangeWiseCharges/ExchangeWiseChargesList',
            controller: 'ExchangeWiseChargesController'

        })
        .when('/EditExchangeWiseCharges/:id', {
            templateUrl: 'Charge/ExchangeWiseCharges/EditExchangeWiseCharges',
            controller: 'ExchangeWiseChargesController'

        })

        //Account Type Setting
        .when('/AccountTypeSettingList', {
            templateUrl: 'Charge/AccountTypeSetting/AccTypeSettingList',
            controller: 'AccountTypeSettingController'

        })
        .when('/AccountTypeSetting', {
            templateUrl: 'Charge/AccountTypeSetting/AccTypeSetting',
            controller: 'AccountTypeSettingController'

        })
        .when('/EditAccountTypeSetting/:id', {
            templateUrl: 'Charge/AccountTypeSetting/EditAccTypeSetting',
            controller: 'AccountTypeSettingController'

        })

        //Investor Account Type Setting
        .when('/InvestorAccountTypeSettingList', {
            templateUrl: 'Charge/InvestorAccountTypeSetting/InvAccTypeSettingList',
            controller: 'InvestorAccountTypeSettingController'

        })
        .when('/InvestorAccountTypeSetting', {
            templateUrl: 'Charge/InvestorAccountTypeSetting/InvAccTypeSetting',
            controller: 'InvestorAccountTypeSettingController'

        })
        .when('/EditInvestorAccountTypeSetting/:id', {
            templateUrl: 'Charge/InvestorAccountTypeSetting/EditInvAccTypeSetting',
            controller: 'InvestorAccountTypeSettingController'

        })

        //Branch Account Type Setting
        .when('/BranchAccountTypeSettingList', {
            templateUrl: 'Charge/BranchAccountTypeSetting/BranchAccTypeSettingList',
            controller: 'BranchAccountTypeSettingController'

        })
        .when('/BranchAccountTypeSetting', {
            templateUrl: 'Charge/BranchAccountTypeSetting/BranchAccTypeSetting',
            controller: 'BranchAccountTypeSettingController'

        })
        .when('/EditBranchAccountTypeSetting/:id', {
            templateUrl: 'Charge/BranchAccountTypeSetting/EditBranchAccTypeSetting',
            controller: 'BranchAccountTypeSettingController'

        })

         //Sub Account Account Type Setting
        .when('/SubAccountAccountTypeSettingList', {
            templateUrl: 'Charge/SubAccountAccountTypeSetting/SubAccAccTypeSettingList',
            controller: 'SubAccountAccountTypeSettingController'

        })
        .when('/SubAccountAccountTypeSetting', {
            templateUrl: 'Charge/SubAccountAccountTypeSetting/SubAccAccTypeSetting',
            controller: 'SubAccountAccountTypeSettingController'

        })
        .when('/EditSubAccountAccountTypeSetting/:id', {
            templateUrl: 'Charge/SubAccountAccountTypeSetting/EditSubAccAccTypeSetting',
            controller: 'SubAccountAccountTypeSettingController'

        })
        



        //Instrument
        .when('/NewInstrument',
        {
            templateUrl: 'Instrument/Instrument/NewInstrument',
            controller: 'InstrumentController'
        })
        .when('/InstrumentList',
        {
            templateUrl: 'Instrument/Instrument/InstrumentList',
            controller: 'InstrumentController'
        })

        .when('/EditInstrument/:id',
        {
            templateUrl: 'Instrument/Instrument/EditInstrument',
            controller: 'InstrumentController'
        })

        .when('/AddInstrumentReceiveDelivery',
        {
            templateUrl: 'Instrument/InstrumentReceiveDelivery/AddInstrumentReceiveDelivery',
            controller: 'InstrumentReceiveDeliveryController'
        })

        .when('/InstrumentReceiveDeliveryList',
        {
            templateUrl: 'Instrument/InstrumentReceiveDelivery/InstrumentReceiveDeliveryList',
            controller: 'InstrumentReceiveDeliveryController'
        })

        .when('/EditInstrumentReceiveDelivery/:id',
        {
            templateUrl: 'Instrument/InstrumentReceiveDelivery/EditInstrumentReceiveDelivery',
            controller: 'InstrumentReceiveDeliveryController'
        })

         .when('/InstrumentReceiveDeliveryApprove',
        {
            templateUrl: 'Instrument/InstrumentReceiveDeliveryApprove/InstrumentReceiveDeliveryApprove',
            controller: 'InstrumentReceiveDeliveryApproveController'
        })



        //Investor
        .when('/InvestorList',
        {
            templateUrl: 'InvestorManagement/Investor/InvestorList',
            controller: 'InvestorController'
        })
          .when('/AddNewInvestor',
        {
            templateUrl: 'InvestorManagement/Investor/AddNewInvestorTest',
            controller: 'InvestorController'
        })
        // .when('/AddNewInvestorTest',
        //{
        //    templateUrl: 'InvestorManagement/Investor/AddNewInvestorTest',
        //    controller: 'InvestorController'
        //})
          .when('/EditInvestor/:id',
        {
            templateUrl: 'InvestorManagement/Investor/EditInvestor',
            controller: 'InvestorController'
        })
         .when('/EditInvestorTest/:id',
        {
            templateUrl: 'InvestorManagement/Investor/EditInvestorTest',
            controller: 'InvestorController'
        })
        .when('/AddNewJoinHolder',
        {
            templateUrl: 'InvestorManagement/JoinHolder/AddNewJoinHolder',

            controller: 'JoinHolderController'
        })
         .when('/JoinHolderList',
        {
            templateUrl: 'InvestorManagement/JoinHolder/JoinHolderList',
            controller: 'JoinHolderController'
        })
         .when('/EditJoinHolder/:id',
        {
            templateUrl: 'InvestorManagement/JoinHolder/EditJoinHolder',
            controller: 'JoinHolderController'
        })
        // Introducer
        // added by: rifad
        // date: 13-5-2017
         .when('/IntroducerList',
        {
            templateUrl: 'InvestorManagement/Introducer/IntroducerList',
            controller: 'IntroducerController'
        })
         .when('/UpdateIntroducerInfomation/:id',
        {
            templateUrl: 'InvestorManagement/Introducer/EditIntroducer',
            controller: 'IntroducerController'
        })
        .when('/AddNewIntroducer/',
        {
            templateUrl: 'InvestorManagement/Introducer/AddNewIntroducer',
            controller: 'IntroducerController'
        })
        // added by: rifad
        // date: 17-5-2017
        // Omnibus
         .when('/OmnibusList',
        {
            templateUrl: 'InvestorManagement/Omnibus/OmnibusList',
            controller: 'OmnibusController'
        })
         .when('/UpdateOmnibusInfomation/:id',
        {
            templateUrl: 'InvestorManagement/Omnibus/EditOmnibus',
            controller: 'OmnibusController'
        })
        .when('/AddNewOmnibus/',
        {
            templateUrl: 'InvestorManagement/Omnibus/AddNewOmnibus',
            controller: 'OmnibusController'
        })

        // route for Transaction module


        //Cash And Cheque Receive
        .when('/FundReceive', {
            templateUrl: 'Transaction/CashChequeReceive/CashAndChequeReceive',
            controller: 'CashChequeReceiveController'

        })
        .when('/FundReceiveList', {
            templateUrl: 'Transaction/CashChequeReceive/CashAndChequeReceiveList',
            controller: 'CashChequeReceiveController'

        })
        .when('/EditFundReceive/:id', {
            templateUrl: 'Transaction/CashChequeReceive/EditCashAndChequeReceive',
            controller: 'CashChequeReceiveController'

        })

        //Receive Approve
        .when('/ReceiveApprove', {
            templateUrl: 'Transaction/ReceiveApprove/FundReceiveApprove',
            controller: 'ReceiveApproveController'

        })

        //Cheque Deposit to bank
        .when('/CheqDepToBank', {
            templateUrl: 'Transaction/ChequeDepositToBank/CheqDepositToBank',
            controller: 'ChequeDepositToBankController'

        })

        //Clear Cheque
        .when('/CheqClr', {
            templateUrl: 'Transaction/ChequeClear/ChequeClr',
            controller: 'ChequeClearController'

        })

        //Cheque Dishonor
        .when('/CheqDishonor', {
            templateUrl: 'Transaction/ChequeDishonor/CheqDishonor',
            controller: 'ChequeDishonorController'

        })
        .when('/Manage', {
            templateUrl: 'Transaction/ChequeDishonor/CheqDishonor',
        })

        //Fund Withdrawal Request
        .when('/FundWithdrawalRequest', {
            templateUrl: 'Transaction/FundWithdrawalRequest/FndWithdrawalRequest',
            controller: 'FundWithdrawalRequestController'

        })
        .when('/FundWithdrawalRequestList', {
            templateUrl: 'Transaction/FundWithdrawalRequest/FndWithdrawalReqList',
            controller: 'FundWithdrawalRequestController'

        })
        .when('/EditFundWithdrawalRequest/:id', {
            templateUrl: 'Transaction/FundWithdrawalRequest/EditFndWithdrawalReq',
            controller: 'FundWithdrawalRequestController'

        })

        //Fund Withdrawal Request Approve
        .when('/FundWithdrawalRequestApprove', {
            templateUrl: 'Transaction/FundWithdrawalRequestApprove/FndWithdrawalReqApprove',
            controller: 'FundWithdrawalRequestApproveController'

        })

        //Fund Withdrawal Request Cancel
        .when('/FundWithdrawalRequestCancel', {
            templateUrl: 'Transaction/FundWithdrawalRequestCancel/FndWithdrawalCancel',
            controller: 'FundWithdrawalRequestCancelController'

        })

        //Fund Payment
        .when('/FundPayment', {
            templateUrl: 'Transaction/FundPayment/FndPayment',
            controller: 'FundPaymentController'

        })
        .when('/FundPaymentList', {
            templateUrl: 'Transaction/FundPayment/FundPaymentList',
            controller: 'FundPaymentController'

        })
        .when('/EditFundPayment/:id', {
            templateUrl: 'Transaction/FundPayment/EditFundPayment',
            controller: 'FundPaymentController'

        })

        //Payment Approve
        .when('/PaymentApprove', {
            templateUrl: 'Transaction/PaymentApprove/FundPaymentApprove',
            controller: 'PaymentApproveController'

        })

        //On Demand Charges
        .when('/OnDemandCharges', {
            templateUrl: 'Transaction/OnDemandCharge/OnDemandCharges',
            controller: 'OnDemandChargeController'

        })

        .when('/OnDemandChargetList', {
            templateUrl: 'Transaction/OnDemandCharge/OnDemandChargeList',
            controller: 'OnDemandChargeController'

        })

        //On Demand Charge Approve
        .when('/OnDemandChargeApprove', {
            templateUrl: 'Transaction/OnDemandChargeApprove/OnDemCharApprove',
            controller: 'OnDemandChargeApproveController'

        })

        //Fund Transfer
        .when('/FundTransfer', {
            templateUrl: 'Transaction/FundTransfer/FndTransfer',
            controller: 'FundTransferController'

        })
        .when('/FundTransferList', {
            templateUrl: 'Transaction/FundTransfer/FundTransferList',
            controller: 'FundTransferController'

        })
        .when('/EditFundTransfer/:id', {
            templateUrl: 'Transaction/FundTransfer/EditFundTransfer',
            controller: 'FundTransferController'

        })

        //Fund Transfer Approve
        .when('/FundTransferApprove', {
            templateUrl: 'Transaction/FundTransferApprove/FndTransferApprove',
            controller: 'FundTransferApproveController'

        })

        //Trade  Service
        .when('/CreateNonTradingDay',
        {
            templateUrl: 'Trade/Trade/CreateNonTradingDay',
            controller: 'NonTradingDayController'
        })
        .when('/CreateClosePriceFile',
        {
            templateUrl: 'Trade/Trade/CreateClosePriceFile',
            controller: 'PriceFileController'
        })
        .when('/CreateTradeFile',
        {
            templateUrl: 'Trade/Trade/CreateTradeFile',
            controller: 'TradeFileController'
        })
         .when('/EditLoadedData/:id',
        {
            templateUrl: 'Trade/Trade/EditLoadedData',
            controller: 'TradeFileController'
        })
         .when('/EditLoadedData',
        {
            templateUrl: 'Trade/Trade/CreateTradeFile',
            controller: 'TradeFileController'
        })
         .when('/ImportCashLimit',
        {
            templateUrl: 'Trade/ImportCashLimit/ImpCashLimit',
            controller: 'ImportCashLimitController'
        })
         .when('/ImportCashLimitList',
        {
            templateUrl: 'Trade/ImportCashLimit/ImpCashLimitList',
            controller: 'ImportCashLimitController'
        })
         .when('/ImportShareLimit',
        {
            templateUrl: 'Trade/ImportShareLimit/ImpShareLimit',
            controller: 'ImportShareLimitController'
        })
         .when('/ImportShareLimitList',
        {
            templateUrl: 'Trade/ImportShareLimit/ImpShareLimitList',
            controller: 'ImportShareLimitController'
        })
         .when('/ExportCashLimit',
        {
            templateUrl: 'Trade/ExportCashLimit/ExpCashLimit',
            controller: 'ExportCashLimitController'
        })
         .when('/ExportCashLimitList',
        {
            templateUrl: 'Trade/ExportCashLimit/ExpCashLimitList',
            controller: 'ExportCashLimitController'
        })
         .when('/ExportShareLimit',
        {
            templateUrl: 'Trade/ExportShareLimit/ExpShareLimit',
            controller: 'ExportShareLimitController'
        })
         .when('/ExportShareLimitList',
        {
            templateUrl: 'Trade/ExportShareLimit/ExpShareLimitList',
            controller: 'ExportShareLimitController'
        })
         .when('/ExportShareLimitList',
        {
            templateUrl: 'Trade/ExportShareLimit/ExpShareLimitList',
            controller: 'ExportShareLimitController'
        })

        .when('/ExportOmnibusTrade',
        {
            templateUrl: 'Trade/ExportTrade/ExportOmnibusTrade',
            controller: 'ExportOmnibusTradeController'
        })
         .when('/NonTradingDayList',
        {
            templateUrl: 'Trade/Trade/NonTradingDayList',
            controller: 'NonTradingDayController'
        })


        //Security Management
        //.when('/getOnlinePendingUsers',
        //{
        //    templateUrl: '/Account/GetPendingOnlineUserList',
        //    controller: 'GetPendingOnlineUserListController'

        //})

      



        // route for CDBL module


        //Import CDBL Transaction Files
        .when('/ImportCDBLTransactionFiles', {
            templateUrl: 'CDBL/ImportCDBL/ImportCDBLTransactionFiles',
            controller: 'ImportCDBLController'

        })
        //Search CDBL Transaction
        .when('/SearchCDBLTransaction', {
            templateUrl: 'CDBL/SearchCDBL/SearchCDBLTransaction',
            controller: 'SearchCDBLController'

        })
        //Process CDBL Transaction
        .when('/ProcessCDBLTransaction', {
            templateUrl: 'CDBL/ProcessCDBL/ProcessCDBLTransaction',
            controller: 'ProcessCDBLController'

        })
        .when('/PayInOut', {
            templateUrl: 'CDBL/PayInOut/PayInOut',
            controller: 'PayInOutController'

        })

        //Day Process Controller
        .when('/DayEndProcess',
        {
            templateUrl: '/ProcessManagement/DayProcess/DayEndProcess',
            controller: 'DayProcessController'
        })
        .when('/DataBackup',
        {
            templateUrl: '/ProcessManagement/ActivityProcess/DataBackup',
            controller: 'ActivityProcessController'
        })
        .when('/UploadImagesAndSignature',
        {
            templateUrl: '/ProcessManagement/ActivityProcess/UploadImagesAndSignature',
            controller: 'ImageUploadProcessController'
        })


        .when('/Register',
        {
            templateUrl: '/Account/Register',
            controller: 'RegisterController'
        })
        .when('/ChangePassword',
        {
            templateUrl: '/Account/ChangePassword',
            controller: 'ChangePasswordController'
        })
        .when('/UserList',
        {
            templateUrl: '/Account/UserList',
            controller: 'UserListController'
        })
        .when('/EditUser/:id',
        {
            templateUrl: '/Account/EditUser',
            controller: 'UserListController'
        })
         .when('/ResetPassword/:id',
        {
            templateUrl: '/Account/ResetPassword',
            controller: 'ResetPasswordController'
        })
        .when('/UserActionMapping',
        {
            templateUrl: '/Account/UserActionMapping',
            controller: 'UserPermissionController'
        })
        .when('/UserReportActionMapping',
        {
            templateUrl: '/Account/UserReportActionMapping',
            controller: 'UserPermissionController'
        })

        .when('/ForceLogOffUser',
        {
            templateUrl: '/Account/ForceLogOffUser',
            controller: 'ForceLogOffController'
        })
        // route for System management

         .when('/ModuleList',
        {
            templateUrl: '/SystemManagement/Module/ModuleList',
            controller: 'ModuleController'
        })

        .when('/NewModule',
        {
            templateUrl: '/SystemManagement/Module/NewModule',
            controller: 'ModuleController'
        })
        .when('/EditModule/:id',
        {
            templateUrl: '/SystemManagement/Module/EditModule',
            controller: 'ModuleController'
        })
        .when('/BrokerModuleMapping',
        {
            templateUrl: '/SystemManagement/BrokerModuleMapping/BrokerModuleMapping',
            controller: 'BrokerModuleMappingController'
        })

        .when('/ControllerList',
        {
            templateUrl: '/SystemManagement/Controller/ControllerList',
            controller: 'ControllerController'
        })
        .when('/NewController',
        {
            templateUrl: '/SystemManagement/Controller/NewController',
            controller: 'ControllerController'
        })
        .when('/EditController/:id',
        {
            templateUrl: '/SystemManagement/Controller/EditController',
            controller: 'ControllerController'
        })
        .when('/EditAction/:id',
        {
            templateUrl: '/SystemManagement/Action/EditAction',
            controller: 'ActionController'
        })
        .when('/ActionList',
        {
            templateUrl: '/SystemManagement/Action/ActionList',
            controller: 'ActionController'
        })
         .when('/NewAction',
        {
            templateUrl: '/SystemManagement/Action/NewAction',
            controller: 'ActionController'
        })
        .when('/EditReport/:id',
        {
            templateUrl: '/SystemManagement/Action/EditReport',
            controller: 'ActionController'
        })
        .when('/ReportList',
        {
            templateUrl: '/SystemManagement/Action/ReportList',
            controller: 'ActionController'
        })
         .when('/NewReport',
        {
            templateUrl: '/SystemManagement/Action/NewReport',
            controller: 'ActionController'
        })
        .when('/NewBroker',
        {
            templateUrl: '/SystemManagement/Broker/NewBroker',
            controller: 'BrokerController'
        })


        //Service
        .when('/Email',
        {
            templateUrl: '/Service/Email/Email',
            controller: 'EmailController'
        })

         .when('/ExportExcelForSMS',
        {
            templateUrl: '/Service/ExportExcelForSMS/ExcelExportForSMS',
            controller: 'ExportExcelForSMSController'
        })


        //Order
        .when('/PendingOrder',
        {
            templateUrl: '/Order/PendingOrder/PendingOrderList',
            controller: 'PendingOrderController'
        })

         .when('/OrderPlaced',
        {
            templateUrl: '/Order/OrderPlaced/OrderPlacedList',
            controller: 'OrderPlacedController'
        })


        // route for Reports module

        .when('/Report/:id', {
            templateUrl: function (params) { return 'Reports/Report/ViewReport/' + params.id }
            //controller: 'ReportController'

        })

        .when('client_receivable_payable_temp.xlsx',
        {
            templateUrl: '~/App_Data/template/client_receivable_payable_temp.xlsx'
        })


        .when('/getOnlinePendingUsers',
        {
            templateUrl: '/Account/GetPendingOnlineUserList',
            controller: 'GetPendingOnlineUserListController'
        })

         .when('/getOnlineApprovedUsers',
        {
            templateUrl: '/Account/GetApprovedOnlineUserList',
            controller: 'ApprovedOnlineUsersController'
        })

        //If link not found
    .otherWise
    {
        redirectTo: '/'
    }


});
