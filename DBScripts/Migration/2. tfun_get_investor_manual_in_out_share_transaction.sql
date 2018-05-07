USE [Escrow.BOAS]
GO
/****** Object:  UserDefinedFunction [Investor].[tfun_get_investor_buy_sale_share_transaction]    Script Date: 2/9/2016 5:48:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 12-JAN-2016
-- Description:	GET IPO DATA FOR SHARE TRANSACTION MANAGEMENT

-- SELECT * FROM [Investor].[tfun_get_investor_manual_in_out_share_transaction]
-- =============================================
CREATE FUNCTION [Investor].[tfun_get_investor_manual_in_out_share_transaction]
(	
	  @ids AS VARCHAR(MAX) --- IN OUT IDs FROM tblInstrumentManualInOut
	, @membership_id numeric(9,0)
)
RETURNS @RESULT TABLE 
( 
	 client_id VARCHAR(10) 
	,instrument_id NUMERIC(4,0)
	,received_qty	numeric(15, 0)
	,received_cost	numeric(30, 10)
	,delivery_qty	numeric(15, 0)
	,delivery_cost	numeric(30, 10)
	,sale_qty	numeric(15, 0)
	,sale_value	numeric(30, 10)
	,sale_commission	numeric(30, 10)
	,buy_qty	numeric(15, 0)
	,buy_cost	numeric(30, 10)
	,buy_commission	numeric(30, 10)
	,additional_ledger_quantity	numeric(15, 0)
	,additional_salable_quantity	numeric(15, 0)
	,additional_ipo_receivable_quantity	numeric(15, 0)
	,additional_bonus_receivable_quantity	numeric(15, 0)
	,additional_lock_quantity	numeric(15, 0)
	,additional_pledge_quantity	numeric(15, 0)
	,additional_cost_value	numeric(30, 10)
	,market_price	numeric(30, 10)
	,membership_id NUMERIC(9,0)
)  
WITH SCHEMABINDING
AS
BEGIN
	DECLARE 
		 @receive_transaction_type_id AS NUMERIC(4,0)
		,@withdraw_transaction_type_id AS NUMERIC(4,0)

	SET @receive_transaction_type_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','RECEIVE')
	SET @withdraw_transaction_type_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','WITHDRAW')

	INSERT INTO @RESULT(client_id,instrument_id,received_qty,received_cost,delivery_qty,delivery_cost,sale_qty,sale_value,sale_commission,buy_qty,buy_cost,buy_commission
			,additional_ledger_quantity,additional_salable_quantity,additional_ipo_receivable_quantity,additional_bonus_receivable_quantity,additional_lock_quantity,additional_pledge_quantity
			,additional_cost_value,market_price,membership_id)
		SELECT MIO.client_id
			,MIO.instrument_id
			,CASE WHEN MIO.transaction_type_id=@receive_transaction_type_id THEN MIO.quantity ELSE 0 END received_qty
			,CASE WHEN MIO.transaction_type_id=@receive_transaction_type_id THEN MIO.quantity * MIO.rate ELSE 0 END received_cost
			,CASE WHEN MIO.transaction_type_id=@withdraw_transaction_type_id THEN MIO.quantity ELSE 0 END delivery_qty
			,CASE WHEN MIO.transaction_type_id=@withdraw_transaction_type_id THEN MIO.quantity * MIO.rate ELSE 0 END delivery_cost
			,0 sale_qty
			,0 sale_value
			,0 sale_commission
			,0 buy_qty
			,0 buy_cost
			,0 buy_commission
			,CASE WHEN MIO.transaction_type_id=@receive_transaction_type_id THEN MIO.quantity ELSE MIO.quantity *-1 END additional_ledger_quantity
			,CASE WHEN MIO.transaction_type_id=@receive_transaction_type_id THEN MIO.quantity ELSE MIO.quantity *-1 END additional_salable_quantity
			,0 additional_ipo_receivable_quantity
			,0 additional_bonus_receivable_quantity
			,0 additional_lock_quantity
			,0 additional_pledge_quantity
			,CASE WHEN MIO.transaction_type_id=@receive_transaction_type_id THEN MIO.quantity * MIO.rate ELSE (MIO.quantity * MIO.rate)*-1 END additional_cost_value
			,ISNULL(TINS.closed_price,0) market_price
			,MIO.membership_id
		FROM 
			DBO.udfSpliter(@ids) INS --- IN OUT IDs FROM tblInstrumentManualInOut = @ID
		INNER JOIN 
			Instrument.tblInstrumentManualInOut MIO 
			ON INS.id=MIO.id
		INNER JOIN 
			Instrument.tblInstrument TINS 
			ON MIO.instrument_id=TINS.id 
			and MIO.membership_id=TINS.membership_id
		WHERE 
			MIO.membership_id=@membership_id
	RETURN
END









