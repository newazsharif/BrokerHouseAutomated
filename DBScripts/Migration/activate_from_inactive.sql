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

	print 'update share balance of existing client share balance'		
	update inv
	set bo_code=BoCode
		, active_status_id=@active_status_id
	--select 
	--	distinct ClientCode, BoCode 
	from
		Portfolio_Status ps
	inner join 
		Investor.tblInvestor inv
		on ps.ClientCode=inv.client_id

	update isb
	set isb.ledger_quantity=ps.LedgerQty
		,isb.salable_quantity=ps.FreeQty
		,isb.cost_average=case when isb.cost_average=0 then INS.closed_price else isb.cost_average end
		,isb.cost_value=ps.LedgerQty*(case when isb.cost_average=0 then INS.closed_price else isb.cost_average end)
		,isb.market_price=INS.closed_price
		,isb.market_value=ps.LedgerQty*INS.closed_price
	--select 
	--	ps.ClientCode, ps.InstrumentName, ps.LedgerQty, ps.FreeQty, isb.ledger_quantity, isb.salable_quantity, isb.transaction_date
	from
		Portfolio_Status ps
	inner join
		Instrument.tblInstrument ins
		on ps.isin=ins.isin
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
		on ps.ClientCode=isb.client_id
		and ins.id=isb.instrument_id


	print 'add new share in share ledger'
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
		ps.ClientCode,
		ins.id instrument_id,
		@PROCESS_DATE transaction_date,
		0 opening_qty,
		0 opening_rate,
		0 opening_cost,
		ps.LedgerQty received_qty,
		isnull(ins.closed_price,0) received_rate,
		ps.LedgerQty * isnull(ins.closed_price,0) received_cost,
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
		ps.LedgerQty remaining_qty,
		isnull(ins.closed_price,0) remaining_rate,
		ps.LedgerQty * isnull(ins.closed_price,0) remaining_cost,
		0 buy_qty,
		0 buy_cost,
		0 buy_commission,
		0 buy_rate,
		0 buy_amount,
		ps.LedgerQty closing_qty,
		isnull(ins.closed_price,0) closing_rate,
		ps.LedgerQty * isnull(ins.closed_price,0) closing_cost,
		@active_status_id, 
		@membership_id membership_id, 
		@changed_user_id changed_user_id, 
		GETDATE() changed_date, 
		1 is_dirty
	from
		Portfolio_Status ps
	inner join
		Instrument.tblInstrument ins
		on ps.isin=ins.isin
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
		on ps.ClientCode=isb.client_id
		and ins.id=isb.instrument_id
	where isb.membership_id is null

	print 'add new share in share balance'
	insert into Investor.tblInvestorShareBalance(transaction_date,client_id,instrument_id,ledger_quantity,salable_quantity,ipo_receivable_quantity,bonus_receivable_quantity,lock_quantity
			,pledge_quantity,cost_average,cost_value,market_price,market_value,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
		SELECT @PROCESS_DATE,ps.ClientCode,ins.id,ps.LedgerQty ledger_quantity,ps.FreeQty salable_quantity,0 ipo_receivable_quantity,0 bonus_receivable_quantity,0 lock_quantity
			,0 pledge_quantity,ISNULL(ins.closed_price,0) cost_average,ps.LedgerQty * ISNULL(ins.closed_price,0) cost_value,ISNULL(ins.closed_price,0) market_price,ps.LedgerQty * ISNULL(ins.closed_price,0) market_value
			, @active_status_id, @membership_id membership_id, @changed_user_id changed_user_id, GETDATE() changed_date, 1 is_dirty
	from
		Portfolio_Status ps
	inner join
		Instrument.tblInstrument ins
		on ps.isin=ins.isin
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
		on ps.ClientCode=isb.client_id
		and ins.id=isb.instrument_id
	where isb.membership_id is null

	print 'remove extra share from share balance'
	UPDATE ISB
	SET ledger_quantity=0
		, salable_quantity=0
		, cost_average=0
		, cost_value=0
		, market_value=0
		
	--select 
	--	ISB.* 
	from
		(select 
		 isb.*
		from
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
		where 
			 client_id in(select distinct ClientCode from Portfolio_Status)
		) AS ISB
	INNER JOIN 
		Instrument.tblInstrument INS
		ON ISB.instrument_id=INS.id
	LEFT JOIN 
		Portfolio_Status PS
		ON ISB.client_id=PS.ClientCode
		AND INS.isin=PS.isin
	WHERE PS.BoCode IS NULL

	print 'update final share to share ledger'
	;with isb as
	(
		select
			tisb.client_id, tisb.instrument_id, tisb.ledger_quantity, tisb.cost_average, tisb.cost_value
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
	)
	, isl as
	(
		select
			tisb.client_id, tisb.instrument_id, tisb.transaction_date, tisb.closing_qty, tisb.closing_rate, tisb.closing_cost
		from 
			Investor.tblInvestorShareLedger tisb
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
					from Investor.tblInvestorShareLedger stisb
					where stisb.client_id = tisb.client_id
					and stisb.instrument_id = tisb.instrument_id
				)
	)--288755

	update isl
	set isl.closing_qty=isb.ledger_quantity
		, isl.closing_rate=isb.cost_average
		, isl.closing_cost=isb.cost_value
	--select 
	--	* 
	from 
		isb 
	inner join
		isl
		on isb.client_id=isl.client_id
		and isb.instrument_id=isl.instrument_id
	inner join 
		Instrument.tblInstrument ins
		on isl.instrument_id=ins.id
	inner join
		Portfolio_Status ps
		on isl.client_id=ps.ClientCode
		and ins.isin=ps.isin


	SELECT @FINANCIAL_LEDGER_TYPE_ID=dbo.sfun_get_constant_object_value_id('FINANCIAL_LEDGER_TYPE','COST_VALUE/MARKET_VALUE')
	EXEC Investor.psp_investor_financial_transaction @PROCESS_DATE, @FINANCIAL_LEDGER_TYPE_ID, @membership_id, @changed_user_id

	truncate table Portfolio_Status
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SET @ERROR=ERROR_MESSAGE()
	RAISERROR(@ERROR,16,1)
END CATCH