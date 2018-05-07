USE [Escrow.BOAS]
GO

/****** Object:  Table [Trade].[tblFTLimitsTemp]    Script Date: 12/27/2015 10:56:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Trade].[tblFTLimitsTemp](
	[client_code] [varchar](max) NULL,
	[boid] [varchar](max) NULL,
	[client_name] [varchar](max) NULL,
	[client_type] [varchar](max) NULL,
	[buy_limit] [varchar](max) NULL,
	[panic_withdraw] [varchar](max) NULL,
	[timest] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [TradeManagement]

GO

SET ANSI_PADDING OFF
GO






USE [Escrow.BOAS]
GO

/****** Object:  Table [Trade].[tblFTPositionsTemp]    Script Date: 12/27/2015 10:57:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Trade].[tblFTPositionsTemp](
	[isin] [varchar](max) NULL,
	[com_s_name] [varchar](max) NULL,
	[boid] [varchar](max) NULL,
	[f_join_holder_name] [varchar](max) NULL,
	[current_balance] [varchar](max) NULL,
	[free_balance] [varchar](max) NULL,
	[investor_code] [varchar](max) NULL,
	[trd_dt] [varchar](max) NULL,
	[branch_Code] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [TradeManagement]

GO

SET ANSI_PADDING OFF
GO




alter table [Trade].[tblFTImportLog] add omnibus_master_id varchar(10) null





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[ssp_ft_import_client_limits]    Script Date: 12/27/2015 1:58:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 27/12/2015
-- Description:	Import client limits validation
-- =============================================

CREATE PROCEDURE [Trade].[ssp_ft_import_client_limits](
	@membership_id numeric(9,0),
	@import_dt numeric(9,0),
	@file_name as nvarchar(max),
	@omnibus_master_id varchar(10)
	)
AS
begin
	
	---------------------------------START: Duplication checking----------------------------------------
	IF EXISTS(SELECT log_id from Trade.tblFTImportLog WHERE file_type='limits' AND import_dt = @import_dt
		AND [file_name] = @file_name
		AND omnibus_master_id = @omnibus_master_id
		AND membership_id = @membership_id) 
	BEGIN
		RAISERROR('This limit file already imported',16,1)
		RETURN
	END
	---------------------------------END: Duplication checking----------------------------------------

	-------------------START INVESTOR CODE NOT FOUND BUT BO CODE FOUND IN tblFTtmp_branch_limits_file---------  
    SELECT 
		boid
		,'Investor code missing for following BO: ' 
	FROM 
		Trade.tblFTLimitsTemp
    WHERE 
		client_code IS NULL
	-------------------CLOSE INVESTOR CODE NOT FOUND BUT BO CODE FOUND IN tblFTtmp_branch_limits_file--------- 
	
	-------------------START BO CODE NOT FOUND BUT INVESTOR CODE FOUND IN tblFTtmp_branch_limits_file---------  
    SELECT 
		client_code
		,'BO Code missing for following investors: ' 
	FROM 
		Trade.tblFTLimitsTemp
    WHERE 
		client_code IS NOT NULL 
		AND boid IS NULL
	-------------------CLOSE BO CODE NOT FOUND BUT INVESTOR CODE FOUND IN tblFTtmp_branch_limits_file--------- 

	-------------------START BO CODE NOT FOUND BUT INVESTOR CODE FOUND IN tblFTtmp_branch_limits_file---------  
    SELECT 
		client_code
		,'BOID length is not 16 digit: ' 
	FROM 
		Trade.tblFTLimitsTemp
    WHERE 
		client_code IS NOT NULL 
		AND len(isnull(boid,'')) != 16
	-------------------CLOSE BO CODE NOT FOUND BUT INVESTOR CODE FOUND IN tblFTtmp_branch_limits_file--------- 

	-------------------START BO CODE NOT FOUND BUT INVESTOR CODE FOUND IN tblFTtmp_branch_limits_file---------  
    SELECT 
		client_code
		,'Duplicate limit found: ' 
	FROM 
		Trade.tblFTLimitsTemp
    WHERE 
		client_code IS NOT NULL 
	GROUP BY 
		client_code
	HAVING 
		COUNT(client_code) > 1
	-------------------CLOSE BO CODE NOT FOUND BUT INVESTOR CODE FOUND IN tblFTtmp_branch_limits_file--------- 

	-------------------START INACTIVE INVESTOR CODE FOUND---------  
    SELECT 
		tflt.client_code
		,'Limit Found for Inactive/Closed Investors: ' 
	FROM  
		(
			SELECT DISTINCT 
				client_code 
			FROM 
				Trade.tblFTLimitsTemp 
		) AS tflt 
	INNER JOIN  
		Investor.tblInvestor tinv 
			ON tflt.client_code = tinv.client_id
	INNER JOIN 
		dbo.tblConstantObjectValue covas
			ON covas.object_value_id = tinv.active_status_id
    WHERE 
		covas.display_value != 'Active'
		AND tinv.membership_id = @membership_id
		AND omnibus_master_id = @omnibus_master_id
	-------------------CLOSE INACTIVE INVESTOR CODE FOUND---------

	-------------------START TRADER MAPPING WITH INVESTOR CODE PROPERLY---------  
    SELECT 
		tflt.client_code
		,'Found Investors which not mapped with trader: ' 
	FROM  
		(
			SELECT DISTINCT 
				client_code 
			FROM 
				Trade.tblFTLimitsTemp 
		) AS tflt 
	INNER JOIN  
		Investor.tblInvestor tinv 
			ON tflt.client_code = tinv.client_id 
	INNER JOIN
		broker.tblTrader tt 
			ON tt.id = tinv.trader_id
			AND tt.membership_id = tinv.membership_id 
    WHERE 
		LEN(ISNULL(tt.trader_code,''))<8
		AND tinv.membership_id = @membership_id
		AND omnibus_master_id = @omnibus_master_id
	-------------------CLOSE TRADER MAPPING WITH INVESTOR CODE PROPERLY--------- 

	-------------------START BUY LIMIT CAN NOT BE NEGETIVE---------  
    SELECT 
		client_code
		,'Found Negetive limit: ' 
	FROM 
		Trade.tblFTLimitsTemp
    WHERE 
		CONVERT(numeric(15,0), ISNULL(buy_limit,-1)) <0
	-------------------CLOSE BUY LIMIT CAN NOT BE NEGETIVE--------- 
END










USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[usp_ft_trader_by_investor_range_mapping]    Script Date: 12/28/2015 12:34:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 27/12/2015
-- Description:	Update trader by investor range mapping
-- =============================================

CREATE PROCEDURE [Trade].[usp_ft_trader_by_investor_range_mapping] 
AS
BEGIN
	DECLARE @MaxTraderID AS numeric(2,0)
		, @TraderID AS numeric(2,0)
		, @InvestorRange as varchar(max)
		, @DealerID as varchar(12)
	
	SELECT @MaxTraderID = MAX(id) FROM broker.tblTrader

	PRINT @MaxTraderID

	IF NOT (@MaxTraderID IS NULL)
	BEGIN
		SET @TraderID = 1
			WHILE (@TraderID <= @MaxTraderID)
				BEGIN
					PRINT @traderid
					SELECT @InvestorRange= investor_range, @DealerID = trader_Code FROM broker.tblTrader WHERE id = @TraderID
					IF NOT(@InvestorRange IS NULL)
						BEGIN
							UPDATE tinv
								SET 
									tinv.trader_id = @TraderID 
							FROM 
								Investor.tblInvestor tinv
							INNER JOIN 
								(
									SELECT  
										id ClientCode  
									FROM 
										dbo.udfSpliter(@InvestorRange)) SIR 
											ON LTRIM(RTRIM(tinv.client_id)) = LTRIM(RTRIM(SIR.ClientCode)
								)
							WHERE 
								ISNULL(tinv.trader_id,0) = 0
						END
					SET @TraderID = @TraderID + 1
				END
	END
END






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[psp_ft_imp_client_limits]    Script Date: 12/28/2015 12:23:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 27/12/2015
-- Description:	Process import client limits
-- =============================================

CREATE PROCEDURE [Trade].[psp_ft_imp_client_limits](
	@membership_id numeric(9,0),
	@import_dt numeric(9,0),
	@file_name varchar(max),
	@omnibus_master_id varchar(10),
	@changed_user_id nvarchar(128),
	@changed_date datetime
	)
AS
begin
	DECLARE @version_no numeric(2,0)
		, @log_id int

	---------------------------------START: Duplication checking----------------------------------------
	IF EXISTS(SELECT log_id FROM Trade.tblFTImportLog WHERE file_type='limits' AND import_dt = @import_dt
		AND [file_name] = @file_name
		AND omnibus_master_id = @omnibus_master_id
		AND membership_id = @membership_id) 
	BEGIN
		RAISERROR('This limit file already imported',16,1)
		RETURN
	END
	---------------------------------END: Duplication checking----------------------------------------
		
	UPDATE Trade.tblFTLimitsTemp
		SET 
			client_code = RTRIM(LTRIM(ISNULL(client_code,'')))
			,boid = LEFT(RTRIM(LTRIM(ISNULL(boid,''))),16)
			,client_name = LEFT(RTRIM(LTRIM(ISNULL(client_name,''))),50)
			,client_type = LEFT(RTRIM(LTRIM(ISNULL(client_type,''))),1)
			,buy_limit = RTRIM(LTRIM(ISNULL(buy_limit,'0')))
	
	-- Get new version no
	SELECT @version_no = MAX(version_no) FROM Trade.tblFTImportLog WHERE file_type = 'limits' AND membership_id = @membership_id AND omnibus_master_id = @omnibus_master_id

	IF @version_no IS NULL SET @version_no = 1
	ELSE SET @version_no = @version_no + 1

    -- Insert statements for procedure here
	INSERT INTO 
		Trade.tblFTImportLog
			(
				file_type
				,file_name
				,import_dt
				,version_no
				,omnibus_master_id
				,membership_id
			) 
		VALUES
			(
				'limits'
				,@file_name
				,@import_dt
				,@version_no
				,@omnibus_master_id
				,@membership_id
			)

    SELECT @log_id = log_id FROM Trade.tblFTImportLog WHERE file_type = 'limits' AND membership_id = @membership_id AND version_no = @version_no AND omnibus_master_id = @omnibus_master_id

	DECLARE 
		@account_type_id AS numeric(4,0)
		,@active_status_id AS numeric(4,0)
		,@operation_type_id AS numeric(4,0)
		,@branch_id AS numeric(4,0)
		,@trader_id AS numeric(4,0)
		,@ipo_type_id AS numeric(4,0)

	SELECT @account_type_id = dbo.sfun_get_constant_object_value_id('INVESTOR_ACC_TYPE','C')

	SELECT @active_status_id = dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')

	SELECT @operation_type_id = dbo.sfun_get_constant_object_value_id('INVESTOR_OPERATION_TYPE','Omnibus')

	SELECT TOP 1 @trader_id = id FROM broker.tblTrader WHERE Is_Default = 1

	SELECT TOP 1 @branch_id = branch_id FROM broker.tblTrader WHERE id = @trader_id

	SELECT @ipo_type_id = dbo.sfun_get_constant_object_value_id('IPO_TYPE','RB')
    
	INSERT INTO 
		Investor.tblInvestor
			(
				client_id
				,bo_code
				,first_holder_name
				,account_type_id
				,trade_type_id
				,active_status_id
				,export_log_id
				,export_st
				,omnibus_master_id
				,membership_id
				,beftn_enabled
				,email_enabled
				,internet_enabled
				,sms_enabled
				,operation_type_id
				,branch_id
				,trader_id
				,ipo_type_id
				,changed_user_id
				,changed_date
				,is_dirty
			)
		SELECT 
			tflt.client_code
			,tflt.boid
			,tflt.client_name
			,@account_type_id
			,dbo.sfun_get_constant_object_value_id('TRADE_TYPE',tflt.client_type)
			,@active_status_id
			,@log_id
			,0
			,@omnibus_master_id
			,@membership_id
			,0
			,0
			,0
			,0
			,@operation_type_id
			,@branch_id
			,@trader_id
			,@ipo_type_id
			,@changed_user_id
			,@changed_date
			,1
		FROM 
			Trade.tblFTLimitsTemp tflt
		LEFT JOIN 
			Investor.tblInvestor tinv 
				ON tflt.client_code = tinv.client_id
				AND tinv.membership_id = @membership_id
				AND tinv.omnibus_master_id = @omnibus_master_id
		WHERE 
			LEN(tflt.client_code) > 0
			AND tinv.client_id IS NULL
			AND LEN(tflt.boid) = 16
		GROUP BY 
			tflt.client_code
			,tflt.boid
			,tflt.client_name
			,tflt.client_type
		HAVING 
			COUNT(tflt.client_code) = 1
	

	UPDATE tinv
		SET 
			tinv.bo_code = tflt.boid
			,tinv.export_st = 0
			,tinv.changed_user_id = @changed_user_id
			,tinv.changed_date = @changed_date
	FROM 
		Trade.tblFTLimitsTemp tflt
	INNER JOIN 
		Investor.tblInvestor tinv 
			ON tflt.client_code = tinv.client_id
			AND tinv.membership_id = @membership_id
			AND tinv.omnibus_master_id = @omnibus_master_id
	WHERE 
		LEN(ISNULL(tflt.BOID,'')) = 16 
		AND LEN(ISNULL(tinv.bo_code,'')) != 16
	
	EXEC [Trade].[usp_ft_trader_by_investor_range_mapping]

	INSERT INTO 
		Trade.tblFTLimits
			(
				ClientCode
				,Cash
				,MaxCapitalBuy
				,MaxCapitalSell
				,TotalTransaction
				,NetTransaction
				,Deposit
				,MarginRatio
				,acc_Type_S_Name
				,import_type
				,import_log_id
				,membership_id
			)
		SELECT 
			tflt.client_code
			,MIN(tflt.buy_limit*1000)
			,0
			,0
			,0
			,0
			,0
			,0 
			,covat.display_value
			,'B'
			,@log_id
			,@membership_id
		FROM 
			Trade.tblFTLimitsTemp tflt 
		INNER JOIN 
			Investor.tblInvestor tinv 
				ON tflt.client_code = tinv.client_id
				AND tinv.membership_id = @membership_id
		LEFT JOIN 
			dbo.tblConstantObjectValue covat
				ON covat.object_value_id = tinv.account_type_id
		GROUP BY 
			tflt.client_code, covat.display_value

	TRUNCATE TABLE Trade.tblFTLimitsTemp

	---------------------------------START: Record not found----------------------------------------
	IF NOT EXISTS(SELECT log_id FROM Trade.tblFTLimits WHERE import_log_id = @log_id) 
	BEGIN
		DELETE FROM Trade.tblFTImportLog WHERE log_id = @log_id AND omnibus_master_id = @omnibus_master_id
		RAISERROR('Record not found',16,1)
		RETURN
	END
	---------------------------------END: Record not found----------------------------------------
END






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[ssp_ft_import_positions]    Script Date: 12/27/2015 1:58:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 27/12/2015
-- Description:	Import positions validation
-- =============================================

CREATE PROCEDURE [Trade].[ssp_ft_import_positions](
	@membership_id numeric(9,0),
	@import_dt numeric(9,0),
	@file_name as nvarchar(max),
	@omnibus_master_id varchar(10)
	)
AS
begin
	
	---------------------------------START: Duplication checking----------------------------------------
	IF EXISTS(SELECT log_id from Trade.tblFTImportLog WHERE file_type='positions' AND import_dt = @import_dt
		AND [file_name] = @file_name
		AND omnibus_master_id = @omnibus_master_id
		AND membership_id = @membership_id) 
	BEGIN
		RAISERROR('This positions file already imported',16,1)
		RETURN
	END
	---------------------------------END: Duplication checking----------------------------------------

	-------------------START ISIN NOT FOUND---------  
    SELECT 
		ISNULL(investor_code,'') + ':' + ISNULL(com_s_name,'')
		,'ISIN Missing in File: ' 
	FROM 
		Trade.tblFTPositionsTemp
    WHERE 
		LEN(ISNULL(isin,'')) = 0
	-------------------CLOSE ISIN NOT FOUND--------- 
	
	-------------------START INVALID ISIN---------  
    SELECT 
		ISNULL(investor_code,'') + ':' + ISNULL(isin,'')
		,'ISIN Code is not 12 digit: '
	FROM 
		Trade.tblFTPositionsTemp
    WHERE 
		LEN(ISNULL(isin,'')) !=12
	-------------------CLOSE INVALID ISIN--------- 

	-------------------START INVESTOR CODE NOT FOUND BUT BO CODE FOUND IN tblFTtmp_branch_limits_file---------  
    SELECT 
		investor_code
		,'Investor code missing for following BO: '
	FROM 
		Trade.tblFTPositionsTemp
    WHERE 
		investor_code IS NULL 
	-------------------CLOSE INVESTOR CODE NOT FOUND BUT BO CODE FOUND IN tblFTtmp_branch_limits_file--------- 

	-------------------START BO CODE NOT FOUND BUT INVESTOR CODE FOUND IN tblFTtmp_branch_positions_file---------  
    SELECT 
		investor_code
		,'BO Code missing for following investors: ' 
	FROM 
		Trade.tblFTPositionsTemp
    WHERE 
		LEN(ISNULL(boid,'')) = 0
	-------------------CLOSE BO CODE NOT FOUND BUT INVESTOR CODE FOUND IN tblFTtmp_branch_positions_file--------- 

	-------------------START INVALID BO CODE BUT INVESTOR CODE FOUND IN tblFTtmp_branch_positions_file---------  
    SELECT 
		investor_code
		,'BO Code is not 16 digit for following investors: '
	FROM  
		Trade.tblFTPositionsTemp
    WHERE 
		LEN(ISNULL(boid,'')) != 16
	-------------------CLOSE INVALID BO CODE BUT INVESTOR CODE FOUND IN tblFTtmp_branch_positions_file---------

	-------------------START INVESTOR CODE FOUND IN tblFTtmp_branch_positions_file BUT NOT IN TRD_INVESTOR_ACCOUNT---------  
    SELECT 
		tfpt.investor_code
		,'Found New Investors :' 
	FROM  
		(
			SELECT DISTINCT 
				investor_code 
			FROM 
				Trade.tblFTPositionsTemp 
		) AS tfpt 
	LEFT JOIN  
		Investor.tblInvestor tinv 
			ON tfpt.investor_code = tinv.client_id
			AND tinv.membership_id = @membership_id
			AND omnibus_master_id = @omnibus_master_id
    WHERE 
		tinv.client_id IS NULL
	-------------------CLOSE INVESTOR CODE FOUND IN tblFTtmp_branch_positions_file BUT NOT IN TRD_INVESTOR_ACCOUNT---------

	-------------------START BO CODE FOUND IN tblFTtmp_branch_positions_file BUT NOT IN TRD_INVESTOR_ACCOUNT---------  
    SELECT 
		tfpt.boid
		,'Found New BO Codes :'
	FROM  
		(
			SELECT DISTINCT 
				boid 
			FROM 
				Trade.tblFTPositionsTemp 
		) AS tfpt 
	LEFT JOIN  
		Investor.tblInvestor tinv 
			ON tfpt.boid = tinv.bo_code
			AND tinv.membership_id = @membership_id
			AND omnibus_master_id = @omnibus_master_id
    WHERE 
		tinv.client_id IS NULL
		AND tinv.bo_code IS NULL
	-------------------CLOSE BO CODE FOUND IN tblFTtmp_branch_positions_file BUT NOT IN TRD_INVESTOR_ACCOUNT---------

	-------------------START INACTIVE INVESTOR CODE FOUND---------  
    SELECT 
		tfpt.investor_code
		,'Found Inactive/Closed Investors :' 
	FROM  
		(
			SELECT DISTINCT 
				investor_code 
			FROM 
				Trade.tblFTPositionsTemp 
		) AS tfpt 
	INNER JOIN  
		Investor.tblInvestor tinv 
			ON tfpt.investor_code = tinv.client_id
			AND tinv.membership_id = @membership_id
			AND omnibus_master_id = @omnibus_master_id
	INNER JOIN 
		dbo.tblConstantObjectValue covas
			ON covas.object_value_id = tinv.active_status_id
    WHERE 
		covas.display_value != 'Active'
	-------------------CLOSE INACTIVE INVESTOR CODE FOUND---------

	-------------------START TRADER MAPPING WITH INVESTOR CODE PROPERLY---------  
    SELECT 
		tfpt.investor_code
		,'Found Investors which not mapped with trader:'
	FROM  
		(
			SELECT DISTINCT 
				investor_code 
			FROM 
				Trade.tblFTPositionsTemp 
		) AS tfpt 
	INNER JOIN  
		Investor.tblInvestor tinv 
			ON tfpt.investor_code = tinv.client_id 
	INNER JOIN
		broker.tblTrader tt 
			ON tt.id = tinv.trader_id
			AND tt.membership_id = tinv.membership_id 
    WHERE 
		LEN(ISNULL(tt.trader_code,''))<8
		AND tinv.membership_id = @membership_id
		AND omnibus_master_id = @omnibus_master_id
	-------------------CLOSE TRADER MAPPING WITH INVESTOR CODE PROPERLY--------- 

	-------------------START BUY CURRENT BALANCE CAN NOT BE NEGETIVE---------  
    SELECT 
		investor_code
		,'Found Negetive current balance: '
	FROM 
		Trade.tblFTPositionsTemp
    WHERE 
		CONVERT(numeric(15,0), ISNULL(current_balance,-1)) <0
	-------------------CLOSE BUY CURRENT BALANCE CAN NOT BE NEGETIVE--------- 

	-------------------START BUY CURRENT BALANCE CAN NOT BE NEGETIVE---------  
    SELECT 
		investor_code
		,'Found Negetive current balance: '
	FROM 
		Trade.tblFTPositionsTemp
    WHERE 
		CONVERT(numeric(15,0), ISNULL(free_balance,-1)) <0
	-------------------CLOSE BUY CURRENT BALANCE CAN NOT BE NEGETIVE--------- 
END







USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[psp_ft_imp_positions]    Script Date: 12/27/2015 3:39:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 27/12/2015
-- Description:	Process import positions
-- =============================================

CREATE PROCEDURE [Trade].[psp_ft_imp_positions](
	@membership_id numeric(9,0),
	@import_dt numeric(9,0),
	@file_name varchar(max),
	@omnibus_master_id varchar(10)
	)
AS
begin
	DECLARE @version_no numeric(2,0)
		, @log_id int

	---------------------------------START: Duplication checking----------------------------------------
	IF EXISTS(SELECT log_id FROM Trade.tblFTImportLog WHERE file_type='positions' AND import_dt = @import_dt
		AND [file_name] = @file_name
		AND omnibus_master_id = @omnibus_master_id
		AND membership_id = @membership_id) 
	BEGIN
		RAISERROR('This positions file already imported',16,1)
		RETURN
	END
	---------------------------------END: Duplication checking----------------------------------------
	
	-- Get new version no
	SELECT @version_no = MAX(version_no) FROM Trade.tblFTImportLog WHERE file_type = 'positions' AND membership_id = @membership_id AND omnibus_master_id = @omnibus_master_id

	IF @version_no IS NULL SET @version_no = 1
	ELSE SET @version_no = @version_no + 1

    -- Insert statements for procedure here
	INSERT INTO 
		Trade.tblFTImportLog
			(
				file_type
				,file_name
				,import_dt
				,version_no
				,omnibus_master_id
				,membership_id
			) 
		VALUES
			(
				'positions'
				,@file_name
				,@import_dt
				,@version_no
				,@omnibus_master_id
				,@membership_id
			)

    SELECT @log_id = log_id FROM Trade.tblFTImportLog WHERE file_type = 'positions' AND membership_id = @membership_id AND version_no = @version_no AND omnibus_master_id = @omnibus_master_id

	INSERT INTO 
		Trade.tblFTpositions
			(
				ClientCode
				,SecurityCode
				,ISIN
				,Quantity
				,TotalCost
				,PositionType
				,import_type
				,import_log_id
				,membership_id
			)
		SELECT 
			RTRIM(LTRIM(ISNULL(investor_code,''))) 
			,RTRIM(LTRIM(ISNULL(com_s_name,'')))
			,RTRIM(LTRIM(ISNULL(isin,'')))
			,ISNULL(free_balance,0)
			,0
			,'Long'
			,'B'
			,@log_id
			,@membership_id
		FROM 
			Trade.tblFTPositionsTemp

	TRUNCATE TABLE Trade.tblFTPositionsTemp

	---------------------------------START: Record not found----------------------------------------
	IF NOT EXISTS(SELECT log_id FROM Trade.tblFTPositions) 
	BEGIN
		RAISERROR('Record not found',16,1)
		RETURN
	END
	---------------------------------END: Record not found----------------------------------------
END







-----------------------------------------------------02/01/15-----------------------------------------




USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_client_portfolio_statement_as_on]    Script Date: 1/2/2016 3:40:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 02/12/2015
-- Description:	Client Portfolio Report 
-- Updated by : Sarwar
-- Update Date: 12/13/2015
-- Description: Set currnet date and As on date script separate

--[Investor].[rsp_client_portfolio_statement_as_on] 62,'10','2015-12-09'
-- =============================================
ALTER PROCEDURE [Investor].[rsp_client_portfolio_statement_as_on]
	@MEMBERSHIP_ID NUMERIC(9,0),
	@user_id nvarchar(128),
	@CLIENT_ID VARCHAR(10),
	@REPORT_DATE DATETIME
AS
BEGIN
SET NOCOUNT ON;

--DECLARATION
DECLARE  @PROCESS_DATETIME AS DATETIME
		,@TRANSACTION_DATE AS NUMERIC(9)

--INITIALIZATION
SELECT @PROCESS_DATETIME=[dbo].[sfun_get_process_date_as_datetime]()
SELECT @TRANSACTION_DATE = DATEKEY FROM [dbo].[DimDate] WHERE [DATE]=@report_date

/***************************************************************FOR CURRENT DATE***************************************************/
IF CONVERT(DATE,@PROCESS_DATETIME)=CONVERT(DATE,@report_date)
BEGIN
	IF EXISTS(SELECT 1 FROM [Investor].[vw_InvestorShareBalance] WHERE membership_id=@MEMBERSHIP_ID AND CLIENT_ID=@client_id AND (ISNULL(cost_value,0) + ISNULL(market_value,0)) !=0 )
		BEGIN
		SELECT 
		   tis.client_id,
		   ti.first_holder_name,
		   (CASE WHEN ti.mobile_no IS NOT NULL THEN ti.mobile_no WHEN ti.phone_no IS NOT NULL THEN ti.phone_no ELSE NULL END) AS contact_no,
		   ti.mailing_address,
		   tis.ledger_quantity,
		   tis.salable_quantity,
		   tii.security_code,
		   tis.cost_average,
		   tis.cost_value,
		   tis.market_price,
		   tis.market_value,
		   (tis.market_value-tis.cost_value) as gainloss,
		   case when tif.unrealized_gain <> 0 then (((tis.market_value-tis.cost_value)/tif.[unrealized_gain])* 100) else 0 end as precentage,
		   tif.available_balance,
		   tif.un_clear_cheque,
		   tif.total_deposit,
		   tif.total_withdraw,
		   tif.market_value as final_market_value,
		   tif.ledger_balance as final_ledger,
		   tif.equity,
		   tif.purchase_power,
		   tif.loan_ratio,
		   tif.realized_gain,
		   tif.unrealized_gain
		FROM 
			[Investor].[vw_InvestorShareBalance] tis
		INNER JOIN 
			[Investor].[vw_InvestorFundBalance] tif 
			on tif.membership_id=tis.membership_id 
			and tis.client_id = tif.client_id
		INNER JOIN 
			Investor.tblInvestor ti 
			on ti.membership_id=tis.membership_id
			and tif.client_id = ti.client_id
		INNER JOIN 
			Instrument.tblInstrument tii on tis.instrument_id = tii.id
		WHERE 
			tif.client_id = @client_id
			AND tis.membership_id= @membership_id
			AND tis.ledger_quantity + tis.salable_quantity != 0
		ORDER BY tii.security_code
	END
	--SHOW ONLY FINANCILA BALANCE AS NO SHARE EXISTS 
	ELSE
		BEGIN
		SELECT 
			tif.client_id,
			ti.first_holder_name,
			(CASE WHEN ti.mobile_no IS NOT NULL THEN ti.mobile_no WHEN ti.phone_no IS NOT NULL THEN ti.phone_no ELSE NULL END) AS contact_no,
			ti.mailing_address,
			0 as ledger_quantity,
			0 as salable_quantity,
			null as security_code,
			0 as cost_average,
			0 as cost_value,
			0 as market_price,
			0 as market_value,
			0 as gainloss,
			0 as precentage,
			tif.available_balance,
			tif.un_clear_cheque,
			tif.total_deposit,
			tif.total_withdraw,
			tif.market_value as final_market_value,
			tif.ledger_balance as final_ledger,
			tif.equity,
			tif.purchase_power,
			tif.loan_ratio,
			tif.realized_gain,
			tif.unrealized_gain
		FROM 
			[Investor].[vw_InvestorFundBalance]  tif
		INNER JOIN 
			Investor.tblInvestor ti 
			on ti.membership_id=tif.membership_id
			and tif.client_id = ti.client_id
		WHERE 
			tif.client_id = @client_id
			AND tif.membership_id= @membership_id
	END
END

/***************************************************************FOR AS ON DATE***************************************************/
ELSE
BEGIN
	IF EXISTS(SELECT 1 FROM [Investor].[tblInvestorShareBalance] WHERE membership_id=@MEMBERSHIP_ID AND CLIENT_ID=@client_id AND TRANSACTION_DATE<= @TRANSACTION_DATE)
		BEGIN
		SELECT 
		   tis.client_id,
		   ti.first_holder_name,
		   (CASE WHEN ti.mobile_no IS NOT NULL THEN ti.mobile_no WHEN ti.phone_no IS NOT NULL THEN ti.phone_no ELSE NULL END) AS contact_no,
		   ti.mailing_address,
		   tis.ledger_quantity,
		   tis.salable_quantity,
		   tii.security_code,
		   tis.cost_average,
		   tis.cost_value,
		   tis.market_price,
		   tis.market_value,
		   (tis.market_value-tis.cost_value) as gainloss,
		    case when tif.unrealized_gain <> 0 then (((tis.market_value-tis.cost_value)/tif.[unrealized_gain])* 100) else 0 end as precentage,
		   tif.available_balance,
		   tif.un_clear_cheque,
		   tif.total_deposit,
		   tif.total_withdraw,
		   tif.market_value as final_market_value,
		   tif.ledger_balance as final_ledger,
		   tif.equity,
		   tif.purchase_power,
		   tif.loan_ratio,
		   tif.realized_gain,
		   tif.unrealized_gain
		FROM 
			[Investor].[tblInvestorShareBalance]  tis
		INNER JOIN 
			[Investor].[tblInvestorFundBalance] tif 
			ON  tif.membership_id=tis.membership_id 
			AND tis.client_id = tif.client_id
			AND TIF.transaction_date =
				(
					SELECT 
						MAX(tif2.transaction_date)
					FROM
						[Investor].[tblInvestorFundBalance] tif2
					WHERE
						tif2.membership_id=tif.membership_id
						AND tif2.client_id=tif.client_id
						AND tif2.transaction_date<=@TRANSACTION_DATE 
				)
		INNER JOIN 
			Investor.tblInvestor ti 
			ON ti.membership_id=tis.membership_id
			AND tif.client_id = ti.client_id
		INNER JOIN 
			Instrument.tblInstrument tii on tis.instrument_id = tii.id
		WHERE 
			tif.client_id = @client_id
			AND tis.membership_id= @membership_id
			AND tis.ledger_quantity + tis.salable_quantity != 0
			AND TIS.transaction_date =
				(
					SELECT 
						MAX(TIS2.transaction_date)
					FROM
						[Investor].[tblInvestorShareBalance] TIS2
					WHERE
						TIS2.membership_id=tif.membership_id
						AND TIS2.client_id=tif.client_id
						AND TIS2.instrument_id=TIS.instrument_id
						AND TIS2.transaction_date<=@TRANSACTION_DATE 
				)
		ORDER BY tii.security_code
	END
	--SHOW ONLY FINANCILA BALANCE AS NO SHARE EXISTS 
	ELSE
		BEGIN
		SELECT 
			tif.client_id,
			ti.first_holder_name,
			(CASE WHEN ti.mobile_no IS NOT NULL THEN ti.mobile_no WHEN ti.phone_no IS NOT NULL THEN ti.phone_no ELSE NULL END) AS contact_no,
			ti.mailing_address,
			0 as ledger_quantity,
			0 as salable_quantity,
			null as security_code,
			0 as cost_average,
			0 as cost_value,
			0 as market_price,
			0 as market_value,
			0 as gainloss,
			0 as precentage,
			tif.available_balance,
			tif.un_clear_cheque,
			tif.total_deposit,
			tif.total_withdraw,
			tif.market_value as final_market_value,
			tif.ledger_balance as final_ledger,
			tif.equity,
			tif.purchase_power,
			tif.loan_ratio,
			tif.realized_gain,
			tif.unrealized_gain
		FROM 
			[Investor].[tblInvestorFundBalance] tif
		INNER JOIN 
			Investor.tblInvestor ti 
			on ti.membership_id=tif.membership_id
			and tif.client_id = ti.client_id
		WHERE 
			tif.client_id = @client_id
			AND tif.membership_id= @membership_id
			AND TIF.transaction_date =
				(
					SELECT 
						MAX(tif2.transaction_date)
					FROM
						[Investor].[tblInvestorFundBalance] tif2
					WHERE
						tif2.membership_id=tif.membership_id
						AND tif2.client_id=tif.client_id
						AND tif2.transaction_date<=@TRANSACTION_DATE 
				)
	END
END	
END












USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[rsp_client_ledger]    Script Date: 1/2/2016 12:37:33 PM ******/
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

--- exec Investor.rsp_client_ledger '62','1bf1c0e7-fa04-4266-9ce4-d20d6516737a','10','2015-01-06','2015-12-06'
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
			case when(tcov.display_value ='BUY/SALE') then (case when(SUM(tif.debit) > 0)then 'BUY' else 'SELL' end) else tcov.display_value end  AS finintial_ledger_type,
			tif.narration,
			SUM(tif.quantity) AS quantity,
			SUM(tif.rate) AS rate,
			SUM(tif.quantity*tif.rate) as amount,
			SUM(tif.comm_amount) AS comm_amount,
			SUM(tif.debit) AS debit,
			SUM(tif.credit) AS credit,
			@opening_balance as openingbalance
		FROM 
			Investor.tblInvestorFinancialLedger tif
		INNER JOIN  
			Investor.tblInvestor ti 
			on tif.client_id = ti.client_id
		INNER JOIN 
			dbo.tblConstantObjectValue tcov
			on tif.transaction_type_id = tcov.object_value_id
		INNER JOIN [dbo].[DimDate] dd
			on dd.DateKey=tif.transaction_date
		INNER JOIN dbo.tblConstantObject tco on tco.object_name='TRANSACTION_MODE'
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
			tcov.display_value,
			tif.narration
		ORDER BY 
			tif.transaction_date,
			tcov.display_value	
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
/****** Object:  StoredProcedure [Trade].[rsp_trade_confirmation_statement_client_wise]    Script Date: 1/2/2016 1:51:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_trade_confirmation_statement_client_wise 62, 20141020, 20151231, null, null
-- =============================================
-- Author:		Asif
-- Create date: 21/12/15
-- Description:	Trade confirmation statement client wise
-- =============================================
--[Trade].[rsp_trade_confirmation_statement_client_wise] 62,'2015-01-01','2015-12-12',null,null

--[Trade].[rsp_trade_confirmation_statement_client_wise] 62, null,'2015-01-01','2015-12-12','20685'
ALTER PROCEDURE [Trade].[rsp_trade_confirmation_statement_client_wise]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime,
@client_id varchar(10)
)

AS

BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF
	
	DECLARE @opening_dt numeric(9,0);
	
	SELECT @opening_dt = MAX(DateKey) FROM dbo.DimDate WHERE DateKey < (select DateKey from dimdate where Date = @from_dt)
	 
	SELECT 
		ttd.client_id
		,tinv.bo_code
		,tinv.first_holder_name
		,(CASE WHEN tinv.mobile_no IS NOT NULL THEN tinv.mobile_no WHEN tinv.phone_no IS NOT NULL THEN tinv.phone_no ELSE NULL END) AS contact_no
		,tinv.mailing_address
		,CASE WHEN ttd.transaction_type = 'B' THEN 'Buy' WHEN ttd.transaction_type = 'S' THEN 'Sell' END AS transaction_type
		,ddd.FullDateCDBL AS exe_date
		,tins.security_code
		,SUM(CAST(ttd.Quantity AS int)) AS qty
		,SUM(ttd.Unit_Price) AS Unit_Price
		,SUM(ttd.commission_rate) AS commission_rate
		,SUM([Investor].[sfun_get_investor_fund_balance](ttd.client_id,ddt.DateKey)) AS ledger_balance
		,CASE WHEN ttd.transaction_type = 'B' THEN SUM(CAST(ttd.Quantity AS int)) * SUM(ttd.Unit_Price) + SUM(ttd.commission_rate) ELSE SUM(CAST(ttd.Quantity AS int)) * SUM(ttd.Unit_Price) + SUM(ttd.commission_rate) END AS balance
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
	LEFT JOIN 
		[Investor].[tblJoinHolder] tjh 
		ON tjh.client_id = ttd.client_id
		AND tjh.membership_id=ttd.membership_id
	INNER JOIN 
		[broker].[tblBrokerBranch] tbb 
		ON tbb.id = tinv.branch_id
		AND tbb.membership_id=ttd.membership_id
	INNER JOIN 
		[dbo].[tblConstantObjectValue] tcovmt 
		ON tcovmt.object_value_id = ttd.market_type_id
	inner join 
		DimDate ddf 
		on @from_dt = ddf.Date
	inner join 
		Dimdate ddt 
		on @to_dt = ddt.Date 
	WHERE 
		ttd.membership_id = @membership_id
		AND ttd.Date BETWEEN ddf.DateKey AND ddt.DateKey
		AND (ttd.client_id = @client_id OR @client_id IS NULL OR @client_id = '')
	GROUP BY 
		ttd.client_id
		,tinv.bo_code
		,tinv.first_holder_name
		,tinv.mobile_no
		,tinv.phone_no
		,tinv.mailing_address
		,ttd.transaction_type
		,ddd.FullDateCDBL
		,tins.security_code
		,ttd.Date
	ORDER BY
		ttd.Date
	 
END






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_brokerage_commission_income_branch_wise]    Script Date: 1/2/2016 5:29:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_brokerage_commission_income_branch_wise 62, 20141020, 20151231
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
	 
	 SELECT CASE WHEN ttd.transaction_type = 'B' THEN 'Buy' WHEN ttd.transaction_type = 'S' THEN 'Sell' END AS transaction_type
	 ,SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) AS turnover
	 ,SUM(ttd.commission_amount) AS total_com
	 ,SUM(ISNULL(ttd.transaction_fee,0)) AS transaction_fee
	 ,SUM(ISNULL(ttd.ait,0)) AS ait
	 ,SUM(ttd.commission_rate) - (SUM(ISNULL(ttd.transaction_fee,0)) + SUM(ISNULL(ttd.ait,0))) AS net_income
	 ,tcovmt.display_value AS market_name
	 ,tbb.name AS branch_name
	 FROM [Trade].[tblTradeData] ttd
	 INNER JOIN [Investor].[tblInvestor] ti ON ti.client_id = ttd.client_id
	 INNER JOIN [broker].[tblBrokerBranch] tbb ON tbb.id = ti.branch_id
	 INNER JOIN [dbo].[tblConstantObjectValue] tcovmt ON tcovmt.object_value_id = ttd.market_type_id
	 INNER JOIN dbo.DimDate DD ON TTD.Date=DD.DateKey
	 WHERE ttd.membership_id = @membership_id
	 AND DD.Date BETWEEN @from_dt AND @to_dt
	 AND (@branch_id IS NULL OR TBB.id = @branch_id)
	 GROUP BY ttd.membership_id, ttd.transaction_type, tcovmt.display_value, tbb.name
	 
END






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_brokerage_commission_income_client_wise]    Script Date: 1/2/2016 5:36:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_brokerage_commission_income_client_wise 62, 20141020, 20151231
-- =============================================
-- Author:		Asif
-- Create date: 17/11/15
-- Description:	Brokerage commission income client wise
-- =============================================

-- exec [Trade].[rsp_brokerage_commission_income_client_wise] 62,'2015-01-01','2015-12-12'

ALTER PROCEDURE [Trade].[rsp_brokerage_commission_income_client_wise]
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
			CASE WHEN ttd.transaction_type = 'B' THEN 'Buy' WHEN ttd.transaction_type = 'S' THEN 'Sell' END AS transaction_type
			,SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) AS turnover
			,SUM(ttd.commission_amount) AS total_com
			,SUM(ISNULL(ttd.transaction_fee,0)) AS transaction_fee
			,SUM(ISNULL(ttd.ait,0)) AS ait
			,SUM(ttd.commission_amount) - (SUM(ISNULL(ttd.transaction_fee,0)) + SUM(ISNULL(ttd.ait,0))) AS net_income
			,tcovmt.display_value AS market_name
			,ttd.client_id
			,ti.first_holder_name
		FROM [Trade].[tblTradeData] ttd
			INNER JOIN [Investor].[tblInvestor] ti
				ON ti.client_id = ttd.client_id
			INNER JOIN [dbo].[tblConstantObjectValue] tcovmt 
				ON tcovmt.object_value_id = ttd.market_type_id
			INNER JOIN DimDate dd 
				ON ttd.Date = dd.DateKey
		WHERE 
			ttd.membership_id = @membership_id
			AND dd.Date BETWEEN @from_dt AND @to_dt
		GROUP BY 
			ttd.client_id
			,ti.first_holder_name
			,ttd.membership_id
			,ttd.transaction_type
			,tcovmt.display_value
	 
END








USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_brokerage_commission_income_trader_wise]    Script Date: 1/2/2016 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_brokerage_commission_income_trader_wise 62, 20141020, 20151231
-- =============================================
-- Author:		Asif
-- Create date: 17/11/15
-- Description:	Brokerage commission income trader wise
-- =============================================

-- exec [Trade].[rsp_brokerage_commission_income_trader_wise] 62,'2015-01-01','2015-12-12'

ALTER PROCEDURE [Trade].[rsp_brokerage_commission_income_trader_wise]
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
	 
	 SELECT CASE WHEN ttd.transaction_type = 'B' THEN 'Buy' WHEN ttd.transaction_type = 'S' THEN 'Sell' END AS transaction_type
	 ,SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) AS turnover
	 ,SUM(ttd.commission_amount) AS total_com
	 ,SUM(ISNULL(ttd.transaction_fee,0)) AS transaction_fee
	 ,SUM(ISNULL(ttd.ait,0)) AS ait
	 ,SUM(ttd.commission_amount) - (SUM(ISNULL(ttd.transaction_fee,0)) + SUM(ISNULL(ttd.ait,0))) AS net_income
	 ,tcovmt.display_value AS market_name
	 ,ttd.TraderDealerID AS trader_code
	 FROM [Trade].[tblTradeData] ttd
	 INNER JOIN [dbo].[tblConstantObjectValue] tcovmt ON tcovmt.object_value_id = ttd.market_type_id
	 inner join DimDate dd on ttd.Date = dd.DateKey
	 WHERE ttd.membership_id = @membership_id
	 AND dd.Date BETWEEN @from_dt AND @to_dt
	 GROUP BY ttd.membership_id, ttd.transaction_type, tcovmt.display_value, ttd.TraderDealerID
	 
END






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_brokerage_commission_income_agent_wise]    Script Date: 1/2/2016 5:34:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_brokerage_commission_income_agent_wise 62, 20141020, 20151231, null
-- =============================================
-- Author:		Asif
-- Create date: 24/11/15
-- Description:	Brokerage commission income agent wise
-- =============================================

ALTER PROCEDURE [Trade].[rsp_brokerage_commission_income_agent_wise]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime,
@ref_code varchar(20)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
	 SELECT a.client_id
		,a.introducer_code
		,a.introducer_name
		,SUM(a.total_buy) AS total_buy
		,SUM(a.total_sell) AS total_sell
		,SUM(a.commission_amount) AS commission_amount
		,SUM(a.commission_rate)/COUNT(a.commission_rate) AS commission_rate
		,a.first_holder_name
		,a.market_name
		FROM
		(
			SELECT ttd.client_id
			,tint.ref_code AS introducer_code
			,tint.introducer_name
			,CASE ttd.transaction_type WHEN 'B' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) ELSE 0 END AS total_buy
			,CASE ttd.transaction_type WHEN 'S' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) ELSE 0 END AS total_sell
			,ttd.commission_amount AS commission_rate
			,SUM(ttd.commission_amount - (ISNULL(ttd.transaction_fee,0) + ISNULL(ttd.ait,0))) AS commission_amount
			,tinv.first_holder_name
			,tcovmt.display_value AS market_name
			FROM [Trade].[tblTradeData] ttd
			INNER JOIN [Investor].[tblInvestor] tinv ON tinv.client_id = ttd.client_id
			INNER JOIN [Investor].[tblIntroducer] tint ON tint.id = tinv.introducer_id
			INNER JOIN [dbo].[tblConstantObjectValue] tcovmt ON tcovmt.object_value_id = ttd.market_type_id
			INNER JOIN dbo.DimDate DD ON TTD.Date=DD.DateKey
			WHERE ttd.membership_id = @membership_id
			AND DD.Date BETWEEN @from_dt AND @to_dt
			AND (tint.ref_code = @ref_code OR @ref_code IS NULL OR @ref_code = '')
			GROUP BY ttd.client_id, tinv.first_holder_name, ttd.transaction_type, ttd.commission_amount, tcovmt.display_value, tint.ref_code, tint.introducer_name
		) AS a
		GROUP BY a.client_id, a.introducer_code, a.introducer_name, a.first_holder_name, a.market_name
		ORDER BY a.client_id
	 
END







USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_trade_confirmation_statement]    Script Date: 1/2/2016 5:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_trade_confirmation_statement 62, 20141020, 20151231
-- =============================================
-- Author:		Asif
-- Create date: 23/11/15
-- Description:	Trade confirmation statement
-- =============================================

ALTER PROCEDURE [Trade].[rsp_trade_confirmation_statement]
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
		ttd.client_id
		,CASE WHEN ttd.transaction_type = 'B' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) ELSE 0 END AS total_buy
		,CASE WHEN ttd.transaction_type = 'S' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price)ELSE 0 END AS total_sales
		,SUM(ttd.commission_amount) AS commission_amount
		,ttd.commission_rate
		,tbb.name AS branch_name
		,tinv.first_holder_name
		,tjh.join_holder_name AS second_holder_name
		,tcovmt.display_value AS market_name
		,(CASE WHEN ttd.transaction_type = 'S' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price)ELSE 0 END) - (CASE WHEN ttd.transaction_type = 'B' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price)ELSE 0 END) - (SUM(ttd.commission_amount)) AS balance
		,SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) AS turnover
	FROM 
		[Trade].[tblTradeData] ttd
	INNER JOIN 
		[Instrument].[tblInstrument] tins 
		ON tins.id = ttd.instrument_id
	INNER JOIN 
		[Investor].[tblInvestor] tinv 
		ON tinv.client_id = ttd.client_id
		AND tinv.membership_id=ttd.membership_id
	LEFT JOIN 
		[Investor].[tblJoinHolder] tjh 
		ON tjh.client_id = ttd.client_id
		AND tjh.membership_id=ttd.membership_id
	INNER JOIN 
		[broker].[tblBrokerBranch] tbb 
		ON tbb.id = tinv.branch_id
		AND tbb.membership_id=ttd.membership_id
	inner join 
		DimDate ddf on @from_dt = ddf.Date 
	inner join 
		DimDate ddt on @to_dt = ddt.Date 
	INNER JOIN 
		[dbo].[tblConstantObjectValue] tcovmt 
		ON tcovmt.object_value_id = ttd.market_type_id
	WHERE 
		ttd.membership_id = @membership_id
		AND ttd.Date BETWEEN ddf.DateKey AND ddt.DateKey
	GROUP BY 
		ttd.client_id, tbb.name, tinv.first_holder_name, tjh.join_holder_name, tcovmt.display_value, ttd.transaction_type,ttd.commission_rate
	ORDER BY ttd.client_id
	 
END








USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_trade_confirmation_statement_client_wise]    Script Date: 1/2/2016 5:46:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_trade_confirmation_statement_client_wise 62, 20141020, 20151231, null, null
-- =============================================
-- Author:		Asif
-- Create date: 21/12/15
-- Description:	Trade confirmation statement client wise
-- =============================================
--[Trade].[rsp_trade_confirmation_statement_client_wise] 62,'2015-01-01','2015-12-12',null,null

--[Trade].[rsp_trade_confirmation_statement_client_wise] 62, null,'2015-01-01','2015-12-12','20685'
ALTER PROCEDURE [Trade].[rsp_trade_confirmation_statement_client_wise]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime,
@client_id varchar(10)
)

AS

BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF
	
	DECLARE @opening_dt numeric(9,0);
	
	SELECT @opening_dt = MAX(DateKey) FROM dbo.DimDate WHERE DateKey < (select DateKey from dimdate where Date = @from_dt)
	 
	SELECT 
		ttd.client_id
		,tinv.bo_code
		,tinv.first_holder_name
		,(CASE WHEN tinv.mobile_no IS NOT NULL THEN tinv.mobile_no WHEN tinv.phone_no IS NOT NULL THEN tinv.phone_no ELSE NULL END) AS contact_no
		,tinv.mailing_address
		,CASE WHEN ttd.transaction_type = 'B' THEN 'Buy' WHEN ttd.transaction_type = 'S' THEN 'Sell' END AS transaction_type
		,ddd.FullDateCDBL AS exe_date
		,tins.security_code
		,SUM(CAST(ttd.Quantity AS int)) AS qty
		,SUM(ttd.Unit_Price) AS Unit_Price
		,SUM(ttd.commission_amount) AS commission_rate
		,SUM([Investor].[sfun_get_investor_fund_balance](ttd.client_id,ddt.DateKey)) AS ledger_balance
		,CASE WHEN ttd.transaction_type = 'B' THEN SUM(CAST(ttd.Quantity AS int)) * SUM(ttd.Unit_Price) + SUM(ttd.commission_amount) ELSE SUM(CAST(ttd.Quantity AS int)) * SUM(ttd.Unit_Price) + SUM(ttd.commission_rate) END AS balance
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
	LEFT JOIN 
		[Investor].[tblJoinHolder] tjh 
		ON tjh.client_id = ttd.client_id
		AND tjh.membership_id=ttd.membership_id
	INNER JOIN 
		[broker].[tblBrokerBranch] tbb 
		ON tbb.id = tinv.branch_id
		AND tbb.membership_id=ttd.membership_id
	INNER JOIN 
		[dbo].[tblConstantObjectValue] tcovmt 
		ON tcovmt.object_value_id = ttd.market_type_id
	inner join 
		DimDate ddf 
		on @from_dt = ddf.Date
	inner join 
		Dimdate ddt 
		on @to_dt = ddt.Date 
	WHERE 
		ttd.membership_id = @membership_id
		AND ttd.Date BETWEEN ddf.DateKey AND ddt.DateKey
		AND (ttd.client_id = @client_id OR @client_id IS NULL OR @client_id = '')
	GROUP BY 
		ttd.client_id
		,tinv.bo_code
		,tinv.first_holder_name
		,tinv.mobile_no
		,tinv.phone_no
		,tinv.mailing_address
		,ttd.transaction_type
		,ddd.FullDateCDBL
		,tins.security_code
		,ttd.Date
	ORDER BY
		ttd.Date
	 
END






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[rsp_trade_confirmation_statement_consolidate]    Script Date: 1/2/2016 5:47:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_trade_confirmation_statement_consolidate 62, 20141020, 20151231, 0
-- =============================================
-- Author:		Asif
-- Create date: 24/11/15
-- Description:	Trade confirmation statement consolidate
-- =============================================
--[Trade].[rsp_trade_confirmation_statement_consolidate] 62,'2015-01-01','2015-12-12',null
ALTER PROCEDURE [Trade].[rsp_trade_confirmation_statement_consolidate]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime,
@branch_id datetime
)

AS

BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF
	
	DECLARE @opening_dt numeric(9,0);
	
	SELECT @opening_dt = MAX(DateKey) FROM dbo.DimDate WHERE DateKey < (select DateKey from dimdate where Date = @from_dt)
	 
	SELECT 
		ttd.client_id
		,CASE WHEN ttd.transaction_type = 'B' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) ELSE 0 END AS total_buy
		,CASE WHEN ttd.transaction_type = 'S' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price)ELSE 0 END AS total_sell
		,SUM(ttd.commission_amount) AS commission_amount
		,ttd.commission_rate
		,tbb.name AS branch_name
		,tinv.first_holder_name
		,tjh.join_holder_name AS second_holder_name
		,tcovmt.display_value AS market_name
		,[Investor].[sfun_get_investor_fund_balance](ttd.client_id,@opening_dt) AS opening_balance
		,[Investor].[sfun_get_investor_fund_balance](ttd.client_id,ddt.DateKey) AS ledger_balance
		,SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price) AS turnover
		,(CASE WHEN ttd.transaction_type = 'S' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price)ELSE 0 END) - ((CASE WHEN ttd.transaction_type = 'B' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price)ELSE 0 END) + (SUM(ttd.commission_amount))) AS net_balance
	FROM 
		[Trade].[tblTradeData] ttd
	INNER JOIN 
		[Instrument].[tblInstrument] tins 
		ON tins.id = ttd.instrument_id
	INNER JOIN 
		[Investor].[tblInvestor] tinv 
		ON tinv.client_id = ttd.client_id
		AND tinv.membership_id=TTD.membership_id
	LEFT JOIN 
		[Investor].[tblJoinHolder] tjh 
		ON tjh.client_id = ttd.client_id
		AND tjh.membership_id=TTD.membership_id
	INNER JOIN 
		[broker].[tblBrokerBranch] tbb 
		ON tbb.id = tinv.branch_id
		AND TBB.membership_id=TTD.membership_id
	INNER JOIN 
		[dbo].[tblConstantObjectValue] tcovmt 
		ON tcovmt.object_value_id = ttd.market_type_id
	inner join 
		DimDate ddf 
		on @from_dt = ddf.Date
	inner join 
		Dimdate ddt 
		on @to_dt = ddt.Date 
	WHERE 
		ttd.membership_id = @membership_id
		AND ttd.Date BETWEEN ddf.DateKey AND ddt.DateKey
		AND (tinv.branch_id = @branch_id OR @branch_id IS NULL OR @branch_id = 0)
	GROUP BY 
		ttd.client_id, tbb.name, tinv.first_holder_name, tjh.join_holder_name, tcovmt.display_value, ttd.transaction_type,ddt.DateKey,ttd.commission_rate
	ORDER BY ttd.client_id
	 
END





USE [master]
GO
ALTER DATABASE [Escrow.BOAS] ADD FILEGROUP [IpoManagement]
GO





ALTER DATABASE [Escrow.BOAS]
 ADD FILE
( NAME = N'Escrow.BOAS.IpoManagement', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Escrow.BOAS.IpoManagement.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
TO FILEGROUP [IpoManagement] 
GO



USE [Escrow.BOAS]
GO

/****** Object:  Schema [Ipo]    Script Date: 1/2/2016 8:37:46 PM ******/
CREATE SCHEMA [Ipo]
GO







USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Ipo].[psp_ipo_pull_data]    Script Date: 1/3/2016 4:50:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 02/01/2016
-- Description:	PULL DATA FROM BROKER BACK OFFICE SYSTEM TO SYNC WITH IPO MODULE
-- =============================================

-- EXEC Ipo.psp_ipo_pull_data '2015-05-01', 23
CREATE PROCEDURE [Ipo].[psp_ipo_pull_data]
	@branch_sync_date as datetime,
	@client_info_sync_date as datetime,
	@membership_id AS numeric(9,0),
	@is_pull_branch as bit,
	@is_pull_client_info as bit,
	@is_pull_client_ledger as bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @active_status_id AS numeric(4,0)
		, @ipo_type_id AS numeric(4,0)

	SELECT @active_status_id = dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')

	SELECT @ipo_type_id = dbo.sfun_get_constant_object_default_value_id('IPO_TYPE')

    ----------------------------------- START: BRANCH INFORMATION --------------------------------------------------
	IF(@is_pull_branch=1)
	BEGIN
		SELECT 
			id AS BranchID
			,name AS BranchName
			,@membership_id AS membership_id
		FROM 
			broker.tblBrokerBranch 
		WHERE 
			@branch_sync_date IS NULL 
			OR changed_date>= @branch_sync_date
	END
	----------------------------------- END: BRANCH INFORMATION --------------------------------------------------

	----------------------------------- START: CLIENT INFORMATION --------------------------------------------------
	IF(@is_pull_client_info=1)
	BEGIN
		SELECT 
			tinv.client_id AS client_Code
			,tinv.first_holder_name AS name
			,tinv.mailing_address AS present_Address
			,tinv.permanent_address As permanent_Address
			,tinv.email_address AS email
			,(
				CASE WHEN tinv.mobile_no IS NOT NULL 
					THEN tinv.mobile_no 
				WHEN tinv.phone_no IS NOT NULL 
					THEN tinv.phone_no 
				ELSE NULL END
			) AS contact_numbers
			,tbrokb.ipo_branch_code AS branch_id
			,tinv.bo_code bo_Code
			,0 AS is_margin
			,ISNULL(tinv.active_status_id,@active_status_id) AS status
			,tcovit.display_value AS client_type
		FROM 
			Investor.tblInvestor tinv
		INNER JOIN
			dbo.tblConstantObjectValue tcovit
				ON tcovit.object_value_id = tinv.ipo_type_id
		INNER JOIN 
			broker.tblBrokerBranch tbrokb
				ON tbrokb.id = tinv.branch_id
		WHERE 
			LEN(ISNULL(tinv.bo_code, 0)) = 16
			AND 
				(
					tinv.changed_user_id > @client_info_sync_date 
					OR @client_info_sync_date IS NULL
				)
	END
	----------------------------------- END: CLIENT INFORMATION --------------------------------------------------

	----------------------------------- START: CLIENT BALANCE --------------------------------------------------
	IF(@is_pull_client_ledger=1)
	BEGIN
		SELECT 
			vifb.client_id
			,vifb.available_balance AS matured_balance
		FROM 
			Investor.tblInvestor tinv
		INNER JOIN 
			Investor.vw_InvestorFundBalance vifb 
				ON vifb.client_id = tinv.client_id
	END
	----------------------------------- END: CLIENT BALANCE --------------------------------------------------
END











USE [Escrow.BOAS]
GO

/****** Object:  Table [Ipo].[tblIpoApplication]    Script Date: 1/3/2016 10:46:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Ipo].[tblIpoApplication](
	[client_Code] [varchar](10) NOT NULL,
	[Date] [datetime] NULL,
	[BS] [varchar](3) NOT NULL,
	[Particulars] [varchar](19) NOT NULL,
	[Debit] [numeric](26, 4) NULL
) ON [IpoManagement]

GO

SET ANSI_PADDING OFF
GO










USE [Escrow.BOAS]
GO

/****** Object:  Table [Ipo].[tblIpoRefund]    Script Date: 1/3/2016 12:29:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Ipo].[tblIpoRefund](
	[client_Code] [varchar](10) NOT NULL,
	[Date] [datetime] NULL,
	[BS] [varchar](3) NOT NULL,
	[Particulars] [varchar](22) NOT NULL,
	[Credit] [numeric](26, 4) NULL
) ON [IpoManagement]

GO

SET ANSI_PADDING OFF
GO





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Ipo].[psp_boas_sync_from_ipo]    Script Date: 1/3/2016 10:48:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 03/01/2015
-- Description:	IPO APPLICATION AND REFUND TRANSACTION TRANSFER TO BACK OFFICE SYSTEM FROM IPO
-- =============================================
CREATE PROCEDURE [Ipo].[psp_boas_sync_from_ipo]
	@is_push_ipo_application as bit,
	@is_push_ipo_refund as bit,
	@membership_id numeric(9,0),
	@changed_user_id nvarchar(128),
	@changed_date datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE
		 @PROCESS_DATE AS NUMERIC(9,0)
		,@active_status_id AS NUMERIC(4,0)
		,@transaction_type_receive AS NUMERIC(4,0)
		,@transaction_type_pay AS NUMERIC(4,0)
		,@application_fee_id AS NUMERIC(4,0)
		,@application_charge_id AS NUMERIC(4,0)
		,@application_refund_id AS NUMERIC(4,0)
		,@application_refund_charge_id AS NUMERIC(4,0)


	SELECT @PROCESS_DATE = dbo.sfun_get_process_date()
	SELECT @active_status_id = dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
	SELECT @transaction_type_receive = dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','Receive')
	SELECT @transaction_type_pay = dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','Pay')
	SELECT @application_fee_id = id FROM Charge.tblGlobalCharge WHERE short_code = 'IAF'
	SELECT @application_charge_id = id FROM Charge.tblGlobalCharge WHERE short_code = 'IAC'
	SELECT @application_refund_id = id FROM Charge.tblGlobalCharge WHERE short_code = 'IRF'
	SELECT @application_refund_charge_id = id FROM Charge.tblGlobalCharge WHERE short_code = 'IRC'

    ----------------------------------- START: IPO APPLICATION --------------------------------------------------
	IF(@is_push_ipo_application=1)
	BEGIN
		INSERT INTO 
			[Transaction].[tblForceChargeApply]
				(
					client_id
					,transaction_date
					,remarks
					,amount
					,charge_id
					,transaction_type_id
					,value_date
					,active_status_id
					,membership_id
					,changed_user_id
					,changed_date
					,is_dirty
				)
			SELECT 
				tia.client_Code
				,@PROCESS_DATE
				,tia.Particulars
				,tia.Debit
				,@application_fee_id
				,@transaction_type_receive
				,ddd.DateKey
				,@active_status_id
				,@membership_id
				,@changed_user_id
				,@changed_date
				,1
			FROM 
				Ipo.tblIpoApplication tia
			INNER JOIN 
				dbo.DimDate ddd
					ON ddd.Date = tia.Date
			LEFT JOIN 
				Investor.tblInvestor tinv 
					ON tinv.client_id = tia.client_Code
			LEFT JOIN 
				dbo.tblConstantObjectValue tcovit
					ON tcovit.object_value_id = tinv.ipo_type_id
			WHERE 
				tia.date IS NOT NULL
				AND tcovit.display_value != 'NRB' 
				AND tcovit.display_value !='FI'
	
		INSERT INTO 
			[Transaction].[tblForceChargeApply]
				(
					client_id
					,transaction_date
					,remarks
					,amount
					,charge_id
					,transaction_type_id
					,value_date
					,active_status_id
					,membership_id
					,changed_user_id
					,changed_date
					,is_dirty
				)
			SELECT 
				tia.client_Code
				,@PROCESS_DATE
				,'Ipo Application Charge'
				,5
				,@application_charge_id
				,@transaction_type_receive
				,ddd.DateKey
				,@active_status_id
				,@membership_id
				,@changed_user_id
				,@changed_date
				,1
			FROM 
				Ipo.tblIpoApplication tia
			INNER JOIN 
				dbo.DimDate ddd
					ON ddd.Date = tia.Date
			WHERE 
				tia.date IS NOT NULL
	END
	----------------------------------- END: IPO APPLICATION --------------------------------------------------

	----------------------------------- START: IPO REFUND --------------------------------------------------
	IF(@is_push_ipo_refund=1)
	BEGIN
		INSERT INTO 
			[Transaction].[tblForceChargeApply]
				(
					client_id
					,transaction_date
					,remarks
					,amount
					,charge_id
					,transaction_type_id
					,value_date
					,active_status_id
					,membership_id
					,changed_user_id
					,changed_date
					,is_dirty
				)
			SELECT 
				tir.client_Code
				,@PROCESS_DATE
				,'Ipo Application Refund'
				,tir.Credit
				,@application_refund_id
				,@transaction_type_pay
				,ddd.DateKey
				,@active_status_id
				,@membership_id
				,@changed_user_id
				,@changed_date
				,1
			FROM 
				Ipo.tblIpoRefund tir
			INNER JOIN 
				dbo.DimDate ddd
					ON ddd.Date = tir.Date
			LEFT JOIN 
				Investor.tblInvestor tinv 
					ON tinv.client_id = tir.client_Code
			LEFT JOIN 
				dbo.tblConstantObjectValue tcovit
					ON tcovit.object_value_id = tinv.ipo_type_id
			WHERE 
				tir.date IS NOT NULL
				AND tcovit.display_value != 'NRB' 
				AND tcovit.display_value !='FI'

		INSERT INTO 
			[Transaction].[tblForceChargeApply]
				(
					client_id
					,transaction_date
					,remarks
					,amount
					,charge_id
					,transaction_type_id
					,value_date
					,active_status_id
					,membership_id
					,changed_user_id
					,changed_date
					,is_dirty
				)
			SELECT 
				tir.client_Code
				,@PROCESS_DATE
				,'Ipo Refund Charge'
				,5
				,@application_refund_charge_id
				,@transaction_type_receive
				,ddd.DateKey
				,@active_status_id
				,@membership_id
				,@changed_user_id
				,@changed_date
				,1
			FROM 
				Ipo.tblIpoRefund tir
			INNER JOIN 
				dbo.DimDate ddd
					ON ddd.Date = tir.Date
			WHERE 
				tir.date IS NOT NULL
	END
	----------------------------------- END: IPO REFUND --------------------------------------------------
END











USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Investor].[psp_investor_share_transaction]    Script Date: 1/4/2016 7:27:23 PM ******/
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
-- EXEC Investor.psp_investor_share_transaction 'BD0641AFL004',242, 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a'

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
	
	BEGIN TRY
	SELECT @PROCESS_DATE=dbo.sfun_get_process_date()
	SELECT @active_status_id=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
	

	CREATE TABLE #trans
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

	IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='IPO'))
	BEGIN
		PRINT 'GET IPO'
		INSERT INTO #trans
			(
			client_id,
			instrument_id,
			received_qty,
			received_cost,
			delivery_qty,
			delivery_cost,
			sale_qty,
			sale_value,
			sale_commission,
			buy_qty,
			buy_cost,
			buy_commission,
			additional_ledger_quantity,
			additional_salable_quantity,
			additional_ipo_receivable_quantity,
			additional_bonus_receivable_quantity,
			additional_lock_quantity,
			additional_pledge_quantity,
			additional_cost_value,
			market_price,
			membership_id
			)
		SELECT 
			TI.client_id, 
			TINS.id instrument_id, 
			CONVERT(NUMERIC,CI.qty)-CONVERT(NUMERIC,CI.lock_qty) received_qty, 
			(CONVERT(NUMERIC,CI.qty)-CONVERT(NUMERIC,CI.lock_qty)  * (CONVERT(NUMERIC,TINS.face_value)+ CONVERT(NUMERIC,ISNULL(TINS.premium,0)) - CONVERT(NUMERIC,ISNULL(TINS.discount,0)))) received_cost,
			0 delivery_qty,
			0 delivery_cost,
			0 sale_qty,
			0 sale_value,
			0 sale_commission,
			0 buy_qty,
			0 buy_cost,
			0 buy_commission,
			CONVERT(NUMERIC,CI.qty)-CONVERT(NUMERIC,CI.lock_qty)  additional_ledger_quantity,
			CONVERT(NUMERIC,CI.qty)-CONVERT(NUMERIC,CI.lock_qty)  additional_salable_quantity,
			0 additional_ipo_receivable_quantity,
			0 additional_bonus_receivable_quantity,
			CONVERT(NUMERIC,CI.qty) additional_lock_quantity,
			0 additional_pledge_quantity,
			((CONVERT(NUMERIC,CI.qty)-CONVERT(NUMERIC,CI.lock_qty))  * (CONVERT(NUMERIC,TINS.face_value)+ CONVERT(NUMERIC,ISNULL(TINS.premium,0)) - CONVERT(NUMERIC,ISNULL(TINS.discount,0)))) additional_cost_value,
			ISNULL(TINS.closed_price,0) market_price,
			TI.membership_id
		FROM 
		    [CDBL].[16DP95UX] CI 
			INNER JOIN Investor.tblInvestor TI ON CI.bo_code=TI.bo_code --AND CI.membership_id=TI.membership_id
			INNER JOIN Instrument.tblInstrument TINS ON CI.isin=TINS.isin
		--WHERE CI.membership_id=@membership_id
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='TRANSMISSION'))
	BEGIN
		PRINT 'GET TRANSMISSION'
		INSERT INTO #trans
			(
			client_id,
			instrument_id,
			received_qty,
			received_cost,
			delivery_qty,
			delivery_cost,
			sale_qty,
			sale_value,
			sale_commission,
			buy_qty,
			buy_cost,
			buy_commission,
			additional_ledger_quantity,
			additional_salable_quantity,
			additional_ipo_receivable_quantity,
			additional_bonus_receivable_quantity,
			additional_lock_quantity,
			additional_pledge_quantity,
			additional_cost_value,
			market_price,
			membership_id
			)
		SELECT 
			TI.client_id, 
			TINS.id instrument_id, 
			CONVERT(NUMERIC,CI.qty) received_qty, 
			(CONVERT(NUMERIC,CI.qty)  *  ISNULL(CI.Rate,0)) received_cost,
			0 delivery_qty,
			0 delivery_cost,
			0 sale_qty,
			0 sale_value,
			0 sale_commission,
			0 buy_qty,
			0 buy_cost,
			0 buy_commission,
			CONVERT(NUMERIC,CI.qty)  additional_ledger_quantity,
			CONVERT(NUMERIC,CI.qty)  additional_salable_quantity,
			0 additional_ipo_receivable_quantity,
			0 additional_bonus_receivable_quantity,
			0 additional_lock_quantity,
			0 additional_pledge_quantity,
			(CONVERT(NUMERIC,CI.qty)  *  ISNULL(CI.Rate,0)) additional_cost_value,
			ISNULL(TINS.closed_price,0) market_price,
			TI.membership_id
		FROM 
		    [CDBL].[11DP81UX] CI 
			INNER JOIN Investor.tblInvestor TI ON CI.transferor_bo_code=TI.bo_code --AND CI.membership_id=TI.membership_id
			INNER JOIN Instrument.tblInstrument TINS ON CI.isin=TINS.isin
		--WHERE CI.membership_id=@membership_id
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='Devidend Receivable'))
	BEGIN
	    PRINT 'GET Devidend Receivable'
		INSERT INTO #trans
			(
			client_id,
			instrument_id,
			received_qty,
			received_cost,
			delivery_qty,
			delivery_cost,
			sale_qty,
			sale_value,
			sale_commission,
			buy_qty,
			buy_cost,
			buy_commission,
			additional_ledger_quantity,
			additional_salable_quantity,
			additional_ipo_receivable_quantity,
			additional_bonus_receivable_quantity,
			additional_lock_quantity,
			additional_pledge_quantity,
			additional_cost_value,
			market_price,
			membership_id
			)
		SELECT 
			TI.client_id, 
			TINS.id instrument_id, 
			CDR.total_entitlement received_qty, 
			0 received_cost,
			0 delivery_qty,
			0 delivery_cost,
			0 sale_qty,
			0 sale_value,
			0 sale_commission,
			0 buy_qty,
			0 buy_cost,
			0 buy_commission,
			CDR.total_entitlement additional_ledger_quantity,
			0 additional_salable_quantity,
			0 additional_ipo_receivable_quantity,
			CDR.total_entitlement additional_bonus_receivable_quantity,
			0 additional_lock_quantity,
			0 additional_pledge_quantity,
			0 additional_cost_value,
			ISNULL(TINS.closed_price,0) market_price,
			TI.membership_id
		FROM 
			[CDBL].[17DP64UX] CDR 
			INNER JOIN Investor.tblInvestor TI ON CDR.bo_code=TI.bo_code --AND CDR.membership_id=TI.membership_id
			INNER JOIN Instrument.tblInstrument TINS ON CDR.isin=TINS.isin 
		--WHERE 
		--CDR.membership_id=@membership_id and
		
		
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='BONUS/RIGHTS'))
	BEGIN
		PRINT 'BONUS/RIGHTS'
		INSERT INTO #trans
			(
			client_id,
			instrument_id,
			received_qty,
			received_cost,
			delivery_qty,
			delivery_cost,
			sale_qty,
			sale_value,
			sale_commission,
			buy_qty,
			buy_cost,
			buy_commission,
			additional_ledger_quantity,
			additional_salable_quantity,
			additional_ipo_receivable_quantity,
			additional_bonus_receivable_quantity,
			additional_lock_quantity,
			additional_pledge_quantity,
			additional_cost_value,
			market_price,
			membership_id
			)
		SELECT 
			TI.client_id, 
			TINS.id instrument_id
			,CASE WHEN CBR.share_transaction_type='RIGHTS' THEN CONVERT(NUMERIC,CBR.qty) ELSE 0 END received_qty
			,CASE WHEN CBR.share_transaction_type='RIGHTS' THEN CONVERT(NUMERIC,CBR.qty) * CONVERT(NUMERIC,ISNULL(CBR.rate,0)) ELSE 0 END received_cost
			,0 delivery_qty,
			0 delivery_cost,
			0 sale_qty,
			0 sale_value,
			0 sale_commission,
			0 buy_qty,
			0 buy_cost,
			0 buy_commission
			,CASE WHEN CBR.share_transaction_type='RIGHTS' THEN CONVERT(NUMERIC,CBR.qty) ELSE 0 END additional_ledger_quantity
			,CONVERT(NUMERIC,CBR.qty) additional_salable_quantity
			,0 additional_ipo_receivable_quantity
			,CASE WHEN CBR.share_transaction_type='BONUS' THEN CONVERT(NUMERIC,CBR.qty) * -1 ELSE 0 END additional_bonus_receivable_quantity
			,0 additional_lock_quantity
			,0 additional_pledge_quantity
			,CASE WHEN CBR.share_transaction_type='RIGHTS' THEN CONVERT(NUMERIC,CBR.qty) * CONVERT(NUMERIC,ISNULL(CBR.rate,0)) ELSE 0 END additional_cost_value
			,ISNULL(TINS.closed_price,0) market_price
			,TI.membership_id
		FROM 
			[CDBL].[17DP70UX] CBR 
			INNER JOIN Investor.tblInvestor TI ON CBR.bo_code=TI.bo_code --AND CBR.membership_id=TI.membership_id
			INNER JOIN Instrument.tblInstrument TINS ON CBR.isin=TINS.isin 
		--WHERE CBR.membership_id=@membership_id and CBR.is_dirty=1
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='BUY/SALE'))
	BEGIN
		INSERT INTO #trans(client_id,instrument_id,received_qty,received_cost,delivery_qty,delivery_cost,sale_qty,sale_value,sale_commission,buy_qty,buy_cost,buy_commission
			,additional_ledger_quantity,additional_salable_quantity,additional_ipo_receivable_quantity,additional_bonus_receivable_quantity,additional_lock_quantity,additional_pledge_quantity
			,additional_cost_value,market_price,membership_id)
		SELECT TTD.client_id
			,TTD.instrument_id
			,0 received_qty
			,0 received_cost
			,0 delivery_qty
			,0 delivery_cost
			,SUM(CASE WHEN TTD.transaction_type='S' THEN TTD.Quantity ELSE 0 END) sale_qty
			,SUM(CASE WHEN TTD.transaction_type='S' THEN TTD.Quantity*TTD.Unit_Price ELSE 0 END) sale_value
			,SUM(CASE WHEN TTD.transaction_type='S' THEN TTD.commission_amount ELSE 0 END) sale_commission
			,SUM(CASE WHEN TTD.transaction_type='B' THEN TTD.Quantity ELSE 0 END) buy_qty
			,SUM(CASE WHEN TTD.transaction_type='B' THEN TTD.Quantity*TTD.Unit_Price ELSE 0 END) buy_cost
			,SUM(CASE WHEN TTD.transaction_type='B' THEN TTD.commission_amount ELSE 0 END) buy_commission
			,SUM(CASE WHEN TTD.transaction_type='B' THEN TTD.Quantity ELSE TTD.Quantity*-1 END) additional_ledger_quantity
			,SUM(CASE WHEN TTD.transaction_type='S' THEN TTD.Quantity*-1 ELSE 0 END) additional_salable_quantity
			,0 additional_ipo_receivable_quantity
			,0 additional_bonus_receivable_quantity
			,0 additional_lock_quantity
			,0 additional_pledge_quantity
			,SUM(CASE WHEN TTD.transaction_type='B' THEN (TTD.Quantity*TTD.Unit_Price)+TTD.commission_amount ELSE ((TTD.Quantity*TTD.Unit_Price)-TTD.commission_amount)*-1 END) additional_cost_value
			,ISNULL(TINS.closed_price,0) market_price
			,TTD.membership_id
		FROM DBO.udfSpliter(@ID) INS --- TRANSACTION DATE = @ID
			INNER JOIN Trade.tblTradeData TTD ON INS.id=TTD.Date
			INNER JOIN Instrument.tblInstrument TINS ON TTD.instrument_id=TINS.id 
		WHERE TTD.membership_id=@membership_id
		GROUP BY TTD.client_id, TTD.instrument_id,TINS.closed_price,TTD.membership_id
	END
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='Reverse BUY/SALE'))
	BEGIN
		INSERT INTO #trans
		(
		client_id
		,instrument_id
		,received_qty
		,received_cost
		,delivery_qty
		,delivery_cost
		,sale_qty
		,sale_value
		,sale_commission
		,buy_qty
		,buy_cost
		,buy_commission
		,additional_ledger_quantity
		,additional_salable_quantity
		,additional_ipo_receivable_quantity
		,additional_bonus_receivable_quantity
		,additional_lock_quantity
		,additional_pledge_quantity
		,additional_cost_value
		,market_price
		,membership_id
		)
		SELECT 
			TTD.client_id
			,TTD.instrument_id
			,0 received_qty
			,0 received_cost
			,0 delivery_qty
			,0 delivery_cost
			,SUM(CASE WHEN TTD.transaction_type='S' THEN TTD.Quantity ELSE 0 END)*-1 sale_qty
			,SUM(CASE WHEN TTD.transaction_type='S' THEN TTD.Quantity*TTD.Unit_Price ELSE 0 END)*-1 sale_value
			,SUM(CASE WHEN TTD.transaction_type='S' THEN TTD.commission_amount ELSE 0 END)*-1 sale_commission
			,SUM(CASE WHEN TTD.transaction_type='B' THEN TTD.Quantity ELSE 0 END)*-1 buy_qty
			,SUM(CASE WHEN TTD.transaction_type='B' THEN TTD.Quantity*TTD.Unit_Price ELSE 0 END)*-1 buy_cost
			,SUM(CASE WHEN TTD.transaction_type='B' THEN TTD.commission_amount ELSE 0 END)*-1 buy_commission
			,SUM(CASE WHEN TTD.transaction_type='B' THEN TTD.Quantity*-1  ELSE TTD.Quantity END)additional_ledger_quantity
			,SUM(CASE WHEN TTD.transaction_type='S' THEN TTD.Quantity ELSE 0 END) additional_salable_quantity
			,0 additional_ipo_receivable_quantity
			,0 additional_bonus_receivable_quantity
			,0 additional_lock_quantity
			,0 additional_pledge_quantity
			,SUM(CASE WHEN TTD.transaction_type='B' THEN (TTD.Quantity*TTD.Unit_Price)+TTD.commission_amount ELSE 0 END)*-1 additional_cost_value
			,ISNULL(TINS.closed_price,0) market_price,TTD.membership_id
		FROM 
			DBO.udfSpliter(@ID) INS --- TRANSACTION DATE = @ID
			INNER JOIN Trade.tblTradeData TTD ON INS.id=TTD.Date
			INNER JOIN Instrument.tblInstrument TINS ON TTD.instrument_id=TINS.id 
		WHERE 
			TTD.membership_id=@membership_id
		GROUP BY 
			TTD.client_id, TTD.instrument_id,TINS.closed_price,TTD.membership_id
	END
	--FOR SHARE MATURITY
	ELSE IF EXISTS(SELECT 1 FROM DBO.tblConstantObjectValue WHERE (object_value_id = @SHARE_LEDGER_TYPE_ID) AND (display_value='Share Settlement'))
	BEGIN
		INSERT INTO #trans
		(
		client_id
		,instrument_id
		,received_qty
		,received_cost
		,delivery_qty
		,delivery_cost
		,sale_qty
		,sale_value
		,sale_commission
		,buy_qty
		,buy_cost
		,buy_commission
		,additional_ledger_quantity
		,additional_salable_quantity
		,additional_ipo_receivable_quantity
		,additional_bonus_receivable_quantity
		,additional_lock_quantity
		,additional_pledge_quantity
		,additional_cost_value
		,market_price
		,membership_id
		)
		SELECT 
		TTD.client_id
		,TTD.instrument_id
		,0 received_qty
		,0 received_cost
		,0 delivery_qty
		,0 delivery_cost
		,0 sale_qty
		,0 sale_value
		,0 sale_commission
		,0 buy_qty
		,0 buy_cost
		,0 buy_commission
		,0 additional_ledger_quantity
		,SUM(TTD.Quantity) additional_salable_quantity
		,0 additional_ipo_receivable_quantity
		,0 additional_bonus_receivable_quantity
		,0 additional_lock_quantity
		,0 additional_pledge_quantity
		,0 additional_cost_value
		,0 market_price
		,TTD.membership_id
		FROM 
		DBO.udfSpliter(@ID) INS --- SETTLEMENT DATE = @ID
		INNER JOIN [Trade].[vw_today_maturity] TTD ON INS.id=TTD.settle_date AND TTD.transaction_type = 'B'
		WHERE 
		TTD.membership_id=@membership_id
		GROUP BY TTD.membership_id,TTD.client_id,TTD.instrument_id
	END
	




	print 'Insert INTO tblInvestorShareLedger'
	insert into 
		Investor.tblInvestorShareLedger
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
		TRN.client_id,
		TRN.instrument_id,
		@PROCESS_DATE transaction_date,
		0 opening_qty,
		0 opening_rate,
		0 opening_cost,
		0 received_qty,
		0 received_rate,
		0 received_cost,
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
		0 remaining_qty,
		0 remaining_rate,
		0 remaining_cost,
		0 buy_qty,
		0 buy_cost,
		0 buy_commission,
		0 buy_rate,
		0 buy_amount,
		0 closing_qty,
		0 closing_rate,
		0 closing_cost, 
		TI.active_status_id, 
		@membership_id membership_id,
		@changed_user_id changed_user_id, 
		GETDATE() changed_date, 
		1 is_dirty
	FROM 
		#trans TRN
	INNER JOIN 
		Investor.tblInvestor TI 
		ON TI.client_id=TRN.client_id 
		AND TI.membership_id=TRN.membership_id
	INNER JOIN 
		Instrument.tblInstrument TINS 
		ON TRN.instrument_id=TINS.id 
		AND TRN.membership_id=TINS.membership_id
	LEFT JOIN 
		Investor.tblInvestorShareLedger ISL 
		ON TRN.client_id=ISL.client_id 
		AND TRN.instrument_id=ISL.instrument_id 
		AND TRN.membership_id=ISL.membership_id
	WHERE 
		ISL.client_id IS NULL
		AND (TRN.received_qty!=0 OR TRN.delivery_cost!=0 OR TRN.sale_qty!=0 OR TRN.buy_qty!=0)


	print 'Investor.tblInvestorShareLedger'
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
		TRN.client_id,
		TRN.instrument_id,
		@PROCESS_DATE transaction_date,
		ISL.closing_qty opening_qty,
		ISL.closing_rate opening_rate,
		ISL.closing_cost opening_cost,
		0 received_qty,
		0 received_rate,
		0 received_cost,
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
		0 remaining_qty,
		0 remaining_rate,
		0 remaining_cost,
		0 buy_qty,
		0 buy_cost,
		0 buy_commission,
		0 buy_rate,
		0 buy_amount,
		ISL.closing_qty,
		ISL.closing_rate,
		ISL.closing_cost, 
		TI.active_status_id, 
		@membership_id membership_id, 
		@changed_user_id changed_user_id, 
		GETDATE() changed_date, 
		1 is_dirty
	FROM 
		#trans TRN
	INNER JOIN 
		Investor.tblInvestor TI 
		ON TI.client_id=TRN.client_id 
		AND TI.membership_id=TRN.membership_id
	INNER JOIN 
		Instrument.tblInstrument TINS 
		ON TRN.instrument_id=TINS.id 
    INNER JOIN 
		Investor.tblInvestorShareLedger ISL
		ON  ISL.client_id=TI.client_id 
		AND ISL.instrument_id=TINS.ID 
		AND ISL.membership_id=TI.membership_id
		AND ISL.transaction_date
		= (
			SELECT MAX(TIS2.transaction_date) 
				FROM Investor.tblInvestorShareLedger TIS2 
			WHERE 
				TIS2.client_id=ISL.client_id AND 
				TIS2.instrument_id= ISL.instrument_id AND 
				TIS2.membership_id=ISL.membership_id AND 
				TIS2.transaction_date< @PROCESS_DATE
		  )
	--INNER JOIN (
	--			SELECT 
	--				TIS.* 
	--			FROM 
	--				Investor.tblInvestorShareLedger TIS
	--			LEFT JOIN (
	--						SELECT 
	--							* 
	--						FROM 
	--							Investor.tblInvestorShareLedger 
	--						WHERE 
	--							transaction_date=@PROCESS_DATE
	--					   ) TIST
	--					   ON TIS.client_id=TIST.client_id 
	--					   AND TIS.instrument_id=TIST.instrument_id 
	--					   AND TIS.transaction_date=TIST.transaction_date 
	--					   AND TIS.membership_id=TIST.membership_id
	--			WHERE 
	--				TIST.ID IS NULL and TIS.transaction_date=@PROCESS_DATE
	--			) ISL 
	--			ON TRN.client_id=ISL.client_id 
	--			AND TRN.instrument_id=ISL.instrument_id 
	--			AND TRN.membership_id=ISL.membership_id
	WHERE 
		 (TRN.received_qty!=0 OR TRN.delivery_cost!=0 OR TRN.sale_qty!=0 OR TRN.buy_qty!=0)


	print 'update Investor.tblInvestorShareLedger'
	UPDATE ISL
	SET
		 ISL.received_qty=ISL.received_qty + TRN.received_qty
		,ISL.received_rate=CASE WHEN (ISL.received_qty + TRN.received_qty)!=0 --QUANTITY MUST NOT ZERO
							THEN (ISL.received_cost + TRN.received_cost)/(ISL.received_qty + TRN.received_qty) --COST/QUANTITY=RATE
							ELSE 0 END
		,ISL.received_cost=ISL.received_cost + TRN.received_cost
		,ISL.delivery_qty=ISL.delivery_qty + TRN.delivery_qty
		,ISL.delivery_rate=CASE WHEN (ISL.delivery_qty + TRN.delivery_qty)!=0 --QUANTITY MUST NOT ZERO
							THEN (ISL.delivery_cost + TRN.delivery_cost)/(ISL.delivery_qty + TRN.delivery_qty) --COST/QUANTITY=RATE
							ELSE 0 END
		,ISL.delivery_cost=ISL.delivery_cost + TRN.delivery_cost
		,ISL.sale_qty=ISL.sale_qty+TRN.sale_qty
		,ISL.sale_value=ISL.sale_value+TRN.sale_value
		,ISL.sale_commission=ISL.sale_commission+TRN.sale_commission
		,ISL.sale_rate=CASE WHEN (ISL.sale_qty+TRN.sale_qty)!=0 --QUANTITY MUST NOT ZERO
							THEN ((ISL.sale_value+TRN.sale_value)+(ISL.sale_commission+TRN.sale_commission))/(ISL.sale_qty+TRN.sale_qty) --(VALUE+COMMISION)/QUANTITY=RATE
							ELSE 0 END
		,ISL.sale_amount=(ISL.sale_value+TRN.sale_value)+(ISL.sale_commission+TRN.sale_commission) --(VALUE+COMMISION)=SALE AMOUNT

		-- SALE COST RATE = BEFORE SALE COST / BEFORE SALE QTY
		,ISL.sale_cost_rate=CASE WHEN (ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty))!=0 AND (ISL.sale_qty+TRN.sale_qty)!=0 -- BEFORE SALE QTY AND SALE QTY MUST NOT ZERO
							THEN (ISL.opening_cost+(ISL.received_cost + TRN.received_cost)-(ISL.delivery_cost + TRN.delivery_cost)) -- BEFORE SALE COST
								/ (ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)) -- BEFORE SALE QTY
							ELSE 0 END

		-- SALE COST = SALE QTY * SALE COST RATE
		,ISL.sale_cost=(ISL.sale_qty+TRN.sale_qty) -- SALE QTY
						*(CASE WHEN (ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty))!=0 AND (ISL.sale_qty+TRN.sale_qty)!=0 -- BEFORE SALE QTY AND SALE QTY MUST NOT ZERO
							THEN (ISL.opening_cost+(ISL.received_cost + TRN.received_cost)-(ISL.delivery_cost + TRN.delivery_cost)) -- BEFORE SALE COST
								/(ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)) -- BEFORE SALE QTY
							ELSE 0 END)
		
		-- GAIN/LOSS = SALE AMOUNT - SALE COST
		,ISL.gain_loss=(ISL.sale_value+TRN.sale_value)+(ISL.sale_commission+TRN.sale_commission) -- SALE AMOUNT (VALUE+COMMISION)
						- ((ISL.sale_qty+TRN.sale_qty) -- SALE QTY
							*(CASE WHEN (ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty))!=0 AND (ISL.sale_qty+TRN.sale_qty)!=0 -- BEFORE SALE QTY AND SALE QTY MUST NOT ZERO
								THEN (ISL.opening_cost+(ISL.received_cost + TRN.received_cost)-(ISL.delivery_cost + TRN.delivery_cost)) -- BEFORE SALE COST
									/(ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)) -- BEFORE SALE QTY
								ELSE 0 END))

		
		,ISL.remaining_qty=(ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)-(ISL.sale_qty+TRN.sale_qty)) -- OPENING + RECEIVE -DELIVERY - SALE QUANTITY = REMAINING QTY

		-- REMAINING RATE = BEFORE SALE COST / BEFORE SALE QTY
		,ISL.remaining_rate=CASE WHEN (ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty))!=0  -- BEFORE SALE QTY MUST NOT ZERO
								THEN (ISL.opening_cost+(ISL.received_cost + TRN.received_cost)-(ISL.delivery_cost + TRN.delivery_cost)) -- BEFORE SALE COST
									/(ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)) -- BEFORE SALE QTY
								ELSE 0 END
		
		-- REMAINING COST = (REMAINING QTY - SALE QTY) * REMAINING RATE
		,ISL.remaining_cost=(ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)-(ISL.sale_qty+TRN.sale_qty)) -- (REMAINING QTY - SALE QTY)
								*(CASE WHEN (ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty))!=0 -- BEFORE SALE QTY MUST NOT ZERO
									THEN (ISL.opening_cost+(ISL.received_cost + TRN.received_cost)-(ISL.delivery_cost + TRN.delivery_cost)) -- BEFORE SALE COST
										/(ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)) -- BEFORE SALE QTY
									ELSE 0 END)
		,ISL.buy_qty=ISL.buy_qty+TRN.buy_qty
		,ISL.buy_cost=ISL.buy_cost+TRN.buy_cost
		,ISL.buy_commission=ISL.buy_commission+TRN.buy_commission
		,ISL.buy_rate=CASE WHEN (ISL.buy_qty+TRN.buy_qty)!=0 THEN (ISL.buy_cost+TRN.buy_cost+ISL.buy_commission+TRN.buy_commission)/(ISL.buy_qty+TRN.buy_qty) ELSE 0 END -- (COST + COMMISSION)/QTY OF BUY = BUY RATE
		,ISL.buy_amount=(ISL.buy_cost+TRN.buy_cost+ISL.buy_commission+TRN.buy_commission) -- (COST + COMMISSION)
		,ISL.closing_qty=(ISL.opening_qty+(ISL.received_qty + TRN.received_qty)+(ISL.buy_qty+TRN.buy_qty)-(ISL.delivery_qty + TRN.delivery_qty)-(ISL.sale_qty+TRN.sale_qty)) -- CLOSING QTY = OPENING + RECEIVE + BUY - DELIVERY - SALE QTY
		
		-- CLOSING COST = BUY COST + REMAINING COST
		,ISL.closing_cost=CASE WHEN (ISL.opening_qty+(ISL.received_qty + TRN.received_qty)+(ISL.buy_qty+TRN.buy_qty)-(ISL.delivery_qty + TRN.delivery_qty)-(ISL.sale_qty+TRN.sale_qty))!=0 -- CLOSING QTY MUST NOT ZERO
							THEN (ISL.buy_cost+TRN.buy_cost+ISL.buy_commission+TRN.buy_commission) -- BUY COST
								+((ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)-(ISL.sale_qty+TRN.sale_qty)) -- (REMAINING QTY - SALE QTY)
									*(CASE WHEN (ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty))!=0 -- BEFORE SALE QTY MUST NOT ZERO
										THEN (ISL.opening_cost+(ISL.received_cost + TRN.received_cost)-(ISL.delivery_cost + TRN.delivery_cost)) -- BEFORE SALE COST
											/(ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)) -- BEFORE SALE QTY
										ELSE 0 END)) 
							ELSE 0 END

		-- CLOSING RATE = CLOSING COST / CLOSING QTY
		,ISL.closing_rate=CASE WHEN (ISL.opening_qty+(ISL.received_qty + TRN.received_qty)+(ISL.buy_qty+TRN.buy_qty)-(ISL.delivery_qty + TRN.delivery_qty)-(ISL.sale_qty+TRN.sale_qty))!=0 -- CLOSING QTY MUST NOT ZERO
							THEN ((ISL.buy_cost+TRN.buy_cost+ISL.buy_commission+TRN.buy_commission)+((ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)-(ISL.sale_qty+TRN.sale_qty)) -- (REMAINING QTY - SALE QTY)
								*(CASE WHEN (ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty))!=0 -- BEFORE SALE QTY MUST NOT ZERO
									THEN (ISL.opening_cost+(ISL.received_cost + TRN.received_cost)-(ISL.delivery_cost + TRN.delivery_cost)) -- BEFORE SALE COST
										/(ISL.opening_qty+(ISL.received_qty + TRN.received_qty)-(ISL.delivery_qty + TRN.delivery_qty)) -- BEFORE SALE QTY
									ELSE 0 END))
								/(ISL.opening_qty+(ISL.received_qty + TRN.received_qty)+(ISL.buy_qty+TRN.buy_qty)-(ISL.delivery_qty + TRN.delivery_qty)-(ISL.sale_qty+TRN.sale_qty))) -- CLOSING QTY
							ELSE 0 END
	FROM #trans TRN
		INNER JOIN Investor.tblInvestor TI ON TI.client_id=TRN.client_id AND TI.membership_id=TRN.membership_id
		INNER JOIN Instrument.tblInstrument TINS ON TRN.instrument_id=TINS.id 
		INNER JOIN Investor.tblInvestorShareLedger ISL ON TRN.client_id=ISL.client_id AND TRN.instrument_id=ISL.instrument_id AND TRN.membership_id=ISL.membership_id
	WHERE ISL.transaction_date=@PROCESS_DATE
		AND (TRN.received_qty!=0 OR TRN.delivery_cost!=0 OR TRN.sale_qty!=0 OR TRN.buy_qty!=0)

	print '1 Investor.tblInvestorShareBalance'

	insert into Investor.tblInvestorShareBalance(transaction_date,client_id,instrument_id,ledger_quantity,salable_quantity,ipo_receivable_quantity,bonus_receivable_quantity,lock_quantity
		,pledge_quantity,cost_average,cost_value,market_price,market_value,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
	SELECT @PROCESS_DATE,TRN.client_id,TRN.instrument_id,0 ledger_quantity,0 salable_quantity,0 ipo_receivable_quantity,0 bonus_receivable_quantity,0 lock_quantity
		,0 pledge_quantity,0 cost_average,0 cost_value,ISNULL(TINS.closed_price,0) market_price,0 market_value, TI.active_status_id, @membership_id membership_id, @changed_user_id changed_user_id, GETDATE() changed_date, 1 is_dirty
	FROM #trans TRN
		INNER JOIN Investor.tblInvestor TI ON TI.client_id=TRN.client_id AND TI.membership_id=TRN.membership_id
		INNER JOIN Instrument.tblInstrument TINS ON TRN.instrument_id=TINS.id 
		LEFT JOIN Investor.tblInvestorShareBalance ISB ON TRN.client_id=ISB.client_id AND TRN.instrument_id=ISB.instrument_id AND TRN.membership_id=ISB.membership_id
	WHERE ISB.client_id IS NULL


	print '2 Investor.tblInvestorShareBalance'

	insert into Investor.tblInvestorShareBalance
		(
		transaction_date,
		client_id,
		instrument_id,
		ledger_quantity,
		salable_quantity,
		ipo_receivable_quantity,
		bonus_receivable_quantity,
		lock_quantity,
		pledge_quantity,
		cost_average,
		cost_value,
		market_price,
		market_value,
		active_status_id,
		membership_id,
		changed_user_id,
		changed_date,
		is_dirty
		)
	SELECT 
		@PROCESS_DATE,
		TRN.client_id,
		TRN.instrument_id,
		ISB.ledger_quantity,
		ISB.salable_quantity,
		ISB.ipo_receivable_quantity,
		ISB.bonus_receivable_quantity,
		ISB.lock_quantity,
		ISB.pledge_quantity,
		ISB.cost_average,
		ISB.cost_value,
		ISNULL(ISB.market_price,0),
		ISB.market_value, 
		TI.active_status_id, 
		@membership_id membership_id, 
		@changed_user_id changed_user_id, 
		GETDATE() changed_date, 
		1 is_dirty
	FROM #trans TRN
	INNER JOIN 
		Investor.tblInvestor TI 
		ON TI.client_id=TRN.client_id 
		AND TI.membership_id=TRN.membership_id
	INNER JOIN 
		Instrument.tblInstrument TINS 
		ON TRN.instrument_id=TINS.id
	INNER JOIN 
		[Investor].[vw_InvestorShareBalance] ISB
		ON TRN.client_id=ISB.client_id 
		AND TRN.instrument_id=ISB.instrument_id 
		AND TRN.membership_id=ISB.membership_id
		AND ISB.transaction_date < @PROCESS_DATE
	

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
	FROM #trans TRN
		INNER JOIN Investor.tblInvestor TI ON TI.client_id=TRN.client_id --AND TI.membership_id=TRN.membership_id
		INNER JOIN Instrument.tblInstrument TINS ON TRN.instrument_id=TINS.id 
		INNER JOIN Investor.tblInvestorShareBalance ISB ON TRN.client_id=ISB.client_id AND TRN.instrument_id=ISB.instrument_id --AND TRN.membership_id=ISB.membership_id
	WHERE ISB.transaction_date=@PROCESS_DATE
	
	print 'end: update Investor.tblInvestorShareBalance'


	DROP TABLE #trans



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
	
	END TRY
	BEGIN CATCH
		SET @ERROR_MESSAGE=ERROR_MESSAGE()
		RAISERROR(@ERROR_MESSAGE,16,1)
	END CATCH
	
END





