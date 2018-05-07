



USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_client_portfolio_statement_summary]    Script Date: 04/06/2016 4:13:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		SHOHID
-- Create date: 18/1/2016
--[Investor].[rsp_client_portfolio_statement_summary] 63,'4','2016-02-15','11450'
-- =============================================
-- =============================================
-- Edited by:	SHOHID
-- Create date: 17/02/2016
-- =============================================
ALTER PROCEDURE [Investor].[rsp_client_portfolio_statement_summary]
	@membership_id NUMERIC(9,0),
	@user_id nvarchar(128),
	@report_date DATETIME,
	@client_id VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	--DECLARATION
	DECLARE  @transection_date AS NUMERIC(9)
	DECLARE  @bo_code AS VARCHAR(16)

	--INITIALIZATION
	Select @transection_date = DATEKEY FROM [dbo].[DimDate] WHERE [DATE]=@report_date
	Select @bo_code = bo_code FROM [Investor].[tblInvestor] WHERE client_id = @client_id



	select * into #investorsharebalance from Investor.tfun_get_investor_share_balnace(@transection_date,@membership_id)
	WHERE client_id=@client_id

	SELECT
		ROW_NUMBER() OVER(ORDER BY a.fullDateUK) AS Serial_No,
		a.FullDateUK,
		a.qty,
		a.qty_type,
		a.security_code
		
	FROM 
	(	
			SELECT 
				--dt.FullDateUK,
				(SELECT MAX(tcdr.transaction_date) FROM [CDBL].[tblCdblDividendReceivable] tcdr WHERE tcdr.bo_code = @bo_code AND tcdr.isin = tins.isin GROUP BY tcdr.bo_code,tcdr.isin ) AS FullDateUK,
				'IPO Receivable' AS qty_type,
				tins.security_code, 
				SUM(insb.ipo_receivable_quantity) AS qty
			FROM 
				#investorsharebalance insb
			INNER JOIN 
				[Instrument].[tblInstrument] tins
					ON insb.instrument_id = tins.id
			INNER JOIN 
				[dbo].[DimDate] dt
					ON dt.DateKey = insb.transaction_date
			WHERE 
				insb.membership_id= @membership_id
				AND dt.Date<=@report_date
				AND insb.client_id = @client_id
				AND insb.ipo_receivable_quantity != 0
			GROUP BY 
				dt.FullDateUK,
				insb.transaction_date,
				tins.security_code,
				tins.isin
			
		UNION ALL

			SELECT 
				dt.FullDateUK,				
				'Lock' AS qty_type,
				tins.security_code, 
				SUM(insb.lock_quantity) AS qty
			FROM 
				#investorsharebalance insb
			INNER JOIN 
				[Instrument].[tblInstrument] tins
					ON insb.instrument_id = tins.id
			INNER JOIN 
				[dbo].[DimDate] dt
					ON dt.DateKey = insb.transaction_date		
					
				
			WHERE	
				insb.membership_id= @membership_id
				AND dt.Date<=@report_date
				AND insb.client_id = @client_id
				AND insb.lock_quantity != 0
			GROUP BY
				dt.FullDateUK,
				insb.transaction_date,
				tins.security_code

		UNION ALL

			SELECT 
				dt.FullDateUK,
				'Bonus Receivable' AS qty_type,
				tins.security_code, 
				SUM(insb.bonus_receivable_quantity) AS qty
			FROM 
				#investorsharebalance insb
			INNER JOIN 
				[Instrument].[tblInstrument] tins
					ON insb.instrument_id = tins.id
			INNER JOIN 
				[dbo].[DimDate] dt
					ON dt.DateKey = insb.transaction_date
			WHERE	
				insb.membership_id= @membership_id
				AND dt.Date<=@report_date
				AND insb.client_id = @client_id
				AND insb.bonus_receivable_quantity != 0
			GROUP BY
				dt.FullDateUK,
				insb.transaction_date,
				tins.security_code
	) a

END






update Instrument.tblInstrumentManualInOut
set approve_by = '1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
,approve_date = 20160411
where approve_by is null









------added two column in tblInstrumentManualInOut---------

--ALTER TABLE [Instrument].[tblInstrumentManualInOut]
--ADD [approve_by] [varchar](128) NULL,
--	[approve_date] [numeric](9, 0) NULL





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_trade_howla_wise]    Script Date: 2/17/2016 3:36:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Asif
-- Create date: 17/02/16
-- Description:	Trade howla wise
-- =============================================
--[Trade].[rsp_trade_howla_wise] 63, null, '2015-12-01','2015-12-12',null,null


CREATE PROCEDURE [Trade].[rsp_trade_howla_wise]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime,
@branch_id numeric(2,0),
@client_id varchar(10)
)

AS

BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF
	
	SELECT 
		ddd.FullDateUK AS trade_date
		,tbb.name AS branch
		,ttd.client_id
		,tinv.first_holder_name
		,tins.security_code
		,ttd.OrderId
		,CASE WHEN 
				ttd.transaction_type = 'B' 
			THEN 
				'Buy' 
			WHEN 
				ttd.transaction_type = 'S' 
			THEN 
				'Sell' 
		END AS transaction_type
		,ISNULL(ttd.Quantity,0) AS Quantity
		,ISNULL(ttd.Unit_Price,0) AS Unit_Price
		,ISNULL(ttd.Quantity,0) * ISNULL(ttd.Unit_Price,0) AS amount
		,ISNULL(ttd.commission_rate,0) AS commission_rate
		,ISNULL(ttd.commission_amount,0) AS commission_amount
		,CASE WHEN 
				ttd.transaction_type = 'B' 
			THEN 
				(ISNULL(ttd.Quantity,0) * ISNULL(ttd.Unit_Price,0)) + ISNULL(ttd.commission_amount,0)
			ELSE
				0
		END AS debit
		,CASE WHEN 
				ttd.transaction_type = 'S' 
			THEN 
				(ISNULL(ttd.Quantity,0) * ISNULL(ttd.Unit_Price,0)) - ISNULL(ttd.commission_amount,0)
			ELSE
				0
		END AS credit
	FROM 
		[Trade].[tblTradeData] ttd
	INNER JOIN 
		[Instrument].[tblInstrument] tins 
		ON tins.id = ttd.instrument_id
	INNER JOIN 
		[Investor].[tblInvestor] tinv 
		ON tinv.client_id = ttd.client_id
		AND tinv.membership_id=ttd.membership_id
	INNER JOIN dbo.DimDate ddd
		ON ddd.DateKey = ttd.Date
	INNER JOIN 
		[broker].[tblBrokerBranch] tbb 
		ON tbb.id = tinv.branch_id
		AND tbb.membership_id=ttd.membership_id
	INNER JOIN 
		DimDate ddf 
		ON @from_dt = ddf.Date
	INNER JOIN 
		Dimdate ddt 
		ON @to_dt = ddt.Date 
	WHERE
		ttd.membership_id = @membership_id
		AND ttd.Date BETWEEN ddf.DateKey AND ddt.DateKey
		AND (ttd.client_id = @client_id OR @client_id IS NULL OR @client_id = '')
		AND (tinv.branch_id = @branch_id OR @branch_id IS NULL OR @branch_id = 0)
		
	 
END







USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_trade_summary]    Script Date: 2/17/2016 3:36:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Asif
-- Create date: 17/02/16
-- Description:	Trade summary
-- =============================================
--[Trade].[rsp_trade_summary] 63, null, '2015-12-01','2015-12-12',null,null


CREATE PROCEDURE [Trade].[rsp_trade_summary]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime,
@branch_id numeric(2,0),
@client_id varchar(10)
)

AS

BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF
	
	SELECT 
		ddd.FullDateUK AS trade_date
		,tbb.name AS branch
		,ttd.client_id
		,tinv.first_holder_name
		,tins.security_code
		,CASE WHEN 
				ttd.transaction_type = 'B' 
			THEN 
				'Buy' 
			WHEN 
				ttd.transaction_type = 'S' 
			THEN 
				'Sell' 
		END AS transaction_type
		,SUM(ttd.Quantity) AS Quantity
		,AVG(ISNULL(ttd.Unit_Price,0)) AS Unit_Price
		,SUM(ISNULL(ttd.Quantity,0)) * SUM(ISNULL(ttd.Unit_Price,0)) AS amount
		,AVG(ISNULL(ttd.commission_rate,0)) AS commission_rate
		,SUM(ISNULL(ttd.commission_amount,0)) AS commission_amount
		,CASE WHEN 
				ttd.transaction_type = 'B' 
			THEN 
				(SUM(ISNULL(ttd.Quantity,0)) * SUM(ISNULL(ttd.Unit_Price,0))) + SUM(ISNULL(ttd.commission_amount,0))
			ELSE
				0
		END AS debit
		,CASE WHEN 
				ttd.transaction_type = 'S' 
			THEN 
				(SUM(ISNULL(ttd.Quantity,0)) * SUM(ISNULL(ttd.Unit_Price,0))) - SUM(ISNULL(ttd.commission_amount,0))
			ELSE
				0
		END AS credit
	FROM 
		[Trade].[tblTradeData] ttd
	INNER JOIN 
		[Instrument].[tblInstrument] tins 
		ON tins.id = ttd.instrument_id
	INNER JOIN 
		[Investor].[tblInvestor] tinv 
		ON tinv.client_id = ttd.client_id
		AND tinv.membership_id=ttd.membership_id
	INNER JOIN dbo.DimDate ddd
		ON ddd.DateKey = ttd.Date
	INNER JOIN 
		[broker].[tblBrokerBranch] tbb 
		ON tbb.id = tinv.branch_id
		AND tbb.membership_id=ttd.membership_id
	INNER JOIN 
		DimDate ddf 
		ON @from_dt = ddf.Date
	INNER JOIN 
		Dimdate ddt 
		ON @to_dt = ddt.Date 
	WHERE
		ttd.membership_id = @membership_id
		AND ttd.Date BETWEEN ddf.DateKey AND ddt.DateKey
		AND (ttd.client_id = @client_id OR @client_id IS NULL OR @client_id = '')
		AND (tinv.branch_id = @branch_id OR @branch_id IS NULL OR @branch_id = 0)
	GROUP BY 
		ddd.FullDateUK
		,tbb.name
		,ttd.client_id
		,tinv.first_holder_name
		,tins.security_code
		,ttd.transaction_type
		
END




INSERT INTO [dbo].[tblAction]
           ([name]
           ,[url]
           ,[display_name]
           ,[controller_id]
           ,[ui_module_id]
           ,[is_view]
           ,[is_in_menu])
     VALUES
           ('Trade Howla Wise'
           ,'/#Report/rptTrdHowlaWise'
           ,'Trade Howla Wise'
           ,48
           ,114
           ,1
           ,1)





INSERT INTO [dbo].[tblUserActionMapping]
           ([user_id]
           ,[action_id]
           ,[is_permitted]
           ,[membership_id])
     VALUES
           ('1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
           ,(select max(id) from [dbo].[tblAction])
           ,1
           ,63)




INSERT INTO [dbo].[tblAction]
           ([name]
           ,[url]
           ,[display_name]
           ,[controller_id]
           ,[ui_module_id]
           ,[is_view]
           ,[is_in_menu])
     VALUES
           ('Trade Summary'
           ,'/#Report/rptTrdSummary'
           ,'Trade Summary'
           ,48
           ,114
           ,1
           ,1)


INSERT INTO [dbo].[tblUserActionMapping]
           ([user_id]
           ,[action_id]
           ,[is_permitted]
           ,[membership_id])
     VALUES
           ('1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
           ,(select max(id) from [dbo].[tblAction])
           ,1
           ,63)





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_bo_acknowledgement]    Script Date: 2/23/2016 4:51:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 23/02/2016
-- Description: BO Acknowledgement
-- =============================================

--- exec Investor.rsp_bo_acknowledgement '63',null,'8'
CREATE PROCEDURE [Investor].[rsp_bo_acknowledgement]
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
	WHERE
		tinv.client_id = @client_id
		AND tinv.membership_id = @membership_id
END




INSERT INTO [dbo].[tblAction]
           ([name]
           ,[url]
           ,[display_name]
           ,[controller_id]
           ,[ui_module_id]
           ,[is_view]
           ,[is_in_menu])
     VALUES
           ('BO Acknowledgement'
           ,'/#Report/rptBoAcknowledgement'
           ,'BO Acknowledgement'
           ,48
           ,9
           ,1
           ,1)





INSERT INTO [dbo].[tblUserActionMapping]
           ([user_id]
           ,[action_id]
           ,[is_permitted]
           ,[membership_id])
     VALUES
           ('1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
           ,(select max(id) from [dbo].[tblAction])
           ,1
           ,63)







USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_brokerage_commission_buy_sell_wise]    Script Date: 2/27/2016 12:28:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_brokerage_commission_income_trader_wise 62, 20141020, 20151231
-- =============================================
-- Author:		Asif
-- Create date: 27/02/16
-- Description:	Brokerage commission buy sell wise
-- =============================================

-- exec [Trade].[rsp_brokerage_commission_buy_sell_wise] 63,NULL,'2016-01-07','2016-01-10'

CREATE PROCEDURE [Trade].[rsp_brokerage_commission_buy_sell_wise]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF

	 SELECT 
		dd.FullDateUK exe_date
		,brokb.name branch
		,SUM
			(
				CASE WHEN 
						ttd.transaction_type = 'B' 
					THEN 
						CAST(ttd.Quantity AS int) * ttd.Unit_Price 
					ELSE 
						0 
				END
			) AS buy_amount
		,SUM
			(
				CASE WHEN 
						ttd.transaction_type = 'S' 
					THEN 
						CAST(ttd.Quantity AS int) * ttd.Unit_Price 
					ELSE 
						0 
				END
			) AS sell_amount
		,SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) AS total_amount
		,SUM
			(
				CASE WHEN 
						ttd.transaction_type = 'B' 
					THEN 
						ttd.commission_amount
					ELSE 
						0 
				END
			) AS buy_comm
		,SUM
			(
				CASE WHEN 
						ttd.transaction_type = 'S' 
					THEN 
						ttd.commission_amount
					ELSE 
						0 
				END
			) AS sell_comm
		,SUM(ttd.commission_amount) AS total_comm
		,SUM(ISNULL(ttd.transaction_fee,0)) AS transaction_fee
		,SUM(ISNULL(ttd.ait,0)) AS ait
		,SUM(ttd.commission_amount) - SUM(ISNULL(ttd.ait,0)) net_comm
	FROM [Trade].[tblTradeData] ttd
		INNER JOIN DimDate dd 
			ON ttd.Date = dd.DateKey
		INNER JOIN [broker].tblBrokerBranch brokb
			ON brokb.id = ttd.trader_branch_id

	WHERE dd.Date BETWEEN @from_dt AND @to_dt 
		AND ttd.membership_id = @membership_id
	GROUP BY 
		brokb.name
		,dd.FullDateUK
		,ttd.membership_id
	 
END












INSERT INTO [dbo].[tblAction]
           ([name]
           ,[url]
           ,[display_name]
           ,[controller_id]
           ,[ui_module_id]
           ,[is_view]
           ,[is_in_menu])
     VALUES
           ('Brokerage Commission Buy Sell Wise'
           ,'/#Report/rptBrokComIncBuySellWise'
           ,'Brokerage Commission Buy Sell Wise'
           ,48
           ,111
           ,1
           ,1)





INSERT INTO [dbo].[tblUserActionMapping]
           ([user_id]
           ,[action_id]
           ,[is_permitted]
           ,[membership_id])
     VALUES
           ('1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
           ,(select max(id) from [dbo].[tblAction])
           ,1
           ,63)






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_realize_gain_detail]    Script Date: 2/28/2016 3:01:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 17/12/2015
-- Description:	realize gain summary
-- =============================================

-- EXEC [Investor].[rsp_realize_gain_detail] '02-01-2016', '02-28-2016', 63, null,'8', null
ALTER PROCEDURE [Investor].[rsp_realize_gain_detail] 

	@from_dt DATETIME,
	@to_dt DATETIME,
	@membership_id numeric(9,0),
	@user_id nvarchar(128),
	@client_id as varchar(10),
	@instrument_id as varchar(20)
AS
BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF

	DECLARE @active_status_id AS NUMERIC(4,0)

	SELECT @active_status_id=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')

	SELECT 
		tihl.client_id
		,tins.security_code
		,ddtd.FullDateUK AS transaction_date
		,tihl.opening_qty
		,tihl.opening_rate
		,tihl.opening_cost
		,tihl.received_qty
		,tihl.received_rate
		,tihl.received_cost
		,tihl.sale_qty
		,tihl.sale_value
		,tihl.sale_commission
		,tihl.sale_rate
		,tihl.sale_amount
		,tihl.sale_cost_rate
		,tihl.sale_cost
		,tihl.gain_loss
		,tihl.remaining_qty
		,tihl.remaining_rate
		,tihl.remaining_cost
		,tihl.buy_qty
		,tihl.buy_cost
		,tihl.buy_commission
		,tihl.buy_rate
		,tihl.buy_amount
		,tihl.closing_qty
		,tihl.closing_rate
		,tihl.closing_cost
		,tinv.first_holder_name
		,tinv.bo_code
		,CASE 
				WHEN ISNULL(tjh.join_holder_name,'') = ''
					THEN ''
				ELSE 
					tjh.join_holder_name
				END AS join_holder_name
	FROM Investor.tblInvestorShareLedger tihl
		INNER JOIN Investor.tblInvestor tinv 
			ON tinv.client_id = tihl.client_id
		INNER JOIN Instrument.tblInstrument tins
			ON tins.id = tihl.instrument_id
		INNER JOIN dbo.DimDate ddtd
			ON ddtd.DateKey = tihl.transaction_date
		LEFT JOIN
			Investor.tblJoinHolder tjh
			ON tjh.client_id = tinv.client_id
	WHERE 
		ddtd.Date BETWEEN @from_dt AND @to_dt
		AND 
			(
				tihl.opening_qty
				+ tihl.received_qty
				+ tihl.sale_qty
				+ tihl.remaining_qty
				+ tihl.buy_qty
				+ tihl.closing_qty
			) != 0
		AND (tihl.client_id = @client_id OR @client_id IS NULL OR @client_id = '')
		AND (tihl.instrument_id = @instrument_id OR @instrument_id IS NULL OR @instrument_id = 0)
		AND tihl.membership_id = @membership_id
	ORDER BY tihl.transaction_date
	
END













USE [Escrow.Security]
GO

/****** Object:  Table [dbo].[tblCRUDLog]    Script Date: 2/29/2016 4:24:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblCRUDLog](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[login_date] [datetime] NOT NULL,
	[ip_address] [nvarchar](50) NULL,
	[pc_address] [nvarchar](50) NULL,
	[pc_name] [nvarchar](50) NULL,
	[controller] [nvarchar](50) NULL,
	[action] [nvarchar](50) NULL,
	[old_value] [nvarchar](max) NULL,
	[new_value] [nvarchar](max) NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
 CONSTRAINT [PK_tblCRUDLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblCRUDLog]  WITH CHECK ADD  CONSTRAINT [FK_tblCRUDLog_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[tblCRUDLog] CHECK CONSTRAINT [FK_tblCRUDLog_AspNetUsers]
GO

ALTER TABLE [dbo].[tblCRUDLog]  WITH CHECK ADD  CONSTRAINT [FK_tblCRUDLog_tblBrokerInformation] FOREIGN KEY([membership_id])
REFERENCES [dbo].[tblBrokerInformation] ([membership_id])
GO

ALTER TABLE [dbo].[tblCRUDLog] CHECK CONSTRAINT [FK_tblCRUDLog_tblBrokerInformation]
GO






USE [Escrow.Security]
GO
/****** Object:  StoredProcedure [dbo].[isp_crud_log]    Script Date: 2/29/2016 4:18:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Asif
-- Create date: 29/02/16
-- Description:	Insert Crud Log
-- =============================================

-- exec [dbo].[isp_crud_log] '1bf1c0e7-fa04-4266-9ce4-d20d6516737a', GETDATE(), '', '', '', '', '', '', '', 63


CREATE PROCEDURE [dbo].[isp_crud_log]
(
	@UserId nvarchar(128),
	@login_date datetime,
	@ip_address nvarchar(50),
	@pc_address nvarchar(50),
	@pc_name nvarchar(50),
	@controller nvarchar(50),
	@action nvarchar(50),
	@old_value nvarchar(MAX),
	@new_value nvarchar(MAX),
	@membership_id numeric (9,0)
)

AS


BEGIN

	INSERT INTO dbo.tblCRUDLog
           (
			   UserId
			   ,login_date
			   ,ip_address
			   ,pc_address
			   ,pc_name
			   ,controller
			   ,action
			   ,old_value
			   ,new_value
			   ,membership_id
		   )
     VALUES
           (
			   @UserId
			   ,@login_date
			   ,@ip_address
			   ,@pc_address
			   ,@pc_name
			   ,@controller
			   ,@action
			   ,@old_value
			   ,@new_value
			   ,@membership_id
		   )
END



--========== Instrument Receive Delivery approve =========----

USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [dbo].[psp_day_end]    Script Date: 03/05/2016 3:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 11/1/2015
-- =============================================
/*
	DECLARE @ERROR AS VARCHAR(MAX)
	BEGIN TRANSACTION
	BEGIN TRY
		EXEC [dbo].[psp_day_end] 20160121,'1bf1c0e7-fa04-4266-9ce4-d20d6516737a',63
		--RAISERROR('PASS',16,1)
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @ERROR=ERROR_MESSAGE()
		RAISERROR(@ERROR,16,1)
	END CATCH
*/

ALTER PROCEDURE [dbo].[psp_day_end]
	@process_dt numeric(8,0)
	,@end_by nvarchar(MAX)
	,@membership_id numeric(9,0)
AS
BEGIN


		
	-------Update day end Started-------------
	SET NOCOUNT ON;
	
	DECLARE @result VARCHAR(MAX)
	
	begin transaction
	BEGIN TRY
		IF NOT EXISTS(SELECT * FROM dbo.tblDayProcess WHERE process_date=@process_dt AND end_date IS NULL)
		BEGIN 
			RAISERROR('Day end process already completed',16,1)
		END

		IF EXISTS(SELECT * FROM [Transaction].tblFundReceive WHERE approve_date IS NULL)
		BEGIN 
			RAISERROR('Unapproved fund receive vouchers found',16,1)
		END

		IF EXISTS(SELECT * FROM [Transaction].tblFundWithdrawalRequest WHERE approve_date IS NULL)
		BEGIN 
			RAISERROR('Unapproved fund withdrawal request found',16,1)
		END

		IF EXISTS(SELECT * FROM [Transaction].tblFundWithdraw WHERE approve_date IS NULL)
		BEGIN 
			RAISERROR('Unapproved fund payment vouchers found',16,1)
		END

		IF EXISTS(SELECT * FROM [Transaction].tblForceChargeApply WHERE approve_date IS NULL)
		BEGIN 
			RAISERROR('Unapproved charge transactions found',16,1)
		END

		IF EXISTS(SELECT * FROM [Instrument].[tblInstrumentManualInOut] WHERE approve_date IS NULL)
		BEGIN 
			RAISERROR('Unapproved instrument receive delivery found',16,1)
		END
		
		
		update tblDayProcess 
		set end_date = GETDATE(),
		end_by = @end_by
		where process_date = @process_dt
		-------Update day end Completed-------------

		-------Insert day Start-----------
	
		EXEC psp_day_start @process_dt,@end_by,@membership_id

		-------Insert day Start Completed-----------

		-------Delete Unnecessary Data-------

		EXEC dbo.dsp_unnecessary_data @membership_id

		-------Delete Unnecessary Data Complete-------

		commit transaction
	END TRY
	BEGIN CATCH
	rollback transaction
		SELECT @result = ERROR_MESSAGE()
		RAISERROR(@result,16,1)
	END CATCH

	

END





USE [Escrow.BOAS]
GO

/****** Object:  Table [broker].[tblBrokerImages]    Script Date: 03/13/2016 2:55:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [broker].[tblBrokerImages](
	[membership_id] [numeric](9, 0) NOT NULL,
	[report_header_image] [image] NOT NULL,
	[report_footer_image] [image] NOT NULL,
	[report_logo] [image] NOT NULL,
	[active_status_id] [int] NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_broker]].[tblBrokerImages] PRIMARY KEY CLUSTERED 
(
	[membership_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BrokerManagement]
) ON [BrokerManagement] TEXTIMAGE_ON [BrokerManagement]

GO


--Insert Image directly into database using script---
USE [Escrow.BOAS]
GO

Insert Into [broker].[tblBrokerImages]
			([membership_id]
           ,[report_header_image]
           ,[report_footer_image]
           ,[report_logo]
           ,[active_status_id]
           ,[changed_user_id]
           ,[changed_date]
           ,[is_dirty])

Select 63,(SELECT BulkColumn from Openrowset (Bulk 'D:\Images\banco_header.JPG', Single_Blob) as report_header_image), 
		(SELECT BulkColumn from Openrowset (Bulk 'D:\Images\banco_header.JPG', Single_Blob) as report_footer_image),
		(SELECT BulkColumn from Openrowset (Bulk 'D:\Images\banco_logo.JPG', Single_Blob) as report_logo),
		61,
		'1bf1c0e7-fa04-4266-9ce4-d20d6516737a',
		GETDATE(),
		0










USE [Escrow.Security]
GO
/****** Object:  StoredProcedure [dbo].[rsp_crud_log]    Script Date: 3/20/2016 12:12:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 19/03/2016
-- Description:	crud log
-- =============================================

-- EXEC [dbo].[rsp_crud_log] '03-02-2016', '03-19-2016', 63, 'asif','Edit'
CREATE PROCEDURE [dbo].[rsp_crud_log]

	@from_dt DATETIME,
	@to_dt DATETIME,
	@membership_id numeric(9,0),
	@user_id nvarchar(128),
	@user_name nvarchar(256),
	@action nvarchar(50)
AS
BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF

	SELECT
		anu.UserName
		,tcl.login_date
		,tcl.ip_address
		,tcl.pc_address
		,tcl.pc_name
		,tcl.controller
		,tcl.action
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(tcl.old_value, '¤', 'Table = '), '»', ', '), '©', 'Properties and Values '), '¢', '{ '), '‡', ' = '), 'Ð', ' }') old_value
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(tcl.new_value, '¤', 'Table = '), '»', ', '), '©', 'Properties and Values '), '¢', '{ '), '‡', ' = '), 'Ð', ' }') new_value
		,tbi.short_name member
	FROM 
		[dbo].[tblCRUDLog] tcl
	INNER JOIN
		[dbo].[tblBrokerInformation] tbi
			ON tbi.membership_id = tcl.membership_id
			AND tbi.membership_id = @membership_id
	INNER JOIN
		[dbo].[tblBrokerUser] tbu
			ON tbu.UserId = tcl.UserId
	INNER JOIN
		[dbo].[AspNetUsers] anu
			ON anu.Id = tbu.UserId
	WHERE CONVERT(date, tcl.login_date) BETWEEN @from_dt AND @to_dt
		AND (tcl.action = @action OR @action = '' OR @action IS NULL)
		AND (anu.UserName = @user_name OR @user_name = '' OR @user_name IS NULL)
	ORDER BY
		tcl.login_date
	
END




















		


-------------------------- client id added-------------------

USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_bo_acknowledgement]    Script Date: 03/21/2016 3:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 23/02/2016
-- Description: BO Acknowledgement
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
	WHERE
		tinv.client_id = @client_id
		AND tinv.membership_id = @membership_id
END




USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Instrument].[rsp_instrument_ledger_client_wise]    Script Date: 03/29/2016 12:26:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 19/12/2015
-- Description:	Instrument ledger report
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
		case when (tisl.sale_qty > 0) then tisl.sale_qty when (tisl.delivery_qty> 0 ) then tisl.delivery_qty end as debit,
		case when (tisl.buy_qty > 0) then tisl.buy_qty when (tisl.received_qty> 0 ) then tisl.received_qty end as credit,
		tisl.opening_qty,
		(CASE WHEN tisl.buy_rate>0
			THEN
				tisl.buy_rate
			WHEN 
				tisl.sale_rate>0
			THEN
				tisl.sale_rate
			ELSE
				0
		END) AS average

		
	
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










USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_client_ledger]    Script Date: 29-Mar-16 3:28:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 22/11/2015
-- Description:	Client Ledger Report
-- Updated by : Sarwar
-- Update Date: 12/13/2015
-- Description: Updated ledger report 
-- =============================================

--- exec Investor.rsp_client_ledger '63','1bf1c0e7-fa04-4266-9ce4-d20d6516737a','8','2016-01-03','2016-01-03'
ALTER PROCEDURE [Investor].[rsp_client_ledger]
(
	@membership_id numeric(9,0),
	@user_id nvarchar(128),
	@client_id varchar(10),
	@from_dt datetime,
	@to_dt datetime
)
AS
BEGIN
	DECLARE  @opening_balance numeric(30,10)
			,@balance_date numeric(9,0)
			,@Transaction_Date_From numeric(9,0)
			,@Transaction_Date_To numeric(9,0)

	SELECT @Transaction_Date_From = MAX(DateKey) FROM dbo.DimDate WHERE [Date]=@from_dt
	SELECT @Transaction_Date_To = MAX(DateKey) FROM dbo.DimDate WHERE [Date]=@to_dt
	SELECT @balance_date = MAX(DateKey) FROM dbo.DimDate WHERE DateKey < convert(numeric,convert(varchar,@from_dt,112)) 
	SELECT @opening_balance =  [Investor].[sfun_get_investor_fund_balance] (@client_id,@balance_date)
	print  @balance_date

	IF EXISTS(
				 SELECT 
						1 
				 FROM 
					Investor.tblInvestorFinancialLedger tif
				 WHERE 
					tif.transaction_date BETWEEN @Transaction_Date_From AND @Transaction_Date_To
					AND tif.client_id = @client_id
					AND tif.membership_id = @membership_id
			 )
	BEGIN
		print 'Ledger Data exists'
		SELECT 
			tif.client_id,
			ti.first_holder_name,
			ti.bo_code,
			tif.transaction_date,
			dd.FullDateUK,
			TIF.finintial_ledger_type,
			tif.narration,
			SUM(tif.quantity) AS quantity,
			case 
				when tif.debit>0 
					then ((tif.quantity*tif.rate)+tif.comm_amount)/(tif.quantity)
				else ((tif.quantity*tif.rate)-tif.comm_amount)/(tif.quantity) end AS rate,
			SUM(tif.quantity*tif.rate) as amount,
			SUM(tif.comm_amount) AS comm_amount,
			SUM(tif.debit) AS debit,
			SUM(tif.credit) AS credit,
			@opening_balance as openingbalance,
			tjh.join_holder_name
		FROM 
			(SELECT TIF.*,
				 case when(tcov.display_value ='BUY/SALE') then (case when tif.debit > 0 then 'BUY' else 'SELL' end) else tcov.display_value end  AS finintial_ledger_type
			FROM Investor.tblInvestorFinancialLedger tif
			INNER JOIN 
				dbo.tblConstantObjectValue tcov
				on tif.transaction_type_id = tcov.object_value_id) TIF
		INNER JOIN  
			Investor.tblInvestor ti 
			on tif.client_id = ti.client_id
		INNER JOIN [dbo].[DimDate] dd
			on dd.DateKey=tif.transaction_date
		INNER JOIN dbo.tblConstantObject tco on tco.object_name='TRANSACTION_MODE'
		LEFT JOIN
			Investor.tblJoinHolder tjh
			ON tjh.client_id = tif.client_id
		WHERE 
			tif.transaction_date BETWEEN @Transaction_Date_From AND @Transaction_Date_To
			AND tif.client_id = @client_id
			AND tif.membership_id = @membership_id
		GROUP BY
			tif.client_id,
			ti.first_holder_name,
			ti.bo_code,
			tif.transaction_date,
			dd.FullDateUK,
			TIF.finintial_ledger_type,
			tif.narration,
			tjh.join_holder_name,
			tif.rate,
			TIF.quantity,
			tif.comm_amount,
			tif.debit
		ORDER BY 
			tif.transaction_date,
			TIF.finintial_ledger_type,	
			TIF.narration
	END
	ELSE
	BEGIN
		print 'Ledger Data not exists'
		SELECT 
			ti.client_id,
			ti.first_holder_name,
			ti.bo_code,
			NULL FullDateUK,
			NULL finintial_ledger_type,
			NULL narration,
			NULL quantity,
			NULL rate,
			NULL amount,
			NULL comm_amount,
			NULL debit,
			NULL credit,
			@opening_balance as openingbalance

		FROM 
			Investor.tblInvestor ti
		WHERE 
			ti.client_id = @client_id
			AND ti.membership_id = @membership_id
	END
END





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[ssp_get_investor_info]    Script Date: 03/30/2016 3:13:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author: Shohid
-- Create date: 13/01/2015
-- Description:	get Investor info using udfSpliter
-- =============================================

-- EXEC [Investor].[ssp_get_investor_info]'1-5000',2

CREATE PROCEDURE [Investor].[ssp_get_investor_info]
(
	@investor_ids varchar(MAX),
	@trader_id int
)

AS

BEGIN

	SELECT 
		ti.client_id,
		ti.bo_code,
		ti.first_holder_name,
		ti.trader_id,
		tt.trader_code as trader
	FROM 
		[Investor].[tblInvestor] ti
	JOIN [broker].[tblTrader] tt
		ON tt.id = ti.trader_id
	WHERE ti.client_id IN ( SELECT id FROM dbo.udfSpliter(@investor_ids))
		AND
		ti.active_status_id=61
		AND
		ti.trader_id!= @trader_id

		
END





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_client_payable]    Script Date: 04/06/2016 5:39:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[Investor].[rsp_client_payable] 62,'2015-12-08',0

ALTER PROCEDURE [Investor].[rsp_client_payable]
(
	@membership_id numeric(9,0),
	@user_id nvarchar(128),
	@report_date datetime,
	@branch_id numeric(5,0)
)
AS
BEGIN
SELECT	
	tifb.client_id
	,ti.first_holder_name
	,ti.branch_id
	,TIFB.market_value
	,receivable = CASE WHEN [ledger_balance]> 0 THEN [ledger_balance] ELSE 0 END
	,payable = CASE WHEN [ledger_balance]< 0 THEN (abs([ledger_balance])) ELSE 0 END
FROM 
	INVESTOR.TBLINVESTORFUNDBALANCE TIFB
INNER JOIN 
	INVESTOR.TBLINVESTOR TI 
	ON TIFB.CLIENT_ID = TI.CLIENT_ID
INNER JOIN 
	DIMDATE DD 
	ON @REPORT_DATE = DD.DATE
inner join dbo.tblConstantObjectValue tco
    on ti.active_status_id = tco.object_value_id
inner join broker.tblDepositoryPerticipant tdp
	on left(ti.bo_code,8) = tdp.bo_reference_no
WHERE 
	TIFB.MEMBERSHIP_ID = @MEMBERSHIP_ID
	AND (TI.BRANCH_ID = @BRANCH_ID OR @BRANCH_ID IS NULL OR @BRANCH_ID = 0)
	AND [ledger_balance]< 0
	AND TIFB.TRANSACTION_DATE = (
									SELECT 
										MAX(TRANSACTION_DATE) 
									FROM 
										INVESTOR.TBLINVESTORFUNDBALANCE TEMP 
									WHERE 
										TEMP.TRANSACTION_DATE <= DD.DATEKEY
										AND TIFB.CLIENT_ID = TEMP.CLIENT_ID
										AND TEMP.membership_id=TIFB.membership_id
								 )	
	AND tco.display_value <> 'CLOSE'
	AND tco.display_value <> 'INACTIVE'
	AND tdp.is_omnibus is null
ORDER BY 
--TIFB.CLIENT_ID ASC,
payable DESC
END






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_client_receivable]    Script Date: 04/06/2016 5:42:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [Investor].[rsp_client_receivable]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@report_date datetime,
@branch_id numeric(5,0)
)
AS
BEGIN

SELECT	
	tifb.client_id
	,ti.first_holder_name
	,ti.branch_id
	,TIFB.market_value
	,receivable = CASE WHEN ([ledger_balance]) > 0 THEN ([ledger_balance]) ELSE 0 END
	--,payable = CASE WHEN ([ledger_balance]) < 0 THEN (abs([ledger_balance])) ELSE 0 END
FROM 
	INVESTOR.TBLINVESTORFUNDBALANCE TIFB
INNER JOIN 
	INVESTOR.TBLINVESTOR TI 
	ON TIFB.CLIENT_ID = TI.CLIENT_ID
INNER JOIN 
	DIMDATE DD 
	ON DD.DATE = @REPORT_DATE
inner join dbo.tblConstantObjectValue tco
    on ti.active_status_id = tco.object_value_id
inner join broker.tblDepositoryPerticipant tdp
	on left(ti.bo_code,8) = tdp.bo_reference_no
WHERE 
	TIFB.MEMBERSHIP_ID = @MEMBERSHIP_ID
	AND (TI.BRANCH_ID = @BRANCH_ID OR @BRANCH_ID IS NULL OR @BRANCH_ID = 0)
	AND ([ledger_balance])> 0
	AND TIFB.TRANSACTION_DATE = (
									SELECT 
										MAX(TRANSACTION_DATE) 
									FROM 
										INVESTOR.TBLINVESTORFUNDBALANCE TEMP 
									WHERE 
										TEMP.TRANSACTION_DATE <= DD.DATEKEY
										AND TIFB.CLIENT_ID = TEMP.CLIENT_ID
										AND TEMP.membership_id=TIFB.membership_id
								 )
	AND tco.display_value <> 'CLOSE'
	AND tco.display_value <> 'INACTIVE'
	AND tdp.is_omnibus is null
ORDER BY 
--TIFB.CLIENT_ID ASC, 
receivable DESC

END




USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_client_receivable_payable]    Script Date: 04/06/2016 5:43:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [Investor].[rsp_client_receivable_payable]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@report_date datetime,
@branch_id numeric(5,0)
)
AS
BEGIN
SELECT	
	tifb.client_id
	,ti.first_holder_name
	,ti.branch_id
	,tifb.market_value
	,receivable = CASE WHEN (tifb.available_balance+tifb.un_clear_cheque+tifb.sale_receivable) > 0 THEN (tifb.available_balance+tifb.un_clear_cheque+tifb.sale_receivable) ELSE 0 END
	,payable = CASE WHEN (tifb.available_balance+tifb.un_clear_cheque+tifb.sale_receivable) < 0 THEN (abs(tifb.available_balance+tifb.un_clear_cheque+tifb.sale_receivable)) ELSE 0 END
FROM 
	Investor.tblInvestorFundBalance tifb
inner join 
	Investor.tblInvestor ti 
	on tifb.client_id = ti.client_id
inner join 
	DimDate dd 
	on dd.Date = @report_date
inner join dbo.tblConstantObjectValue tco
    on ti.active_status_id = tco.object_value_id
inner join broker.tblDepositoryPerticipant tdp
	on left(ti.bo_code,8) = tdp.bo_reference_no
WHERE 
	tifb.membership_id = @membership_id
	AND (ti.branch_id = @branch_id OR @branch_id IS NULL OR @branch_id = 0)
	AND (tifb.available_balance+tifb.un_clear_cheque+tifb.sale_receivable)<> 0
	AND tifb.transaction_date = (
									SELECT 
										MAX(transaction_date) 
									FROM 
										Investor.tblInvestorFundBalance TEMP 
									WHERE 
										TEMP.transaction_date <= dd.DateKey
									AND tifb.client_id = TEMP.client_id
									AND TEMP.membership_id=TIFB.membership_id
								)
	AND tco.display_value <> 'CLOSE'
	AND tdp.is_omnibus is null
order by tifb.client_id asc
END




USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Transaction].[psp_on_dem_char_xl_dt]    Script Date: 4/9/2016 11:53:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [Transaction].[psp_on_dem_char_xl_dt]
(
@charge_id numeric(3,0),
@transaction_type_id numeric(4,0),
@transaction_date numeric (9,0),
@value_date numeric(9,0),
@membership_id numeric (9,0),
@changed_user_id nvarchar(128),
@changed_date datetime,
@is_dirty numeric (1,0),
@is_upd_processed_client numeric (1,0)
)

AS

BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF

	DECLARE @active_status_id numeric(4,0);

	SELECT @active_status_id = object_value_id FROM [dbo].[tblConstantObjectValue] WHERE display_value = 'ACTIVE'
	
	IF @is_upd_processed_client = 1
		BEGIN

			UPDATE tfcat
				SET tfcat.is_processed = 1
				FROM [Transaction].[tblForceChargeApplyTemp] tfcat

			INSERT INTO [Transaction].[tblForceChargeApply] (
				[client_id]
				,[charge_id]
				,[transaction_type_id]
				,[amount]
				,[transaction_date]
				,[value_date]
				,[remarks]
				,[active_status_id]
				,[membership_id]
				,[changed_user_id]
				,[changed_date]
				,[is_dirty]
				)
				SELECT tfcat.client_id
				,@charge_id
				,@transaction_type_id
				,tfcat.amount
				,@transaction_date
				,@value_date
				,tfcat.remarks
				,@active_status_id
				,@membership_id
				,@changed_user_id
				,@changed_date
				,@is_dirty
				FROM [Transaction].[tblForceChargeApplyTemp] tfcat

		END
	ELSE
		BEGIN	

			UPDATE tfcat
				SET tfcat.is_processed = 1
				FROM [Transaction].[tblForceChargeApplyTemp] tfcat
				LEFT JOIN [Transaction].[tblForceChargeApply] tfca ON tfca.client_id = tfcat.client_id AND tfca.transaction_date = @transaction_date AND tfca.transaction_type_id = @transaction_type_id AND tfca.charge_id = @charge_id
				WHERE tfca.client_id IS NULL

			INSERT INTO [Transaction].[tblForceChargeApply] (
				[client_id]
				,[charge_id]
				,[transaction_type_id]
				,[amount]
				,[transaction_date]
				,[value_date]
				,[remarks]
				,[active_status_id]
				,[membership_id]
				,[changed_user_id]
				,[changed_date]
				,[is_dirty]
				)
				SELECT tfcat.client_id
				,@charge_id
				,@transaction_type_id
				,tfcat.amount
				,@transaction_date
				,@value_date
				,tfcat.remarks
				,@active_status_id
				,@membership_id
				,@changed_user_id
				,@changed_date
				,@is_dirty
				FROM [Transaction].[tblForceChargeApplyTemp] tfcat
				LEFT JOIN [Transaction].[tblForceChargeApply] tfca ON tfca.client_id = tfcat.client_id AND tfca.transaction_date = @transaction_date AND tfca.transaction_type_id = @transaction_type_id AND tfca.charge_id = @charge_id
				WHERE tfca.client_id IS NULL

		END
	
END






















































