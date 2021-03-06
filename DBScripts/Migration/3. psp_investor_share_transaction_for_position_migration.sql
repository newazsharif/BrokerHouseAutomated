USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[psp_investor_share_transaction]    Script Date: 2/9/2016 7:35:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 03-DEC-2015
-- Description:	HANDLE ALL KINDS OF SHARE TRANSACTION (IPO, DIVEDEND, BONUS, RIGHTS, BUY, SALE) FROM A SINGLE SP
-- Updated by : Sarwar
-- Update Date: 12/08/2015
-- Description: Added block for SHARE MATURITY

/*
	DECLARE @ERROR AS VARCHAR(MAX)
		, @SHARE_LEDGER_TYPE_ID AS NUMERIC(4,0)
		, @NEW_PROCESS_DATE AS NUMERIC(9,0)
		,@start_by nvarchar(MAX)='1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
	BEGIN TRANSACTION
	BEGIN TRY
		SET @NEW_PROCESS_DATE=dbo.sfun_get_process_date() ---GET NEW TRANSACTION DATE
		SET @SHARE_LEDGER_TYPE_ID = dbo.sfun_get_constant_object_value_id('SHARE_LEDGER_TYPE', 'SHARE SETTLEMENT') 
		EXEC Investor.psp_investor_share_transaction @process_dt, @SHARE_LEDGER_TYPE_ID, @membership_id, @start_by --Call share transaction execution process
		RAISERROR('PASS',16,1)
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @ERROR=ERROR_MESSAGE()
		RAISERROR(@ERROR,16,1)
	END CATCH
*/

-- =============================================
ALTER PROCEDURE [Investor].[psp_investor_share_transaction]
	 @id AS VARCHAR(MAX)
	, @SHARE_LEDGER_TYPE_ID AS NUMERIC(4,0)
	, @membership_id numeric(9,0)
	, @changed_user_id VARCHAR(128)
AS
BEGIN
	DECLARE
		 @PROCESS_DATE AS NUMERIC(9,0)
		,@active_status_id AS NUMERIC(4,0)
		,@FINANCIAL_LEDGER_TYPE_ID AS NUMERIC(4,0)
		,@ERROR_MESSAGE VARCHAR(MAX)
	
	DECLARE @ShareTransaction AS ShareTransactionType

	BEGIN TRY

	SELECT @PROCESS_DATE=dbo.sfun_get_process_date()
	SELECT @active_status_id=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
	
	
	----=====================================START: GET SHARE TRANSACTION DATA========================================
	IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='IPO'))
	BEGIN
		PRINT 'GET IPO'
		INSERT INTO @ShareTransaction
		SELECT * FROM [Investor].[tfun_get_investor_ipo_share_transaction]()
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='TRANSMISSION'))
	BEGIN
		PRINT 'GET TRANSMISSION'
		INSERT INTO @ShareTransaction
		SELECT * FROM [Investor].[tfun_get_investor_transmission_share_transaction]()
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='Devidend Receivable'))
	BEGIN
	    PRINT 'GET Devidend Receivable'
		INSERT INTO @ShareTransaction
		SELECT * FROM [Investor].[tfun_get_investor_devidend_receivable_share_transaction]()
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='BONUS/RIGHTS'))
	BEGIN
		PRINT 'GET BONUS/RIGHTS'
		INSERT INTO @ShareTransaction
		SELECT * FROM [Investor].[tfun_get_investor_bonus_rights_share_transaction]()
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='BUY/SALE'))
	BEGIN
		PRINT 'GET BUY/SALE'
		INSERT INTO @ShareTransaction
		SELECT * FROM [Investor].[tfun_get_investor_buy_sale_share_transaction](@id, @membership_id)
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='Reverse BUY/SALE'))
	BEGIN
		PRINT 'GET Reverse BUY/SALE'
		INSERT INTO @ShareTransaction
		SELECT * FROM [Investor].[tfun_get_investor_reverse_buy_sale_share_transaction](@id, @membership_id)
	END
	--FOR SHARE MATURITY
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='Share Settlement'))
	BEGIN
		PRINT 'GET Share Settlement'
		INSERT INTO @ShareTransaction
		SELECT * FROM [Investor].[tfun_get_investor_share_settlement_share_transaction](@id, @membership_id)
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='MANUAL IN/OUT'))
	BEGIN
		PRINT 'GET MANUAL IN/OUT'
		INSERT INTO @ShareTransaction
		SELECT * FROM [Investor].[tfun_get_investor_manual_in_out_share_transaction](@id,@membership_id)
	END
	----=====================================CLOSE: GET SHARE TRANSACTION DATA========================================

	EXEC [Investor].[psp_investor_share_ledger_transaction] @PROCESS_DATE, @membership_id, @changed_user_id, @ShareTransaction

	EXEC [Investor].[psp_investor_share_balance_transaction] @PROCESS_DATE, @membership_id, @changed_user_id, @ShareTransaction

	----=====================================START: MANAGE FINANCILA LEDGER FOR SHARE TRANSACTION========================================
	IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='BUY/SALE'))
	BEGIN
		print 'FINANCIAL_LEDGER_TYPE BUY/SALE'
		SELECT @FINANCIAL_LEDGER_TYPE_ID=dbo.sfun_get_constant_object_value_id('FINANCIAL_LEDGER_TYPE','BUY/SALE')
		EXEC Investor.psp_investor_financial_transaction @PROCESS_DATE, @FINANCIAL_LEDGER_TYPE_ID, @membership_id, @changed_user_id
	END

	IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='Reverse BUY/SALE'))
	BEGIN
		print 'FINANCIAL_LEDGER_TYPE Reverse BUY/SALE'
		SELECT @FINANCIAL_LEDGER_TYPE_ID=dbo.sfun_get_constant_object_value_id('FINANCIAL_LEDGER_TYPE','Reverse BUY/SALE')
		EXEC Investor.psp_investor_financial_transaction @PROCESS_DATE, @FINANCIAL_LEDGER_TYPE_ID, @membership_id, @changed_user_id
	END
	
	--Update Market value and cost value
	PRINT 'COST_VALUE/MARKET_VALUE 2'
	SELECT @FINANCIAL_LEDGER_TYPE_ID=dbo.sfun_get_constant_object_value_id('FINANCIAL_LEDGER_TYPE','COST_VALUE/MARKET_VALUE')
	EXEC Investor.psp_investor_financial_transaction @PROCESS_DATE, @FINANCIAL_LEDGER_TYPE_ID, @membership_id, @changed_user_id
	----=====================================CLOSE: MANAGE FINANCILA LEDGER FOR SHARE TRANSACTION========================================

	END TRY
	BEGIN CATCH
		SET @ERROR_MESSAGE=ERROR_MESSAGE()
		RAISERROR(@ERROR_MESSAGE,16,1)
	END CATCH
	
END









