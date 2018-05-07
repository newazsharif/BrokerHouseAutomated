DECLARE @ERROR AS VARCHAR(MAX)
BEGIN TRANSACTION
BEGIN TRY

		DECLARE @PROCESS_DATE AS NUMERIC(9,0)
			,@receive_transaction_type_id AS NUMERIC(4,0)
			,@withdraw_transaction_type_id AS NUMERIC(4,0)
			,@active_status_id AS NUMERIC(4,0)
			,@membership_id AS NUMERIC(9,0)
			,@changed_user_id AS [nvarchar](128)
			,@ids as nvarchar(max)
			,@SHARE_LEDGER_TYPE_ID AS NUMERIC(4,0)

		SET @PROCESS_DATE=dbo.sfun_get_process_date()
		SET @receive_transaction_type_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','RECEIVE')
		SET @withdraw_transaction_type_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','WITHDRAW')
		SELECT @MEMBERSHIP_ID=membership_id FROM [Escrow.Security].dbo.tblBrokerInformation
		SET @ACTIVE_STATUS_ID=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
		SET @changed_user_id = (SELECT TOP 1 UserId FROM [Escrow.Security].dbo.tblBrokerUser WHERE membership_id=@MEMBERSHIP_ID AND is_admin=1)


		select * into #investor_share_balnace from Investor.tfun_get_investor_share_balnace(@PROCESS_DATE,63)
		print 'Got share current balance'
		-- TRUNCATE TABLE [Instrument].[tblInstrumentManualInOut]
		--------------------------------------Start: Receive and Delevery which quantity are not same in BOAS and CBO---------------------
		INSERT INTO [Instrument].[tblInstrumentManualInOut]
		(
			 [client_id]			-- varchar(10)
			,[instrument_id]		-- numeric(4,0)
			,[transaction_date]		-- numeric(9,0)
			,[transaction_type_id]	-- numeric(4,0)
			,[quantity]				-- numeric(15,0)
			,[rate]					-- numeric(30,10)
			,[remarks]				-- varchar(500)
			,[active_status_id]		-- int NOT NULL
			,[membership_id]		-- [numeric](9, 0) NOT NULL,
			,[changed_user_id]		-- [nvarchar](128) NOT NULL,
			,[changed_date]			-- [datetime] NOT NULL,
			,[is_dirty]				-- [numeric](1, 0) NOT NULL
		)
		select 
			 b.ClientCode
			,ins.id instrument_id
			,@PROCESS_DATE transaction_date
			,CASE WHEN b.Quantity - c.Quantity > 0 THEN @withdraw_transaction_type_id ELSE @receive_transaction_type_id END transaction_type_id
			,CASE WHEN b.Quantity - c.Quantity > 0 THEN b.Quantity - c.Quantity ELSE c.Quantity - b.Quantity END quantity
			,isb.cost_average rate
			,'Opening Adjustment'
			,@active_status_id
			,@membership_id
			,@changed_user_id 
			,GETDATE() changed_date
			,0 is_dirty
		from
			BOASPositions b
		inner join
			Instrument.tblInstrument ins
			on b.SecurityCode=ins.security_code
		inner join 
			CBOPositions c
			on b.ClientCode=c.ClientCode
			and b.SecurityCode=c.SecurityCode
		inner join 
			#investor_share_balnace isb
			on b.ClientCode=isb.client_id
			and ins.id=isb.instrument_id
		where
			b.Quantity!=c.Quantity
			and b.ClientCode not like 'i%'
		order by
			b.ClientCode
			, b.SecurityCode    
		print 'Done Receive and Delevery which quantity are not same in BOAS and CBO'
		--------------------------------------End: Receive and Delevery which quantity are not same in BOAS and CBO---------------------
		--------------------------------------Start: Delevery which are extra in BOAS---------------------
		INSERT INTO [Instrument].[tblInstrumentManualInOut]
		(
			 [client_id]			-- varchar(10)
			,[instrument_id]		-- numeric(4,0)
			,[transaction_date]		-- numeric(9,0)
			,[transaction_type_id]	-- numeric(4,0)
			,[quantity]				-- numeric(15,0)
			,[rate]					-- numeric(30,10)
			,[remarks]				-- varchar(500)
			,[active_status_id]		-- int NOT NULL
			,[membership_id]		-- [numeric](9, 0) NOT NULL,
			,[changed_user_id]		-- [nvarchar](128) NOT NULL,
			,[changed_date]			-- [datetime] NOT NULL,
			,[is_dirty]				-- [numeric](1, 0) NOT NULL
		)
		select 
			 b.ClientCode
			,ins.id instrument_id
			,@PROCESS_DATE transaction_date
			,@withdraw_transaction_type_id transaction_type_id
			,b.Quantity quantity
			,isb.cost_average rate
			,'Opening Adjustment'
			,@active_status_id
			,@membership_id
			,@changed_user_id 
			,GETDATE() changed_date
			,0 is_dirty
		from
			BOASPositions b
		inner join
			Instrument.tblInstrument ins
			on b.SecurityCode=ins.security_code
		left join 
			CBOPositions c
			on b.ClientCode=c.ClientCode
			and b.SecurityCode=c.SecurityCode
		inner join 
			#investor_share_balnace isb
			on b.ClientCode=isb.client_id
			and ins.id=isb.instrument_id
		where
			c.Quantity is null
			and b.ClientCode not like 'i%'
		order by
			b.ClientCode
			, b.SecurityCode 
		print 'Done Delevery which are extra in BOAS' 
		--------------------------------------End: Delevery which are extra in BOAS---------------------
		--------------------------------------Start: Receive which quantity are not available in BOAS but availabe in CBO---------------------

		INSERT INTO [Instrument].[tblInstrumentManualInOut]
		(
			 [client_id]			-- varchar(10)
			,[instrument_id]		-- numeric(4,0)
			,[transaction_date]		-- numeric(9,0)
			,[transaction_type_id]	-- numeric(4,0)
			,[quantity]				-- numeric(15,0)
			,[rate]					-- numeric(30,10)
			,[remarks]				-- varchar(500)
			,[active_status_id]		-- int NOT NULL
			,[membership_id]		-- [numeric](9, 0) NOT NULL,
			,[changed_user_id]		-- [nvarchar](128) NOT NULL,
			,[changed_date]			-- [datetime] NOT NULL,
			,[is_dirty]				-- [numeric](1, 0) NOT NULL
		)
		select 
			 c.ClientCode
			,ins.id instrument_id
			,@PROCESS_DATE transaction_date
			,@receive_transaction_type_id transaction_type_id
			,c.Quantity quantity
			,isnull(ins.closed_price,0) rate
			,'Opening Adjustment'
			,@active_status_id
			,@membership_id
			,@changed_user_id 
			,GETDATE() changed_date
			,0 is_dirty
		from
			CBOPositions c
		left join 
			BOASPositions b
			on c.ClientCode=b.ClientCode
			and c.SecurityCode=b.SecurityCode
		inner join
			Instrument.tblInstrument ins
			on c.SecurityCode=ins.security_code
		inner join 
			Investor.tblInvestor inv
			on c.ClientCode=inv.client_id
		where
			b.Quantity is null
			and c.ClientCode not like 'i%'
		order by
			c.ClientCode
			, c.SecurityCode
		print 'Done Receive which quantity are not available in BOAS but availabe in CBO' 
		--------------------------------------End: Receive which quantity are not available in BOAS but availabe in CBO---------------------
		drop table #investor_share_balnace

		--------------------------------------START: Activate all investor WHO ARE EXISTS MANUAL TRANSFER---------------------
		UPDATE INV
		SET INV.active_status_id=61
		--SELECT DISTINCT INV.client_id 
		FROM Instrument.tblInstrumentManualInOut MIO
		INNER JOIN Investor.tblInvestor INV ON MIO.client_id=INV.client_id
		WHERE INV.active_status_id!=61
		--------------------------------------End: Activate all investor WHO ARE EXISTS MANUAL TRANSFER---------------------

		----------------------------------------Start: Process Share Transaction---------------------
		SELECT @ids = COALESCE(@ids + ', ','' ) + CAST(id AS varchar(18)) FROM Instrument.tblInstrumentManualInOut
		SET @SHARE_LEDGER_TYPE_ID = dbo.sfun_get_constant_object_value_id('SHARE_LEDGER_TYPE', 'MANUAL IN/OUT') 
		print 'Start Call share transaction execution process' 
		EXEC Investor.psp_investor_share_transaction @ids, @SHARE_LEDGER_TYPE_ID, @membership_id, @changed_user_id --Call share transaction execution process
		print 'Done Call share transaction execution process' 
		--------------------------------------End: Process Share Transaction---------------------

		--------------------------------------START: Deactivate all investor WHO ARE EXISTS MANUAL TRANSFER---------------------
		UPDATE Investor.tblInvestor
		SET active_status_id=63
		WHERE client_id NOT IN(
		SELECT ClientID FROM CBO.DBO.tbl_Client_Details
		WHERE client_status=1)
		--------------------------------------End: Deactivate all investor WHO ARE EXISTS MANUAL TRANSFER---------------------

		--------------------------------------Start: List of Missing Investors in BOAS---------------------
		select 
			distinct c.ClientCode, 'Missing Investors in BOAS' missing_in_BOAS
		from
			CBOPositions c
		left join
			Investor.tblInvestor inv
			on c.ClientCode=inv.client_id
		where
			inv.client_id is null
			and c.ClientCode not like 'i%'
		order by
			c.ClientCode
		--------------------------------------End: List of Missing Investors in BOAS---------------------
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SET @ERROR=ERROR_MESSAGE()
	RAISERROR(@ERROR,16,1)
END CATCH