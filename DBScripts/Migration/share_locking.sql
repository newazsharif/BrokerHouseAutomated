DECLARE @ERROR AS VARCHAR(MAX)
BEGIN TRANSACTION
BEGIN TRY

declare 
	  @process_date as numeric(9,0)
	, @membership_id as numeric(9,0)
	, @sector_id as numeric(4,0)
	, @instument_type_id as numeric(4,0)
	, @depository_company_id as numeric(4,0)
	, @group_id as numeric(4,0)
	, @market_type_id as numeric(4,0)
	, @active_status_id as numeric(4,0)
	, @changed_user_id as varchar(128)
	, @FINANCIAL_LEDGER_TYPE_ID as numeric(4,0)
	, @CLOSED_ACTIVE_STATUS_ID as numeric(4,0)

	SELECT @MEMBERSHIP_ID=membership_id FROM [Escrow.Security].dbo.tblBrokerInformation
	SET @process_date=dbo.sfun_get_process_date()
	SET @ACTIVE_STATUS_ID=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
	SET @CLOSED_ACTIVE_STATUS_ID=dbo.sfun_get_constant_object_value_id('ACTIVE_STATUS','CLOSE')
	SET @changed_user_id = (SELECT TOP 1 UserId FROM [Escrow.Security].dbo.tblBrokerUser WHERE membership_id=@MEMBERSHIP_ID AND is_admin=1)
	SET @instument_type_id=dbo.sfun_get_constant_object_default_value_id('INSTRUMENT_TYPE')
	SET @depository_company_id=dbo.sfun_get_constant_object_default_value_id('DEPOSITORY_COMPANY')
	SET @group_id=dbo.sfun_get_constant_object_default_value_id('INSTRUMENT_GROUP')
	SET @sector_id=dbo.sfun_get_constant_object_default_value_id('INSTRUMENT_SECTOR')
	SET @market_type_id=dbo.sfun_get_constant_object_default_value_id('MARKET_TYPE')

	print 'Remove match data'
	delete from lock_share where DIFF=0 and IS_SAME=1
	delete from lock_share where ClientCode=''

	print 'Add new instrument'
	insert into Instrument.tblInstrument(isin,security_code,instrument_name,sector_id,instument_type_id,depository_company_id,market_type_id
		,face_value,discount,premium,lot,is_marginable,group_id,closed_price,is_foreign
		,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
	select 
		ls.ISIN,'',ls.[INS NAME], @sector_id, @instument_type_id, @depository_company_id, @market_type_id
		,0,0,0,0,0,@group_id,0,0
		,@active_status_id,@membership_id,@changed_user_id,getdate(),0
	from 
		lock_share ls
	left join 
		Instrument.tblInstrument ins
		on ls.ISIN=ins.isin
	where ins.id is null

	print 'Back up inactive instument'
	select 
		distinct id 
	into #inactive_instrument
	from 
		lock_share ls
	inner join 
		Instrument.tblInstrument ins
		on ls.ISIN=ins.isin
	where ins.active_status_id !=@active_status_id

	print 'activate inactive instrument'
	update ins
	set ins.active_status_id=@active_status_id
	from 
		Instrument.tblInstrument ins
	inner join 
		#inactive_instrument ii
		on ins.id=ii.id

	print 'back up inactive investor'
	select 
		distinct ClientCode 
	into #inactive_client
	from 
		lock_share ls
	inner join 
		Investor.tblInvestor inv
		on ls.ClientCode=inv.client_id
	where inv.active_status_id !=@active_status_id

	print 'activate inactive investor'
	update inv
	set inv.active_status_id=@active_status_id
	from 
		Investor.tblInvestor inv
	inner join 
		#inactive_client ic
		on inv.client_id=ic.ClientCode

	print 'transfer lock quantity for available in share balance'
	update isb
	set salable_quantity=isb.salable_quantity-(ls.LED_QTY-ls.FREE_QTY)
		, lock_quantity=(ls.LED_QTY-ls.FREE_QTY)
	--select
	--	isb.client_id, isb.instrument_id, isb.transaction_date, isb.ledger_quantity, isb.salable_quantity, ls.LED_QTY, ls.FREE_QTY, isb.salable_quantity-(ls.LED_QTY-ls.FREE_QTY), ls.LED_QTY-ls.FREE_QTY
	from 
		lock_share ls
	inner join 
		Instrument.tblInstrument ins
		on ls.ISIN=ins.isin
	inner join 
		Investor.tblInvestor inv
		on ls.ClientCode=inv.client_id
	inner join
		(SELECT 
			I.* 
		FROM 
			Investor.tblInvestorShareBalance I
		INNER JOIN 
			(SELECT 
				client_id, instrument_id, MAX(transaction_date) transaction_date 
			FROM 
				Investor.tblInvestorShareBalance 
			GROUP BY 
				client_id, instrument_id
			) T
			ON I.client_id=T.client_id
			AND I.instrument_id=T.instrument_id
			AND I.transaction_date=T.transaction_date
			) isb 
		on ls.ClientCode=isb.client_id
		and ins.id=isb.instrument_id


	print 'transfer lock quantity for unavailable in share ledger'
	insert into Investor.tblInvestorShareLedger
		(
		client_id,
		instrument_id,
		transaction_date,
		opening_qty,
		opening_rate,
		opening_cost,
		received_qty,
		received_rate,
		received_cost,
		delivery_qty,
		delivery_rate,
		delivery_cost,
		sale_qty,
		sale_value,
		sale_commission,
		sale_rate,
		sale_amount,
		sale_cost_rate,
		sale_cost,
		gain_loss,
		remaining_qty,
		remaining_rate,
		remaining_cost,
		buy_qty,
		buy_cost,
		buy_commission,
		buy_rate,
		buy_amount,
		closing_qty,
		closing_rate,
		closing_cost,
		active_status_id,
		membership_id,
		changed_user_id,
		changed_date,
		is_dirty
		)
	SELECT 
		inv.client_id,
		ins.id instrument_id,
		@PROCESS_DATE transaction_date,
		0 opening_qty,
		0 opening_rate,
		0 opening_cost,
		ls.LED_QTY received_qty,
		isnull(ins.closed_price,0) received_rate,
		ls.LED_QTY * isnull(ins.closed_price,0) received_cost,
		0 delivery_qty,
		0 delivery_rate,
		0 delivery_cost,
		0 sale_qty,
		0 sale_value,
		0 sale_commission,
		0 sale_rate,
		0 sale_amount,
		0 sale_cost_rate,
		0 sale_cost,
		0 gain_loss,
		ls.LED_QTY remaining_qty,
		isnull(ins.closed_price,0) remaining_rate,
		ls.LED_QTY * isnull(ins.closed_price,0) remaining_cost,
		0 buy_qty,
		0 buy_cost,
		0 buy_commission,
		0 buy_rate,
		0 buy_amount,
		ls.LED_QTY closing_qty,
		isnull(ins.closed_price,0) closing_rate,
		ls.LED_QTY * isnull(ins.closed_price,0) closing_cost,
		@active_status_id, 
		@membership_id membership_id, 
		@changed_user_id changed_user_id, 
		GETDATE() changed_date, 
		1 is_dirty
	from 
		lock_share ls
	inner join 
		Instrument.tblInstrument ins
		on ls.ISIN=ins.isin
	inner join 
		Investor.tblInvestor inv
		on ls.ClientCode=inv.client_id
	left join
		(SELECT 
			I.* 
		FROM 
			Investor.tblInvestorShareBalance I
		INNER JOIN 
			(SELECT 
				client_id, instrument_id, MAX(transaction_date) transaction_date 
			FROM 
				Investor.tblInvestorShareBalance 
			GROUP BY 
				client_id, instrument_id
			) T
			ON I.client_id=T.client_id
			AND I.instrument_id=T.instrument_id
			AND I.transaction_date=T.transaction_date
			) isb 
		on ls.ClientCode=isb.client_id
		and ins.id=isb.instrument_id
	where isb.client_id is null

	print 'transfer lock quantity for unavailable in share balance'
	insert into Investor.tblInvestorShareBalance(transaction_date,client_id,instrument_id,ledger_quantity,salable_quantity,ipo_receivable_quantity,bonus_receivable_quantity,lock_quantity
			,pledge_quantity,cost_average,cost_value,market_price,market_value,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
		SELECT @PROCESS_DATE,inv.client_id,ins.id,ls.LED_QTY ledger_quantity,ls.FREE_QTY salable_quantity,0 ipo_receivable_quantity,0 bonus_receivable_quantity,ls.LED_QTY-ls.FREE_QTY lock_quantity
			,0 pledge_quantity,ISNULL(ins.closed_price,0) cost_average,ls.LED_QTY * ISNULL(ins.closed_price,0) cost_value,ISNULL(ins.closed_price,0) market_price,ls.LED_QTY * ISNULL(ins.closed_price,0) market_value
			, @active_status_id, @membership_id membership_id, @changed_user_id changed_user_id, GETDATE() changed_date, 1 is_dirty
	from 
		lock_share ls
	inner join 
		Instrument.tblInstrument ins
		on ls.ISIN=ins.isin
	inner join 
		Investor.tblInvestor inv
		on ls.ClientCode=inv.client_id
	left join
		(SELECT 
			I.* 
		FROM 
			Investor.tblInvestorShareBalance I
		INNER JOIN 
			(SELECT 
				client_id, instrument_id, MAX(transaction_date) transaction_date 
			FROM 
				Investor.tblInvestorShareBalance 
			GROUP BY 
				client_id, instrument_id
			) T
			ON I.client_id=T.client_id
			AND I.instrument_id=T.instrument_id
			AND I.transaction_date=T.transaction_date
			) isb 
		on ls.ClientCode=isb.client_id
		and ins.id=isb.instrument_id
	where isb.client_id is null	

	SELECT @FINANCIAL_LEDGER_TYPE_ID=dbo.sfun_get_constant_object_value_id('FINANCIAL_LEDGER_TYPE','COST_VALUE/MARKET_VALUE')
	EXEC Investor.psp_investor_financial_transaction @PROCESS_DATE, @FINANCIAL_LEDGER_TYPE_ID, @membership_id, @changed_user_id

	print 'unactivate inactive instrument'
	update ins
	set ins.active_status_id=@CLOSED_ACTIVE_STATUS_ID
	from 
		Instrument.tblInstrument ins
	inner join 
		#inactive_instrument ii
		on ins.id=ii.id

	print 'unactivate inactive investor'
	update inv
	set inv.active_status_id=@CLOSED_ACTIVE_STATUS_ID
	from 
		Investor.tblInvestor inv
	inner join 
		#inactive_client ic
		on inv.client_id=ic.ClientCode
	truncate table lock_share
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SET @ERROR=ERROR_MESSAGE()
	RAISERROR(@ERROR,16,1)
END CATCH