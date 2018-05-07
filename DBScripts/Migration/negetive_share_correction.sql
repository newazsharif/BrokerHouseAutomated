DECLARE @ERROR AS VARCHAR(MAX)
BEGIN TRANSACTION
BEGIN TRY

declare 
	  @process_date as numeric(9,0)
	, @membership_id as numeric(9,0)
	, @active_status_id as numeric(4,0)
	, @changed_user_id as varchar(128)
	, @FINANCIAL_LEDGER_TYPE_ID as numeric(4,0)

	SELECT @MEMBERSHIP_ID=membership_id FROM [Escrow.Security].dbo.tblBrokerInformation
	SET @process_date=dbo.sfun_get_process_date()
	SET @ACTIVE_STATUS_ID=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
	SET @changed_user_id = (SELECT TOP 1 UserId FROM [Escrow.Security].dbo.tblBrokerUser WHERE membership_id=@MEMBERSHIP_ID AND is_admin=1)


	update tisb
	set tisb.salable_quantity=0
	from 
		Investor.tblInvestorShareBalance tisb
	inner join 
		Instrument.tblInstrument tins 
		on tins.id = tisb.instrument_id
	inner join 
		Investor.tblInvestor tinv 
		on tinv.client_id = tisb.client_id
	where
		tisb.transaction_date = 
			(
				select max(stisb.transaction_date)
				from Investor.tblInvestorShareBalance stisb
				where stisb.client_id = tisb.client_id
				and stisb.instrument_id = tisb.instrument_id
			)
		and (tisb.salable_quantity<0)


	update tisb
	set tisb.ledger_quantity=tisb.salable_quantity
	from 
		Investor.tblInvestorShareBalance tisb
	inner join 
		Instrument.tblInstrument tins 
		on tins.id = tisb.instrument_id
	inner join 
		Investor.tblInvestor tinv 
		on tinv.client_id = tisb.client_id
	where
		tisb.transaction_date = 
			(
				select max(stisb.transaction_date)
				from Investor.tblInvestorShareBalance stisb
				where stisb.client_id = tisb.client_id
				and stisb.instrument_id = tisb.instrument_id
			)
		and (tisb.ledger_quantity<0)

	update tisb
	set tisb.ledger_quantity=tisb.salable_quantity, tisb.cost_value=tisb.salable_quantity*tisb.cost_average, tisb.market_value=tisb.salable_quantity*tisb.market_price
	from 
		Investor.tblInvestorShareBalance tisb
	inner join 
		Instrument.tblInstrument tins 
		on tins.id = tisb.instrument_id
	inner join 
		Investor.tblInvestor tinv 
		on tinv.client_id = tisb.client_id
	where
		tisb.transaction_date = 
			(
				select max(stisb.transaction_date)
				from Investor.tblInvestorShareBalance stisb
				where stisb.client_id = tisb.client_id
				and stisb.instrument_id = tisb.instrument_id
			)
		and (tisb.ledger_quantity< tisb.salable_quantity)

	update tisb
	set tisb.cost_value=0,tisb.cost_average=0, tisb.market_value=0
	from 
		Investor.tblInvestorShareBalance tisb
	inner join 
		Instrument.tblInstrument tins 
		on tins.id = tisb.instrument_id
	inner join 
		Investor.tblInvestor tinv 
		on tinv.client_id = tisb.client_id
	where
		tisb.transaction_date = 
			(
				select max(stisb.transaction_date)
				from Investor.tblInvestorShareBalance stisb
				where stisb.client_id = tisb.client_id
				and stisb.instrument_id = tisb.instrument_id
			)
		and (tisb.ledger_quantity=0 and tisb.salable_quantity=0)

	SELECT @FINANCIAL_LEDGER_TYPE_ID=dbo.sfun_get_constant_object_value_id('FINANCIAL_LEDGER_TYPE','COST_VALUE/MARKET_VALUE')
	EXEC Investor.psp_investor_financial_transaction @PROCESS_DATE, @FINANCIAL_LEDGER_TYPE_ID, @membership_id, @changed_user_id

COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SET @ERROR=ERROR_MESSAGE()
	RAISERROR(@ERROR,16,1)
END CATCH