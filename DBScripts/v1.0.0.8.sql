



USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [CDBL].[psp_bo_registration]    Script Date: 4/20/2016 5:01:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- exec CDBL.psp_bo_registration '01-NOV-2015', '16-NOV-2015', 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
-- =============================================
-- Author:		Asif
-- Create date: 13/10/15
-- Description:	Process BO Registration
-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 04/11/15
-- Description:	Modify for add to bank, bank branch, thana, district, existing investor update, investor insert, ledger and financial balance
-- =============================================
ALTER PROCEDURE [CDBL].[psp_bo_registration]
(
@from_date varchar(50),
@to_date varchar(50),
@membership_id numeric(9,0),
@changed_user_id nvarchar(128),
@result VARCHAR(MAX) OUT
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
	 SET @result = 'success'
	 
	 BEGIN TRANSACTION
	 
		BEGIN TRY

			DECLARE @PROCESS_DATE AS NUMERIC(9,0)
				,@DEFAULT_INVESTOR_ACC_TYPE AS NUMERIC(4,0)
				,@DEFAULT_IPO_TYPE AS NUMERIC(4,0)
				,@DEFAULT_TRADE_TYPE AS NUMERIC(4,0)
				,@DEFAULT_ACTIVE_STATUS AS NUMERIC(4,0)
				,@DEFAULT_INVESTOR_SUB_ACC AS NUMERIC(4,0)
				,@trader_id as numeric(2)
				,@branch_id as numeric(2)
				,@GENDER_OBJECT_ID AS NUMERIC(3)
				,@OPERATION_TYPE_OBJECT_ID AS NUMERIC(3)
				,@THANA_OBJECT_ID AS NUMERIC(3)
				,@DISTRICT_OBJECT_ID AS NUMERIC(3)
				,@FINANCIAL_LEDGER_TYPE_ID AS NUMERIC(4,0) --FOR ACCOUNT OPENING TYPE 
				,@transaction_type_id AS NUMERIC(4,0) -- FOR CHARGE APPLY FOR RECEIVE
			
			SELECT @PROCESS_DATE=dbo.sfun_get_process_date()

			SELECT @DEFAULT_INVESTOR_ACC_TYPE=dbo.sfun_get_constant_object_default_value_id('INVESTOR_ACC_TYPE')
			SELECT @DEFAULT_IPO_TYPE=dbo.sfun_get_constant_object_default_value_id('IPO_TYPE')
			SELECT @DEFAULT_TRADE_TYPE=dbo.sfun_get_constant_object_default_value_id('TRADE_TYPE')
			SELECT @DEFAULT_ACTIVE_STATUS=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
			SELECT @DEFAULT_INVESTOR_SUB_ACC=dbo.sfun_get_constant_object_default_value_id('INVESTOR_SUB_ACC')

			SELECT @FINANCIAL_LEDGER_TYPE_ID=dbo.sfun_get_constant_object_value_id('FINANCIAL_LEDGER_TYPE','Account Opening Fee')
			SELECT @transaction_type_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','Receive')

			SELECT @GENDER_OBJECT_ID=TCO.object_id FROM DBO.tblConstantObject TCO WHERE TCO.object_name='GENDER'
			SELECT @OPERATION_TYPE_OBJECT_ID=TCO.object_id FROM DBO.tblConstantObject TCO WHERE TCO.object_name='INVESTOR_OPERATION_TYPE'
			SELECT @THANA_OBJECT_ID=TCO.object_id FROM DBO.tblConstantObject TCO WHERE TCO.object_name='THANA'
			SELECT @DISTRICT_OBJECT_ID=TCO.object_id FROM DBO.tblConstantObject TCO WHERE TCO.object_name='DISTRICT'

			set @trader_id = (select top 1 id from broker.tblTrader where Is_Default = 1 order by id)
			set @branch_id = (select top 1 id from broker.tblBrokerBranch order by id)

			-----------------------Insert data from temp table to bo registration-----------------------
			print 'tblCdblBoRegistration'

			INSERT INTO [CDBL].[tblCdblBoRegistration] (bo_code,operation_Type,internal_Ref_No,first_holder_name,second_holder_name,gender,birth_date,father_name,mother_name,occupation,res_flag,nationality,add1,add2,add3,city,state,
				country,post_code,phone,email,fax,passport_no,passport_issue_dt,passport_exp_dt,passport_issue_place,bank_name,bank_branch_name,bank_account_no,bank_routing_No,opening_date,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			SELECT a.bo_code,a.operation_Type,a.internal_Ref_No,a.first_holder_name,a.second_holder_name,a.gender,a.birth_date,a.father_name,a.mother_name,a.occupation,a.res_flag,a.nationality,a.add1,a.add2,a.add3,a.city,a.state,a.country,
				a.post_code,a.phone,a.email,a.fax,a.passport_no,a.passport_issue_dt,a.passport_exp_dt,a.passport_issue_place,a.bank_name,a.bank_branch_name,a.bank_account_no,a.bank_routing_No,a.opening_date,@DEFAULT_ACTIVE_STATUS,@membership_id,@changed_user_id,
				GETDATE(),1
			FROM [CDBL].[08DP01UX] a
				LEFT JOIN (SELECT * FROM [CDBL].[tblCdblBoRegistration] WHERE membership_id=@membership_id) tcbr ON a.bo_code = tcbr.bo_code AND a.internal_Ref_No = tcbr.internal_ref_no
			WHERE CONVERT(Datetime, a.opening_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120)
				AND tcbr.registration_id IS NULL
							
			-----------------------End insert data from temp table to bo registration-----------------------

			-----------------------insert data from temp table to bank-----------------------
			print 'tblBank'

			insert into Accounting.tblBank(short_name,bank_name,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			select SUBSTRING(dp.bank_name,1,3), dp.bank_name,@DEFAULT_ACTIVE_STATUS,@membership_id,@changed_user_id,GETDATE(),1
			from (
				select distinct bank_name from CDBL.[08DP01UX] dp
					left join (SELECT * FROM Accounting.tblBankBranch WHERE membership_id=@membership_id) tbb on dp.bank_routing_No=tbb.routing_no
				where tbb.id is null
			) as dp left join (SELECT * FROM Accounting.tblBank WHERE membership_id=@membership_id) tb on dp.bank_name=tb.bank_name
			where tb.bank_name is null

			-----------------------End insert data from temp table to bank-----------------------

			-----------------------insert data from temp table to bank branch-----------------------
			print 'tblBankBranch'

			insert into Accounting.tblBankBranch(branch_name,routing_no,bank_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			select distinct DP.bank_branch_name, dp.bank_routing_No, tb.id,@DEFAULT_ACTIVE_STATUS,@membership_id,@changed_user_id,GETDATE(),1
			from CDBL.[08DP01UX] dp
				inner join (SELECT * FROM Accounting.tblBank WHERE membership_id=@membership_id) tb on dp.bank_name=tb.bank_name
				left join (SELECT * FROM Accounting.tblBankBranch WHERE membership_id=@membership_id) tbb on dp.bank_routing_No=tbb.routing_no
			where tbb.id is null

			-----------------------End insert data from temp table to bank branch-----------------------

			-----------------------insert district from temp table to object value-----------------------
			print 'DISTRICT'

			insert into dbo.tblConstantObjectValue(display_value, object_id, is_default)
			select t.state, (select object_id from DBO.tblConstantObject WHERE object_name='DISTRICT'), 0
			from
				(select distinct state from [CDBL].[08DP01UX]) t 
				left join (SELECT tcv.object_value_id, tcv.display_value FROM 
					DBO.tblConstantObjectValue TCV 
						INNER JOIN DBO.tblConstantObject TCO ON TCV.object_id=TCO.object_id WHERE TCO.object_name='DISTRICT') as v
					on t.state=v.display_value
			where v.object_value_id is null
			-----------------------insert district from temp table to object value-----------------------

			-----------------------insert thana from temp table to object value-----------------------
			print 'THANA'
			insert into dbo.tblConstantObjectValue(display_value, object_id, is_default)
			select t.state, (select object_id from DBO.tblConstantObject WHERE object_name='THANA'), 0
			from
				(select distinct state from [CDBL].[08DP01UX]) t 
				left join (SELECT tcv.object_value_id, tcv.display_value FROM 
					DBO.tblConstantObjectValue TCV 
						INNER JOIN DBO.tblConstantObject TCO ON TCV.object_id=TCO.object_id WHERE TCO.object_name='THANA') as v
					on t.state=v.display_value
			where v.object_value_id is null
			-----------------------End insert thana from temp table to object value-----------------------
			
			-----------------------update data at investor table from temp-----------------------
			print 'Update Investor' 

			UPDATE TI
			SET 
				TI.bo_refernce_id=TDP.id,TI.bo_code= DP.bo_code,TI.first_holder_name = DP.first_holder_name,TI.birth_date = DP.birth_date,TI.gender_id = gcov.object_value_id,TI.passport_no = DP.passport_no,TI.father_name = DP.father_name
				,TI.mother_name = DP.mother_name,TI.operation_type_id = otcov.object_value_id,TI.mailing_address = DP.add2,TI.permanent_address = DP.add1
				,TI.thana_id = thanacov.object_value_id,TI.district_id = distcov.object_value_id,TI.phone_no = DP.phone,TI.email_address = DP.email,TI.bank_id = tbb.bank_id,TI.bank_branch_id = TBB.id,TI.banc_account_no = DP.bank_account_no
				,TI.opening_date = oddd.DateKey,TI.passport_issue_place = DP.passport_issue_place
				,TI.passport_issue_date = CASE WHEN LEN(dp.passport_issue_dt)>0 THEN DP.passport_issue_dt ELSE NULL END
				,TI.passport_valid_to_date = CASE WHEN LEN(dp.passport_exp_dt)>0 THEN DP.passport_exp_dt ELSE NULL END
				,TI.changed_user_id = @changed_user_id,TI.changed_date = GETDATE(),TI.is_dirty = 1
			FROM [CDBL].[08DP01UX] dp
				INNER JOIN (select * from [Investor].[tblInvestor] where membership_id=@membership_id) ti ON DP.internal_Ref_No = ti.client_id
				INNER JOIN (select * from [Accounting].[tblBankBranch] where membership_id=@membership_id) tbb ON UPPER(dp.bank_branch_name) = UPPER(tbb.branch_name)
				INNER JOIN (SELECT * FROM broker.tblDepositoryPerticipant WHERE membership_id=@membership_id) TDP ON SUBSTRING(DP.BO_CODE,1,8)=TDP.bo_reference_no
				INNER JOIN [dbo].[DimDate] oddd ON DP.opening_date = oddd.FullDateCDBL
				INNER JOIN [dbo].[tblConstantObjectValue] gcov ON UPPER(DP.gender) = UPPER(gcov.display_value) AND gcov.object_id=@GENDER_OBJECT_ID
				INNER JOIN [dbo].[tblConstantObjectValue] otcov ON UPPER(DP.operation_type) = UPPER(otcov.display_value) AND otcov.object_id=@OPERATION_TYPE_OBJECT_ID
				INNER JOIN [dbo].[tblConstantObjectValue] thanacov ON UPPER(DP.state) = UPPER(thanacov.display_value) AND thanacov.object_id=@THANA_OBJECT_ID
				INNER JOIN [dbo].[tblConstantObjectValue] distcov ON UPPER(DP.city) = UPPER(distcov.display_value) AND distcov.object_id=@DISTRICT_OBJECT_ID
			WHERE ISDATE(dp.opening_date)=1 
				and ((len(dp.birth_date)>0 and ISDATE(dp.birth_date)=1) or LEN(dp.birth_date)=0)  
				and ((len(dp.passport_issue_dt)>0 and ISDATE(dp.passport_issue_dt)=1) or LEN(dp.passport_issue_dt)=0)
				and ((len(dp.passport_exp_dt)>0 and ISDATE(dp.passport_exp_dt)=1) or LEN(dp.passport_exp_dt)=0)
				AND ( CONVERT(Datetime, dp.opening_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))

			-----------------------End update data at investor table from temp-----------------------

			-----------------------Insert data from bo registration to investor temporary-----------------------
			print 'tblInvestorTemp'

			TRUNCATE TABLE [Investor].[tblInvestorTemp]

			INSERT INTO [Investor].[tblInvestorTemp](client_id,bo_refernce_id,bo_code,first_holder_name, second_joint_holder,birth_date,gender_id,passport_no,father_name,mother_name,account_type_id,operation_type_id,sub_account_type_id
				,mailing_address
				,permanent_address
				,thana_id,district_id,phone_no,email_address,bank_id,bank_branch_id,banc_account_no,beftn_enabled,email_enabled,internet_enabled,sms_enabled,branch_id,opening_date,passport_issue_place
				,passport_issue_date
				,passport_valid_to_date
				,trader_id
				,ipo_type_id
				,trade_type_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty
			)

			SELECT dp.internal_Ref_No, TDP.id,dp.bo_code,dp.first_holder_name, dp.second_holder_name, dp.birth_date,gcov.object_value_id,dp.passport_no,dp.father_name,dp.mother_name,@DEFAULT_INVESTOR_ACC_TYPE,otcov.object_value_id,@DEFAULT_INVESTOR_SUB_ACC
				,[Investor].[sfun_get_address](dp.add1,dp.add2,dp.add3,dp.city,dp.state,dp.country,dp.post_code) mailing_address
				,[Investor].[sfun_get_address](dp.add1,dp.add2,dp.add3,dp.city,dp.state,dp.country,dp.post_code) permanent_address
				,thanacov.object_value_id, distcov.object_value_id,dp.phone,dp.email,tbb.bank_id,tbb.id bank_branch_id,dp.bank_account_no,0,0,0,0,@branch_id,oddd.DateKey,dp.passport_issue_place
				,CASE WHEN LEN(dp.passport_issue_dt)>0 THEN DP.passport_issue_dt ELSE NULL END
				,CASE WHEN LEN(dp.passport_exp_dt)>0 THEN DP.passport_exp_dt ELSE NULL END
				,ISNULL((SELECT trader_id FROM broker.tblTrader WHERE  dp.internal_ref_no IN (SELECT id FROM dbo.udfSpliter(investor_range))),@trader_id)
				,CASE 
					WHEN
						dp.res_flag = 'Resident'
					THEN
						[dbo].[sfun_get_constant_object_value_id]('IPO_TYPE', 'RB')
					WHEN
						dp.res_flag = 'Non Resident'
					THEN
						[dbo].[sfun_get_constant_object_value_id]('IPO_TYPE', 'NRB')
					ELSE
						@DEFAULT_IPO_TYPE
				END ipo_type_id
				, @DEFAULT_TRADE_TYPE,@DEFAULT_ACTIVE_STATUS,@membership_id,@changed_user_id,GETDATE(),1
			FROM [CDBL].[08DP01UX] dp
				LEFT JOIN (select * from [Investor].[tblInvestor] where membership_id=@membership_id) ti ON DP.internal_Ref_No = ti.client_id
				LEFT JOIN (select * from [Accounting].[tblBank] where membership_id=@membership_id) tb ON dp.bank_name = tb.bank_name
				LEFT JOIN (select * from [Accounting].[tblBankBranch] where membership_id=@membership_id) tbb ON UPPER(dp.bank_branch_name) = UPPER(tbb.branch_name) and tb.id=tbb.bank_id
				LEFT JOIN (SELECT * FROM broker.tblDepositoryPerticipant WHERE membership_id=@membership_id) TDP ON SUBSTRING(DP.BO_CODE,1,8)=TDP.bo_reference_no
				LEFT JOIN [dbo].[DimDate] oddd ON DP.opening_date = oddd.FullDateCDBL
				LEFT JOIN [dbo].[tblConstantObjectValue] gcov ON UPPER(DP.gender) = UPPER(gcov.display_value) AND gcov.object_id=@GENDER_OBJECT_ID
				LEFT JOIN [dbo].[tblConstantObjectValue] otcov ON UPPER(DP.operation_type) = UPPER(otcov.display_value) AND otcov.object_id=@OPERATION_TYPE_OBJECT_ID
				LEFT JOIN [dbo].[tblConstantObjectValue] thanacov ON UPPER(DP.state) = UPPER(thanacov.display_value) AND thanacov.object_id=@THANA_OBJECT_ID
				LEFT JOIN [dbo].[tblConstantObjectValue] distcov ON UPPER(DP.city) = UPPER(distcov.display_value) AND distcov.object_id=@DISTRICT_OBJECT_ID
			WHERE TI.client_id IS NULL 
				and ISDATE(dp.opening_date)=1 
				and ((len(dp.birth_date)>0 and ISDATE(dp.birth_date)=1) or LEN(dp.birth_date)=0)  
				and ((len(dp.passport_issue_dt)>0 and ISDATE(dp.passport_issue_dt)=1) or LEN(dp.passport_issue_dt)=0)
				and ((len(dp.passport_exp_dt)>0 and ISDATE(dp.passport_exp_dt)=1) or LEN(dp.passport_exp_dt)=0)
				AND ( CONVERT(Datetime, dp.opening_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			
			UPDATE INV
			SET
				INV.branch_id=TDR.branch_id
			FROM 
				Investor.tblInvestorTemp INV
			INNER JOIN 
				broker.tblTrader TDR
				ON INV.trader_id=TDR.id
			-----------------------End insert data from bo registration to investor temporary-----------------------

			-----------------------Insert data from investor temporary to investor-----------------------
			print 'tblInvestor'
			INSERT INTO [Investor].[tblInvestor](client_id,bo_refernce_id,bo_code,first_holder_name,birth_date,gender_id,passport_no,father_name,mother_name,account_type_id,operation_type_id,sub_account_type_id,mailing_address
				,permanent_address,thana_id,district_id,phone_no,email_address,bank_id,bank_branch_id,banc_account_no,beftn_enabled,email_enabled,internet_enabled,sms_enabled,branch_id,opening_date,passport_issue_place
				,passport_issue_date
				,passport_valid_to_date
				,trader_id,ipo_type_id,trade_type_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			select client_id,bo_refernce_id,bo_code,first_holder_name,birth_date,gender_id,passport_no,father_name,mother_name,account_type_id,operation_type_id,sub_account_type_id,mailing_address
				,permanent_address,thana_id,district_id,phone_no,email_address,bank_id,bank_branch_id,banc_account_no,beftn_enabled,email_enabled,internet_enabled,sms_enabled,branch_id,opening_date,passport_issue_place
				,passport_issue_date
				,passport_valid_to_date
				,trader_id,ipo_type_id,trade_type_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty
			from Investor.tblInvestorTemp tmp
			WHERE membership_id=@membership_id
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to investor-----------------------

			-----------------------Insert data from investor temporary to investor image-----------------------
			print 'tblInvestorImage'
			INSERT INTO [Investor].[tblInvestorImage](client_id)
			select client_id
			from Investor.tblInvestorTemp tmp
			WHERE membership_id=@membership_id
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to investor image-----------------------

			-----------------------Insert data from investor temporary to JOINT HOLDER-----------------------
			print 'tblJoinHolder'
			INSERT INTO [Investor].[tblJoinHolder](client_id,join_holder_name,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			select client_id,second_joint_holder,active_status_id,membership_id,changed_user_id,changed_date,is_dirty
			from Investor.tblInvestorTemp tmp
			WHERE membership_id=@membership_id AND ISNULL(second_joint_holder,'')!=''
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to JOINT HOLDER-----------------------

			-----------------------Insert data from investor temporary to Finuncial Ledger-----------------------
			print 'tblForceChargeApply'

			INSERT INTO [Transaction].tblForceChargeApply(client_id,charge_id,transaction_type_id,amount,transaction_date,value_date,remarks,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,approve_by,approve_date)
			select tmp.client_id, 5 charge_id, @transaction_type_id, apf.charge_amount amount,@PROCESS_DATE transaction_date,@PROCESS_DATE value_date,TGC.name remarks,@DEFAULT_ACTIVE_STATUS active_status_id,@membership_id
				,@changed_user_id, GETDATE() changed_date,1 is_dirty, @changed_user_id approve_by, @PROCESS_DATE approve_date
			from Investor.tblInvestorTemp tmp 
				inner join (select * from charge.vw_all_investors_charges where global_charge_id=5) apf on tmp.client_id=apf.client_id
				inner join Charge.tblGlobalCharge tgc on apf.global_charge_id=tgc.id
			where apf.charge_amount>0 AND TMP.membership_id=@membership_id
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to Finuncial Ledger-----------------------

			-----------------------Insert data from investor temporary to Finuncial Ledger-----------------------
			print 'tblInvestorFinancialLedger'

			insert into Investor.tblInvestorFinancialLedger(client_id,transaction_type_id,narration,debit,credit,transaction_date,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			select tmp.client_id, @FINANCIAL_LEDGER_TYPE_ID, tgc.name, apf.charge_amount, 0, @PROCESS_DATE, tmp.active_status_id, tmp.membership_id, tmp.changed_user_id, tmp.changed_date, tmp.is_dirty 
			from Investor.tblInvestorTemp tmp 
				inner join (select * from charge.vw_all_investors_charges where global_charge_id=5) apf on tmp.client_id=apf.client_id
				inner join Charge.tblGlobalCharge tgc on apf.global_charge_id=tgc.id
			where apf.charge_amount>0 AND TMP.membership_id=@membership_id
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to Finuncial Ledger-----------------------

			-----------------------Insert data from investor temporary to fund balance-----------------------
			print 'tblInvestorFundBalance'

			insert into Investor.tblInvestorFundBalance(client_id,transaction_date,account_type_id,available_balance,sale_receivable,un_clear_cheque, ledger_balance,total_deposit,share_transfer_in,total_withdraw,share_transfer_out,realized_interest,
				realized_charge,accured_interest,fund_withdrawal_request,cost_value,market_value,equity,marginable_equity,sanction_amount,loan_ratio,purchase_power,max_withdraw_limit,excess_over_limit,realized_gain,unrealized_gain,
				active_status_id, membership_id, changed_user_id, changed_date, is_dirty)
			select tmp.client_id, @PROCESS_DATE, account_type_id, -1 * apf.charge_amount, 0, 0, -1 * apf.charge_amount, 0, 0, 0, 0, 0, apf.charge_amount, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
				, tmp.active_status_id, tmp.membership_id, tmp.changed_user_id, tmp.changed_date, tmp.is_dirty
			from Investor.tblInvestorTemp tmp
				inner join (select * from charge.vw_all_investors_charges where global_charge_id=5) apf on tmp.client_id=apf.client_id
			where apf.charge_amount>0 AND TMP.membership_id=@membership_id
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to fund balance-----------------------

			TRUNCATE TABLE [CDBL].[08DP01UX]

			COMMIT TRANSACTION
			
		END TRY
		
		BEGIN CATCH
		
			SELECT @result = ERROR_MESSAGE()
			ROLLBACK TRANSACTION
			RAISERROR(@result,16,1)
		END CATCH	 
END




USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Instrument].[rsp_instrument_ledger_client_wise]    Script Date: 05/31/2016 11:06:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 19/12/2015
-- Description:	Instrument ledger report
-- Edited by: Shohid
-- Edit date: 30-05-2016
-- Purpose: debit average and credit average added
-- =============================================
---[Instrument].[rsp_instrument_ledger_client_wise] 63,'8','391',null,'2015-01-01','2016-12-12'
ALTER PROCEDURE [Instrument].[rsp_instrument_ledger_client_wise]
	@membership_id numeric(9,0),
	@user_id nvarchar(128),
	@client_id varchar(10),
	@instrument_id numeric(4,0),
	@from_dt datetime,
	@to_dt datetime
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select 
		ti.instrument_name,
		ti.security_code,
		ti.isin,
		tii.first_holder_name,
		tjh.join_holder_name,
		dd.FullDateUK Date,
		case when(tisl.sale_qty > 0) then  'Sell'  when (tisl.buy_qty > 0) then 'Buy' when(tisl.received_qty > 0) then 'Receive' when(tisl.delivery_qty > 0) then 'Delivered' end as Type,
		case when (tisl.sale_qty > 0) then tisl.sale_qty when (tisl.delivery_qty> 0 ) then tisl.delivery_qty else 0 end as debit,
		case when (tisl.buy_qty > 0) then tisl.buy_qty when (tisl.received_qty> 0 ) then tisl.received_qty else 0 end as credit,
		tisl.opening_qty,
		(CASE WHEN tisl.buy_rate>0
			THEN
				tisl.buy_rate
			--WHEN 
			--	tisl.sale_rate>0
			--THEN
			--	tisl.sale_rate
			--ELSE
			--	0
		END) AS average_cr,
		(CASE WHEN tisl.sale_rate>0
			THEN
				tisl.sale_rate
			--WHEN 
			--	tisl.sale_rate>0
			--THEN
			--	tisl.sale_rate
			--ELSE
			--	0
		END) AS average_dt

		
	
		--tisl.sale_qty,tisl.buy_qty,tisl.received_qty,tisl.delivery_qty
	from Investor.tblInvestorShareLedger tisl
	inner join Instrument.tblInstrument ti on tisl.instrument_id = ti.id
	inner join Investor.tblInvestor tii on tisl.client_id = tii.client_id
	inner join DimDate dd on tisl.transaction_date = dd.DateKey
	inner join Dimdate ddf on @from_dt = ddf.Date
	inner join Dimdate ddt on @to_dt = ddt.Date
	LEFT JOIN
			Investor.tblJoinHolder tjh
			ON tjh.client_id = tii.client_id
	where (tisl.sale_qty > 0 or tisl.buy_qty > 0 or tisl.received_qty > 0 or tisl.delivery_qty > 0)
	and tisl.transaction_date between ddf.DateKey  and ddt.DateKey
	and tisl.client_id = @client_id and tisl.membership_id = @membership_id
	and tisl.instrument_id = ISNULL(@instrument_id,tisl.instrument_id)
    ORDER BY tisl.transaction_date
	
END




--------- Update Investor Bank information--------------

select 
 bb.bank_id ,
 bb.id as branch_id,
 cbd.Client_Code,
 cbd.AC_No
 
 into #client_bank_info 
 from dbo.Client_wise_bank_details$ cbd
inner join [Accounting].[tblBankBranch] bb
on cbd.Routing_No = bb.routing_no


Update Investor.tblInvestor 
 SET bank_id = cbi.bank_id,
  bank_branch_id = cbi.branch_id,
  banc_account_no = cbi.AC_No
From #client_bank_info as cbi
Where cbi.Client_Code = client_id





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Transaction].[rsp_et_list]    Script Date: 05/31/2016 10:32:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 12/09/2015
-- Description:	Et list report
-- Edited by: Shohid
-- Edit date:30/05/2016
-- Purpose: Instructed by Newaz vai for Report modification
-- Exec [Transaction].[rsp_et_list] 63,8,'20160215'
-- =============================================
ALTER PROCEDURE [Transaction].[rsp_et_list] 
	@membership_id numeric(9,0),
	@user_id nvarchar(128),
	@report_date datetime
AS
BEGIN

	SET NOCOUNT ON;

	 SELECT 
		dd.FullDateUK as date,
		ti.banc_account_no as receiving_ac,
		ti.first_holder_name as receiver_name,
		tfw.amount ,
		'120271706' as orginating_brn,
		tbb.routing_no as receiving_brn,
		'1090297080041' as orginating_ac,
		'Banco securities Ltd.' as orginator_name,
		ti.bo_code+'('+tfw.client_id+')' as remarks
		--ti.bo_code,
		--tb.bank_name,
		--tbb.branch_name,
		--tbb.routing_no
		
	 from
		[Transaction].tblFundWithdraw tfw
	 inner join 
		Investor.tblInvestor ti 
		on tfw.client_id = ti.client_id
		AND TI.membership_id=TFW.membership_id
	 inner join 
		Accounting.tblBankBranch tbb 
		on tfw.bank_branch_id = tbb.id
		AND tbb.membership_id=TFW.membership_id
	 inner join 
		Accounting.tblBank tb 
		on tbb.bank_id = tb.id
	 inner join 
		tblConstantObjectValue tcov 
		on tfw.transaction_mode_id = tcov.object_value_id
	 inner join 
		tblConstantObject tco 
		on tcov.object_id = tco.object_id
	 inner join 
		DimDate dd 
		on tfw.cheque_date = dd.DateKey
	 where 
		 tco.object_name='TRANSACTION_MODE'
		 and tcov.display_value = 'ET'
		 and tfw.membership_id = @membership_id
		 and dd.Date = @report_date

END






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [dbo].[psp_export_sms]    Script Date: 05/31/2016 10:52:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Newaz Sharif
-- Create date: 16-05-2016
-- Description:	SMS 
-- EXEC [dbo].[psp_export_sms] '1000' 
-- =============================================
ALTER PROCEDURE  [dbo].[psp_export_sms]
(@OCode Varchar(10))
AS
BEGIN
	SET NOCOUNT ON;

    declare @process_dt numeric(9,0) = dbo.sfun_get_process_date()

	select * into #ClosingPrice from trade.tblClosingPrice
	where trans_dt = @process_dt

	select * into #TradeData from Trade.tblTradeData with(index([idx_member_date_client_instrument]))
		where date = @process_dt

	SELECT client_id, sum(amount) receive_amt INTO #FundReceive	FROM [Transaction].tblFundReceive tfr1
	WHERE tfr1.receive_date = @process_dt AND tfr1.approve_by IS NOT NULL
	GROUP BY client_id

	SELECT client_id, sum(amount) withdraw_amt INTO #FundWithdraw FROM [Transaction].tblFundWithdraw tfw
	WHERE tfw.withdraw_date = @process_dt AND tfw.approve_by IS NOT NULL
	GROUP BY client_id

	--DELETE FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0',
	--          'Excel 12.0 Xml;HDR=NO; Database=D:\BULK_SMS\test.xlsx; Extended Properties=Excel 12.0')...[Sheet1$] 

	
	Insert into OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0',
	          'Excel 12.0 Xml;HDR=NO; Database=D:\BULK_SMS\SMS.xlsx; Extended Properties=Excel 12.0')...[Sheet1$] 

	select 
		DISTINCT inv.mobile_no as Mobile
		,left('BANCO '
		+ convert(varchar,convert(date,GETDATE()))
		+' CC'+':'+inv.client_id
		+ISNULL(' '+'WA:'+ (convert(varchar,(cast(tfW.withdraw_amt as money)))) ,'')
		+ISNULL(' '+'DA:'+ (convert(varchar,(cast(tfr.receive_amt as money)))) ,'')
		+ ISNULL(' TDR:' + STUFF(
			(select ' ' + ins.security_code
				+' '+CASE WHEN std.transaction_type = 'B' THEN 'B' else'S'  end
				+ CONVERT(varchar,CAST(SUM(CAST(std.Quantity AS int)) as int)) + ' ' + CONVERT(varchar,CAST(SUM(CAST(std.Quantity AS int) * std.Unit_Price)/sum(std.quantity) as money))
				+' '+'CP:'+ convert(varchar,CAST(ttcp.closing_price as money))
			from 
				#TradeData std
			inner join 
				instrument.tblInstrument ins 
				on std.instrument_id = ins.id 
			left join 
				#ClosingPrice ttcp 
				on ins.security_code =ttcp.security_code
			where std.client_id=ttd.client_id
			group by 
				std.client_id, 
				ins.security_code, 
				std.transaction_type, 
				ttcp.closing_price 
			for xml PATH('')),1,1,''),'') 
		+' LB:'+ (convert(varchar,(cast([Investor].[sfun_get_investor_fund_balance] (inv.client_id,@process_dt) as money)))),250)
		as Message

		, @OCode OCODE
	from
		Investor.tblInvestor inv
	left join 
		#TradeData ttd 
		on inv.client_id=ttd.client_id
	left join 
		#FundReceive tfr 
		on inv.client_id = tfr.client_id
	left join 
		#FundWithdraw tfw 
		on inv.client_id = tfw.client_id
	where
		INV.active_status_id=61
		AND LEN(RTRIM(LTRIM(ISNULL(INV.mobile_no,'')))) > 10
		AND INV.sms_enabled=0
		AND (ttd.client_id is not null
			OR tfw.client_id IS NOT NULL
			OR tfr.client_id IS NOT NULL
			)


	--SELECT * FROM #FundReceive


	drop table #TradeData
	drop table #ClosingPrice
	drop table #FundReceive
	DROP TABLE #FundWithdraw

END





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_bo_acknowledgement]    Script Date: 05/31/2016 11:56:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 23/02/2016
-- Description: BO Acknowledgement
-- Edited by: shohid
-- Edit date: 31-05-2016
-- 
-- =============================================

--- exec Investor.rsp_bo_acknowledgement '63',null,'8'
ALTER PROCEDURE [Investor].[rsp_bo_acknowledgement]
(
	@membership_id numeric(9,0),
	@user_id nvarchar(128),
	@client_id varchar(10)
)
AS
BEGIN
	SELECT
		tdp.bo_reference_no
		,tinv.bo_code
		,tcovas.display_value active_status
		,tcovot.display_value operation_type
		,tcovtt.display_value trader_type
		,tinv.first_holder_name
		,tjh.join_holder_name
		,tcovg.display_value gender
		,dddob.FullDateCDBL dob
		,tinv.father_name
		,tinv.mother_name
		,tinv.mailing_address
		,tcovd.display_value district
		,tcovt.display_value thana
		,tinv.client_id
		,tbb.routing_no
		,CASE WHEN
				tinv.phone_no IS NOT NULL
				AND tinv.mobile_no IS NOT NULL
			THEN
				tinv.phone_no + ', ' + tinv.mobile_no
			WHEN
				tinv.phone_no IS NOT NULL
				AND tinv.mobile_no IS NULL
			THEN
				tinv.phone_no
			WHEN
				tinv.phone_no IS NULL
				AND tinv.mobile_no IS NOT NULL
			THEN
				tinv.mobile_no
			ELSE
				NULL
		END phone
		,tinv.email_address
		,tinv.passport_no
		,ddpid.FullDateCDBL passport_issue_date
		,ddpvtd.FullDateCDBL passport_valid_to_date
		,tinv.passport_issue_place
		,tban.bank_name
		,tbrokb.name broker_branch
		,tinv.banc_account_no
	FROM Investor.tblInvestor tinv
	LEFT JOIN [broker].tblDepositoryPerticipant tdp
		ON tdp.id = tinv.bo_refernce_id
	INNER JOIN dbo.tblConstantObjectValue tcovot
		ON tcovot.object_value_id = tinv.operation_type_id
	INNER JOIN dbo.tblConstantObjectValue tcovtt
		ON tcovtt.object_value_id = tinv.trade_type_id
	INNER JOIN dbo.tblConstantObjectValue tcovas
		ON tcovas.object_value_id = tinv.active_status_id
	INNER JOIN [broker].[tblBrokerBranch] tbrokb
		ON tbrokb.id = tinv.branch_id
	LEFT JOIN Investor.tblJoinHolder tjh
		ON tjh.client_id = tinv.client_id
	LEFT JOIN dbo.tblConstantObjectValue tcovg
		ON tcovg.object_value_id = tinv.gender_id
	LEFT JOIN dbo.DimDate dddob
		ON dddob.Date = tinv.birth_date
	LEFT JOIN dbo.tblConstantObjectValue tcovt
		ON tcovt.object_value_id = tinv.thana_id
	LEFT JOIN dbo.tblConstantObjectValue tcovd
		ON tcovd.object_value_id = tinv.district_id
	LEFT JOIN dbo.DimDate ddpid
		ON ddpid.Date = tinv.passport_issue_date
	LEFT JOIN dbo.DimDate ddpvtd
		ON ddpvtd.Date = tinv.passport_valid_to_date
	LEFT JOIN Accounting.tblBank tban
		ON tban.id = tinv.bank_id
	LEFT JOIN Accounting.tblBankBranch tbb
		ON tbb.id = tinv.branch_id
	WHERE
		tinv.client_id = @client_id
		AND tinv.membership_id = @membership_id
END






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_brokerage_commission_income_branch_wise]    Script Date: 06/13/2016 12:09:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_brokerage_commission_income_branch_wise 63, 20141020, 20651231
-- =============================================
-- Author:		Asif
-- Create date: 16/11/15
-- Description:	Brokerage commission income branch wise
-- =============================================

ALTER PROCEDURE [Trade].[rsp_brokerage_commission_income_branch_wise]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@branch_id numeric(2,0),
@from_dt DATETIME,
@to_dt DATETIME
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	;WITH TTD AS (
	 SELECT CASE WHEN ttd.transaction_type = 'B' THEN 'Buy' WHEN ttd.transaction_type = 'S' THEN 'Sell' END AS transaction_type
	 ,SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) AS turnover
	 ,SUM(ttd.commission_amount) AS total_com
	 ,SUM(ISNULL(ttd.transaction_fee,0)) AS transaction_fee
	 ,SUM(ISNULL(ttd.ait,0)) AS ait
	 ,SUM(ttd.commission_amount) - (SUM(ISNULL(ttd.transaction_fee,0)) + SUM(ISNULL(ttd.ait,0))) AS net_income
	 --,ttd.market_type_id
	 --,tcovmt.display_value AS market_name
	 ,tbb.name AS branch_name
	 FROM [Trade].[tblTradeData] ttd
	 INNER JOIN [Investor].[tblInvestor] ti ON ti.client_id = ttd.client_id
	 INNER JOIN [broker].[tblBrokerBranch] tbb ON tbb.id = ti.branch_id
	 
	 --INNER JOIN [dbo].[tblConstantObjectValue] tcovmt ON tcovmt.object_value_id = ttd.market_type_id
	 INNER JOIN dbo.DimDate DD ON TTD.Date=DD.DateKey
	 WHERE ttd.membership_id = @membership_id
	 AND DD.Date BETWEEN @from_dt AND @to_dt
	 AND (@branch_id IS NULL OR TBB.id = @branch_id)
	 GROUP BY ttd.membership_id, ttd.transaction_type,tbb.name--,ttd.market_type_id --tcovmt.display_value
	 )
	 SELECT transaction_type,turnover,total_com,transaction_fee,ait,net_income,branch_name FROM TTD
	 --INNER JOIN [dbo].[tblConstantObjectValue] tcovmt ON tcovmt.object_value_id = TTD.market_type_id
	-- GROUP BY TTD.transaction_type, TTD.turnover,TTD.total_com,TTD.transaction_fee,TTD.ait,TTD.net_income,tcovmt.display_value,TTD.branch_name
	 
END










USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Service].[ssp_placed_order_by_user_id]    Script Date: 6/19/2016 12:26:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 18-06-2016
-- Description:	GET pending order for order place
-- =============================================
CREATE PROCEDURE [Service].[ssp_placed_order_by_user_id]
	  @user_id as varchar(128)
	, @membership_id AS NUMERIC(9,0)
AS
BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF
	 
	DECLARE @active_status_id AS NUMERIC(4,0)
	SET @active_status_id=DBO.sfun_get_constant_object_value_id('ACTIVE_STATUS','Active')

	IF EXISTS(SELECT * FROM [Escrow.Security].dbo.tblBrokerUser TBU WHERE TBU.UserId = @user_id AND TBU.membership_id = @membership_id AND is_admin=1)
		BEGIN
			SELECT
				tpo.id
				,tpo.client_id
				,tinv.first_holder_name
				,tins.security_code
				,tpo.order_type
				,tpo.market_price
				,tpo.negotiable
				,dd.FullDateUK approve_date
			 
			FROM [Service].[tblPlaceOrder] tpo
			INNER JOIN
				Investor.tblInvestor tinv
					ON tinv.client_id = tpo.client_id
			INNER JOIN
				Instrument.tblInstrument tins
					ON tins.id = tpo.instrument_id
			INNER JOIN
				dbo.DimDate dd
					ON dd.DateKey = tpo.approve_date
			INNER JOIN
				[broker].tblBrokerBranch tbrok
					ON tbrok.id = tinv.branch_id
			WHERE
				tpo.approve_by IS NOT NULL
				AND tpo.approve_date IS NOT NULL
				AND tpo.membership_id = @membership_id
				AND tinv.branch_id IN 
									(
										SELECT DISTINCT TBB.id
										FROM broker.tblBrokerBranch TBB
										WHERE TBB.active_status_id=@active_status_id AND TBB.membership_id = @membership_id
									)
		END
	ELSE
		BEGIN
			SELECT
				tpo.id
				,tpo.client_id
				,tinv.first_holder_name
				,tins.security_code
				,tpo.order_type
				,tpo.market_price
				,tpo.negotiable
				,dd.FullDateUK approve_date
			FROM [Service].[tblPlaceOrder] tpo
			INNER JOIN
				Investor.tblInvestor tinv
					ON tinv.client_id = tpo.client_id
			INNER JOIN
				Instrument.tblInstrument tins
					ON tins.id = tpo.instrument_id
			INNER JOIN
				dbo.DimDate dd
					ON dd.DateKey = tpo.approve_date
			INNER JOIN
				[broker].tblBrokerBranch tbrok
					ON tbrok.id = tinv.branch_id
			WHERE
				tpo.approve_by IS NOT NULL
				AND tpo.approve_date IS NOT NULL
				AND tpo.membership_id = @membership_id
				AND tinv.branch_id IN 
									(
										SELECT DISTINCT TBB.id
										FROM [Escrow.Security].dbo.tblBrokerUser TBU
											INNER JOIN broker.tblEmployeeUserMapping EUM ON TBU.UserId=EUM.user_id AND TBU.membership_id=EUM.membership_id
											INNER JOIN broker.tblEmployee TE ON EUM.employee_id=TE.id AND EUM.membership_id=TE.membership_id
											INNER JOIN broker.tblBrokerBranch TBB ON TE.branch_id=TBB.id AND TE.membership_id=TBB.membership_id
										WHERE TBB.active_status_id = @active_status_id
											AND TBU.UserId = @user_id
									)
		END
END













USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Service].[ssp_pending_order_by_user_id]    Script Date: 6/19/2016 12:26:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 18-06-2016
-- Description:	GET pending order for order place
-- =============================================
CREATE PROCEDURE [Service].[ssp_pending_order_by_user_id]
	  @user_id as varchar(128)
	, @membership_id AS NUMERIC(9,0)
AS
BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF
	 
	DECLARE @active_status_id AS NUMERIC(4,0)
	SET @active_status_id=DBO.sfun_get_constant_object_value_id('ACTIVE_STATUS','Active')

	IF EXISTS(SELECT * FROM [Escrow.Security].dbo.tblBrokerUser TBU WHERE TBU.UserId = @user_id AND TBU.membership_id = @membership_id AND is_admin=1)
		BEGIN
			SELECT
				tpo.id
				,tpo.client_id
				,tinv.first_holder_name
				,tins.security_code
				,tpo.order_type
				,tpo.market_price
				,tpo.negotiable
			 
			FROM [Service].[tblPlaceOrder] tpo
			INNER JOIN
				Investor.tblInvestor tinv
					ON tinv.client_id = tpo.client_id
			INNER JOIN
				Instrument.tblInstrument tins
					ON tins.id = tpo.instrument_id
			INNER JOIN
				[broker].tblBrokerBranch tbrok
					ON tbrok.id = tinv.branch_id
			WHERE
				tpo.approve_by IS NULL
				AND tpo.approve_date IS NULL
				AND tpo.membership_id = @membership_id
				AND tinv.branch_id IN 
									(
										SELECT DISTINCT TBB.id
										FROM broker.tblBrokerBranch TBB
										WHERE TBB.active_status_id=@active_status_id AND TBB.membership_id = @membership_id
									)
		END
	ELSE
		BEGIN
			SELECT
				tpo.id
				,tpo.client_id
				,tinv.first_holder_name
				,tins.security_code
				,tpo.order_type
				,tpo.market_price
				,tpo.negotiable
			FROM [Service].[tblPlaceOrder] tpo
			INNER JOIN
				Investor.tblInvestor tinv
					ON tinv.client_id = tpo.client_id
			INNER JOIN
				Instrument.tblInstrument tins
					ON tins.id = tpo.instrument_id
			INNER JOIN
				[broker].tblBrokerBranch tbrok
					ON tbrok.id = tinv.branch_id
			WHERE
				tpo.approve_by IS NULL
				AND tpo.approve_date IS NULL
				AND tpo.membership_id = @membership_id
				AND tinv.branch_id IN 
									(
										SELECT DISTINCT TBB.id
										FROM [Escrow.Security].dbo.tblBrokerUser TBU
											INNER JOIN broker.tblEmployeeUserMapping EUM ON TBU.UserId=EUM.user_id AND TBU.membership_id=EUM.membership_id
											INNER JOIN broker.tblEmployee TE ON EUM.employee_id=TE.id AND EUM.membership_id=TE.membership_id
											INNER JOIN broker.tblBrokerBranch TBB ON TE.branch_id=TBB.id AND TE.membership_id=TBB.membership_id
										WHERE TBB.active_status_id = @active_status_id
											AND TBU.UserId = @user_id
									)
		END
END































