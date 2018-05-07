/*
	PLEASE CREATE PARTITION IN CBO.DBO.tbl_Client_Ledger WITH THE COLUMN DATE YEAR WISE.
	EXECUTE CBO.dbo.udp_ReProcessAverageGainLossFromBegining NULL, NULL -- First alter the Stored procedure for migration. Then better call from CBO database else its take long time
	PLEASE CREATE PARTITION IN CBO.DBO.TBL_INSTRUMENT_TRANSACTION_HISTORY WITH THE COLUMN TRADINGDATE YEAR WISE.
*/
--=======================================================START ALTER TABLE IF REQUIRED. NB: DONT AFRAID IF GET ERROR =======================================================
/*
ALTER TABLE broker.tblTrader ADD is_default numeric(1,0)
GO
ALTER TABLE Instrument.tblInstrument ADD market_type_id numeric(4,0) NULL
GO
ALTER TABLE broker.tblTrader ADD investor_range nvarchar(250)
GO
ALTER TABLE Accounting.tblBankBranch ADD district_id NUMERIC(4,0) NULL
GO
ALTER TABLE dbo.tblConstantObject ALTER COLUMN Purpose VARCHAR(150) NULL
GO
ALTER TABLE Investor.tblInvestor ALTER COLUMN bank_id NUMERIC(3,0) NULL
GO
ALTER TABLE Investor.tblInvestor ALTER COLUMN bank_branch_id NUMERIC(4,0) NULL
GO
ALTER TABLE Investor.tblInvestor ALTER COLUMN banc_account_no VARCHAR(20) NULL
GO
ALTER TABLE Investor.tblInvestor ALTER COLUMN sms_enabled NUMERIC(1,0) NOT NULL
GO
ALTER TABLE Investor.tblOmnibus ALTER COLUMN short_name VARCHAR(4) NOT NULL
GO
UPDATE Investor.tblInvestor SET sms_enabled=0 WHERE sms_enabled IS NULL
GO
ALTER TABLE Investor.tblNominee ALTER COLUMN relation_id NUMERIC(4,0) NULL
GO
ALTER TABLE Investor.tblInvestorTemp ALTER COLUMN bank_id NUMERIC(3,0) NULL
GO
ALTER TABLE Investor.tblInvestorTemp ALTER COLUMN bank_branch_id NUMERIC(4,0) NULL
GO
ALTER TABLE Investor.tblInvestorTemp ALTER COLUMN banc_account_no VARCHAR(20) NULL
GO
UPDATE Investor.tblInvestorTemp SET sms_enabled=0 WHERE sms_enabled IS NULL
GO
ALTER TABLE Investor.tblInvestorTemp ALTER COLUMN sms_enabled NUMERIC(1,0) NOT NULL
GO
ALTER TABLE Trade.tblTradeData ALTER COLUMN Quantity NUMERIC(15,0)
GO
ALTER TABLE Trade.tblTradeData ALTER COLUMN Unit_Price NUMERIC(30,10)
GO
ALTER TABLE Trade.tblTradeData ALTER COLUMN commission_rate NUMERIC(30,10)
GO
ALTER TABLE Trade.tblTradeData ALTER COLUMN commission_amount NUMERIC(30,10)
GO
ALTER TABLE Trade.tblTradeData ALTER COLUMN transaction_fee NUMERIC(30,10)
GO
ALTER TABLE Trade.tblTradeData ALTER COLUMN ait NUMERIC(30,10)
GO
ALTER TABLE broker.tblBrokerBankAccount ALTER COLUMN account_no VARCHAR(50)
GO
ALTER TABLE CDBL.tblCdblIpo ALTER COLUMN isin VARCHAR(12) NOT NULL
ALTER TABLE CDBL.tblCdblIpo ALTER COLUMN trans_date numeric(9,0) NOT NULL
ALTER TABLE CDBL.tblCdblIpo ALTER COLUMN bo_code VARCHAR(16) NOT NULL
ALTER TABLE CDBL.tblCdblIpo ALTER COLUMN qty numeric(15,0) NOT NULL
ALTER TABLE CDBL.tblCdblIpo ALTER COLUMN lock_qty numeric(15,0) NOT NULL 
ALTER TABLE CDBL.tblCdblIpo ADD unloak_date numeric(9,0)
ALTER TABLE CDBL.tblCdblIpo ADD sold_qty numeric(15,0)
ALTER TABLE CDBL.tblCdblIpo ALTER COLUMN transaction_date numeric(9,0) NOT NULL
*/

/*
CREATE TABLE tmpBank
(
	 routing_no VARCHAR(20) NULL
	,bank_name VARCHAR(250) NULL
	,branch_name VARCHAR(250) NULL
	,district VARCHAR(250) NULL
)

NB: PLEASE COPY DATA FROM "BANK ROUTING.xls" EXCEL FILE AND PASTE IT TO "tmpBank"
*/
--=======================================================END ALTER TABLE IF REQUIRED. NB: DONT AFRAID IF GET ERROR =======================================================
DECLARE 
	 @MIGRATION_DATE AS NUMERIC(9,0)
	,@ACTIVE_STATUS_ID AS NUMERIC(4,0)
	,@MEMBERSHIP_ID AS NUMERIC(9,0)
	,@USER_ID AS VARCHAR(128)
	,@ACCOUNT_TYPE_ID AS NUMERIC(4,0)
	,@OPERATION_TYPE_ID AS NUMERIC(4,0)
	,@JOINT_OPERATION_TYPE_ID AS NUMERIC(4,0)
	,@DISTRICT_TYPE_ID AS NUMERIC(4,0)
	,@THANA_TYPE_ID AS NUMERIC(4,0)
	,@DEFAULT_BRANCH_ID AS NUMERIC(2,0)
	,@DEFAULT_DEPARTMENT_ID AS NUMERIC(4,0)
	,@DEFAULT_DESIGNATION_ID AS NUMERIC(4,0)
	,@DEFAULT_GENDER_ID AS NUMERIC(4,0)
	,@DEFAULT_EMPLOYEE_ID AS NUMERIC(5,0)
	,@DEFAULT_IPO_TYPE_ID AS NUMERIC(4,0)
	,@DEFAULT_TRADE_TYPE_ID AS NUMERIC(4,0)
	,@DEFAULT_TRADER_ID AS NUMERIC(4,0)
	,@DEFAULT_INSTRUMENT_TYPE_ID AS NUMERIC(4,0)
	,@DEFAULT_DEPOSITORY_COMPANY_ID AS NUMERIC(4,0)
	,@DEFAULT_GROUP_ID AS NUMERIC(4,0)
	,@DEFAULT_SECTOR_ID AS NUMERIC(4,0)
	,@DEFAULT_INTRODUCER_TYPE_ID AS NUMERIC(4,0)
	,@DEFAULT_OCCUPATION_ID AS NUMERIC(4,0)
	,@BROKER AS NUMERIC(4,0)
	,@CDBL AS NUMERIC(4,0)
	,@EXCHANGE AS NUMERIC(4,0)
	,@BROK_COMM_CHARGE_ID AS NUMERIC(3,0)
	,@OMNIBUS_OPERATION_TYPE_ID AS NUMERIC(4,0)
	,@M_TRADE_TYPE_ID AS NUMERIC(4,0)
	,@DSE_STOCK_EXCHANGE_ID AS NUMERIC(4,0)
	,@TRADE_DATE AS NUMERIC(9,0)
	,@PRV_TRADE_DATE AS DATETIME
	,@cash_account_type_id AS NUMERIC(4,0)
	,@NON_TRADING_DAY_TYPE_ON_DEMAND_ID AS NUMERIC(4,0)
	,@NON_TRADING_DAY_TYPE_WEEKLY_ID AS NUMERIC(4,0)
	,@NON_TRADING_DAY_TYPE_YEARLY_ID AS NUMERIC(4,0)
	,@CLOSED_ACTIVE_STATUS_ID AS NUMERIC(4,0)
	,@DEFAULT_TRANSACTION_ON_ID AS NUMERIC(4,0)
	,@LB_TRANSACTION_ON_ID AS NUMERIC(4,0)
	,@DEFAULT_MARKET_TYPE_ID AS NUMERIC(4,0)
	,@DEFAULT_TRADER AS VARCHAR(10)
	,@CH_transaction_mode_id AS NUMERIC(4,0)
	,@CS_transaction_mode_id AS NUMERIC(4,0)
	,@deposit_bank_branch_id AS NUMERIC(9,0)

SET @cash_account_type_id=dbo.sfun_get_constant_object_default_value_id('INVESTOR_ACC_TYPE')
SET @DSE_STOCK_EXCHANGE_ID=dbo.sfun_get_constant_object_value_id('STOCK_EXCHANGE','Dhaka Stock Exchange Limited')
SELECT @DEFAULT_DEPARTMENT_ID=DBO.sfun_get_constant_object_default_value_id('DEPARTMENT')
SELECT @DEFAULT_DESIGNATION_ID=DBO.sfun_get_constant_object_default_value_id('DESIGNATION')
SELECT @DEFAULT_GENDER_ID=DBO.sfun_get_constant_object_default_value_id('GENDER')
SELECT @DEFAULT_IPO_TYPE_ID=DBO.sfun_get_constant_object_default_value_id('IPO_TYPE')
SELECT @DEFAULT_TRADE_TYPE_ID=DBO.sfun_get_constant_object_default_value_id('TRADE_TYPE')
SELECT @DEFAULT_TRADER=trader_code, @DEFAULT_TRADER_ID=id FROM broker.tblTrader WHERE is_default=1
SELECT @MEMBERSHIP_ID=membership_id FROM [Escrow.Security].dbo.tblBrokerInformation
SET @DISTRICT_TYPE_ID=(SELECT object_id FROM tblConstantObject WHERE object_name='DISTRICT')
SET @THANA_TYPE_ID=(SELECT object_id FROM tblConstantObject WHERE object_name='THANA')
SELECT @MIGRATION_DATE=CAST(CONVERT(VARCHAR,MAX(CAST(SUBSTRING(Date,7,4) + '-' + SUBSTRING(Date,4,2) + '-' + SUBSTRING(Date,1,2) AS DATE)),112) AS numeric) FROM CBO.DBO.L_tbl_Tesa_Trades
SET @ACTIVE_STATUS_ID=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
SET @USER_ID = (SELECT TOP 1 UserId FROM [Escrow.Security].dbo.tblBrokerUser WHERE membership_id=@MEMBERSHIP_ID AND is_admin=1)
SET @ACCOUNT_TYPE_ID=dbo.sfun_get_constant_object_default_value_id('INVESTOR_ACC_TYPE')
SET @OPERATION_TYPE_ID=dbo.sfun_get_constant_object_default_value_id('INVESTOR_OPERATION_TYPE')
SET @JOINT_OPERATION_TYPE_ID=dbo.sfun_get_constant_object_value_id('INVESTOR_OPERATION_TYPE','Joint Holders')
SET @DEFAULT_INSTRUMENT_TYPE_ID=dbo.sfun_get_constant_object_default_value_id('INSTRUMENT_TYPE')
SET @DEFAULT_DEPOSITORY_COMPANY_ID=dbo.sfun_get_constant_object_default_value_id('DEPOSITORY_COMPANY')
SET @DEFAULT_GROUP_ID=dbo.sfun_get_constant_object_default_value_id('INSTRUMENT_GROUP')
SET @DEFAULT_SECTOR_ID=dbo.sfun_get_constant_object_default_value_id('INSTRUMENT_SECTOR')
SET @DEFAULT_INTRODUCER_TYPE_ID=dbo.sfun_get_constant_object_default_value_id('INTRODUCER_TYPE')
SET @DEFAULT_OCCUPATION_ID=dbo.sfun_get_constant_object_default_value_id('OCCUPATION')
SET @DEFAULT_BRANCH_ID = (SELECT TOP 1 id FROM broker.tblBrokerBranch)
SET @DEFAULT_EMPLOYEE_ID=(SELECT TOP 1 id FROM broker.tblEmployee)
SET @BROKER=dbo.sfun_get_constant_object_value_id('CHARGE_TYPE','BROKER')
SET @CDBL=dbo.sfun_get_constant_object_value_id('CHARGE_TYPE','CDBL')
SET @EXCHANGE=dbo.sfun_get_constant_object_value_id('CHARGE_TYPE','EXCHANGE')
SET @OMNIBUS_OPERATION_TYPE_ID=dbo.sfun_get_constant_object_value_id('INVESTOR_OPERATION_TYPE','Omnibus')
SET @M_TRADE_TYPE_ID=dbo.sfun_get_constant_object_value_id('TRADE_TYPE','M')
SET @NON_TRADING_DAY_TYPE_ON_DEMAND_ID=dbo.sfun_get_constant_object_value_id('NON_TRADING_DAY_TYPE','On Demand')
SET @NON_TRADING_DAY_TYPE_WEEKLY_ID=dbo.sfun_get_constant_object_value_id('NON_TRADING_DAY_TYPE','Weekly')
SET @NON_TRADING_DAY_TYPE_YEARLY_ID=dbo.sfun_get_constant_object_value_id('NON_TRADING_DAY_TYPE','Yearly')
SET @CLOSED_ACTIVE_STATUS_ID=dbo.sfun_get_constant_object_value_id('ACTIVE_STATUS', 'CLOSE')
SET @DEFAULT_TRANSACTION_ON_ID=dbo.sfun_get_constant_object_default_value_id('TRANSACTION_ON')
SET @LB_TRANSACTION_ON_ID=dbo.sfun_get_constant_object_value_id('TRANSACTION_ON', 'LEDGER BALANCE')
SET @DEFAULT_MARKET_TYPE_ID=dbo.sfun_get_constant_object_default_value_id('MARKET_TYPE')
SET @CH_transaction_mode_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_MODE','CH')
SET @CS_transaction_mode_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_MODE','CS')
SELECT @deposit_bank_branch_id=id FROM broker.tblBrokerBankAccount WHERE is_default=1


--=======================================================START ADD DATE IN DIMENSION DATE TABLE BY CALLING STORED PROCEDURE=======================================================
--exec psp_generate_dimensionDate '2000-01-01', '2020-12-31'
--=======================================================END ADD DATE IN DIMENSION DATE TABLE BY CALLING STORED PROCEDURE=======================================================

--=======================================================START CONSTANT OBJECT TYPE AND ITS VALUES FROM EXCEL FILE=======================================================
/*
	--DELETE FROM dbo.tblConstantObject
	--DBCC CHECKIDENT ( 'dbo.tblConstantObject', RESEED, 0 )

	--DELETE FROM dbo.tblConstantObjectValue
	--DBCC CHECKIDENT ( 'dbo.tblConstantObjectValue', RESEED, 1 ) -- MUST DO IT
	
	INSERT INTO dbo.tblConstantObject(object_name) VALUES('STOCK_EXCHANGE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'DHAKA STOCK EXCHANGE LIMITED',		object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='STOCK_EXCHANGE' UNION ALL 
	SELECT 'CHITTAGONG STOCK EXCHANGE LIMITED', object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='STOCK_EXCHANGE' 

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('MARKET_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'PUBLIC',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='MARKET_TYPE' UNION ALL 
	SELECT 'BLOCK',		object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='MARKET_TYPE' UNION ALL 
	SELECT 'BUYIN',		object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='MARKET_TYPE' UNION ALL 
	SELECT 'SPOT',		object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='MARKET_TYPE' UNION ALL 
	SELECT 'DEBT',		object_id,5,0 FROM dbo.tblConstantObject WHERE object_name='MARKET_TYPE' 

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('INSTRUMENT_SECTOR')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'BANK',							object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'CEMENT',						object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'CERAMICS SECTOR',				object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'CORPORATE BOND',				object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'DEBENTURE',						object_id,5,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'ENGINEERING',					object_id,6,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'FINANCIAL INSTITUTIONS',		object_id,7,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'FOOD & ALLIED',					object_id,8,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'FUEL & POWER',					object_id,9,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'INSURANCE',						object_id,10,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'IT SECTOR',						object_id,11,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'JUTE',							object_id,12,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'MISCELLANEOUS',					object_id,13,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'MUTUAL FUNDS',					object_id,14,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'PAPER & PRINTING',				object_id,15,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'PHARMACEUTICALS & CHEMICALS',	object_id,16,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'SERVICES & REAL ESTATE',		object_id,17,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'TANNERY INDUSTRIES',			object_id,18,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'TELECOMMUNICATION',				object_id,19,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'TEXTILE',						object_id,20,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'TRAVEL & LEISURE',				object_id,21,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR' UNION ALL
	SELECT 'TREASURY BOND',					object_id,22,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_SECTOR'  

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('INSTRUMENT_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'SHARE',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_TYPE' UNION ALL
	SELECT 'BOND',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_TYPE'
	
	INSERT INTO dbo.tblConstantObject(object_name) VALUES('DEPOSITORY_COMPANY')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'CDBL',		object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='DEPOSITORY_COMPANY' UNION ALL
	SELECT 'PHYSICAL',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='DEPOSITORY_COMPANY'
	
	INSERT INTO dbo.tblConstantObject(object_name) VALUES('INSTRUMENT_GROUP')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'N',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_GROUP' UNION ALL
	SELECT 'A',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_GROUP' UNION ALL
	SELECT 'B',	object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_GROUP' UNION ALL
	SELECT 'G',	object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_GROUP' UNION ALL
	SELECT 'Z',	object_id,5,0 FROM dbo.tblConstantObject WHERE object_name='INSTRUMENT_GROUP'
	
	INSERT INTO dbo.tblConstantObject(object_name) VALUES('INTRODUCER_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'EMPLOYEE',	object_id,1,0 FROM dbo.tblConstantObject WHERE object_name='INTRODUCER_TYPE' UNION ALL
	SELECT 'TRADER',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='INTRODUCER_TYPE' UNION ALL
	SELECT 'INVESTOR',	object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='INTRODUCER_TYPE' UNION ALL
	SELECT 'OTHER',		object_id,4,1 FROM dbo.tblConstantObject WHERE object_name='INTRODUCER_TYPE'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('INVESTOR_OPERATION_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'INDIVIDUAL',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='INVESTOR_OPERATION_TYPE' UNION ALL
	SELECT 'JOINT HOLDERS',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='INVESTOR_OPERATION_TYPE' UNION ALL
	SELECT 'OMNIBUS',		object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='INVESTOR_OPERATION_TYPE' UNION ALL
	SELECT 'COMPANY',		object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='INVESTOR_OPERATION_TYPE'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('INVESTOR_ACC_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'CASH',		object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='INVESTOR_ACC_TYPE' UNION ALL
	SELECT 'MARGIN',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='INVESTOR_ACC_TYPE'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('INVESTOR_SUB_ACC')
	
	INSERT INTO dbo.tblConstantObject(object_name) VALUES('IPO_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'RB',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='IPO_TYPE' UNION ALL
	SELECT 'ASI',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='IPO_TYPE' UNION ALL
	SELECT 'FI',	object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='IPO_TYPE' UNION ALL
	SELECT 'MF',	object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='IPO_TYPE' UNION ALL
	SELECT 'NRB',	object_id,5,0 FROM dbo.tblConstantObject WHERE object_name='IPO_TYPE'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('TRADE_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'N',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='TRADE_TYPE' UNION ALL
	SELECT 'D',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='TRADE_TYPE' UNION ALL
	SELECT 'F',	object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='TRADE_TYPE' UNION ALL
	SELECT 'I',	object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='TRADE_TYPE' UNION ALL
	SELECT 'M',	object_id,5,0 FROM dbo.tblConstantObject WHERE object_name='TRADE_TYPE' UNION ALL
	SELECT 'O',	object_id,6,0 FROM dbo.tblConstantObject WHERE object_name='TRADE_TYPE' UNION ALL
	SELECT 'R',	object_id,7,0 FROM dbo.tblConstantObject WHERE object_name='TRADE_TYPE' 

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('ACTIVE_STATUS')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'ACTIVE',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='ACTIVE_STATUS' UNION ALL
	SELECT 'CLOSE',		object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='ACTIVE_STATUS' UNION ALL
	SELECT 'INACTIVE',	object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='ACTIVE_STATUS' UNION ALL
	SELECT 'SUSPENSE',	object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='ACTIVE_STATUS'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('TRANSACTION_MODE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'CS',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_MODE' UNION ALL
	SELECT 'CH',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_MODE' UNION ALL
	SELECT 'ET',	object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_MODE' UNION ALL
	SELECT 'DD',	object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_MODE' UNION ALL
	SELECT 'TT',	object_id,5,0 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_MODE' UNION ALL
	SELECT 'PO',	object_id,6,0 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_MODE'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('TRANSACTION_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'RECEIVE',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_TYPE' UNION ALL
	SELECT 'WITHDRAW',		object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_TYPE'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('TRANSACTION_ON')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'NOT APPLICABLE',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_ON' UNION ALL
	SELECT 'AVAILABLE BALANCE',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_ON' UNION ALL
	SELECT 'LEDGER BALANCE',	object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_ON' UNION ALL
	SELECT 'PURCHASE POWER',	object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='TRANSACTION_ON'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('CHARGE_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'BROKER',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='CHARGE_TYPE' UNION ALL
	SELECT 'CDBL',		object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='CHARGE_TYPE' UNION ALL
	SELECT 'EXCHANGE',	object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='CHARGE_TYPE'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('NON_TRADING_DAY_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'ON DEMAND',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='NON_TRADING_DAY_TYPE' UNION ALL
	SELECT 'WEEKLY',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='NON_TRADING_DAY_TYPE' UNION ALL
	SELECT 'YEARLY',	object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='NON_TRADING_DAY_TYPE'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('FINANCIAL_LEDGER_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'ACCOUNT OPENING FEE',		object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'CHARGE APPLY',				object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'BUY/SALE',					object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'COST_VALUE/MARKET_VALUE',	object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'IPO',						object_id,5,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'DEPOSIT',					object_id,6,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'WITHDRAW',					object_id,7,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'TRANSFER IN OUT',			object_id,8,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'CASH DIVIDEND',				object_id,9,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'FUND MATURE',				object_id,10,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'WITHDRAW REQUEST',			object_id,11,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE' UNION ALL
	SELECT 'REVERSE BUY/SALE',			object_id,12,0 FROM dbo.tblConstantObject WHERE object_name='FINANCIAL_LEDGER_TYPE'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('SHARE_LEDGER_TYPE')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'IPO',					object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'BUY/SALE',				object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'TRANSMISSION',			object_id,3,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'BONUS/RIGHTS',			object_id,4,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'SHARE SETTLEMENT',		object_id,5,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'MANUAL IN/OUT',			object_id,6,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'PLEDGE',				object_id,7,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'UNPLEDGE',				object_id,8,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'MANUAL LOCK',			object_id,9,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'UNLOCK',				object_id,10,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'DEVIDEND RECEIVABLE',	object_id,11,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE' UNION ALL
	SELECT 'REVERSE BUY/SALE',		object_id,12,0 FROM dbo.tblConstantObject WHERE object_name='SHARE_LEDGER_TYPE'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('GENDER')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'MALE',		object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='GENDER' UNION ALL
	SELECT 'FEMALE',	object_id,2,0 FROM dbo.tblConstantObject WHERE object_name='GENDER'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('DEPARTMENT')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'IT',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='DEPARTMENT'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('DESIGNATION')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'IT HEAD',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='DESIGNATION'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('OCCUPATION')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'SERVICE HOLDER',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='OCCUPATION'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('COUNTRY')
	INSERT INTO dbo.tblConstantObjectValue(display_value,object_id,sorting_order,is_default) 
	SELECT 'BANGLADESH',	object_id,1,1 FROM dbo.tblConstantObject WHERE object_name='COUNTRY'

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('DISTRICT')

	INSERT INTO dbo.tblConstantObject(object_name) VALUES('THANA')

*/
--=======================================================END CONSTANT OBJECT TYPE AND ITS VALUES FROM EXCEL FILE=======================================================

--=======================================================START ADD RUNNING DAY IN DAY PROCESS=======================================================
--DELETE FROM tblDayProcess
--INSERT INTO tblDayProcess(process_date,start_date,start_by,membership_id) VALUES(@MIGRATION_DATE,GETDATE(),@USER_ID,@MEMBERSHIP_ID)
--=======================================================END ADD RUNNING DAY IN DAY PROCESS=======================================================


--=======================================================START ADD BROKER BRANCH=======================================================
--DELETE FROM broker.tblBrokerBranch
--DBCC CHECKIDENT ( 'broker.tblBrokerBranch', RESEED, 0 )

--INSERT INTO broker.tblBrokerBranch(name, ipo_branch_code,address,registration_dt,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT BranchName name, BranchID ipo_branch_code,BranchLocation address,@MIGRATION_DATE registration_dt,@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty 
--FROM CBO.DBO.LU_tbl_TradingBranch
--=======================================================END ADD BROKER BRANCH=======================================================

--=======================================================START Add Employee =======================================================
--DELETE FROM broker.tblEmployee
--DBCC CHECKIDENT ( 'broker.tblEmployee', RESEED, 0 )

--INSERT INTO broker.tblEmployee(employee_code,name,branch_id,department_id,designation_id,gender_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--VALUES('EMP001', 'IT HEAD', @DEFAULT_BRANCH_ID, @DEFAULT_DEPARTMENT_ID, @DEFAULT_DESIGNATION_ID, @DEFAULT_GENDER_ID,@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID,GETDATE(),0 )
--=======================================================START Add Employee =======================================================

--======================================================= Employee User Mapping =======================================================

--=======================================================START Add Trader =======================================================
--DELETE FROM broker.tblTrader
--DBCC CHECKIDENT ( 'broker.tblTrader', RESEED, 0 )

--INSERT INTO broker.tblTrader(trader_code,employee_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,branch_id,is_default)
--SELECT distinct TradeCounter trader_code, @DEFAULT_EMPLOYEE_ID,@ACTIVE_STATUS_ID,@MEMBERSHIP_ID, @USER_ID, GETDATE(),0,@DEFAULT_BRANCH_ID,0 from CBO.dbo.L_tbl_Tesa_Trades
--where len(tradecounter)=10 OR TradeCounter LIKE '%DLR%'

--UPDATE broker.tblTrader SET is_default=1 WHERE trader_code='BANTRDR001'
--UPDATE broker.tblTrader SET investor_range='1-4099,5000-5099,6001-7099,8000-19999,25001-29999' WHERE trader_code='BANTRDR001'
--UPDATE broker.tblTrader SET investor_range='4100-4999' WHERE trader_code='BANTRDR002'
--UPDATE broker.tblTrader SET investor_range='5100-5999' WHERE trader_code='BANTRDR005'
--UPDATE broker.tblTrader SET investor_range='35001-45000' WHERE trader_code='BANTRDR007'
--UPDATE broker.tblTrader SET investor_range='7100-7999' WHERE trader_code='BANTRDR009'
--UPDATE broker.tblTrader SET investor_range='45001-48000' WHERE trader_code='BANTRDR012'
--UPDATE broker.tblTrader SET investor_range='48001-50000' WHERE trader_code='BANTRDR013'
--UPDATE broker.tblTrader SET investor_range='50001-52000' WHERE trader_code='BANTRDR014'
--UPDATE broker.tblTrader SET investor_range='52001-55000' WHERE trader_code='BANTRDR015'
--UPDATE broker.tblTrader SET investor_range='20000-25000' WHERE trader_code='BANTRDR016'
--UPDATE broker.tblTrader SET investor_range='55005-56500' WHERE trader_code='BANTRDR017'
--UPDATE broker.tblTrader SET investor_range='56501-57000' WHERE trader_code='BANTRDR018'

--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='HEAD OFFICE') WHERE trader_code='BANTRDR001'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Al-Hamra') WHERE trader_code='BANTRDR002'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='HEAD OFFICE') WHERE trader_code='BANTRDR003'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='HEAD OFFICE') WHERE trader_code='BANTRDR004'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Al-Hamra') WHERE trader_code='BANTRDR005'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='HEAD OFFICE') WHERE trader_code='BANTRDR006'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='RN Tower') WHERE trader_code='BANTRDR007'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='HEAD OFFICE') WHERE trader_code='BANTRDR008'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Moulovibazar') WHERE trader_code='BANTRDR009'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Moulovibazar') WHERE trader_code='BANTRDR010'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='RN Tower') WHERE trader_code='BANTRDR011'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Sreemangal') WHERE trader_code='BANTRDR012'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Sreemangal') WHERE trader_code='BANTRDR013'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Palton') WHERE trader_code='BANTRDR014'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Palton') WHERE trader_code='BANTRDR015'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Al-Hamra') WHERE trader_code='BANTRDR016'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Gulshan') WHERE trader_code='BANTRDR017'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Gulshan') WHERE trader_code='BANTRDR018'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Baitul') WHERE trader_code='BANTRDR019'
--UPDATE broker.tblTrader SET branch_id=(SELECT id FROM broker.tblBrokerBranch WHERE name='Baitul') WHERE trader_code='BANTRDR020'
--=======================================================END Add Trader =======================================================

--=======================================================START Add District =======================================================
--INSERT INTO tblConstantObjectValue(display_value, object_id)
--SELECT DISTINCT TB.district, @DISTRICT_TYPE_ID
--FROM tmpBank TB 
--	LEFT JOIN 
--	(SELECT object_id, object_value_id, display_value FROM tblConstantObjectValue WHERE object_id=@DISTRICT_TYPE_ID) COV
--		ON TB.district=COV.display_value
--WHERE COV.display_value IS NULL

--UPDATE CBO.dbo.LU_tbl_District SET DistrictName='MOULVI BAZAR' WHERE DistrictName='Moulvibazar'

--INSERT INTO dbo.tblConstantObjectValue(display_value,object_id)
--SELECT DISTINCT TB.DistrictName, @DISTRICT_TYPE_ID
--FROM CBO.dbo.LU_tbl_District TB 
--	LEFT JOIN 
--	(SELECT object_id, object_value_id, display_value FROM tblConstantObjectValue WHERE object_id=@DISTRICT_TYPE_ID) COV
--		ON TB.DistrictName=COV.display_value
--WHERE COV.display_value IS NULL
--=======================================================END Add District =======================================================


--=======================================================START Add Thana =======================================================
--INSERT INTO dbo.tblConstantObjectValue(display_value,object_id)
--SELECT DISTINCT TB.ThanaName, @THANA_TYPE_ID
--FROM CBO.dbo.LU_tbl_Thana TB 
--	LEFT JOIN 
--	(SELECT object_id, object_value_id, display_value FROM tblConstantObjectValue WHERE object_id=@THANA_TYPE_ID) COV
--		ON TB.ThanaName=COV.display_value
--WHERE COV.display_value IS NULL
--=======================================================END Add Thana =======================================================

--=======================================================START ADD BANK AND BANK BRANCH INFORMATION FROM CDBL PROVIDED EXCEL FILE. ======================================================= 
-- NB: EXCEL FILE MUST IMPORT TO tmpBank BEFORE RUN THIS STEP 

--DELETE FROM Accounting.tblBankBranch
--DBCC CHECKIDENT ( 'Accounting.tblBankBranch', RESEED, 0 )

--DELETE FROM Accounting.tblBank
--DBCC CHECKIDENT ( 'Accounting.tblBank', RESEED, 0 )

--INSERT INTO Accounting.tblBank(short_name,bank_name,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT DISTINCT LEFT(bank_name,4) short_name, bank_name, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM tmpBank

--INSERT INTO Accounting.tblBankBranch(branch_name,routing_no,bank_id,district_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT TMP.branch_name, TMP.routing_no, TB.id bank_id, COV.object_value_id district_id, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM tmpBank TMP 
--	INNER JOIN Accounting.tblBank TB ON TMP.bank_name=TB.bank_name
--	INNER JOIN dbo.tblConstantObjectValue COV ON TMP.district=COV.display_value
--	INNER JOIN dbo.tblConstantObject TCO ON COV.object_id=TCO.object_id
--WHERE TCO.object_name='DISTRICT' 
--=======================================================END ADD BANK AND BANK BRANCH INFORMATION FROM CDBL PROVIDED EXCEL FILE. ======================================================= 

--=======================================================START Add DP Information=======================================================
-- NB: PLEASE CLEARING ACCOUNT NUMBER MANUALLY IN INSERT STATEMENT. IT IS MANDATORY 

--DELETE FROM broker.tblDepositoryPerticipant
--DBCC CHECKIDENT ( 'broker.tblDepositoryPerticipant', RESEED, 0 )

--INSERT INTO broker.tblDepositoryPerticipant(dp_no,clearance_no,bo_reference_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT DISTINCT RIGHT(LEFT(ISNULL('1202150000084869',''),8),5) dp_no,'1202150000084869', LEFT(ISNULL('1202150000084869',''),8) BORefNumber 
--	, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty

--INSERT INTO broker.tblDepositoryPerticipant(dp_no,clearance_no,bo_reference_no, omnibus_master_id, is_omnibus,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT DISTINCT RIGHT(LEFT(ISNULL('1605570048535541',''),8),5) dp_no,'1202150000084869', LEFT(ISNULL('1605570048535541',''),8) BORefNumber, '16478', 1 is_omnibus
--	, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--=======================================================END Add DP Information=======================================================

--=======================================================START Add Broker Bank Information=======================================================
--DELETE FROM broker.tblBrokerBankAccount
--DBCC CHECKIDENT ( 'broker.tblBrokerBankAccount', RESEED, 0 )

--INSERT INTO broker.tblBrokerBankAccount(bank_branch_id,account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,is_default)
--SELECT TBB.id,'STD Customer - 1090-297080-041',@ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty, 1 is_default
--FROM Accounting.tblBank TB
--	INNER JOIN Accounting.tblBankBranch TBB ON TB.id=TBB.bank_id
--WHERE short_name = 'IFIC'
--AND branch_name ='DHAKA STOCK EXCHANGE'

--INSERT INTO broker.tblBrokerBankAccount(bank_branch_id,account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,is_default)
--SELECT TBB.id,'STD - 1090-696441-041',@ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty, 0 is_default
--FROM Accounting.tblBank TB
--	INNER JOIN Accounting.tblBankBranch TBB ON TB.id=TBB.bank_id
--WHERE short_name = 'IFIC'
--AND branch_name ='SYLHET'

--INSERT INTO broker.tblBrokerBankAccount(bank_branch_id,account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,is_default)
--SELECT TBB.id,'STD - 1090-696444-041',@ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty, 0 is_default
--FROM Accounting.tblBank TB
--	INNER JOIN Accounting.tblBankBranch TBB ON TB.id=TBB.bank_id
--WHERE short_name = 'IFIC'
--AND branch_name ='SYLHET'

--INSERT INTO broker.tblBrokerBankAccount(bank_branch_id,account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,is_default)
--SELECT TBB.id,'STD Customer -1090-297080-041',@ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty, 0 is_default
--FROM Accounting.tblBank TB
--	INNER JOIN Accounting.tblBankBranch TBB ON TB.id=TBB.bank_id
--WHERE short_name = 'IFIC'
--AND branch_name ='DHAKA STOCK EXCHANGE'

--INSERT INTO broker.tblBrokerBankAccount(bank_branch_id,account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,is_default)
--SELECT TBB.id,'STD Customer -3047-2232239-001',@ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty, 0 is_default
--FROM Accounting.tblBank TB
--	INNER JOIN Accounting.tblBankBranch TBB ON TB.id=TBB.bank_id
--WHERE short_name = 'IFIC'
--AND branch_name ='SREE MANGAL'

--INSERT INTO broker.tblBrokerBankAccount(bank_branch_id,account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,is_default)
--SELECT TBB.id,'11100010457',@ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty, 0 is_default
--FROM Accounting.tblBank TB
--	INNER JOIN Accounting.tblBankBranch TBB ON TB.id=TBB.bank_id
--WHERE short_name = 'SOUT'
--AND branch_name ='MOULAVI BAZAR'

--INSERT INTO broker.tblBrokerBankAccount(bank_branch_id,account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,is_default)
--SELECT TBB.id,'00240320000559',@ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty, 0 is_default
--FROM Accounting.tblBank TB
--	INNER JOIN Accounting.tblBankBranch TBB ON TB.id=TBB.bank_id
--WHERE short_name = 'JAMU'
--AND branch_name ='MOTIJHEEL'
--=======================================================END Add Broker Bank Information=======================================================

--=======================================================START Add INTRODUCER Information=======================================================
--DELETE FROM Investor.tblIntroducer
--DBCC CHECKIDENT ( 'Investor.tblIntroducer', RESEED, 0 )

--INSERT INTO Investor.tblIntroducer(ref_code,introducer_name,introducer_type_id,occupation_id,commission_percentage,valid_from,valid_to,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT AgentID, AgentName, @DEFAULT_INTRODUCER_TYPE_ID,  @DEFAULT_OCCUPATION_ID, 0 commission_percentage, @MIGRATION_DATE, 20201230, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM CBO.dbo.LU_tbl_Agent
--=======================================================END Add INTRODUCER Information=======================================================

--=======================================================START Add Investor ======================================================= 

--	SELECT DISTINCT A.ClientID, TT.trader_code, TT.id
--	INTO #TT	
--	FROM broker.tblTrader TT
--		LEFT JOIN CBO.dbo.tbl_Client_Details A ON A.ClientID IN (SELECT * FROM DBO.udfSpliter(TT.investor_range) )
--		WHERE TT.investor_range IS NOT NULL

----DELETE FROM Investor.tblInvestor
--INSERT INTO Investor.tblInvestor(client_id,bo_refernce_id,bo_code,first_holder_name,account_type_id,operation_type_id,mailing_address,permanent_address
--	,thana_id,district_id,phone_no,mobile_no,email_address,beftn_enabled,email_enabled,internet_enabled,sms_enabled
--	,branch_id,opening_date,trader_id,introducer_id,ipo_type_id,trade_type_id
--	,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,export_st)
--SELECT TCD.ClientID, TDP.id bo_refernce_id, NULL bo_code
--	, CASE WHEN CHARINDEX('&', TCD.ClientName, 1)>0 THEN RTRIM(LEFT(TCD.ClientName,CHARINDEX('&', TCD.ClientName, 1)-1)) ELSE TCD.ClientName END first_holder_name
--	, @ACCOUNT_TYPE_ID account_type_id
--	, CASE WHEN CHARINDEX('&', TCD.ClientName, 1)>0 THEN @JOINT_OPERATION_TYPE_ID ELSE @OPERATION_TYPE_ID END operation_type_id
--	, TCD.Address mailing_address, TCD.Address permanent_address
--	, THANA.object_value_id thana_id, DISTRICT.object_value_id district_id, TCD.Telephone phone_no, TCD.Mobile mobile_no, TCD.Email email_address,0 beftn_enabled,0 email_enabled,0 internet_enabled,0 sms_enabled
--	, TBB.id branch_id, CAST(CONVERT(VARCHAR,TCD.EditDate,112) AS numeric) opening_date, ISNULL(TT.id,@DEFAULT_TRADER_ID) trader_id, TIND.id introducer_id, ISNULL(IPO_TYPE.object_value_id,@DEFAULT_IPO_TYPE_ID) ipo_type_id, ISNULL(TRADE_TYPE.object_value_id,@DEFAULT_TRADE_TYPE_ID) trade_type_id
--	, ISNULL(ACTIVE_STATUS.object_value_id,@ACTIVE_STATUS_ID) active_status_id, @MEMBERSHIP_ID membership_id, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty, 1 export_st
--FROM CBO.dbo.tbl_Client_Details TCD
--	LEFT JOIN broker.tblDepositoryPerticipant TDP ON LEFT(ISNULL(TCD.BONumber,''),8)=TDP.bo_reference_no
--	LEFT JOIN CBO.dbo.LU_tbl_Thana CTHANA ON TCD.Thana=CTHANA.ThanaID
--	LEFT JOIN (SELECT THANA.* FROM dbo.tblConstantObjectValue THANA 
--		INNER JOIN dbo.tblConstantObject THANA_TYPE ON THANA.object_id=THANA_TYPE.object_id WHERE object_name='THANA') THANA
--			ON CTHANA.ThanaName=THANA.display_value
--	LEFT JOIN CBO.dbo.LU_tbl_District CDIST ON TCD.District=CDIST.DistrictID
--	LEFT JOIN (SELECT DISTRICT.* FROM dbo.tblConstantObjectValue DISTRICT 
--		INNER JOIN dbo.tblConstantObject DISTRICT_TYPE ON DISTRICT.object_id=DISTRICT_TYPE.object_id WHERE object_name='DISTRICT') DISTRICT
--			ON CDIST.DistrictName=DISTRICT.display_value
--	LEFT JOIN CBO.dbo.LU_tbl_TradingBranch CBRANCH ON TCD.BranchID=CBRANCH.BranchID
--	LEFT JOIN broker.tblBrokerBranch TBB ON CBRANCH.BranchName=TBB.name
--	LEFT JOIN #TT TT ON TCD.ClientID=TT.ClientID
--	LEFT JOIN (SELECT IPO_TYPE.* 
--				, CASE WHEN IPO_TYPE.display_value = 'FI' THEN 'F'
--					WHEN IPO_TYPE.display_value = 'MF' THEN 'I'
--					WHEN IPO_TYPE.display_value = 'NRB' THEN 'R'
--					ELSE 'N'
--					END TRADE_TYPE_NAME
--				FROM dbo.tblConstantObjectValue IPO_TYPE 
--		INNER JOIN dbo.tblConstantObject IPO_TYPE_TYPE ON IPO_TYPE.object_id=IPO_TYPE_TYPE.object_id WHERE object_name='IPO_TYPE') AS IPO_TYPE
--			ON TCD.client_type=IPO_TYPE.display_value
--	LEFT JOIN (SELECT TRADE_TYPE.* FROM dbo.tblConstantObjectValue TRADE_TYPE 
--		INNER JOIN dbo.tblConstantObject TRADE_TYPE_TYPE ON TRADE_TYPE.object_id=TRADE_TYPE_TYPE.object_id WHERE object_name='TRADE_TYPE') AS TRADE_TYPE
--			ON IPO_TYPE.TRADE_TYPE_NAME=TRADE_TYPE.display_value
--	LEFT JOIN (SELECT ACTIVE_STATUS.* 
--				, CASE WHEN ACTIVE_STATUS.display_value = 'ACTIVE' THEN 1
--						WHEN ACTIVE_STATUS.display_value = 'CLOSE' THEN 2
--						WHEN ACTIVE_STATUS.display_value = 'INACTIVE' THEN 0
--						ELSE 3
--						END active_status_id
--				FROM dbo.tblConstantObjectValue ACTIVE_STATUS 
--		INNER JOIN dbo.tblConstantObject ACTIVE_STATUS_TYPE ON ACTIVE_STATUS.object_id=ACTIVE_STATUS_TYPE.object_id WHERE object_name='ACTIVE_STATUS') AS ACTIVE_STATUS
--			ON TCD.client_status=ACTIVE_STATUS.active_status_id
--	LEFT JOIN Investor.tblIntroducer TIND ON TCD.AgentAssigned=TIND.ref_code


--DROP TABLE #TT

--update Investor.tblInvestor set bo_code=null

--UPDATE INV
--SET INV.bo_code=TCD.BONumber
----SELECT * 
--FROM 
--	CBO.dbo.tbl_Client_Details TCD
--INNER JOIN 
--	Investor.tblInvestor INV
--	ON TCD.ClientID=INV.client_id
--WHERE client_status=1 AND LEN(ISNULL(BONumber,''))=16

--UPDATE INV
--SET INV.bo_refernce_id=TDP.id
--FROM
--	Investor.tblInvestor INV
--INNER JOIN 
--	broker.tblDepositoryPerticipant TDP
--	ON LEFT(ISNULL(INV.bo_code,''),8)=TDP.bo_reference_no
--WHERE LEN(ISNULL(INV.bo_code,''))=16

--;WITH CDBL AS 
--(
--	SELECT DISTINCT ClientID, BONumber, BOName
--	FROM CBO.dbo.L_tbl_CDBL_Holding
--)

--UPDATE TI
--SET first_holder_name=BOName
----SELECT * 
--FROM Investor.tblInvestor TI INNER JOIN CDBL ON TI.client_id=CDBL.ClientID

----------------------------Need manual update following bo info
--select client_id, first_holder_name
--from Investor.tblInvestor INV
--where bo_code is null and active_status_id=@ACTIVE_STATUS_ID 
--=======================================================END Add Investor ======================================================= 

--=======================================================START Add OMNIBUS ACCOUNT ======================================================= 
--DELETE FROM Investor.tblOmnibus

--INSERT INTO Investor.tblOmnibus(omnibus_id,name,short_name,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT client_id omnibus_id, first_holder_name name, 'BFIL' short_name, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM Investor.tblInvestor WHERE client_id='16478'
--=======================================================END Add OMNIBUS ACCOUNT ======================================================= 

--=======================================================START Add OMNIBUS INVESTORS ======================================================= 
--DELETE FROM Investor.tblInvestor WHERE omnibus_master_id='16478'

--UPDATE CBO.dbo.L_tbl_Tesa_Trades SET TradeCounter=LEFT(TradeCounter, LEN(TradeCounter)-2) + '0' + RIGHT(TradeCounter,2) WHERE LEN(TradeCounter)!=10 AND TradeCounter NOT LIKE '%DLR%'

--INSERT INTO Investor.tblInvestor(client_id,first_holder_name,account_type_id,operation_type_id,beftn_enabled,email_enabled,internet_enabled,sms_enabled
--	,branch_id,opening_date
--	,trader_id,ipo_type_id,trade_type_id, omnibus_master_id
--	,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,export_st)
--SELECT DISTINCT ClientID client_id, ClientID first_holder_name, @ACCOUNT_TYPE_ID account_type_id
--	, @OMNIBUS_OPERATION_TYPE_ID operation_type_id,0 beftn_enabled,0 email_enabled,0 internet_enabled,0 sms_enabled, TDR.branch_id
--	, CAST(CONVERT(VARCHAR,MIN(TTT.EditDate),112) AS numeric) opening_date
--	, MAX(TDR.id) trader_id, @DEFAULT_IPO_TYPE_ID
--	, @M_TRADE_TYPE_ID, '16478' omnibus_master_id, @active_status_id, @MEMBERSHIP_ID membership_id, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty, 1 export_st
--FROM CBO.dbo.L_tbl_Tesa_Trades TTT --608286
--LEFT JOIN Investor.tblInvestor INV ON TTT.ClientID=INV.client_id
--LEFT JOIN broker.tblTrader TDR ON TTT.TradeCounter=TDR.trader_code
--WHERE INV.client_id IS NULL
--GROUP BY ClientID, TDR.branch_id


--=======================================================END Add OMNIBUS INVESTORS ======================================================= 

--=======================================================START Add INVESTORS IN INVESTOR IMAGE ======================================================= 
--INSERT INTO Investor.tblInvestorImage(client_id)
--SELECT client_id FROM Investor.tblInvestor
--=======================================================END Add INVESTORS IN INVESTOR IMAGE ======================================================= 

--=======================================================START Add JOINT HOLDER =======================================================
--DELETE FROM Investor.tblJoinHolder

--INSERT INTO Investor.tblJoinHolder(client_id,join_holder_name,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT TCD.ClientID, CASE WHEN CHARINDEX('&', TCD.ClientName, 1)>0 THEN LTRIM(SUBSTRING(TCD.ClientName,CHARINDEX('&', TCD.ClientName, 1)+1,LEN(TCD.ClientName))) ELSE TCD.ClientName END
--	, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM Investor.tblInvestor TI INNER JOIN CBO.DBO.tbl_Client_Details TCD ON TI.client_id=TCD.ClientID
--WHERE ClientName LIKE '%&%'
--=======================================================END Add JOINT HOLDER =======================================================

--=======================================================START Add NOMINEE =======================================================
--DELETE FROM Investor.tblNominee
--DBCC CHECKIDENT ( 'Investor.tblNominee', RESEED, 0 )

--INSERT INTO Investor.tblNominee(client_id,nominee_name,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT ClientID, Nameofnominee, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM Investor.tblInvestor TI INNER JOIN CBO.DBO.tbl_Client_Details TCD ON TI.client_id=TCD.ClientID
--WHERE Nameofnominee IS NOT NULL
--=======================================================END Add NOMINEE =======================================================

--=======================================================START Add Instrument ======================================================= 

--DELETE FROM Instrument.tblInstrument
--DBCC CHECKIDENT ( 'Instrument.tblInstrument', RESEED, 0 )

--DELETE FROM CBO.dbo.LU_tbl_CompanyISIN WHERE ISINCode='BDO467WATA03'
--INSERT INTO Instrument.tblInstrument(isin,security_code,instrument_name,sector_id,instument_type_id,depository_company_id,face_value
--	,lot,is_marginable,group_id,is_foreign,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT ISINCode isin, LTRIM(RTRIM(TESACode)) security_code, TCI.ISINName instrument_name, @DEFAULT_SECTOR_ID sector_id, @DEFAULT_INSTRUMENT_TYPE_ID instument_type_id, @DEFAULT_DEPOSITORY_COMPANY_ID depository_company_id, FLOOR(ISNULL(TIP.IPOPrice,0)) face_value
--	, CASE WHEN ISNULL(IPO.CurrentBalance,0)>99999 THEN 0 ELSE ISNULL(IPO.CurrentBalance,0) END lot
--	, 0 is_marginable, ISNULL(INST_GROUP.object_value_id,@DEFAULT_GROUP_ID) group_id, 0 is_foreign, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, TCI.EditDate changed_date, 0 is_dirty
--FROM CBO.dbo.LU_tbl_CompanyISIN TCI
--	LEFT JOIN CBO.dbo.tbl_IPO_Prices TIP ON TCI.ISINCode=TIP.ISIN
--	LEFT JOIN (SELECT INST_GROUP.* FROM dbo.tblConstantObjectValue INST_GROUP 
--		INNER JOIN dbo.tblConstantObject INST_GROUP_TYPE ON INST_GROUP.object_id=INST_GROUP_TYPE.object_id WHERE object_name='INSTRUMENT_GROUP') INST_GROUP
--			ON TCI.TESAGroup=INST_GROUP.display_value
--	LEFT JOIN (SELECT ISIN, MIN(CurrentBalance) CurrentBalance FROM CBO.dbo.L_tbl_CDBL_IPO GROUP BY ISIN) IPO ON TCI.ISINCode=IPO.ISIN
--WHERE LEN(ISNULL(ISINCode,''))=12

--UPDATE CBO.dbo.tbl_Client_Ledger SET CashCheque=LTRIM(RTRIM(CashCheque)) WHERE CashCheque IS NOT NULL
--UPDATE CBO.dbo.tbl_Client_Ledger SET BS=LTRIM(RTRIM(BS)) WHERE BS IS NOT NULL

--UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'BEDL', 'BARKAPOWER')) WHERE Particulars LIKE '%BEDL%'
--UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'BDBUILDING', 'BBS')) WHERE Particulars LIKE '%BDBUILDING%'
--UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'FLEASEINT', 'FIRSTFIN')) WHERE Particulars LIKE '%FLEASEINT%'
--UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'APEXADELFT', 'APEXFOOT')) WHERE Particulars LIKE '%APEXADELFT%'
--UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'MTBL', 'MTB')) WHERE Particulars LIKE '%MTBL%'
--UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'ULC', 'UNITEDFIN')) WHERE Particulars LIKE '%ULC%'
--UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'BXTEX', 'BEXIMCO')) WHERE Particulars LIKE '%BXTEX%'
--UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'CTGVEG', 'CVOPRL')) WHERE Particulars LIKE '%CTGVEG%'
--UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'UCBL', 'UCB')) WHERE Particulars LIKE '%UCBL%'
--UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=RTRIM(LEFT(Particulars,CHARINDEX(' ',LTRIM(Particulars),1))) 
--	WHERE (ISNULL(BS,'')='BUY' OR ISNULL(BS,'')='SELL') AND CashCheque IS NULL AND CHARINDEX(' ',LTRIM(Particulars),1)>0
--UPDATE CBO.dbo.L_tbl_Tesa_Trades SET [O/P/S]='P' WHERE [O/P/S]='O'
--UPDATE CBO.dbo.L_tbl_Tesa_Trades SET TradeCounter=LEFT(TradeCounter, LEN(TradeCounter)-2) + '0' + RIGHT(TradeCounter,2) WHERE LEN(TradeCounter)!=10 AND TradeCounter NOT LIKE '%DLR%'

--INSERT INTO Instrument.tblInstrument(security_code,instrument_name,sector_id,instument_type_id,depository_company_id,face_value
--	,lot,is_marginable,group_id,is_foreign,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT DISTINCT Particulars, Particulars, @DEFAULT_SECTOR_ID, @DEFAULT_INSTRUMENT_TYPE_ID, @DEFAULT_DEPOSITORY_COMPANY_ID, 0 face_value
--	, 0 lot, 0 is_marginable, @DEFAULT_GROUP_ID, 0, @CLOSED_ACTIVE_STATUS_ID, @membership_id, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM CBO.dbo.tbl_Client_Ledger TCL
--	LEFT JOIN Instrument.tblInstrument INS ON TCL.Particulars=INS.security_code
--WHERE (ISNULL(BS,'')='BUY' OR ISNULL(BS,'')='SELL') AND CashCheque IS NULL AND Particulars != '--x--For' AND INS.id IS NULL AND TCL.ClientID IS NOT NULL

--;WITH TTT AS 
--(
--SELECT TTT.ISIN, TTT.[O/P/S]
--FROM CBO.dbo.L_tbl_Tesa_Trades TTT 
--WHERE cast(convert(varchar,ttt.EditDate,101)as date) =(SELECT MAX(cast(convert(varchar,TMP.EditDate,101)as date)) FROM CBO.dbo.L_tbl_Tesa_Trades TMP WHERE TMP.ISIN=TTT.ISIN)
--)

--UPDATE INS
--SET INS.market_type_id=ISNULL(MARKET_TYPE.object_value_id,@DEFAULT_MARKET_TYPE_ID)
----SELECT distinct INS.id, TTT.[O/P/S], MARKET_TYPE.display_value, MARKET_TYPE.object_value_id
--FROM Instrument.tblInstrument INS 
--	LEFT JOIN TTT ON INS.ISIN=TTT.ISIN
--	INNER JOIN (SELECT MARKET_TYPE.* FROM dbo.tblConstantObjectValue MARKET_TYPE 
--		INNER JOIN dbo.tblConstantObject MARKET_TYPE_TYPE ON MARKET_TYPE.object_id=MARKET_TYPE_TYPE.object_id WHERE object_name='MARKET_TYPE') MARKET_TYPE
--			ON ISNULL(TTT.[O/P/S],'P')=LEFT(MARKET_TYPE.display_value,1)
--=======================================================END Add Instrument =======================================================

--=======================================================START Add GLOBAL CHARGE SETTING======================================================= 
--DELETE FROM Charge.tblGlobalCharge
--DBCC CHECKIDENT ( 'Charge.tblGlobalCharge', RESEED, 0 )

--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('BROK', 'Brokerage Commission', 0.50, 0.00, 1, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('BO F', 'BO Maintenance Fee', 500.00, 500.00, 0, @CDBL, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('CUST', 'CDBL Custody Charge', 0.00, 0.00, 1, @CDBL, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('INT', 'Interest', 0.00, 0.00, 1, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('A.FEE', 'Account Opening Fee', 500.00, 500.00, 0, @CDBL, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('FT', 'Fund Transfer', 0.00, 0.00, 1, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('HW', 'Howla Charge', 0.00, 0.00, 0, @EXCHANGE, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('LAGA', 'Transaction Fee', 0.02, 0.00, 1, @EXCHANGE, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('AIT', 'AIT Charge', 0.05, 0.00, 1, @EXCHANGE, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('CCC', 'Cheque Clearance Charge', 0.00, 0.00, 0, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('CDC', 'Cheque Dishonour Charge', 0.00, 0.00, 0, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('ETC', 'BEFTN Charge', 0.00, 0.00, 0, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('CA', 'Corporate Actions', 0.00, 0.00, 1, @CDBL, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('de', 'Demat of Existing Securities', 0.00, 0.00, 1, @CDBL, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('IPO', 'Demat of new securities (IPO)', 0.00, 0.00, 1, @CDBL, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('ACC', 'Access Commission', 0.00, 0.00, 1, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('TR', 'Transfer', 0.00, 0.00, 1, @CDBL, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('BACC', 'Bulk A/C Transfer', 0.00, 0.00, 1, @CDBL, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('PLED', 'Pledging', 0.00, 0.00, 1, @CDBL, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('UP', 'Unpledging', 0.00, 0.00, 1, @CDBL, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('Email', 'Email Service Charge', 0.00, 0.00, 1, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('SMS', 'SMS Service Charge', 0.00, 0.00, 1, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('ISC', 'Internet Service Charge', 0.00, 0.00, 1, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('STOPA', 'Stop Payment', 575.00, 575.00, 0, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('IAF', 'IPO Application Fee', 0.00, 0.00, 0, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('IAC', 'IPO Application Charge', 5.00, 5.00, 0, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('IRF', 'IPO Refund Fee', 0.00, 0.00, 0, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--INSERT INTO Charge.tblGlobalCharge(short_code,name,charge_amount,minimum_charge,is_percentage,charge_type_id,effective_date,is_slab,income_account_no,active_status_id,membership_id,changed_user_id,changed_date,is_dirty) VALUES('IRC', 'IPO Refund Charge', 5.00, 5.00, 0, @BROKER, @MIGRATION_DATE, 0, '101010102', @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @user_id, GETDATE(), 0)
--=======================================================END Add GLOBAL CHARGE SETTING======================================================= 

--=======================================================START Add ACCOUNT TYPE SETTING======================================================= 
--INSERT INTO Charge.tblGlobalAccountTypeSetting(account_type_id,initial_deposit,minimum_balance_on,minimum_balance,minimum_balance_is_percentage
--	,withdraw_limit_on,withdraw_limit,withdraw_limit_percentage,loan_ratio,loan_max,loan_on,profit_on,active_status_id,membership_id
--	,changed_user_id,changed_date,is_dirty)
--SELECT @ACCOUNT_TYPE_ID, 0 initial_deposit, @DEFAULT_TRANSACTION_ON_ID minimum_balance_on, 0 minimum_balance, 0minimum_balance_is_percentage
--	, @DEFAULT_TRANSACTION_ON_ID withdraw_limit_on,50000000 withdraw_limit,0 withdraw_limit_percentage,0 loan_ratio,0 loan_max, @DEFAULT_TRANSACTION_ON_ID loan_on
--	, @DEFAULT_TRANSACTION_ON_ID profit_on, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty

--INSERT INTO Charge.tblInvestorAccountTypeSetting(client_id, account_type_id,initial_deposit,minimum_balance_on,minimum_balance,minimum_balance_is_percentage
--	,withdraw_limit_on,withdraw_limit,withdraw_limit_percentage,loan_ratio,loan_max,loan_on,profit_on,active_status_id,membership_id
--	,changed_user_id,changed_date,is_dirty)
--SELECT client_id, @ACCOUNT_TYPE_ID, 0 initial_deposit, @DEFAULT_TRANSACTION_ON_ID minimum_balance_on, 0 minimum_balance, 0 minimum_balance_is_percentage
--	, @DEFAULT_TRANSACTION_ON_ID withdraw_limit_on,0 withdraw_limit,0 withdraw_limit_percentage,0 loan_ratio,0 loan_max, @DEFAULT_TRANSACTION_ON_ID loan_on
--	, @DEFAULT_TRANSACTION_ON_ID profit_on, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM Investor.tblInvestor
--WHERE client_id IN ('2500','2600') -- NOTED THAT, CLIENT IDS MENTION HERE
--=======================================================END Add ACCOUNT TYPE SETTING======================================================= 

--=======================================================START Add INVESTOR BROKERAGE COMMISSION SETTING=======================================================
--DELETE FROM Charge.tblInvestorCharge
--DBCC CHECKIDENT ( 'Charge.tblInvestorCharge', RESEED, 0 )

--SET @BROK_COMM_CHARGE_ID=1

--INSERT INTO Charge.tblInvestorCharge(client_id,global_charge_id,charge_amount,is_percentage,is_slab,minimum_charge,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT ClientID, @BROK_COMM_CHARGE_ID global_charge_id, Rate charge_amount, 1 is_percentage, 0 is_slab, 0 minimum_charge, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM Investor.tblInvestor TI INNER JOIN CBO.dbo.tbl_ClientWise_Commission TCC ON TI.client_id=TCC.ClientID
--WHERE TCC.Rate!=0 AND TI.active_status_id=@ACTIVE_STATUS_ID
--=======================================================END Add INVESTOR BROKERAGE COMMISSION SETTING=======================================================

--=======================================================START Add NON TRADING DAY=======================================================

--DELETE FROM Trade.tblSettlementSchedule
--DBCC CHECKIDENT ( 'Trade.tblSettlementSchedule', RESEED, 0 )

--DELETE FROM Trade.tblNonTradingDetail
--DBCC CHECKIDENT ( 'Trade.tblNonTradingDetail', RESEED, 0 )

--DELETE FROM Trade.tblNonTradingMaster 
--DBCC CHECKIDENT ( 'Trade.tblNonTradingMaster', RESEED, 0 )


--exec [Trade].[isp_non_trading_day] '20160414','20160414',@NON_TRADING_DAY_TYPE_ON_DEMAND_ID,'20160414','Bangla Noboborsho',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20160521','20160521',@NON_TRADING_DAY_TYPE_ON_DEMAND_ID,'20160521','Buddha Purnima',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20160523','20160523',@NON_TRADING_DAY_TYPE_ON_DEMAND_ID,'20160523','Shab e Barat',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20160703','20160703',@NON_TRADING_DAY_TYPE_ON_DEMAND_ID,'20160703','Shab e Qadr',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20160705','20160707',@NON_TRADING_DAY_TYPE_ON_DEMAND_ID,'20160706','Eid Ul Fitr',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20160825','20160825',@NON_TRADING_DAY_TYPE_ON_DEMAND_ID,'20160825','Janmashtami',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20160911','20160913',@NON_TRADING_DAY_TYPE_ON_DEMAND_ID,'20160912','Eid Ul Azha',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20161011','20161011',@NON_TRADING_DAY_TYPE_ON_DEMAND_ID,'20161011','Durga Puja',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20161012','20161012',@NON_TRADING_DAY_TYPE_ON_DEMAND_ID,'20161012','Ashura',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20161212','20161212',@NON_TRADING_DAY_TYPE_ON_DEMAND_ID,'20161212','Eid e Milladun Nabi',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID

--exec [Trade].[isp_non_trading_day] '20150101','20201231',@NON_TRADING_DAY_TYPE_WEEKLY_ID,'Friday,Saturday','Weekly Holiday',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID

--exec [Trade].[isp_non_trading_day] '20150101','20201231',@NON_TRADING_DAY_TYPE_YEARLY_ID,'February21','Shahid day',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20150101','20201231',@NON_TRADING_DAY_TYPE_YEARLY_ID,'March17','Birthday of Father of Nation',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20150101','20201231',@NON_TRADING_DAY_TYPE_YEARLY_ID,'March26','Independence Day',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20150101','20201231',@NON_TRADING_DAY_TYPE_YEARLY_ID,'May01','Labour Day',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20150101','20201231',@NON_TRADING_DAY_TYPE_YEARLY_ID,'August15','National Mourning Day',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20150101','20201231',@NON_TRADING_DAY_TYPE_YEARLY_ID,'December16','Victory Day',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID
--exec [Trade].[isp_non_trading_day] '20150101','20201231',@NON_TRADING_DAY_TYPE_YEARLY_ID,'December25','Christmas Day',@ACTIVE_STATUS_ID,@MEMBERSHIP_ID,@USER_ID

--EXEC Trade.psp_settlement_schedule 20150101
--=======================================================END Add NON TRADING DAY=======================================================

--=======================================================START Add TRADE HISTORY DATA=======================================================
--TRUNCATE TABLE Trade.tblTradeData


--INSERT INTO Trade.tblTradeData(instrument_id,AssetClass,OrderId,transaction_type,client_id,stock_exchange_id,market_type_id
--	,Date,Time,Quantity,Unit_Price,ExecID,FillType,group_id
--	,CompulsorySpot,TraderDealerID,OwnerDealerID
--	,commission_rate,commission_amount,transaction_fee,ait,trader_branch_id,client_branch_id
--	,membership_id,changed_user_id,changed_date)
--SELECT INS.id instrument_id, 'EQ' AssetClass, LEFT(ISNULL(TCL.HowlaNo,''),10) OrderId, LEFT(TCL.BS,1) transaction_type, TCL.ClientID client_id, @DSE_STOCK_EXCHANGE_ID stock_exchange_id, INS.market_type_id
--	, CAST(CONVERT(VARCHAR,TCL.Date,112) AS numeric) Date, '13:03:23' Time, TCL.Quantity, TCL.Rate, LEFT(ISNULL(TCL.HowlaNo,''),15) ExecID, 'FILL' FillType, INS.group_id
--	, CASE WHEN INS.market_type_id!=@DEFAULT_MARKET_TYPE_ID THEN 'Y' ELSE 'N' END CompulsorySpot, ISNULL(TDR.trader_code,@DEFAULT_TRADER) TraderDealerID, ISNULL(TDR.trader_code,@DEFAULT_TRADER) OwnerDealerID
--	, ROUND((Comm*100 )/Amount,2,0) commission_rate	, TCL.Comm commission_amount, (TCL.Amount * 0.02)/100 transaction_fee, (TCL.Amount * 0.05)/100 ait, TDR.branch_id trader_branch_id, INV.branch_id client_branch_id
--	, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date
--FROM CBO.dbo.tbl_Client_Ledger TCL --4543816
--	INNER JOIN Investor.tblInvestor INV ON TCL.ClientID=INV.client_id
--	INNER JOIN Instrument.tblInstrument INS ON TCL.Particulars=INS.security_code
--	INNER JOIN broker.tblTrader TDR ON ISNULL(INV.trader_id,@DEFAULT_TRADER_ID)=TDR.id
--WHERE (ISNULL(BS,'')='BUY' OR ISNULL(BS,'')='SELL') AND CashCheque IS NULL AND Particulars != '--x--For' AND TCL.ClientID IS NOT NULL
--ORDER BY TCL.Date, TCL.ClientID, TCL.Particulars


--UPDATE TTD
--SET TTD.transaction_fee = CASE WHEN AIC.is_percentage=0 THEN 
--		CASE WHEN AIC.charge_amount<AIC.minimum_charge THEN AIC.minimum_charge ELSE AIC.charge_amount END
--	  ELSE
--		CASE WHEN ((TTD.Quantity*TTD.Unit_Price * AIC.charge_amount)/100)<AIC.minimum_charge THEN AIC.minimum_charge ELSE ((TTD.Quantity*TTD.Unit_Price * AIC.charge_amount)/100) END
--	  END
--FROM Trade.tblTradeData TTD
--	LEFT JOIN Charge.vw_all_investors_charges AIC ON TTD.client_id=AIC.client_id
--WHERE AIC.global_charge_id=8


--UPDATE TTD
--SET TTD.ait = CASE WHEN AIC.is_percentage=0 THEN 
--		CASE WHEN AIC.charge_amount<AIC.minimum_charge THEN AIC.minimum_charge ELSE AIC.charge_amount END
--	  ELSE
--		CASE WHEN ((TTD.Quantity*TTD.Unit_Price * AIC.charge_amount)/100)<AIC.minimum_charge THEN AIC.minimum_charge ELSE ((TTD.Quantity*TTD.Unit_Price * AIC.charge_amount)/100) END
--	  END
--FROM Trade.tblTradeData TTD
--	LEFT JOIN Charge.vw_all_investors_charges AIC ON TTD.client_id=AIC.client_id
--WHERE AIC.global_charge_id=9

--=======================================================END Add TRADE HISTORY DATA=======================================================

--=======================================================START ADD SHARE LEDGER DATA=======================================================
/*
	PLEASE CREATE PARTITION IN CBO.DBO.TBL_INSTRUMENT_TRANSACTION_HISTORY WITH THE COLUMN TRADINGDATE YEAR WISE.
	PLEASE CREATE PARTITION IN CBO.DBO.L_tbl_CDBL_Holding WITH THE COLUMN HOLDINGDATE YEAR WISE.
*/
--TRUNCATE TABLE Investor.tblInvestorShareLedger

--EXEC CBO.dbo.udp_ReProcessAverageGainLossFromBegining NULL, NULL -- First alter the Stored procedure for migration. Then better call from CBO database else its take long time

--SELECT @TRADE_DATE=MAX(Date) FROM Trade.tblTradeData

--INSERT INTO Investor.tblInvestorShareLedger(client_id,instrument_id,transaction_date,opening_qty,opening_rate,opening_cost,received_qty,received_rate,received_cost
--	,delivery_qty,delivery_rate,delivery_cost,sale_qty,sale_value,sale_commission,sale_rate,sale_amount,sale_cost_rate,sale_cost,gain_loss,remaining_qty,remaining_rate,remaining_cost
--	,buy_qty,buy_cost,buy_commission,buy_rate,buy_amount,closing_qty,closing_rate,closing_cost,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT ITH.ClientID, TI.id instrument_id, CAST(CONVERT(VARCHAR,ITH.TradingDate,112) AS NUMERIC) transaction_date,OpeningQty,OpeningRate,OpeningCost,ReceivedQty,ReceivedRate,ReceivedCost
--	,0 delivery_qty,0 delivery_rate,0 delivery_cost,SaleQty,SaleValue,SaleCommission,SaleRate,SaleAmount,SaleCostRate,SaleCost,GainLoss,RemainingQty,RemainingRate,RemainingCost
--	,BuyQty,BuyCost,BuyCommission,BuyRate,BuyAmount,ClosingQty,ClosingRate,ClosingCost, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM CBO.dbo.tbl_Instrument_Transaction_History ITH --385531
--	INNER JOIN Instrument.tblInstrument TI ON ITH.TradingCode=TI.security_code
--WHERE CAST(CONVERT(VARCHAR,ITH.TradingDate,112) AS NUMERIC)<=@TRADE_DATE
--ORDER BY ITH.TradingDate, ITH.ClientID, TI.id

--=======================================================END ADD SHARE LEDGER DATA=======================================================

--=======================================================START ADD SHARE BALANCE DATA=======================================================
--TRUNCATE TABLE Investor.tblInvestorShareBalance

--SELECT @TRADE_DATE=MAX(Date) FROM Trade.tblTradeData

--INSERT INTO Investor.tblInvestorShareBalance(transaction_date,client_id,instrument_id,ledger_quantity,salable_quantity,ipo_receivable_quantity,bonus_receivable_quantity
--	,lock_quantity,pledge_quantity,cost_average,cost_value,market_price,market_value,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT CAST(CONVERT(VARCHAR,ITH.TradingDate,112) AS NUMERIC) transaction_date,ITH.ClientID, TI.id instrument_id, ClosingQty ledger_quantity, 0 salable_quantity,0 ipo_receivable_quantity,0 bonus_receivable_quantity
--	,0 lock_quantity,0 pledge_quantity,ClosingRate cost_average,ClosingCost cost_value
--	,CASE WHEN TPI.LastTradePrice IS NOT NULL THEN TPI.LastTradePrice ELSE ISNULL((SELECT MAX(LastTradePrice) FROM CBO.DBO.L_tbl_PriceIndex TPIH WHERE TPIH.Instrument=TPI.Instrument AND TPIH.FileDatetime<=TPI.FileDatetime),0)
--		END market_price, 0 market_value
--	, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM CBO.dbo.tbl_Instrument_Transaction_History ITH
--	INNER JOIN Instrument.tblInstrument TI ON ITH.TradingCode=TI.security_code
--	LEFT JOIN CBO.DBO.L_tbl_PriceIndex TPI ON CAST(CONVERT(VARCHAR,ITH.TradingDate,101) AS date)=CAST(CONVERT(VARCHAR,TPI.FileDatetime,101) AS date) AND ITH.TradingCode=TPI.Instrument
--WHERE CAST(CONVERT(VARCHAR,ITH.TradingDate,112) AS NUMERIC)<=@TRADE_DATE
--ORDER BY ITH.TradingDate, ITH.ClientID, TI.id

--UPDATE Investor.tblInvestorShareBalance SET market_value= ledger_quantity*market_price

--UPDATE ISB
--SET ISB.salable_quantity=TCH.FreeBalance
--FROM CBO.DBO.L_tbl_CDBL_Holding TCH 
--	INNER JOIN Instrument.tblInstrument TI ON TCH.ISIN=TI.isin
--	INNER JOIN Investor.tblInvestorShareBalance ISB ON TCH.ClientID=ISB.client_id AND TI.id=ISB.instrument_id AND CAST(CONVERT(VARCHAR,TCH.HoldingDate,112) AS NUMERIC)=ISB.transaction_date
--=======================================================END ADD SHARE BALANCE DATA=======================================================

--=======================================================START ADD CLOSED PRICE DATA=======================================================
--TRUNCATE TABLE Trade.tblClosingPrice

--UPDATE CBO.dbo.L_tbl_PriceIndex SET Instrument='BARKAPOWER' WHERE Instrument='BEDL' -- CAN BE ERROR, NO PROBLEM
--UPDATE CBO.dbo.L_tbl_PriceIndex SET Instrument='BBS' WHERE Instrument='BDBUILDING'
--UPDATE CBO.dbo.L_tbl_PriceIndex SET Instrument='FIRSTFIN' WHERE Instrument='FLEASEINT' -- CAN BE ERROR, NO PROBLEM
--UPDATE CBO.dbo.L_tbl_PriceIndex SET Instrument='APEXFOOT' WHERE Instrument='APEXADELFT'
--UPDATE CBO.dbo.L_tbl_PriceIndex SET Instrument='MTB' WHERE Instrument='MTBL'
--UPDATE CBO.dbo.L_tbl_PriceIndex SET Instrument='UNITEDFIN' WHERE Instrument='ULC'
--UPDATE CBO.dbo.L_tbl_PriceIndex SET Instrument='BEXIMCO' WHERE Instrument='BXTEX'
--UPDATE CBO.dbo.L_tbl_PriceIndex SET Instrument='CVOPRL' WHERE Instrument='CTGVEG'
--UPDATE CBO.dbo.L_tbl_PriceIndex SET Instrument='UCB' WHERE Instrument='UCBL'

--INSERT INTO Trade.tblClosingPrice(security_code,open_price,high_price,low_price,closing_price,group_id,trans_dt,membership_id,changed_user_id,changed_date,active_status)
--SELECT Instrument security_code, 0 open_price, 0 high_price, 0 low_price, LastTradePrice closing_price, INS.group_id, CAST(CONVERT(VARCHAR,TPI.FileDatetime,112) AS numeric) trans_dt
--	,@MEMBERSHIP_ID,@USER_ID changed_user_id, GETDATE() changed_date, @ACTIVE_STATUS_ID
--FROM CBO.dbo.L_tbl_PriceIndex TPI --372119
--	INNER JOIN Instrument.tblInstrument INS ON TPI.Instrument=INS.security_code

--UPDATE INS
--SET INS.closed_price=ISNULL(CP.closing_price,0), INS.group_id=CP.group_id
----SELECT INS.id, CP.closing_price
--FROM Instrument.tblInstrument INS
--	LEFT JOIN Trade.tblClosingPrice CP ON INS.security_code=CP.security_code
--WHERE CP.trans_dt = (SELECT MAX(CPT.trans_dt) FROM Trade.tblClosingPrice CPT WHERE CPT.security_code=CP.security_code AND CPT.trans_dt<=CP.trans_dt)

--UPDATE Instrument.tblInstrument SET closed_price=0 WHERE closed_price IS NULL
--=======================================================END ADD CLOSED PRICE DATA=======================================================

--=======================================================START UPDATE SHARE BALANCE =======================================================

--SELECT @TRADE_DATE=MAX(Date) FROM Trade.tblTradeData
--SELECT @PRV_TRADE_DATE=MAX(Date) FROM DimDate WHERE DateKey<@TRADE_DATE


--SELECT ClientID, BONumber, ISIN, FreeBalance INTO L_tbl_CDBL_Holding
--FROM CBO.DBO.L_tbl_CDBL_Holding WHERE CAST(CONVERT(VARCHAR,HoldingDate,101) AS date)=CAST(CONVERT(VARCHAR,@PRV_TRADE_DATE,101) AS date) ORDER BY ClientID

--DELETE FROM Investor.tblInvestorShareBalance WHERE transaction_date=@TRADE_DATE

--;WITH TCH AS -- PREVIOUS DAY CDBL HOLDING STATUS
--(
--	SELECT INS.id instrument_id, INV.client_id, FreeBalance Quantity
--	FROM L_tbl_CDBL_Holding TCH
--		INNER JOIN Instrument.tblInstrument INS ON TCH.ISIN=INS.isin
--		INNER JOIN Investor.tblInvestor INV ON TCH.BONumber=INV.bo_code
--)
--, TMS AS -- PROCESS DAY'S MATURED SHARE
--(
--	SELECT instrument_id, client_id, SUM(Quantity) Quantity
--	FROM Trade.vw_today_maturity
--	WHERE transaction_type='B'
--	GROUP BY instrument_id, client_id
--)
--, TSS AS -- PROCESS DAY'S SHARE SALE
--(
--	SELECT instrument_id, client_id, SUM(Quantity) Quantity 
--	FROM Trade.tblTradeData
--	WHERE Date=@TRADE_DATE AND transaction_type='S'
--	GROUP BY instrument_id, client_id
--)
--, FMT AS -- FUTURE MATUREABLE SHARE 
--(
--	SELECT TTD.client_id, TTD.instrument_id, SUM(TTD.Quantity) Quantity
--	FROM Trade.tblSettlementSchedule TSS
--		INNER JOIN Trade.tblTradeData TTD 
--			ON TSS.trade_date=TTD.Date AND TSS.stock_exchange_id=TTD.stock_exchange_id 
--				AND TSS.market_type_id=TTD.market_type_id AND TSS.instrument_group_id=TTD.group_id
--	WHERE settle_date>@TRADE_DATE AND TTD.transaction_type='B'
--	GROUP BY TTD.client_id, TTD.instrument_id
--)
--, ISL AS -- INVSTOR SHARE LEDGER FOR AVERAGE PRICE
--(
--	SELECT ISL.client_id, ISL.instrument_id, ISL.closing_rate
--	FROM Investor.tblInvestorShareLedger ISL
--	WHERE transaction_date=(SELECT MAX(transaction_date) FROM Investor.tblInvestorShareLedger TISL WHERE TISL.client_id=ISL.client_id AND TISL.instrument_id=ISL.instrument_id) 
--	GROUP BY ISL.client_id, ISL.instrument_id, ISL.closing_rate
--)

--INSERT INTO Investor.tblInvestorShareBalance(transaction_date,client_id,instrument_id,ledger_quantity,salable_quantity,ipo_receivable_quantity,bonus_receivable_quantity
--	,lock_quantity,pledge_quantity,cost_average,cost_value,market_price,market_value,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT @TRADE_DATE transaction_date, SQ.client_id, SQ.instrument_id, SUM(LEDGER_QTY) LEDGER_QTY, SUM(SALEABLE_QTY) SALEABLE_QTY 
--	, 0 ipo_receivable_quantity, 0 bonus_receivable_quantity, 0 lock_quantity, 0 pledge_quantity, ISNULL(ISL.closing_rate,0) cost_average
--	, SUM(LEDGER_QTY) * ISNULL(ISL.closing_rate,0) cost_value
--	, 0 market_price, 0 market_value, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM
--(
--	SELECT client_id, instrument_id, ISNULL(Quantity,0) LEDGER_QTY, ISNULL(Quantity,0) SALEABLE_QTY, 'TCH' TTYPE FROM TCH
--	UNION ALL
--	SELECT client_id, instrument_id, ISNULL(Quantity,0) LEDGER_QTY, ISNULL(Quantity,0) SALEABLE_QTY, 'TMS' FROM TMS
--	UNION ALL
--	SELECT client_id, instrument_id, ISNULL(Quantity,0) * -1 LEDGER_QTY, ISNULL(Quantity,0) * -1 SALEABLE_QTY, 'TSS' FROM TSS
--	UNION ALL
--	SELECT client_id, instrument_id, ISNULL(Quantity,0) LEDGER_QTY, 0 SALEABLE_QTY, 'FMT' FROM FMT
--) AS SQ
--	LEFT JOIN ISL ON SQ.client_id=ISL.client_id AND SQ.instrument_id=ISL.instrument_id
--GROUP BY SQ.client_id, SQ.instrument_id,ISL.closing_rate
--ORDER BY SQ.client_id, SQ.instrument_id

--DROP TABLE L_tbl_CDBL_Holding

--INSERT INTO Investor.tblInvestorShareBalance(transaction_date,client_id,instrument_id,ledger_quantity,salable_quantity,ipo_receivable_quantity,bonus_receivable_quantity
--	,lock_quantity,pledge_quantity,cost_average,cost_value,market_price,market_value,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT @MIGRATION_DATE, ISB.client_id, ISB.instrument_id, ISB.salable_quantity, ISB.salable_quantity, ISB.ipo_receivable_quantity, ISB.bonus_receivable_quantity, ISB.lock_quantity 
--	, ISB.pledge_quantity, ISB.cost_average, ISB.cost_value, 0 market_price, 0 market_value, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM Investor.vw_InvestorShareBalance ISB
--	INNER JOIN Investor.tblInvestor INV ON ISB.client_id=INV.client_id
--WHERE ISB.transaction_date<@MIGRATION_DATE
--	AND INV.active_status_id=@ACTIVE_STATUS_ID
--	AND ISB.ledger_quantity<ISB.salable_quantity

--DECLARE @MIN_TRADE_DATE AS NUMERIC(9,0)
--select @MIN_TRADE_DATE=min(trade_date) from trade.tblSettlementSchedule where settle_date=@MIGRATION_DATE
--INSERT INTO Investor.tblInvestorShareBalance(transaction_date,client_id,instrument_id,ledger_quantity,salable_quantity,ipo_receivable_quantity,bonus_receivable_quantity
--	,lock_quantity,pledge_quantity,cost_average,cost_value,market_price,market_value,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT @MIGRATION_DATE, ISB.client_id, ISB.instrument_id, 0 ledger_quantity, 0 salable_quantity, 0 ipo_receivable_quantity, 0 bonus_receivable_quantity, 0 lock_quantity 
--	, 0 pledge_quantity, 0 cost_average, 0 cost_value, 0 market_price, 0 market_value, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM Investor.vw_InvestorShareBalance ISB
--	INNER JOIN Investor.tblInvestor INV ON ISB.client_id=INV.client_id
--WHERE ISB.transaction_date<@MIN_TRADE_DATE
--	AND (ledger_quantity!=0 OR salable_quantity!=0)

--UPDATE Investor.vw_InvestorShareBalance
--SET ledger_quantity=0
--WHERE 
--	ledger_quantity<0 AND salable_quantity=0

--SELECT @TRADE_DATE=MAX(Date) FROM Trade.tblTradeData

--;WITH TTD AS
--(
--	SELECT client_id, instrument_id, SUM(Quantity) Quantity, SUM((Quantity*Unit_Price)+commission_amount) COST, SUM((Quantity*Unit_Price)+commission_amount)/SUM(Quantity) RATE
--	FROM Trade.tblTradeData
--	WHERE transaction_type='B'
--	AND Date=@TRADE_DATE
--	GROUP BY client_id, instrument_id
--)

--UPDATE ISB
--SET ISB.cost_average=TTD.RATE, ISB.cost_value=ISB.ledger_quantity*TTD.RATE
----SELECT ISB.*, TTD.RATE 
--FROM Investor.tblInvestorShareBalance ISB
--	INNER JOIN TTD ON ISB.client_id=TTD.client_id AND ISB.instrument_id=TTD.instrument_id AND ISB.ledger_quantity=TTD.Quantity
--WHERE transaction_date=@TRADE_DATE AND ledger_quantity>0 AND salable_quantity=0 AND cost_average=0

--SELECT @TRADE_DATE=MAX(Date) FROM Trade.tblTradeData

--;WITH TPI AS
--(
--	SELECT security_code, closing_price 
--	FROM Trade.tblClosingPrice TPI
--	WHERE TPI.trans_dt=(SELECT MAX(trans_dt) FROM Trade.tblClosingPrice TPIH WHERE TPIH.security_code=TPI.security_code AND trans_dt<=@TRADE_DATE)
--)
--UPDATE ISB
--SET ISB.market_price=ISNULL(TPI.closing_price,0), ISB.market_value=ISB.ledger_quantity*ISNULL(TPI.closing_price,0)
--	, ISB.cost_average=CASE WHEN ISB.ledger_quantity=0 AND ISB.salable_quantity=0 THEN 0 ELSE ISB.cost_average END
----SELECT ISB.*, TPI.closing_price 
--FROM Investor.tblInvestorShareBalance ISB
--	INNER JOIN Instrument.tblInstrument INS ON ISB.instrument_id=INS.id
--	LEFT JOIN TPI ON INS.security_code=TPI.security_code
--WHERE transaction_date=@TRADE_DATE

--UPDATE Investor.tblInvestorShareBalance
--SET cost_average=cost_value/salable_quantity
--WHERE cost_average<=0 AND (ledger_quantity<0 AND salable_quantity>0) AND cost_value>0

--;WITH CP AS
--(
--	SELECT transaction_date, client_id, instrument_id
--		 , ISNULL((SELECT CP.closing_price FROM Trade.tblClosingPrice CP WHERE CP.security_code=INS.security_code AND CP.trans_dt=
--				(SELECT MAX(CPT.trans_dt) FROM Trade.tblClosingPrice CPT WHERE CPT.security_code=CP.security_code AND CPT.trans_dt<=ISB.transaction_date)),0) closing_price
--	FROM Investor.tblInvestorShareBalance ISB
--		INNER JOIN Instrument.tblInstrument INS ON ISB.instrument_id=INS.id
--)	

--UPDATE ISB
--SET ISB.market_price=CP.closing_price, ISB.market_value=CASE WHEN ISB.ledger_quantity<=0 AND ISB.salable_quantity>0 THEN ISB.salable_quantity*CP.closing_price ELSE ISB.ledger_quantity*CP.closing_price END
--FROM Investor.tblInvestorShareBalance ISB INNER JOIN CP ON ISB.transaction_date=CP.transaction_date AND ISB.client_id=CP.client_id AND ISB.instrument_id=CP.instrument_id

--;WITH CP AS
--(
--	SELECT transaction_date, client_id, instrument_id
--		, ISNULL((SELECT CP.closing_price FROM Trade.tblClosingPrice CP WHERE CP.security_code=INS.security_code AND CP.trans_dt=
--			(SELECT MAX(CPT.trans_dt) FROM Trade.tblClosingPrice CPT WHERE CPT.security_code=CP.security_code AND CPT.trans_dt<=ISB.transaction_date)),0) closing_price
--	FROM 
--		Investor.vw_InvestorShareBalance ISB
--	INNER JOIN 
--		Instrument.tblInstrument INS 
--		ON ISB.instrument_id=INS.id
--	WHERE 
--		ISB.cost_average=0 
--		AND ISB.ledger_quantity!=0
--)

--UPDATE ISB
--SET ISB.cost_average=CP.closing_price, ISB.cost_value=ISB.ledger_quantity*CP.closing_price
----SELECT CP.closing_price, ISB.ledger_quantity*CP.closing_price
--FROM Investor.tblInvestorShareBalance ISB INNER JOIN CP ON ISB.transaction_date=CP.transaction_date AND ISB.client_id=CP.client_id AND ISB.instrument_id=CP.instrument_id
--=======================================================END UPDATE SHARE BALANCE =======================================================

--=======================================================START UPDATE SHARE LEDGER FOR LAST DAY =======================================================
--SELECT @TRADE_DATE=MAX(Date) FROM Trade.tblTradeData

--UPDATE ISL
--SET ISL.closing_qty=ISB.ledger_quantity, ISL.closing_rate=CASE WHEN ISB.ledger_quantity=0 AND ISB.salable_quantity=0 THEN 0 ELSE ISB.cost_average END, ISL.closing_cost=ISB.cost_value
----SELECT ISL.client_id, ISL.instrument_id, ISL.closing_qty, ISL.closing_rate, ISL.closing_cost, ISB.ledger_quantity, ISB.salable_quantity, ISB.cost_average, ISB.cost_value
--FROM Investor.tblInvestorShareLedger ISL
--	INNER JOIN Investor.tblInvestorShareBalance ISB ON ISL.transaction_date=ISB.transaction_date AND ISL.client_id=ISB.client_id AND ISL.instrument_id=ISB.instrument_id
--WHERE ISL.transaction_date=@TRADE_DATE 

--SELECT @TRADE_DATE=MAX(Date) FROM Trade.tblTradeData

--INSERT INTO Investor.tblInvestorShareLedger(client_id,instrument_id,transaction_date,opening_qty,opening_rate,opening_cost,received_qty,received_rate,received_cost
--	,delivery_qty,delivery_rate,delivery_cost,sale_qty,sale_value,sale_commission,sale_rate,sale_amount,sale_cost_rate,sale_cost,gain_loss,remaining_qty,remaining_rate,remaining_cost
--	,buy_qty,buy_cost,buy_commission,buy_rate,buy_amount,closing_qty,closing_rate,closing_cost,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT ISB.client_id, ISB.instrument_id, @TRADE_DATE transaction_date,0 OpeningQty,0 OpeningRate,0 OpeningCost, ISB.ledger_quantity ReceivedQty,ISB.cost_average ReceivedRate,ISB.cost_value ReceivedCost
--	,0 delivery_qty,0 delivery_rate,0 delivery_cost,0 SaleQty,0 SaleValue,0 SaleCommission,0 SaleRate,0 SaleAmount,0 SaleCostRate,0 SaleCost,0 GainLoss
--	,ISB.ledger_quantity RemainingQty,ISB.cost_average RemainingRate,ISB.cost_value RemainingCost
--	,0 BuyQty,0 BuyCost,0 BuyCommission,0 BuyRate,0 BuyAmount,ISB.ledger_quantity ClosingQty,ISB.cost_average ClosingRate,ISB.cost_value ClosingCost
--	, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM Investor.tblInvestorShareBalance ISB
--	LEFT JOIN Investor.tblInvestorShareLedger ISL ON ISB.transaction_date=ISL.transaction_date AND ISB.client_id=ISL.client_id AND ISB.instrument_id=ISL.instrument_id
--WHERE ISB.transaction_date=@TRADE_DATE 
--	AND ISL.id IS NULL
--=======================================================START UPDATE SHARE LEDGER FOR LAST DAY =======================================================

----=======================================================START ADD FUND LEDGER DATA =======================================================
--TRUNCATE TABLE Investor.tblInvestorFinancialLedger
--INSERT INTO Investor.tblInvestorFinancialLedger(client_id,refference_no,transaction_type_id,narration,quantity,rate,amount,comm_amount,debit,credit
--	,transaction_date,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT TCD.ClientID client_id, '' refference_no, FLTCOV.object_value_id transaction_type_id,'Opening balance CF from previous software' narration
--	, 0 quantity,0 rate,0 amount,0 comm_amount
--	, CASE WHEN TCD.CFBalance<0 THEN TCD.CFBalance * -1 ELSE 0 END debit
--	, CASE WHEN TCD.CFBalance>0 THEN TCD.CFBalance ELSE 0 END credit
--	, CAST(CONVERT(VARCHAR,ISNULL(MIN(TCL.Date),TCD.EditDate),112) AS numeric) transaction_date
--	, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM CBO.dbo.tbl_Client_Details TCD -- 76
--	INNER JOIN tblConstantObjectValue FLTCOV ON (CASE WHEN TCD.CFBalance>0 THEN 'Deposit' ELSE 'Withdraw' END)=FLTCOV.display_value
--	INNER JOIN tblConstantObject FLTCO ON FLTCOV.object_id=FLTCO.object_id AND FLTCO.object_name='FINANCIAL_LEDGER_TYPE'
--	LEFT JOIN CBO.dbo.tbl_Client_Ledger TCL ON TCD.ClientID=TCL.ClientID
--WHERE TCD.CFBalance!=0
--GROUP BY TCD.ClientID, TCD.CFBalance, TCD.EditDate,FLTCOV.object_value_id

--;WITH TCL AS
--(
--	SELECT TCL.*,TMR.ChequeNo, TMR.ReceiptID
--		, CASE WHEN (RTRIM(LTRIM(CashCheque))='Cash' OR RTRIM(LTRIM(CashCheque))='Cheque' OR RTRIM(LTRIM(CashCheque))='') AND ISNULL(Credit,0)>0 THEN 'Deposit'
--			WHEN (RTRIM(LTRIM(CashCheque))='Cash' OR RTRIM(LTRIM(CashCheque))='Cheque' OR RTRIM(LTRIM(CashCheque))='') AND ISNULL(Debit,0)>0 THEN 'Withdraw'
--			WHEN LTRIM(RTRIM(ISNULL(CashCheque,'')))='Trans' THEN 'Transfer In Out'
--			WHEN (LTRIM(RTRIM(TCL.BS)) ='BUY' OR TCL.BS ='Sell') AND (CashCheque IS NULL) THEN 'BUY/SALE'
--			WHEN (LTRIM(RTRIM(TCL.BS)) ='CDBL') THEN 'Charge Apply'
--			WHEN (LTRIM(RTRIM(TCL.BS)) ='IPO') THEN 'IPO'
--			ELSE NULL END FINANCIAL_LEDGER_TYPE_NAME
--		, CASE WHEN (TCL.CashCheque IS NOT NULL AND RTRIM(LTRIM(TCL.CashCheque))='Cheque') THEN 'CH'
--			ELSE 'CS' END TRANSACTION_MODE_NAME
--	FROM CBO.DBO.tbl_Client_Ledger TCL
--		LEFT JOIN CBO.dbo.tbl_MoneyReceipt TMR ON TCL.RowID=TMR.LedgerRowID
--	WHERE (Credit>0 OR Debit>0) AND CAST(CONVERT(VARCHAR,TCL.Date,101) AS date) BETWEEN '2000-01-01' AND CAST(CONVERT(VARCHAR,@MIGRATION_DATE) AS DATE)
--)

--INSERT INTO Investor.tblInvestorFinancialLedger(client_id,refference_no,transaction_type_id,narration,quantity,rate,amount,comm_amount,debit,credit
--	,transaction_date,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT TCL.ClientID
--	, CASE WHEN TCL.FINANCIAL_LEDGER_TYPE_NAME='Deposit' AND TRANSACTION_MODE_NAME='CH' THEN 'CH# ' + ISNULL(TCL.ChequeNo,'')
--		WHEN TCL.FINANCIAL_LEDGER_TYPE_NAME='Deposit' AND TRANSACTION_MODE_NAME='CS' THEN CAST(ISNULL(TCL.ReceiptID,0) AS VARCHAR)
--		WHEN TCL.FINANCIAL_LEDGER_TYPE_NAME='Withdraw' AND TRANSACTION_MODE_NAME='CH' THEN 'CH# ' + ISNULL(TCL.ChequeNo,'')
--		WHEN TCL.FINANCIAL_LEDGER_TYPE_NAME='Withdraw' AND TRANSACTION_MODE_NAME='CS' THEN CAST(ISNULL(TCL.ReceiptID,0) AS VARCHAR)
--		WHEN TCL.FINANCIAL_LEDGER_TYPE_NAME='Transfer In Out' AND TCL.Credit>0 AND TRANSACTION_MODE_NAME='CH' THEN ISNULL(TCL.ChequeNo,'')
--		WHEN TCL.FINANCIAL_LEDGER_TYPE_NAME='Transfer In Out' AND TCL.Credit>0 AND TRANSACTION_MODE_NAME='CS' THEN CAST(ISNULL(TCL.ReceiptID,0) AS VARCHAR)
--		WHEN TCL.FINANCIAL_LEDGER_TYPE_NAME='Transfer In Out' AND TCL.Debit>0 AND TRANSACTION_MODE_NAME='CH' THEN ISNULL(TCL.ChequeNo,'')
--		WHEN TCL.FINANCIAL_LEDGER_TYPE_NAME='Transfer In Out' AND TCL.Debit>0 AND TRANSACTION_MODE_NAME='CS' THEN CAST(ISNULL(TCL.ReceiptID,0) AS VARCHAR)
--		WHEN TCL.FINANCIAL_LEDGER_TYPE_NAME='BUY/SALE' THEN 'ORDER ID# ' + ISNULL(TCL.HowlaNo,'')
--		WHEN TCL.FINANCIAL_LEDGER_TYPE_NAME='IPO' THEN 'IPO'
--		ELSE NULL END refference_no
--	, FLTCOV.object_value_id, TCL.Particulars narration, TCL.Quantity, TCL.Rate, TCL.Amount, TCL.Comm, ISNULL(TCL.Debit,0) Debit, ISNULL(TCL.Credit,0) Credit
--	, CAST(CONVERT(VARCHAR,TCL.Date,112) AS numeric) transaction_date
--	, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM TCL  -- 4968978
--	INNER JOIN Investor.tblInvestor INV ON TCL.ClientID=INV.client_id
--	INNER JOIN tblConstantObjectValue FLTCOV ON TCL.FINANCIAL_LEDGER_TYPE_NAME=FLTCOV.display_value
--	INNER JOIN tblConstantObject FLTCO ON FLTCOV.object_id=FLTCO.object_id AND FLTCO.object_name='FINANCIAL_LEDGER_TYPE'
--ORDER BY transaction_date, client_id
----=======================================================END ADD FUND LEDGER DATA =======================================================

----=======================================================START ADD FUND BALANCE DATA =======================================================
--TRUNCATE TABLE Investor.tblInvestorFundBalance
--;WITH FB AS 
--(
--SELECT client_id, transaction_date, SUM(credit)-SUM(debit) balance
--FROM Investor.tblInvestorFinancialLedger
--GROUP BY client_id, transaction_date
--)

--INSERT INTO Investor.tblInvestorFundBalance(client_id,transaction_date,account_type_id,available_balance,sale_receivable,un_clear_cheque,ledger_balance,total_deposit,share_transfer_in
--	,total_withdraw,share_transfer_out,realized_interest,realized_charge,accured_interest,fund_withdrawal_request,cost_value,market_value,equity,marginable_equity,sanction_amount
--	,loan_ratio,purchase_power,max_withdraw_limit,excess_over_limit,realized_gain,unrealized_gain,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
--SELECT client_id, transaction_date, NULL account_type_id, 0 available_balance, 0 sale_receivable,0 un_clear_cheque
--    ,SUM(balance) OVER(PARTITION BY client_id ORDER BY client_id, transaction_date ROWS UNBOUNDED PRECEDING) AS ledger_balance
--	,0 total_deposit,0 share_transfer_in,0 total_withdraw,0 share_transfer_out,0 realized_interest,0 realized_charge,0 accured_interest,0 fund_withdrawal_request,0 cost_value,0 market_value,0 equity,0 marginable_equity,0 sanction_amount
--	,0 loan_ratio,0 purchase_power,0 max_withdraw_limit,0 excess_over_limit,0 realized_gain,0 unrealized_gain
--	, @ACTIVE_STATUS_ID, @MEMBERSHIP_ID, @USER_ID changed_user_id, GETDATE() changed_date, 0 is_dirty
--FROM FB
--ORDER BY transaction_date, client_id

--------=======================================================END ADD FUND BALANCE DATA =======================================================

--------=======================================================START UPDATE ALL DATA IN FUND BALANCE =======================================================
------Withdraw---------------------------------------------------------------------
--;WITH FB AS 
--(
--SELECT client_id, transaction_date, SUM(debit) Amount
--FROM Investor.tblInvestorFinancialLedger IFL
--	INNER JOIN dbo.tblConstantObjectValue COV ON IFL.transaction_type_id=COV.object_value_id
--WHERE COV.display_value='Withdraw' OR COV.display_value='Transfer Out'
--GROUP BY client_id, transaction_date
--)

--UPDATE IFB
--SET IFB.total_withdraw=FB.total_withdraw
----SELECT FB.*
--FROM Investor.tblInvestorFundBalance IFB INNER JOIN
--(
--	SELECT IFB.client_id, IFB.transaction_date,SUM(ISNULL(Amount,0)) OVER(PARTITION BY IFB.client_id ORDER BY IFB.client_id, IFB.transaction_date ROWS UNBOUNDED PRECEDING) AS total_withdraw
--	FROM Investor.tblInvestorFundBalance IFB LEFT JOIN FB ON IFB.client_id=FB.client_id AND IFB.transaction_date=FB.transaction_date
--) AS  FB ON IFB.client_id=FB.client_id AND IFB.transaction_date=FB.transaction_date

----Deposit---------------------------------------------------------------------
--;WITH FB AS 
--(
--SELECT client_id, transaction_date, SUM(credit) Amount
--FROM Investor.tblInvestorFinancialLedger IFL
--	INNER JOIN dbo.tblConstantObjectValue COV ON IFL.transaction_type_id=COV.object_value_id
--WHERE COV.display_value='Deposit' OR COV.display_value='Transfer In'
--GROUP BY client_id, transaction_date
--)

--UPDATE IFB
--SET IFB.total_deposit=FB.total_deposit
--FROM Investor.tblInvestorFundBalance IFB INNER JOIN
--(
--	SELECT IFB.client_id, IFB.transaction_date,SUM(ISNULL(Amount,0)) OVER(PARTITION BY IFB.client_id ORDER BY IFB.client_id, IFB.transaction_date ROWS UNBOUNDED PRECEDING) AS total_deposit
--	FROM Investor.tblInvestorFundBalance IFB LEFT JOIN FB ON IFB.client_id=FB.client_id AND IFB.transaction_date=FB.transaction_date
--) AS  FB ON IFB.client_id=FB.client_id AND IFB.transaction_date=FB.transaction_date

----realized Charge---------------------------------------------------------------------
--;WITH FB AS 
--(
--	SELECT client_id, transaction_date, SUM(realized_charge) realized_charge FROM
--	(
--		SELECT client_id, transaction_date, credit-debit realized_charge
--		FROM Investor.tblInvestorFinancialLedger IFL
--			INNER JOIN dbo.tblConstantObjectValue COV ON IFL.transaction_type_id=COV.object_value_id
--		WHERE COV.display_value='IPO' OR COV.display_value='Charge Apply'
--		UNION ALL
--		SELECT client_id, transaction_date, ISNULL(comm_amount,0) realized_charge
--		FROM Investor.tblInvestorFinancialLedger IFL
--			INNER JOIN dbo.tblConstantObjectValue COV ON IFL.transaction_type_id=COV.object_value_id
--		WHERE COV.display_value='BUY/SALE'
--	) AS B
--	GROUP BY client_id, transaction_date
--)


--UPDATE IFB
--SET IFB.realized_charge=FB.realized_charge
----SELECT FB.*
--FROM Investor.tblInvestorFundBalance IFB INNER JOIN
--(
--	SELECT IFB.client_id, IFB.transaction_date,SUM(ISNULL(FB.realized_charge,0)) OVER(PARTITION BY IFB.client_id ORDER BY IFB.client_id, IFB.transaction_date ROWS UNBOUNDED PRECEDING) AS realized_charge
--	FROM Investor.tblInvestorFundBalance IFB LEFT JOIN FB ON IFB.client_id=FB.client_id AND IFB.transaction_date=FB.transaction_date
--) AS  FB ON IFB.client_id=FB.client_id AND IFB.transaction_date=FB.transaction_date

----Realized Gain---------------------------------------------------------------------
--;WITH FB AS 
--(
--	SELECT client_id, transaction_date, SUM(gain_loss) gain_loss
--	FROM Investor.tblInvestorShareLedger IFL
--	GROUP BY client_id, transaction_date
--)

--UPDATE IFB
--SET IFB.realized_gain=FB.realized_gain
----SELECT FB.*
--FROM Investor.tblInvestorFundBalance IFB INNER JOIN
--(
--	SELECT IFB.client_id, IFB.transaction_date,SUM(ISNULL(FB.gain_loss,0)) OVER(PARTITION BY IFB.client_id ORDER BY IFB.client_id, IFB.transaction_date ROWS UNBOUNDED PRECEDING) AS realized_gain
--	FROM Investor.tblInvestorFundBalance IFB LEFT JOIN FB ON IFB.client_id=FB.client_id AND IFB.transaction_date=FB.transaction_date
--) AS  FB ON IFB.client_id=FB.client_id AND IFB.transaction_date=FB.transaction_date

----UPDATE IMMATUER SALE BALANCE--------------------------------------------------------
--;WITH SELL_RECEIVABLE (Date, settle_date,client_id,total_receivable)
--AS
--( select td.Date,tdss.settle_date,td.client_id,sum( (ISNULL(td.Quantity,0) * ISNULL(td.Unit_Price,0))  - ISNULL(td.commission_amount,0) ) total_receivable
--	from [Escrow.BOAS].Trade.tblTradeData td
--	INNER join  [Escrow.BOAS].[Trade].[tblSettlementSchedule] tdss
--		on tdss.instrument_group_id=td.group_id and tdss.market_type_id=td.market_type_id
--		and tdss.stock_exchange_id=td.stock_exchange_id and tdss.trade_date=td.Date
--	where td.transaction_type = 'S'
--	group by td.Date, tdss.settle_date, td.client_id
--)

--UPDATE IFB
--SET
--	IFB.sale_receivable = ISNULL(TD.total_receivable,0)
--from
--	[Escrow.BOAS].Investor.tblInvestorFundBalance IFB
--LEFT JOIN 
--	SELL_RECEIVABLE td
--	ON IFB.client_id=TD.client_id
--	AND (IFB.transaction_date >= TD.[DATE] AND  IFB.transaction_date < td.settle_date)

----COST VALUE / MARKET VALUE---------------------------------------------------------------------
--;WITH FB AS
--(
--	SELECT IFB.client_id, IFB.transaction_date
--		, ISNULL((SELECT SUM(ISB.cost_value) FROM Investor.tblInvestorShareBalance ISB 
--			WHERE ISB.client_id=IFB.client_id AND ISB.transaction_date=
--				(SELECT MAX(transaction_date) FROM Investor.tblInvestorShareBalance TISB 
--					WHERE TISB.client_id=ISB.client_id AND TISB.transaction_date<= IFB.transaction_date
--				)
--			),0) cost_value
--		, ISNULL((SELECT SUM(ISB.market_value) FROM Investor.tblInvestorShareBalance ISB 
--			WHERE ISB.client_id=IFB.client_id AND ISB.transaction_date=
--				(SELECT MAX(transaction_date) FROM Investor.tblInvestorShareBalance TISB 
--					WHERE TISB.client_id=ISB.client_id AND TISB.transaction_date<= IFB.transaction_date
--				)
--			),0) market_value
--	FROM Investor.tblInvestorFundBalance IFB
--)	

--UPDATE IFB
--SET IFB.cost_value=FB.cost_value, IFB.market_value=FB.market_value
----SELECT *
--FROM Investor.tblInvestorFundBalance IFB
--	INNER JOIN FB ON IFB.client_id=FB.client_id and IFB.transaction_date=FB.transaction_date

----UPDATE OTHER BALANCE

--UPDATE IFB
--SET IFB.account_type_id=INV.account_type_id
--	, IFB.available_balance=IFB.ledger_balance - IFB.sale_receivable
--	, IFB.equity = IFB.ledger_balance+IFB.market_value
--	, IFB.marginable_equity = IFB.ledger_balance+IFB.market_value
--	, IFB.purchase_power= 
--		CASE WHEN INV.account_type_id=@cash_account_type_id THEN
--			CASE WHEN IFB.ledger_balance> 0 THEN IFB.ledger_balance 
--			ELSE 0 END
--		ELSE
--			CASE WHEN IFB.loan_ratio>0 THEN 
--				CASE WHEN (IFB.ledger_balance+IFB.market_value)*IFB.loan_ratio>0 THEN (IFB.ledger_balance+IFB.market_value)*IFB.loan_ratio 
--				ELSE 0 
--				END
--			ELSE 
--				CASE WHEN (IFB.ledger_balance+IFB.market_value)>0 THEN (IFB.ledger_balance+IFB.market_value) 
--				ELSE 0 
--				END 
--			END
--		END
--	, IFB.unrealized_gain=IFB.market_value-IFB.cost_value
----SELECT * 
--FROM Investor.tblInvestorFundBalance IFB
-- INNER JOIN Investor.tblInvestor INV ON  IFB.client_id=INV.client_id

--update Investor.tblinvestorfundbalance
--set available_balance=available_balance+sale_receivable
--where transaction_date=20160214 and sale_receivable<0

--update Investor.tblinvestorfundbalance
--set sale_receivable=0
--where transaction_date=20160214 and sale_receivable<0

----=======================================================END UPDATE ALL DATA IN FUND BALANCE =======================================================

----=======================================================START FUND RECEIVE =======================================================
--TRUNCATE TABLE [Transaction].tblFundReceive

--INSERT INTO [Transaction].tblFundReceive(voucher_no,client_id,transaction_mode_id,cheque_no,cheque_date,amount
--	,receive_date,value_date,broker_branch_id,remarks,approve_by,approve_date,deposit_by,deposit_date,clear_by,clear_date
--	,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,deposit_bank_branch_id)
     
--select 
--	 CONVERT(VARCHAR,transaction_date)+RIGHT('00000'+ CONVERT(VARCHAR, ROW_NUMBER()  OVER(PARTITION BY transaction_date ORDER BY transaction_date)) ,5) voucher_no
--	,IFL.client_id 
--	,CASE WHEN ISNULL(refference_no,'') LIKE '%CH%' THEN @CH_transaction_mode_id ELSE @CS_transaction_mode_id END transaction_mode_id
--	,CASE WHEN ISNULL(refference_no,'') LIKE '%CH%' THEN RTRIM(LTRIM(SUBSTRING(refference_no, CHARINDEX('#',refference_no,0)+1,LEN(refference_no)-(CHARINDEX('#',refference_no,0))))) 
--		ELSE NULL END cheque_no
--	,CASE WHEN ISNULL(refference_no,'') LIKE '%CH%' THEN transaction_date ELSE NULL END cheque_date
--	,credit amount,transaction_date receive_date,transaction_date value_date,INV.BRANCH_ID broker_branch_id,narration remarks
--	,@USER_ID approve_by,transaction_date approve_date,@USER_ID deposit_by,transaction_date deposit_date,@USER_ID clear_by,transaction_date clear_date
--	,@ACTIVE_STATUS_ID,@membership_id,@USER_ID changed_user_id,GETDATE() changed_date,0 is_dirty
--	,CASE WHEN ISNULL(refference_no,'') LIKE '%CH%' THEN @deposit_bank_branch_id ELSE NULL END deposit_bank_branch_id
--from Investor.tblInvestorFinancialLedger IFL
--	INNER JOIN Investor.tblInvestor INV ON INV.CLIENT_ID=IFL.client_id
--	INNER JOIN DBO.tblConstantObjectValue COV ON IFL.transaction_type_id=COV.object_value_id
--	INNER JOIN dbo.tblConstantObject TCO ON COV.object_id=TCO.object_id
--where TCO.object_name='FINANCIAL_LEDGER_TYPE' AND (COV.display_value='Deposit' OR COV.display_value='Transfer In Out') AND credit>0
--ORDER BY transaction_date
----=======================================================END FUND RECEIVE =======================================================

----=======================================================START FUND WITHDRAW =======================================================
--TRUNCATE TABLE [Transaction].tblFundWithdraw

--INSERT INTO [Transaction].tblFundWithdraw(voucher_no,client_id,transaction_mode_id,bank_branch_id,cheque_no,cheque_date,amount,withdraw_date
--	,value_date,broker_branch_id,remarks,approve_by,approve_date,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
     
--select 
--	 CONVERT(VARCHAR,transaction_date)+RIGHT('00000'+ CONVERT(VARCHAR, ROW_NUMBER()  OVER(PARTITION BY transaction_date ORDER BY transaction_date)) ,5) voucher_no
--	,IFL.client_id 
--	,CASE WHEN ISNULL(refference_no,'') LIKE '%CH%' THEN @CH_transaction_mode_id ELSE @CS_transaction_mode_id END transaction_mode_id
--	,CASE WHEN ISNULL(refference_no,'') LIKE '%CH%' THEN @deposit_bank_branch_id ELSE NULL END bank_branch_id
--	,CASE WHEN ISNULL(refference_no,'') LIKE '%CH%' THEN RTRIM(LTRIM(SUBSTRING(refference_no, CHARINDEX('#',refference_no,0)+1,LEN(refference_no)-(CHARINDEX('#',refference_no,0))))) 
--		ELSE NULL END cheque_no
--	,CASE WHEN ISNULL(refference_no,'') LIKE '%CH%' THEN transaction_date ELSE NULL END cheque_date
--	,debit amount
--	,transaction_date withdraw_date
--	,transaction_date value_date
--	,INV.BRANCH_ID broker_branch_id
--	,narration remarks
--	,@USER_ID approve_by
--	,transaction_date approve_date,@ACTIVE_STATUS_ID,@membership_id,@USER_ID changed_user_id,GETDATE() changed_date,0 is_dirty
--from Investor.tblInvestorFinancialLedger IFL
--	INNER JOIN Investor.tblInvestor INV ON INV.CLIENT_ID=IFL.client_id
--	INNER JOIN DBO.tblConstantObjectValue COV ON IFL.transaction_type_id=COV.object_value_id
--	INNER JOIN dbo.tblConstantObject TCO ON COV.object_id=TCO.object_id
--where TCO.object_name='FINANCIAL_LEDGER_TYPE' AND (COV.display_value='Withdraw' OR COV.display_value='Transfer In Out') AND debit>0
--ORDER BY transaction_date
----=======================================================END FUND WITHDRAW =======================================================
