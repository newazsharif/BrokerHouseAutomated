GO
/****** Object:  UserDefinedFunction [Investor].[tfun_get_investor_fund_balnace]    Script Date: 3/7/2016 5:50:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 30-JAN-2016
-- Description:	GET ALL ACTIVE INVESTORS FUND BALANCE
-- SELECT * FROM investor.tfun_get_investor_fund_balnace(20160126,63)
-- =============================================

ALTER FUNCTION [Investor].[tfun_get_investor_fund_balnace]
(	
	  @PROCESS_DATE AS NUMERIC(9,0)
	, @membership_id AS NUMERIC(4,0)
)
RETURNS @RESULT TABLE 
( 
	client_id varchar(10),
	transaction_date numeric(9, 0),
	account_type_id numeric(4, 0),
	available_balance numeric(30, 10),
	sale_receivable numeric(30, 10),
	un_clear_cheque numeric(30, 10),
	ledger_balance numeric(30, 10),
	total_deposit numeric(30, 10),
	share_transfer_in numeric(30, 10),
	total_withdraw numeric(30, 10),
	share_transfer_out numeric(30, 10),
	realized_interest numeric(30, 10),
	realized_charge numeric(30, 10),
	accured_interest numeric(30, 10),
	fund_withdrawal_request numeric(30, 10),
	cost_value numeric(30, 10),
	market_value numeric(30, 10),
	equity numeric(30, 10),
	marginable_equity numeric(30, 10),
	sanction_amount numeric(30, 10),
	loan_ratio numeric(15, 10),
	purchase_power numeric(30, 10),
	max_withdraw_limit numeric(30, 10),
	excess_over_limit numeric(30, 10),
	realized_gain numeric(30, 10),
	unrealized_gain numeric(30, 10),
	active_status_id int,
	membership_id numeric(9, 0),
	changed_user_id nvarchar(128),
	changed_date datetime,
	is_dirty numeric(1, 0)
)  

AS
BEGIN
	DECLARE @active_status_id AS NUMERIC(4,0)

	SET @active_status_id=dbo.sfun_get_constant_object_value_id('ACTIVE_STATUS','ACTIVE')
	IF @PROCESS_DATE>=dbo.sfun_get_process_date()
	BEGIN
		INSERT INTO @RESULT
		(
			client_id,-- varchar(10),
			transaction_date,-- numeric(9, 0),
			account_type_id,-- numeric(4, 0),
			available_balance,-- numeric(30, 10),
			sale_receivable,-- numeric(30, 10),
			un_clear_cheque,-- numeric(30, 10),
			ledger_balance,-- numeric(30, 10),
			total_deposit,-- numeric(30, 10),
			share_transfer_in,-- numeric(30, 10),
			total_withdraw,-- numeric(30, 10),
			share_transfer_out,-- numeric(30, 10),
			realized_interest,-- numeric(30, 10),
			realized_charge,-- numeric(30, 10),
			accured_interest,-- numeric(30, 10),
			fund_withdrawal_request,-- numeric(30, 10),
			cost_value,-- numeric(30, 10),
			market_value,-- numeric(30, 10),
			equity,-- numeric(30, 10),
			marginable_equity,-- numeric(30, 10),
			sanction_amount,-- numeric(30, 10),
			loan_ratio,-- numeric(15, 10),
			purchase_power,-- numeric(30, 10),
			max_withdraw_limit,-- numeric(30, 10),
			excess_over_limit,-- numeric(30, 10),
			realized_gain,-- numeric(30, 10),
			unrealized_gain,-- numeric(30, 10),
			active_status_id,-- int,
			membership_id,-- numeric(9, 0),
			changed_user_id,-- nvarchar(128),
			changed_date,-- datetime,
			is_dirty-- numeric(1, 0)
		)
		SELECT	
			  IFB.client_id
			, IFB.transaction_date
			, INV.account_type_id
			, IFB.available_balance
			, IFB.sale_receivable
			, IFB.un_clear_cheque
			, IFB.ledger_balance
			, IFB.total_deposit
			, IFB.share_transfer_in
			, IFB.total_withdraw
			, IFB.share_transfer_out
			, IFB.realized_interest
			, IFB.realized_charge
			, IFB.accured_interest
			, IFB.fund_withdrawal_request
			, IFB.cost_value
			, IFB.market_value
			, IFB.equity
			, IFB.marginable_equity
			, IFB.sanction_amount
			, IFB.loan_ratio
			, IFB.purchase_power
			, IFB.max_withdraw_limit
			, IFB.excess_over_limit
			, IFB.realized_gain
			, IFB.unrealized_gain
			, INV.active_status_id
			, IFB.membership_id
			, IFB.changed_user_id
			, IFB.changed_date
			, IFB.is_dirty
		FROM
			Investor.tblInvestorFundBalance AS IFB  WITH (INDEX(idx_member_date_client))
		INNER JOIN
			Investor.tblInvestor AS INV 
				ON IFB.client_id = INV.client_id 
				AND IFB.membership_id = INV.membership_id 
		WHERE
			(INV.active_status_id = @active_status_id)
			AND IFB.membership_id=@membership_id
	END
	ELSE
	BEGIN
		;WITH IFB2 AS
		(
			SELECT 
				  membership_id
				, client_id
				, MAX(transaction_date) AS transaction_date
			FROM 
				Investor.tblInvestorFundBalanceHistory WITH (INDEX(idx_member_date_client))
			WHERE 
				(transaction_date <= @PROCESS_DATE)
				AND (membership_id=@membership_id)
			GROUP BY 
				 membership_id
				,client_id
		)

		INSERT INTO @RESULT
		(
			client_id,-- varchar(10),
			transaction_date,-- numeric(9, 0),
			account_type_id,-- numeric(4, 0),
			available_balance,-- numeric(30, 10),
			sale_receivable,-- numeric(30, 10),
			un_clear_cheque,-- numeric(30, 10),
			ledger_balance,-- numeric(30, 10),
			total_deposit,-- numeric(30, 10),
			share_transfer_in,-- numeric(30, 10),
			total_withdraw,-- numeric(30, 10),
			share_transfer_out,-- numeric(30, 10),
			realized_interest,-- numeric(30, 10),
			realized_charge,-- numeric(30, 10),
			accured_interest,-- numeric(30, 10),
			fund_withdrawal_request,-- numeric(30, 10),
			cost_value,-- numeric(30, 10),
			market_value,-- numeric(30, 10),
			equity,-- numeric(30, 10),
			marginable_equity,-- numeric(30, 10),
			sanction_amount,-- numeric(30, 10),
			loan_ratio,-- numeric(15, 10),
			purchase_power,-- numeric(30, 10),
			max_withdraw_limit,-- numeric(30, 10),
			excess_over_limit,-- numeric(30, 10),
			realized_gain,-- numeric(30, 10),
			unrealized_gain,-- numeric(30, 10),
			active_status_id,-- int,
			membership_id,-- numeric(9, 0),
			changed_user_id,-- nvarchar(128),
			changed_date,-- datetime,
			is_dirty-- numeric(1, 0)
		)
		SELECT	
			  IFB.client_id
			, IFB.transaction_date
			, INV.account_type_id
			, IFB.available_balance
			, IFB.sale_receivable
			, IFB.un_clear_cheque
			, IFB.ledger_balance
			, IFB.total_deposit
			, IFB.share_transfer_in
			, IFB.total_withdraw
			, IFB.share_transfer_out
			, IFB.realized_interest
			, IFB.realized_charge
			, IFB.accured_interest
			, IFB.fund_withdrawal_request
			, IFB.cost_value
			, IFB.market_value
			, IFB.equity
			, IFB.marginable_equity
			, IFB.sanction_amount
			, IFB.loan_ratio
			, IFB.purchase_power
			, IFB.max_withdraw_limit
			, IFB.excess_over_limit
			, IFB.realized_gain
			, IFB.unrealized_gain
			, INV.active_status_id
			, IFB.membership_id
			, IFB.changed_user_id
			, IFB.changed_date
			, IFB.is_dirty
		FROM
			Investor.tblInvestorFundBalanceHistory AS IFB  WITH (INDEX(idx_member_date_client))
		INNER JOIN
			IFB2 
				ON IFB.membership_id = IFB2.membership_id 
				AND IFB.transaction_date=IFB2.transaction_date
				AND IFB.client_id = IFB2.client_id 
		INNER JOIN
			Investor.tblInvestor AS INV 
				ON IFB.client_id = INV.client_id 
				AND IFB.membership_id = INV.membership_id 
		WHERE
			(INV.active_status_id = @active_status_id)
	END

	RETURN
END
GO
/****** Object:  UserDefinedFunction [Investor].[tfun_get_investor_share_balnace]    Script Date: 3/7/2016 5:50:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 30-JAN-2016
-- Description:	GET ALL ACTIVE INVESTORS SHARE BALANCE
-- SELECT * FROM investor.tfun_get_investor_share_balnace(20160126,63)
-- =============================================

ALTER FUNCTION [Investor].[tfun_get_investor_share_balnace]
(	
	  @PROCESS_DATE AS NUMERIC(9,0)
	, @membership_id AS NUMERIC(4,0)
)
RETURNS @RESULT TABLE 
( 
	transaction_date numeric(9, 0),
	client_id varchar(10),
	instrument_id numeric(4, 0),
	ledger_quantity numeric(15, 0),
	salable_quantity numeric(15, 0),
	ipo_receivable_quantity numeric(15, 0),
	bonus_receivable_quantity numeric(15, 0),
	lock_quantity numeric(15, 0),
	pledge_quantity numeric(15, 0),
	cost_average numeric(30, 10),
	cost_value numeric(30, 10),
	market_price numeric(30, 10),
	market_value numeric(30, 10),
	active_status_id int,
	membership_id numeric(9, 0),
	changed_user_id nvarchar(128),
	changed_date datetime,
	is_dirty numeric(1, 0)
)  

AS
BEGIN
	DECLARE @active_status_id AS NUMERIC(4,0)

	SET @active_status_id=dbo.sfun_get_constant_object_value_id('ACTIVE_STATUS','ACTIVE')

	IF @PROCESS_DATE>=dbo.sfun_get_process_date()
	BEGIN
		INSERT INTO @RESULT
		(
			transaction_date,-- numeric(9, 0),
			client_id,-- varchar(10),
			instrument_id,-- numeric(4, 0),
			ledger_quantity,-- numeric(15, 0),
			salable_quantity,-- numeric(15, 0),
			ipo_receivable_quantity,-- numeric(15, 0),
			bonus_receivable_quantity,-- numeric(15, 0),
			lock_quantity,-- numeric(15, 0),
			pledge_quantity,-- numeric(15, 0),
			cost_average,-- numeric(30, 10),
			cost_value,-- numeric(30, 10),
			market_price,-- numeric(30, 10),
			market_value,-- numeric(30, 10),
			active_status_id,-- int,
			membership_id,-- numeric(9, 0),
			changed_user_id,-- nvarchar(128),
			changed_date,-- datetime,
			is_dirty-- numeric(1, 0)
		)
		SELECT ISB.transaction_date
			, ISB.client_id
			, ISB.instrument_id
			, ISB.ledger_quantity
			, ISB.salable_quantity
			, ISB.ipo_receivable_quantity
			, ISB.bonus_receivable_quantity
			, ISB.lock_quantity
			, ISB.pledge_quantity
			, ISB.cost_average
			, ISB.cost_value
			, ISB.market_price
			, ISB.market_value
			, ISB.active_status_id
			, ISB.membership_id
			, ISB.changed_user_id
			, ISB.changed_date
			, ISB.is_dirty
		FROM
			Investor.tblInvestorShareBalance AS ISB WITH (INDEX(idx_member_date_client_instrument))
		INNER JOIN
			Investor.tblInvestor AS INV
				ON ISB.client_id = INV.client_id 
				AND ISB.membership_id = INV.membership_id 
		INNER JOIN
			Instrument.tblInstrument AS INS 
				ON ISB.instrument_id = INS.id 
				AND ISB.membership_id = INS.membership_id 
		WHERE 
			INV.active_status_id = @active_status_id
			AND INS.active_status_id = @active_status_id
			AND (ISB.ledger_quantity <> 0 OR
				ISB.salable_quantity <> 0 OR
				ISB.ipo_receivable_quantity <> 0 OR
				ISB.bonus_receivable_quantity <> 0 OR
				ISB.lock_quantity <> 0 OR
				ISB.pledge_quantity <> 0
				)
	END
	ELSE
	BEGIN
		;WITH ISB2 AS 
		(
			SELECT membership_id
				, client_id
				, instrument_id
				, MAX(transaction_date) AS transaction_date
			FROM
				Investor.tblInvestorShareBalanceHistory WITH (INDEX(idx_member_date_client_instrument))
			WHERE
				(transaction_date <= @PROCESS_DATE) 
				AND (membership_id=@membership_id)
			GROUP BY 
				  membership_id
				, client_id
				, instrument_id
		)


		INSERT INTO @RESULT
		(
			transaction_date,-- numeric(9, 0),
			client_id,-- varchar(10),
			instrument_id,-- numeric(4, 0),
			ledger_quantity,-- numeric(15, 0),
			salable_quantity,-- numeric(15, 0),
			ipo_receivable_quantity,-- numeric(15, 0),
			bonus_receivable_quantity,-- numeric(15, 0),
			lock_quantity,-- numeric(15, 0),
			pledge_quantity,-- numeric(15, 0),
			cost_average,-- numeric(30, 10),
			cost_value,-- numeric(30, 10),
			market_price,-- numeric(30, 10),
			market_value,-- numeric(30, 10),
			active_status_id,-- int,
			membership_id,-- numeric(9, 0),
			changed_user_id,-- nvarchar(128),
			changed_date,-- datetime,
			is_dirty-- numeric(1, 0)
		)
		SELECT ISB.transaction_date
			, ISB.client_id
			, ISB.instrument_id
			, ISB.ledger_quantity
			, ISB.salable_quantity
			, ISB.ipo_receivable_quantity
			, ISB.bonus_receivable_quantity
			, ISB.lock_quantity
			, ISB.pledge_quantity
			, ISB.cost_average
			, ISB.cost_value
			, ISB.market_price
			, ISB.market_value
			, ISB.active_status_id
			, ISB.membership_id
			, ISB.changed_user_id
			, ISB.changed_date
			, ISB.is_dirty
		FROM
			Investor.tblInvestorShareBalanceHistory AS ISB WITH (INDEX(idx_member_date_client_instrument))
		INNER JOIN
			Investor.tblInvestor AS INV
				ON ISB.client_id = INV.client_id 
				AND ISB.membership_id = INV.membership_id 
		INNER JOIN
			Instrument.tblInstrument AS INS 
				ON ISB.instrument_id = INS.id 
				AND ISB.membership_id = INS.membership_id 
		INNER JOIN 
			ISB2
				ON ISB.membership_id=ISB2.membership_id
				AND ISB.transaction_date=ISB2.transaction_date
				AND ISB.client_id=ISB2.client_id
				AND ISB.instrument_id=ISB2.instrument_id
		WHERE 
			INV.active_status_id = @active_status_id
			AND INS.active_status_id = @active_status_id
			AND (ISB.ledger_quantity <> 0 OR
				ISB.salable_quantity <> 0 OR
				ISB.ipo_receivable_quantity <> 0 OR
				ISB.bonus_receivable_quantity <> 0 OR
				ISB.lock_quantity <> 0 OR
				ISB.pledge_quantity <> 0
				)
	END
	RETURN
END



GO
/****** Object:  View [Charge].[vw_all_investors_account_type_setting]    Script Date: 3/7/2016 5:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [Charge].[vw_all_investors_account_type_setting]
WITH SCHEMABINDING
AS
WITH cte AS (SELECT     client_id, account_type_id, initial_deposit, minimum_balance_on, minimum_balance, minimum_balance_is_percentage, withdraw_limit_on, 
                                                    withdraw_limit, withdraw_limit_percentage, loan_ratio, loan_max, loan_on, profit_on, 1 AS short_order
                             FROM         Charge.tblInvestorAccountTypeSetting
                             UNION ALL
                             SELECT     ti.client_id, ti.account_type_id, tsc.initial_deposit, tsc.minimum_balance_on, tsc.minimum_balance, tsc.minimum_balance_is_percentage, 
                                                   tsc.withdraw_limit_on, tsc.withdraw_limit, tsc.withdraw_limit_percentage, tsc.loan_ratio, tsc.loan_max, tsc.loan_on, tsc.profit_on, 2 AS short_order
                             FROM         Charge.tblSubAccountAccountTypeSetting AS tsc INNER JOIN
                                                   dbo.tblConstantObjectValue AS tcov ON tsc.sub_account_id = tcov.object_value_id INNER JOIN
                                                   dbo.tblConstantObject AS tco ON tcov.object_id = tco.object_id AND tco.object_name = 'INVESTOR_SUB_ACC' INNER JOIN
                                                   Investor.tblInvestor AS ti ON tcov.object_value_id = ti.sub_account_type_id
                             UNION ALL
                             SELECT     ti.client_id, ti.account_type_id, tbc.initial_deposit, tbc.minimum_balance_on, tbc.minimum_balance, tbc.minimum_balance_is_percentage, 
                                                   tbc.withdraw_limit_on, tbc.withdraw_limit, tbc.withdraw_limit_percentage, tbc.loan_ratio, tbc.loan_max, tbc.loan_on, tbc.profit_on, 3 AS short_order
                             FROM         Charge.tblBranchAccountTypeSetting AS tbc INNER JOIN
                                                   Investor.tblInvestor AS ti ON tbc.branch_id = ti.branch_id
                             UNION ALL
                             SELECT     ti.client_id, ti.account_type_id, Charge.tblGlobalAccountTypeSetting.initial_deposit, Charge.tblGlobalAccountTypeSetting.minimum_balance_on, 
                                                   Charge.tblGlobalAccountTypeSetting.minimum_balance, Charge.tblGlobalAccountTypeSetting.minimum_balance_is_percentage, 
                                                   Charge.tblGlobalAccountTypeSetting.withdraw_limit_on, Charge.tblGlobalAccountTypeSetting.withdraw_limit, 
                                                   Charge.tblGlobalAccountTypeSetting.withdraw_limit_percentage, Charge.tblGlobalAccountTypeSetting.loan_ratio, 
                                                   Charge.tblGlobalAccountTypeSetting.loan_max, Charge.tblGlobalAccountTypeSetting.loan_on, Charge.tblGlobalAccountTypeSetting.profit_on, 
                                                   4 AS short_order
                             FROM         Investor.tblInvestor AS ti CROSS JOIN
                                                   Charge.tblGlobalAccountTypeSetting)


    SELECT     c.client_id, c.account_type_id, actcov.display_value AS account_type_name, c.initial_deposit, c.minimum_balance_on, 
                            mbtcov.display_value AS minimun_balance_on_name, c.minimum_balance, c.minimum_balance_is_percentage, c.withdraw_limit_on, 
                            wltcov.display_value AS withdraw_limit_on_name, c.withdraw_limit, c.withdraw_limit_percentage, c.loan_ratio, c.loan_max, c.loan_on, 
                            loantcov.display_value AS loan_on_name, c.profit_on, profittcov.display_value AS profit_on_name, vifb.available_balance, vifb.ledger_balance, 
                            vifb.purchase_power, CASE WHEN [Transaction].[sfun_get_withdrawable_amount](mbtcov.display_value, c.minimum_balance, c.minimum_balance_is_percentage, 
                            wltcov.display_value, c.withdraw_limit, c.withdraw_limit_percentage, vifb.available_balance, vifb.ledger_balance, vifb.purchase_power) 
                            < 0 THEN 0 ELSE ISNULL([Transaction].[sfun_get_withdrawable_amount](mbtcov.display_value, c.minimum_balance, c.minimum_balance_is_percentage, 
                            wltcov.display_value, c.withdraw_limit, c.withdraw_limit_percentage, vifb.available_balance, vifb.ledger_balance, vifb.purchase_power), 0) 
                            END AS withdrawable_amount
     FROM         cte AS c INNER JOIN
                            dbo.tblConstantObjectValue AS actcov ON c.account_type_id = actcov.object_value_id INNER JOIN
                            dbo.tblConstantObjectValue AS mbtcov ON c.minimum_balance_on = mbtcov.object_value_id INNER JOIN
                            dbo.tblConstantObjectValue AS wltcov ON c.withdraw_limit_on = wltcov.object_value_id INNER JOIN
                            dbo.tblConstantObjectValue AS loantcov ON c.loan_on = loantcov.object_value_id INNER JOIN
                            dbo.tblConstantObjectValue AS profittcov ON c.profit_on = profittcov.object_value_id INNER JOIN
                            Investor.tblInvestorFundBalance AS vifb ON vifb.client_id = c.client_id
     WHERE     (c.short_order =
                                (SELECT     MIN(short_order) AS Expr1
                                  FROM          cte AS e
                                  WHERE      (client_id = c.client_id) AND (account_type_id = c.account_type_id) AND (short_order <= c.short_order)))




GO
/****** Object:  View [Investor].[vw_InvestorFundBalance]    Script Date: 3/7/2016 5:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [Investor].[vw_InvestorFundBalance]
WITH SCHEMABINDING
AS
SELECT	
	INV.client_id, IFB.transaction_date, INV.account_type_id, IFB.available_balance, IFB.sale_receivable, IFB.un_clear_cheque, IFB.ledger_balance, IFB.total_deposit, IFB.share_transfer_in, IFB.total_withdraw, 
    IFB.share_transfer_out, IFB.realized_interest, IFB.realized_charge, IFB.accured_interest, IFB.fund_withdrawal_request, IFB.cost_value, IFB.market_value, IFB.equity, IFB.marginable_equity, 
    IFB.sanction_amount, IFB.loan_ratio, IFB.purchase_power, IFB.max_withdraw_limit, IFB.excess_over_limit, IFB.realized_gain, IFB.unrealized_gain, INV.active_status_id, INV.membership_id, 
    INV.changed_user_id, INV.changed_date, INV.is_dirty
FROM 
	Investor.tblInvestorFundBalance AS IFB 
INNER JOIN
	Investor.tblInvestor AS INV 
	ON IFB.client_id = INV.client_id 
	AND IFB.membership_id = INV.membership_id 
INNER JOIN
	dbo.tblConstantObjectValue AS COV 
	ON INV.active_status_id = COV.object_value_id
WHERE
	COV.display_value = 'ACTIVE'



GO

/****** Object:  View [Investor].[vw_InvestorShareBalance]    Script Date: 3/7/2016 5:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [Investor].[vw_InvestorShareBalance]
WITH SCHEMABINDING
AS

SELECT
	transaction_date, ISB.client_id, instrument_id, ledger_quantity, salable_quantity, ipo_receivable_quantity, bonus_receivable_quantity, lock_quantity, pledge_quantity, cost_average, cost_value, 
    market_price, market_value, ISB.active_status_id, ISB.membership_id, ISB.changed_user_id, ISB.changed_date, ISB.is_dirty
FROM            
	Investor.tblInvestorShareBalance AS ISB 
INNER JOIN
	Investor.tblInvestor AS INV 
	ON ISB.client_id = INV.client_id 
	AND ISB.membership_id = INV.membership_id 
INNER JOIN
	Instrument.tblInstrument AS INS 
	ON ISB.instrument_id = INS.id 
	AND ISB.membership_id = INS.membership_id 
INNER JOIN
	dbo.tblConstantObjectValue AS INVCOV 
	ON INV.active_status_id = INVCOV.object_value_id 
INNER JOIN
	dbo.tblConstantObjectValue AS INSCOV 
	ON INS.active_status_id = INSCOV.object_value_id 
WHERE
	INVCOV.display_value = 'ACTIVE' 
	AND INSCOV.display_value = 'ACTIVE' 
	AND (
			ISB.ledger_quantity <> 0 OR
			ISB.salable_quantity <> 0 OR
			ISB.ipo_receivable_quantity <> 0 OR
			ISB.bonus_receivable_quantity <> 0 OR
			ISB.lock_quantity <> 0 OR
			ISB.pledge_quantity <> 0
		)



GO
/****** Object:  StoredProcedure [Investor].[sfun_get_investor_fund_balance]    Script Date: 3/7/2016 5:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 22/11/15
-- Description:	Get fund balance investor wise
-- =============================================

ALTER FUNCTION [Investor].[sfun_get_investor_fund_balance](@InvID varchar(10),@TRD_DT numeric(9,0))  
RETURNS Numeric(15,4)  
WITH SCHEMABINDING
AS   
BEGIN  
    DECLARE @ClosingBalance numeric(30,10)  
    
	IF @TRD_DT=dbo.sfun_get_process_date()
	BEGIN   
		SELECT @ClosingBalance = ledger_balance 
		from [Investor].[tblInvestorFundBalance]  
		WHERE client_id = @INVID 
	END
	ELSE
	BEGIN
		SELECT @ClosingBalance = ledger_balance 
		from [Investor].[tblInvestorFundBalance]  
		WHERE client_id = @INVID 
		AND transaction_date =
		(
			Select MAX(transaction_date)
			FROM [Investor].[tblInvestorFundBalanceHistory] 
			WHERE client_id = @INVID AND transaction_date <= @TRD_DT
		)  
	END
	RETURN(ISNULL(@ClosingBalance,0))  
  
END








GO

/****** Object:  StoredProcedure [dbo].[psp_day_end_reverse]    Script Date: 3/7/2016 5:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 24-JAN-2016
-- Description:	REVERSE THE LAST DAY END PROCESS
/*
	DECLARE @ERROR AS VARCHAR(MAX)
	BEGIN TRANSACTION
	BEGIN TRY
		EXEC [dbo].[psp_day_end_reverse] '1bf1c0e7-fa04-4266-9ce4-d20d6516737a',63
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @ERROR=ERROR_MESSAGE()
		RAISERROR(@ERROR,16,1)
	END CATCH
*/
-- =============================================
ALTER PROCEDURE [dbo].[psp_day_end_reverse]
	 @start_by nvarchar(MAX)
    ,@membership_id numeric(9,0)
AS
BEGIN
	
	DECLARE @process_dt AS NUMERIC(9,0)
		, @OLD_PROCESS_DATE AS NUMERIC(9,0)

	IF EXISTS(SELECT Date TRANS_DATE FROM Trade.tblTradeData WHERE Date=@process_dt
				UNION ALL
			  SELECT receive_date FROM [Transaction].tblFundReceive WHERE receive_date=@process_dt
			    UNION ALL
			  SELECT withdraw_date FROM [Transaction].tblFundWithdraw WHERE withdraw_date=@process_dt
				UNION ALL
			  SELECT transaction_date FROM [Transaction].tblForceChargeApply WHERE transaction_date=@process_dt
	)
	BEGIN
		RAISERROR('Transaction available, reverse day end not possible',16,1)
	END

	SET @process_dt=dbo.sfun_get_process_date()
	SET @OLD_PROCESS_DATE=( select top 1 
				trade_date
			from 
				Trade.tblSettlementSchedule 
			where 
				trade_date<@process_dt 
				order by 
				trade_date DESC
				)

	DELETE FROM Investor.tblInvestorShareBalanceHistory WHERE transaction_date=@process_dt AND membership_id=@membership_id
	DELETE FROM Investor.tblInvestorShareLedger WHERE transaction_date=@process_dt AND membership_id=@membership_id
	DELETE FROM Investor.tblInvestorFundBalanceHistory WHERE transaction_date=@process_dt AND membership_id=@membership_id
	DELETE FROM Investor.tblInvestorFinancialLedger WHERE transaction_date=@process_dt AND membership_id=@membership_id
	DELETE FROM dbo.tblDayProcess WHERE process_date=@process_dt AND membership_id=@membership_id

	UPDATE dbo.tblDayProcess
	SET end_date=NULL, end_by=NULL, start_date=GETDATE(), start_by=@start_by
	WHERE process_date=@OLD_PROCESS_DATE AND membership_id=@membership_id

	UPDATE Investor.tblInvestorShareBalance
	SET transaction_date=@OLD_PROCESS_DATE
	WHERE transaction_date=@process_dt AND membership_id=@membership_id

	UPDATE Investor.tblInvestorFundBalance
	SET transaction_date=@OLD_PROCESS_DATE
	WHERE transaction_date=@process_dt  AND membership_id=@membership_id
END



GO
/****** Object:  StoredProcedure [dbo].[psp_day_start_balance_transfer]    Script Date: 3/7/2016 5:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 19-JAN-2015
-- Description:	BALANCE TRANSFER TO CURRENT DAY FROM PREVIOUS DAY
-- =============================================
ALTER PROCEDURE [dbo].[psp_day_start_balance_transfer]
	@process_dt numeric(8,0)
	,@start_by nvarchar(MAX)
    ,@membership_id numeric(9,0)
AS
BEGIN
	DECLARE @active_status_id AS NUMERIC(4,0)

	SET @ACTIVE_STATUS_ID=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
	PRINT 'START TRANSFER FINANCIAL BALANCE FOR NEW DAY'
	----=======================START TRANSFER FINANCIAL BALANCE========================
	INSERT INTO Investor.tblInvestorFundBalanceHistory
	(
		 client_id
		,transaction_date
		,account_type_id
		,available_balance
		,sale_receivable
		,un_clear_cheque
		,ledger_balance
		,total_deposit
		,share_transfer_in
		,total_withdraw
		,share_transfer_out
		,realized_interest
		,realized_charge
		,accured_interest
		,fund_withdrawal_request
		,cost_value
		,market_value
		,equity
		,marginable_equity
		,sanction_amount
		,loan_ratio
		,purchase_power
		,max_withdraw_limit
		,excess_over_limit
		,realized_gain
		,unrealized_gain
		,active_status_id
		,membership_id
		,changed_user_id
		,changed_date
		,is_dirty
	)
	SELECT 
		 IFB.client_id
		,transaction_date
		,account_type_id
		,available_balance
		,sale_receivable
		,un_clear_cheque
		,ledger_balance
		,total_deposit
		,share_transfer_in
		,total_withdraw
		,share_transfer_out
		,realized_interest
		,realized_charge
		,accured_interest
		,fund_withdrawal_request
		,cost_value
		,market_value
		,equity
		,marginable_equity
		,sanction_amount
		,loan_ratio
		,purchase_power
		,max_withdraw_limit
		,excess_over_limit
		,realized_gain
		,unrealized_gain
		,active_status_id
		,IFB.membership_id
		,@start_by changed_user_id
		,GETDATE() changed_date
		,0 is_dirty 
	FROM 
		Investor.tblInvestorFundBalance IFB
	WHERE 
		IFB.membership_id=@membership_id

	UPDATE Investor.tblInvestorFundBalance SET transaction_date=@process_dt WHERE membership_id=@membership_id
	----=======================CLOSE TRANSFER FINANCIAL BALANCE========================

	----=======================START TRANSFER SHARE BALANCE========================
	PRINT 'START TRANSFER SHARE BALANCE FOR NEW DAY'
	INSERT INTO Investor.tblInvestorShareBalanceHistory
	(
		 transaction_date
		,client_id
		,instrument_id
		,ledger_quantity
		,salable_quantity
		,ipo_receivable_quantity
		,bonus_receivable_quantity
		,lock_quantity
		,pledge_quantity
		,cost_average
		,cost_value
		,market_price
		,market_value
		,active_status_id
		,membership_id
		,changed_user_id
		,changed_date
		,is_dirty
	)
	SELECT 
		 @process_dt
		,ISB.client_id
		,instrument_id
		,ledger_quantity
		,salable_quantity
		,ipo_receivable_quantity
		,bonus_receivable_quantity
		,lock_quantity
		,pledge_quantity
		,cost_average
		,cost_value
		,market_price
		,market_value
		,ISB.active_status_id
		,ISB.membership_id
		,@start_by
		,GETDATE() changed_date
		,0 is_dirty
	FROM
		Investor.tblInvestorShareBalance ISB
	WHERE 
		ISB.membership_id=@membership_id
		AND (ledger_quantity!=0 
			OR salable_quantity!=0 
			OR ipo_receivable_quantity!=0 
			OR bonus_receivable_quantity!=0 
			OR lock_quantity!=0 
			OR pledge_quantity!=0)

	UPDATE Investor.tblInvestorShareBalance SET transaction_date=@process_dt WHERE membership_id=@membership_id
	----=======================CLOSE TRANSFER SHARE BALANCE========================
END




GO




/****** Object:  StoredProcedure [Investor].[psp_investor_financial_balance_transaction]    Script Date: 3/7/2016 5:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 12-JAN-2016
-- Description:	MANAGE INVESTOR SHARE LEDGER TRANSACTION 
-- EXEC [Investor].[psp_investor_financial_balance_transaction] NULL, NULL, NULL, NULL
-- =============================================
ALTER PROCEDURE [Investor].[psp_investor_financial_balance_transaction]
	  @PROCESS_DATE AS NUMERIC(9,0)
	, @active_status_id AS NUMERIC(4,0)
	, @membership_id numeric(9,0)
	, @changed_user_id VARCHAR(128)
	, @FinancialTransaction AS FinancialTransactionType READONLY
AS
BEGIN
	
		SELECT * INTO #InvestorBalance FROM Investor.tfun_get_investor_fund_balnace(@PROCESS_DATE,@membership_id)
		-----------------------Insert data from investor temporary to fund balance-----------------------
		print '1:insert into Investor.tblInvestorFundBalance'
		insert into Investor.tblInvestorFundBalance(client_id,transaction_date,account_type_id,available_balance,sale_receivable,un_clear_cheque,ledger_balance,total_deposit,share_transfer_in,total_withdraw,share_transfer_out,realized_interest
			,realized_charge,accured_interest,fund_withdrawal_request,cost_value,market_value,equity,marginable_equity,sanction_amount,loan_ratio,purchase_power,max_withdraw_limit,excess_over_limit,realized_gain
			,unrealized_gain,active_status_id, membership_id, changed_user_id, changed_date, is_dirty)
		SELECT 
			TI.client_id, 
			@PROCESS_DATE transaction_date, 
			TI.account_type_id, 
			0 available_balance, 
			0 sale_receivable, 
			0 un_clear_cheque, 
			0 ledger_balance, 
			0 total_deposit, 
			0 share_transfer_in, 
			0 total_withdraw, 
			0 share_transfer_out, 
			0 realized_interest, 
			0 realized_charge, 
			0 accured_interest, 
			0 fund_withdrawal_request, 
			0 cost_value, 
			0 market_value, 
			0 equity, 
			0 marginable_equity, 
			0 sanction_amount, 
			0 loan_ratio, 
			0 purchase_power, 
			0 max_withdraw_limit, 
			0 excess_over_limit, 
			0 realized_gain, 
			0 unrealized_gain, 
			TI.active_status_id, 
			@membership_id membership_id, 
			@changed_user_id changed_user_id, 
			GETDATE() changed_date, 
			1 is_dirty
		FROM 
			Investor.tblInvestor TI
		INNER JOIN (
					SELECT 
						DISTINCT client_id, membership_id 
					FROM 
						@FinancialTransaction
					) TRN 
					ON TI.client_id=TRN.client_id 
					AND TI.membership_id=TRN.membership_id
		LEFT JOIN Investor.tblInvestorFundBalance IFB 
			ON TRN.client_id=IFB.client_id 
			AND TRN.membership_id=IFB.membership_id
		WHERE 
			IFB.client_id IS NULL 
			AND TI.active_status_id=@active_status_id
			AND TRN.membership_id=@membership_id

		--PRINT '2 insert into Investor.tblInvestorFundBalance'
		--insert into Investor.tblInvestorFundBalance(client_id,transaction_date,account_type_id,available_balance,sale_receivable,un_clear_cheque,ledger_balance,total_deposit
		--	,share_transfer_in,total_withdraw,share_transfer_out,realized_interest,realized_charge,accured_interest,fund_withdrawal_request
		--	,cost_value,market_value,equity,marginable_equity,sanction_amount,loan_ratio,purchase_power,max_withdraw_limit,excess_over_limit,realized_gain,unrealized_gain
		--	,active_status_id, membership_id, changed_user_id, changed_date, is_dirty)
		--SELECT 
		--	IFB.client_id,
		--	@PROCESS_DATE transaction_date,
		--	TI.account_type_id,
		--	available_balance,
		--	sale_receivable,
		--	un_clear_cheque,
		--	ledger_balance,
		--	total_deposit,
		--	share_transfer_in,
		--	total_withdraw,
		--	share_transfer_out,
		--	realized_interest,
		--	realized_charge,
		--	accured_interest,
		--	fund_withdrawal_request,
		--	cost_value,
		--	market_value,
		--	equity,
		--	marginable_equity,
		--	sanction_amount,
		--	loan_ratio,
		--	purchase_power,
		--	max_withdraw_limit,
		--	excess_over_limit,
		--	realized_gain,
		--	unrealized_gain,
		--	TI.active_status_id, 
		--	@membership_id membership_id,
		--	@changed_user_id changed_user_id, 
		--	GETDATE() changed_date, 
		--	1 is_dirty
		--FROM 
		--	Investor.tblInvestor TI
		--	INNER JOIN Investor.tblInvestorFundBalance IFB
		--			ON TI.client_id=IFB.client_id
		--			AND TI.membership_id=IFB.membership_id
		--WHERE 
		--	IFB.transaction_date<@PROCESS_DATE
		--	AND 
		--	(IFB.available_balance!=0 OR IFB.ledger_balance!=0 OR IFB.market_value!=0 OR IFB.cost_value!=0)
		--	AND 
		--	TI.active_status_id=@active_status_id


		PRINT 'UPDATE  Investor.tblInvestorFundBalance'
		UPDATE IFB
		SET
			  available_balance=available_balance + additional_available_balance
			, sale_receivable= sale_receivable + additional_sale_receivable
			, un_clear_cheque = un_clear_cheque + additional_un_clear_cheque
			, ledger_balance = ledger_balance + additional_ledger_balance
			, total_deposit = total_deposit + additional_total_deposit
			, share_transfer_in = share_transfer_in + additional_share_transfer_in
			, total_withdraw = total_withdraw + additional_total_withdraw
			, share_transfer_out = share_transfer_out + additional_share_transfer_out
			, realized_interest = realized_interest + additional_realized_interest
			, realized_charge = realized_charge + additional_realized_charge
			, accured_interest = accured_interest + additional_accured_interest
			, fund_withdrawal_request = fund_withdrawal_request + additional_fund_withdrawal_request
			, cost_value =  additional_cost_value
			, market_value =  additional_market_value

			, equity = CASE WHEN (ledger_balance + additional_ledger_balance +  additional_market_value)>0 -- EQUEITY MUST GREATER THAN 0
						THEN ledger_balance + additional_ledger_balance +  additional_market_value -- LEDGER BALANCE + MARKET VALUE
						ELSE 0 END 

			, marginable_equity = CASE WHEN (ledger_balance + additional_ledger_balance +  additional_market_value)>0 -- EQUEITY MUST GREATER THAN 0
						THEN ledger_balance + additional_ledger_balance +  additional_market_value -- LEDGER BALANCE + MARKET VALUE
						ELSE 0 END 

			--PURCHASE POWER = EQUITY * LOAN RATIO
			--, purchase_power = CASE WHEN loan_ratio<=0 THEN 
			--						CASE WHEN (ledger_balance + additional_ledger_balance +  additional_market_value)>0 -- EQUEITY MUST GREATER THAN 0
			--							THEN ledger_balance + additional_ledger_balance +  additional_market_value -- LEDGER BALANCE + MARKET VALUE
			--							ELSE 0 END
			--					ELSE (CASE WHEN (ledger_balance + additional_ledger_balance + additional_market_value)>0 -- EQUEITY MUST GREATER THAN 0
			--							THEN ledger_balance + additional_ledger_balance + additional_market_value -- LEDGER BALANCE + MARKET VALUE
			--							ELSE 0 END) 
			--					* loan_ratio END 
			, purchase_power = CASE WHEN loan_ratio<=0 THEN 
									CASE WHEN (ledger_balance + additional_ledger_balance)>0 -- LEDGER BALANCE MUST GREATER THAN 0
										THEN ledger_balance + additional_ledger_balance -- LEDGER BALANCE
										ELSE 0 END
								ELSE (CASE WHEN (ledger_balance + additional_ledger_balance + additional_market_value)>0 -- EQUEITY MUST GREATER THAN 0
										THEN ledger_balance + additional_ledger_balance + additional_market_value -- LEDGER BALANCE + MARKET VALUE
										ELSE 0 END) 
								* loan_ratio END 
			, realized_gain = realized_gain + additional_realized_gain
			, unrealized_gain = (market_value + additional_market_value)-(cost_value + additional_cost_value)
			, changed_user_id=@changed_user_id
			, changed_date=GETDATE()
			, is_dirty=1
			, active_status_id=TI.active_status_id
		FROM 
			(
				SELECT 
					client_id,membership_id,
					SUM(additional_available_balance) additional_available_balance, 
					SUM(additional_sale_receivable) additional_sale_receivable,
					SUM(additional_un_clear_cheque) additional_un_clear_cheque,
					SUM(additional_ledger_balance) additional_ledger_balance,
					SUM(additional_total_deposit) additional_total_deposit,SUM(additional_share_transfer_in) additional_share_transfer_in,SUM(additional_total_withdraw) additional_total_withdraw
					,SUM(additional_share_transfer_out) additional_share_transfer_out,SUM(additional_realized_interest) additional_realized_interest,SUM(additional_realized_charge) additional_realized_charge,SUM(additional_accured_interest) additional_accured_interest
					,SUM(additional_fund_withdrawal_request) additional_fund_withdrawal_request,SUM(additional_cost_value) additional_cost_value,SUM(additional_market_value) additional_market_value,SUM(additional_realized_gain) additional_realized_gain
				FROM @FinancialTransaction GROUP BY membership_id,client_id
			) TRN 
			INNER JOIN Investor.tblInvestor TI ON TRN.client_id=TI.client_id
			INNER JOIN Investor.tblInvestorFundBalance IFB ON TRN.client_id=IFB.client_id AND TRN.membership_id=IFB.membership_id
		WHERE IFB.transaction_date= @PROCESS_DATE

END





GO
/****** Object:  StoredProcedure [Investor].[psp_investor_share_balance_transaction]    Script Date: 3/7/2016 5:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 12-JAN-2016
-- Description:	MANAGE INVESTOR SHARE LEDGER TRANSACTION 
-- EXEC [Investor].[psp_investor_share_balance_transaction] NULL, NULL, NULL, NULL
-- =============================================
ALTER PROCEDURE [Investor].[psp_investor_share_balance_transaction]
	  @PROCESS_DATE AS NUMERIC(9,0)
	, @membership_id numeric(9,0)
	, @changed_user_id VARCHAR(128)
	, @ShareTransaction AS ShareTransactionType READONLY
AS
BEGIN
	
	--select * into #InvestorShareBalance from Investor.tfun_get_investor_share_balnace(@PROCESS_DATE,@membership_id)

	print '1 Investor.tblInvestorShareBalance'
	
	insert into Investor.tblInvestorShareBalance(transaction_date,client_id,instrument_id,ledger_quantity,salable_quantity,ipo_receivable_quantity,bonus_receivable_quantity,lock_quantity
		,pledge_quantity,cost_average,cost_value,market_price,market_value,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
	SELECT @PROCESS_DATE,TRN.client_id,TRN.instrument_id,0 ledger_quantity,0 salable_quantity,0 ipo_receivable_quantity,0 bonus_receivable_quantity,0 lock_quantity
		,0 pledge_quantity,0 cost_average,0 cost_value,ISNULL(TINS.closed_price,0) market_price,0 market_value, TI.active_status_id, @membership_id membership_id, @changed_user_id changed_user_id, GETDATE() changed_date, 1 is_dirty
	FROM @ShareTransaction TRN
		INNER JOIN Investor.tblInvestor TI ON TI.client_id=TRN.client_id AND TI.membership_id=TRN.membership_id
		INNER JOIN Instrument.tblInstrument TINS ON TRN.instrument_id=TINS.id 
		LEFT JOIN Investor.tblInvestorShareBalance ISB ON TRN.client_id=ISB.client_id AND TRN.instrument_id=ISB.instrument_id AND TRN.membership_id=ISB.membership_id
	WHERE ISB.client_id IS NULL

	--print '2 Investor.tblInvestorShareBalance'

	--insert into Investor.tblInvestorShareBalance
	--	(
	--	transaction_date,
	--	client_id,
	--	instrument_id,
	--	ledger_quantity,
	--	salable_quantity,
	--	ipo_receivable_quantity,
	--	bonus_receivable_quantity,
	--	lock_quantity,
	--	pledge_quantity,
	--	cost_average,
	--	cost_value,
	--	market_price,
	--	market_value,
	--	active_status_id,
	--	membership_id,
	--	changed_user_id,
	--	changed_date,
	--	is_dirty
	--	)
	--SELECT 
	--	@PROCESS_DATE,
	--	TRN.client_id,
	--	TRN.instrument_id,
	--	ISB.ledger_quantity,
	--	ISB.salable_quantity,
	--	ISB.ipo_receivable_quantity,
	--	ISB.bonus_receivable_quantity,
	--	ISB.lock_quantity,
	--	ISB.pledge_quantity,
	--	ISB.cost_average,
	--	ISB.cost_value,
	--	ISNULL(ISB.market_price,0),
	--	ISB.market_value, 
	--	TI.active_status_id, 
	--	@membership_id membership_id, 
	--	@changed_user_id changed_user_id, 
	--	GETDATE() changed_date, 
	--	1 is_dirty
	--FROM @ShareTransaction TRN
	--INNER JOIN 
	--	Investor.tblInvestor TI 
	--	ON TI.client_id=TRN.client_id 
	--	AND TI.membership_id=TRN.membership_id
	--INNER JOIN 
	--	Instrument.tblInstrument TINS 
	--	ON TRN.instrument_id=TINS.id
	--INNER JOIN 
	--	#InvestorShareBalance ISB
	--	ON TRN.client_id=ISB.client_id 
	--	AND TRN.instrument_id=ISB.instrument_id 
	--	AND TRN.membership_id=ISB.membership_id
	--	AND ISB.transaction_date < @PROCESS_DATE
	

	print 'start: update Investor.tblInvestorShareBalance'
	UPDATE ISB
	SET 
		 ISB.ledger_quantity=ISB.ledger_quantity + TRN.additional_ledger_quantity
		,ISB.salable_quantity=ISB.salable_quantity + TRN.additional_salable_quantity
		,ISB.ipo_receivable_quantity=ISB.ipo_receivable_quantity + TRN.additional_ipo_receivable_quantity
		,ISB.bonus_receivable_quantity=ISB.bonus_receivable_quantity + TRN.additional_bonus_receivable_quantity
		,ISB.lock_quantity=ISB.lock_quantity + TRN.additional_lock_quantity
		,ISB.pledge_quantity=ISB.pledge_quantity + TRN.additional_pledge_quantity
		,ISB.cost_average=CASE WHEN TRN.additional_cost_value>0 OR TRN.additional_ledger_quantity>0
									THEN --FOR BUY OR RECEIVE
										(
										CASE WHEN ISB.ledger_quantity + TRN.additional_ledger_quantity!=0 
										THEN 
											(ISB.cost_value + TRN.additional_cost_value)/(ISB.ledger_quantity + TRN.additional_ledger_quantity) 
										ELSE 
											0 
										END
										)
									ELSE --FOR SELL
										ISB.cost_average
									END
		,ISB.cost_value=CASE WHEN TRN.additional_cost_value> 0  OR TRN.additional_ledger_quantity>0
								  THEN --FOR BUY OR RECEIVE
									  ISB.cost_value + TRN.additional_cost_value
								  ELSE --FOR SELL
									CASE WHEN ISB.ledger_quantity>0 THEN
									  (ISB.ledger_quantity + TRN.additional_ledger_quantity) * (ISB.cost_value / ISB.ledger_quantity)
									  ELSE 0
									END
								  END
		,ISB.market_price=ISNULL((CASE WHEN TRN.market_price!=0 THEN TRN.market_price ELSE ISB.market_price END),0)
		,ISB.market_value=CASE WHEN (ISB.ledger_quantity + TRN.additional_ledger_quantity) !=0 THEN 
									(ISB.ledger_quantity + TRN.additional_ledger_quantity)*ISNULL((CASE WHEN TRN.market_price!=0 THEN TRN.market_price ELSE ISB.market_price END),0)
									ELSE
									0
									END
		,ISB.active_status_id=TI.active_status_id
	FROM @ShareTransaction TRN
		INNER JOIN Investor.tblInvestor TI ON TI.client_id=TRN.client_id --AND TI.membership_id=TRN.membership_id
		INNER JOIN Instrument.tblInstrument TINS ON TRN.instrument_id=TINS.id 
		INNER JOIN Investor.tblInvestorShareBalance ISB ON TRN.client_id=ISB.client_id AND TRN.instrument_id=ISB.instrument_id --AND TRN.membership_id=ISB.membership_id
	WHERE ISB.transaction_date=@PROCESS_DATE
	
	print 'end: update Investor.tblInvestorShareBalance'
END





GO
