USE [Escrow.BOAS]
GO
/****** Object:  UserDefinedFunction [dbo].[sfun_amount_to_word]    Script Date: 12/22/2015 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 21-DEC-2015
-- Description:	Amount to word convertion

-- SELECT dbo.sfun_amount_to_word(5501)
-- =============================================

CREATE FUNCTION [dbo].[sfun_amount_to_word] (

	@Number Numeric (38, 0) -- Input number with as many as 18 digits

) RETURNS VARCHAR(8000) 

AS BEGIN

DECLARE @inputNumber VARCHAR(38)
DECLARE @NumbersTable TABLE (number CHAR(2), word VARCHAR(10))
DECLARE @outputString VARCHAR(8000)
DECLARE @length INT
DECLARE @counter INT
DECLARE @loops INT
DECLARE @position INT
DECLARE @chunk CHAR(3) -- for chunks of 3 numbers
DECLARE @tensones CHAR(2)
DECLARE @hundreds CHAR(1)
DECLARE @tens CHAR(1)
DECLARE @ones CHAR(1)

IF @Number = 0 Return 'Zero'

-- initialize the variables
SELECT @inputNumber = CONVERT(varchar(38), @Number)
     , @outputString = ''
     , @counter = 1
SELECT @length   = LEN(@inputNumber)
     , @position = LEN(@inputNumber) - 2
     , @loops    = LEN(@inputNumber)/3

-- make sure there is an extra loop added for the remaining numbers
IF LEN(@inputNumber) % 3 <> 0 SET @loops = @loops + 1

-- insert data for the numbers and words
INSERT INTO @NumbersTable   SELECT '00', ''
    UNION ALL SELECT '01', 'one'      UNION ALL SELECT '02', 'two'
    UNION ALL SELECT '03', 'three'    UNION ALL SELECT '04', 'four'
    UNION ALL SELECT '05', 'five'     UNION ALL SELECT '06', 'six'
    UNION ALL SELECT '07', 'seven'    UNION ALL SELECT '08', 'eight'
    UNION ALL SELECT '09', 'nine'     UNION ALL SELECT '10', 'ten'
    UNION ALL SELECT '11', 'eleven'   UNION ALL SELECT '12', 'twelve'
    UNION ALL SELECT '13', 'thirteen' UNION ALL SELECT '14', 'fourteen'
    UNION ALL SELECT '15', 'fifteen'  UNION ALL SELECT '16', 'sixteen'
    UNION ALL SELECT '17', 'seventeen' UNION ALL SELECT '18', 'eighteen'
    UNION ALL SELECT '19', 'nineteen' UNION ALL SELECT '20', 'twenty'
    UNION ALL SELECT '30', 'thirty'   UNION ALL SELECT '40', 'forty'
    UNION ALL SELECT '50', 'fifty'    UNION ALL SELECT '60', 'sixty'
    UNION ALL SELECT '70', 'seventy'  UNION ALL SELECT '80', 'eighty'
    UNION ALL SELECT '90', 'ninety'   

WHILE @counter <= @loops BEGIN

	-- get chunks of 3 numbers at a time, padded with leading zeros
	SET @chunk = RIGHT('000' + SUBSTRING(@inputNumber, @position, 3), 3)

	IF @chunk <> '000' BEGIN
		SELECT @tensones = SUBSTRING(@chunk, 2, 2)
		     , @hundreds = SUBSTRING(@chunk, 1, 1)
		     , @tens = SUBSTRING(@chunk, 2, 1)
		     , @ones = SUBSTRING(@chunk, 3, 1)

		-- If twenty or less, use the word directly from @NumbersTable
		IF CONVERT(INT, @tensones) <= 20 OR @Ones='0' BEGIN
			SET @outputString = (SELECT word 
                                      FROM @NumbersTable 
                                      WHERE @tensones = number)
                   + CASE @counter WHEN 1 THEN '' -- No name
                       WHEN 2 THEN ' thousand ' WHEN 3 THEN ' million '
                       WHEN 4 THEN ' billion '  WHEN 5 THEN ' trillion '
                       WHEN 6 THEN ' quadrillion ' WHEN 7 THEN ' quintillion '
                       WHEN 8 THEN ' sextillion '  WHEN 9 THEN ' septillion '
                       WHEN 10 THEN ' octillion '  WHEN 11 THEN ' nonillion '
                       WHEN 12 THEN ' decillion '  WHEN 13 THEN ' undecillion '
                       ELSE '' END
                               + @outputString
		    END
		 ELSE BEGIN -- break down the ones and the tens separately

             SET @outputString = ' ' 
                            + (SELECT word 
                                    FROM @NumbersTable 
                                    WHERE @tens + '0' = number)
					         + '-'
                             + (SELECT word 
                                    FROM @NumbersTable 
                                    WHERE '0'+ @ones = number)
                   + CASE @counter WHEN 1 THEN '' -- No name
                       WHEN 2 THEN ' thousand ' WHEN 3 THEN ' million '
                       WHEN 4 THEN ' billion '  WHEN 5 THEN ' trillion '
                       WHEN 6 THEN ' quadrillion ' WHEN 7 THEN ' quintillion '
                       WHEN 8 THEN ' sextillion '  WHEN 9 THEN ' septillion '
                       WHEN 10 THEN ' octillion '  WHEN 11 THEN ' nonillion '
                       WHEN 12 THEN ' decillion '   WHEN 13 THEN ' undecillion '
                       ELSE '' END
                            + @outputString
		END

		-- now get the hundreds
		IF @hundreds <> '0' BEGIN
			SET @outputString  = (SELECT word 
                                      FROM @NumbersTable 
                                      WHERE '0' + @hundreds = number)
					            + ' hundred ' 
                                + @outputString
		END
	END

	SELECT @counter = @counter + 1
	     , @position = @position - 3

END

-- Remove any double spaces
SET @outputString = LTRIM(RTRIM(REPLACE(@outputString, '  ', ' ')))
--SET @outputstring = UPPER(LEFT(@outputstring, 1)) + SUBSTRING(@outputstring, 2, 8000)


RETURN @outputString -- return the result
END






USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Transaction].[rsp_money_receipt]    Script Date: 12/22/2015 1:45:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec [Transaction].rsp_money_receipt 62, '2015121600001'
-- =============================================
-- Author:		Asif
-- Create date: 21/12/15
-- Description:	Money Receipt report
-- =============================================

CREATE PROCEDURE [Transaction].[rsp_money_receipt]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@voucher_no varchar(15)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
	SELECT
		tbrok.name AS broker_branch
		,tfr.voucher_no
		,tinv.bo_code
		,ddrd.DayOfMonth + ' ' + ddrd.MonthName + ',' + ' ' + ddrd.Year AS receive_date
		,tfr.client_id
		,tinv.first_holder_name
		,tfr.remarks
		,tfr.amount
		,UPPER(dbo.sfun_amount_to_word(tfr.amount)) + ' TAKA ONLY' AS amount_in_word
	FROM [Transaction].[tblFundReceive] tfr
		INNER JOIN [broker].[tblBrokerBranch] tbrok
			ON tbrok.id = tfr.broker_branch_id
		INNER JOIN [dbo].[DimDate] ddrd
			ON ddrd.DateKey = tfr.receive_date
		INNER JOIN [Investor].[tblInvestor] tinv
			ON tinv.client_id = tfr.client_id
	WHERE tfr.membership_id = @membership_id
		AND tfr.voucher_no = @voucher_no
	 
END




USE [Escrow.BOAS]
GO

/****** Object:  Table [CDBL].[tblCdblDividendReceivable]    Script Date: 12/22/2015 6:48:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [CDBL].[tblCdblDividendReceivable](
	[dividend_receivable_id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[isin] [varchar](12) NULL,
	[company_name] [varchar](150) NULL,
	[seq_no] [numeric](10, 0) NULL,
	[trans_ref] [varchar](50) NULL,
	[record_dt] [varchar](50) NULL,
	[effective_dt] [varchar](50) NULL,
	[cash_fraction_amt] [numeric](5, 2) NULL,
	[cash_payment_dt] [varchar](50) NULL,
	[remarks] [varchar](150) NULL,
	[benifit_isin] [varchar](12) NULL,
	[benifit_company_name] [varchar](150) NULL,
	[par_ratio] [numeric](5, 2) NULL,
	[ben_ratio] [numeric](5, 5) NULL,
	[bo_code] [varchar](16) NULL,
	[bo_name] [varchar](150) NULL,
	[bo_holding] [numeric](10, 3) NULL,
	[total_entitlement] [numeric](10, 3) NULL,
	[dr_cr_flag] [varchar](50) NULL,
	[transaction_date] [varchar](50) NULL,
	[active_status_id] [int] NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblCdblDividendReceivable_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblCdblDividendReceivable] PRIMARY KEY CLUSTERED 
(
	[dividend_receivable_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO





insert into [CDBL].[tblCdblDividendReceivable] 
([isin]
      ,[company_name]
      ,[seq_no]
      ,[trans_ref]
      ,[record_dt]
      ,[effective_dt]
      ,[cash_fraction_amt]
      ,[cash_payment_dt]
      ,[remarks]
      ,[benifit_isin]
      ,[benifit_company_name]
      ,[par_ratio]
      ,[ben_ratio]
      ,[bo_code]
      ,[bo_name]
      ,[bo_holding]
      ,[total_entitlement]
      ,[dr_cr_flag]
      ,[transaction_date]
      ,[active_status_id]
      ,[membership_id]
      ,[changed_user_id]
      ,[changed_date]
      ,[is_dirty])

	SELECT 
      [isin]
      ,[company_name]
      ,[seq_no]
      ,[trans_ref]
      ,[record_dt]
      ,[effective_dt]
      ,[cash_fraction_amt]
      ,[cash_payment_dt]
      ,[remarks]
      ,[benifit_isin]
      ,[benifit_company_name]
      ,[par_ratio]
      ,[ben_ratio]
      ,[bo_code]
      ,[bo_name]
      ,[bo_holding]
      ,[total_entitlement]
      ,[dr_cr_flag]
      ,[transaction_date]
      ,[active_status_id]
      ,[membership_id]
      ,[changed_user_id]
      ,[changed_date]
      ,[is_dirty]
  FROM [CDBL].[tblCdblDevidendReceivable]




  drop table [CDBL].[tblCdblDevidendReceivable]







DROP PROCEDURE [CDBL].[psp_devident_receivable];




USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [CDBL].[psp_dividend_receivable]    Script Date: 12/22/2015 6:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- exec CDBL.psp_dividend_receivable '16-JUN-2015', '16-JUN-2015', 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a', getdate(), 1
-- =============================================
-- Author:		Asif
-- Create date: 28/10/15
-- Description:	Process Devident Receivable
-- Updated by : Sarwar
-- Update Date: 12/07/2015
-- Description: Add validation for invalid dividend uploaded data
-- =============================================
CREATE PROCEDURE [CDBL].[psp_dividend_receivable]
(
	@from_date varchar(50),
	@to_date varchar(50),
	@membership_id numeric(9,0),
	@changed_user_id nvarchar(128),
	@changed_date datetime
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF

	 DECLARE @ERROR_MESSAGE VARCHAR(MAX)
	 DECLARE @active_status_id int;

	 SELECT @active_status_id = tcov.object_value_id
	 FROM dbo.tblConstantObject tco
	 INNER JOIN dbo.tblConstantObjectValue tcov ON tcov.object_id = tco.object_id
	 WHERE tco.object_name = 'ACTIVE_STATUS'
	 AND tcov.display_value = 'Active'
	 
	 BEGIN TRANSACTION
	 
		BEGIN TRY

						
			-----------------------Insert data from temp table to devident receivable-----------------------
			
			INSERT INTO [CDBL].[tblCdblDividendReceivable] (isin,company_name,seq_no,trans_ref,record_dt,effective_dt,cash_fraction_amt,cash_payment_dt,
				remarks,benifit_isin,benifit_company_name,par_ratio,ben_ratio,bo_code,bo_name,bo_holding,total_entitlement,dr_cr_flag,transaction_date,
				active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			SELECT a.isin,a.company_name,CONVERT(numeric(10,0),a.seq_no) seq_no,a.trans_ref,a.record_dt,a.effective_dt,CONVERT(numeric(5,2),a.cash_fraction_amt) cash_fraction_amt,
				a.cash_payment_dt,a.remarks,a.benifit_isin,a.benifit_company_name,CONVERT(numeric(5,2),a.par_ratio) par_ratio,CONVERT(numeric(5,5),a.ben_ratio) ben_ratio,a.bo_code,
				a.bo_name,CONVERT(numeric(10,3),a.bo_holding) bo_holding,CONVERT(numeric(10,3),a.total_entitlement) total_entitlement,a.dr_cr_flag,a.transaction_date,@active_status_id,
				@membership_id,@changed_user_id,@changed_date,1
			FROM [CDBL].[17DP64UX] a
			LEFT JOIN [CDBL].[tblCdblDividendReceivable] tcdr ON tcdr.isin = a.isin AND tcdr.bo_code = a.bo_code AND CONVERT(DATETIME,a.record_dt) =  CONVERT(DATETIME,tcdr.record_dt)
			WHERE tcdr.dividend_receivable_id IS NULL
			AND CONVERT(Datetime, a.transaction_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120)
			
			-----------------------End insert data from temp table to devident receivable-----------------------
		


			----------IF DATA INSERTED SUCCESSFULLY THEN EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE DIVIDEND RECEIVABLE---------
			IF @@ROWCOUNT>0
			BEGIN
			--START OF VALIDATION
			DECLARE @ISIN VARCHAR(50),@object_value_id NUMERIC(4)
			--GET OBJECT ID
			SELECT @object_value_id= A.object_value_id 
			FROM
			tblConstantObjectValue A
			INNER JOIN tblConstantObject B ON B.object_id=A.object_id
			where 
			B.object_name='SHARE_LEDGER_TYPE'
			AND A.display_value='Dividend Receivable'
			
			--FOR ALL IPO FOR GIVEN DATE RANGE
					DECLARE CUR_IPO CURSOR
					FOR
						SELECT 
						DISTINCT A.ISIN
						FROM
						[CDBL].[17DP64UX] a
						WHERE
						CONVERT(Datetime, a.transaction_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120)
					OPEN CUR_IPO
					FETCH NEXT FROM CUR_IPO INTO @ISIN
					WHILE @@FETCH_STATUS=0
					BEGIN
						--CALL SHARE TRANSACTION PROCESS
						EXEC [Investor].[psp_investor_share_transaction] @ISIN,@object_value_id,@membership_id,@changed_user_id
					END
					CLOSE CUR_IPO
					DEALLOCATE CUR_IPO


			--END OF VALIDATEION
			END
			------------------END OF  EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE DIVIDEND RECEIVABLE---------


			
			COMMIT TRANSACTION
		END TRY
		
		BEGIN CATCH
		
			ROLLBACK 
			SET @ERROR_MESSAGE=ERROR_MESSAGE()
			RAISERROR(@ERROR_MESSAGE,16,1)
		END CATCH	 
END




USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [CDBL].[psp_cdbl]    Script Date: 12/22/2015 7:04:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- exec CDBL.psp_cdbl 'BO Registration,Bonus Rights,', '16-JUN-2015', '16-JUN-2015', 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a', getdate, 1
-- =============================================
-- Author:		Asif
-- Create date: 13/10/15
-- Description:	Process CDBL
-- =============================================
ALTER PROCEDURE [CDBL].[psp_cdbl]
(
@display_names varchar(MAX),
@from_date varchar(50),
@to_date varchar(50),
@membership_id numeric(9,0),
@changed_user_id nvarchar(128),
@changed_date datetime,
@is_dirty numeric(1,0),
@result VARCHAR(MAX) OUT
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
	 SET @result = 'success'
	 
	 IF EXISTS(SELECT @display_names WHERE @display_names LIKE '%BO Registration%')
		BEGIN
		    --CHECK VALIDATION FOR INVALID DATA
			IF NOT EXISTS (SELECT 1 FROM [CDBL].[tmpInvalidUploadedData] WHERE [TABLE_NAME]='[08DP01UX]')
			BEGIN
				EXEC CDBL.psp_bo_registration @from_date, @to_date, @membership_id, @changed_user_id, @result OUTPUT
			--END OF VALIDATION
			END
		END
	 
	 IF EXISTS(SELECT @display_names WHERE @display_names LIKE '%Bonus Rights%')
		BEGIN
		    --CHECK VALIDATION FOR INVALID DATA
			IF NOT EXISTS (SELECT 1 FROM [CDBL].[tmpInvalidUploadedData] WHERE [TABLE_NAME]='[17DP70UX]')
			BEGIN
				EXEC CDBL.psp_bonus_rights @from_date, @to_date, @membership_id, @changed_user_id, @changed_date, @is_dirty
			--END OF VALIDATION
			END
		END
	
	 IF EXISTS(SELECT @display_names WHERE @display_names LIKE '%Transmission%')
		BEGIN
			--CHECK VALIDATION FOR INVALID DATA
			IF NOT EXISTS (SELECT 1 FROM [CDBL].[tmpInvalidUploadedData] WHERE [TABLE_NAME]='[11DP81UX]')
			BEGIN
				EXEC CDBL.psp_transmission @from_date, @to_date, @membership_id, @changed_user_id, @changed_date, @is_dirty
			--END OF VALIDATION
			END
		END
	 
	 IF EXISTS(SELECT @display_names WHERE @display_names LIKE '%IPO%')
		BEGIN
		    --CHECK VALIDATION FOR INVALID DATA
			IF NOT EXISTS (SELECT 1 FROM [CDBL].[tmpInvalidUploadedData] WHERE [TABLE_NAME]='[16DP95UX]')
			BEGIN
				EXEC CDBL.psp_ipo @from_date, @to_date, @membership_id, @changed_user_id, @changed_date, @is_dirty
			--END OF VALIDATION
			END
		END	
	 
	 IF EXISTS(SELECT @display_names WHERE @display_names LIKE '%Dividend Receivable%')
		BEGIN
			--CHECK VALIDATION FOR INVALID DATA
			IF NOT EXISTS (SELECT 1 FROM [CDBL].[tmpInvalidUploadedData] WHERE [TABLE_NAME]='[17DP64UX]')
			BEGIN
				EXEC CDBL.psp_dividend_receivable @from_date, @to_date, @membership_id, @changed_user_id, @changed_date
			--END OF VALIDATION
			END
		END 
END



USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [CDBL].[ssp_CDBL_invalid_data_list]    Script Date: 12/22/2015 5:59:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  PROCEDURE [CDBL].[ssp_CDBL_invalid_data_list]
(

@display_names varchar(MAX)
)
as
	 SET NOCOUNT OFF
	 SET FMTONLY OFF

DECLARE @ERROR_MESSAGE nvarchar(MAX)

--REFRESH TABLE
TRUNCATE TABLE CDBL.[tmpInvalidUploadedData]


--INSERT INVALID DATA

IF EXISTS(SELECT @display_names WHERE @display_names LIKE '%BO Registration%')
BEGIN
	--File: 08DP01UX-(BO File)------------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT 
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +LEFT(T1.[bo_code],8) 
	FROM
	[CDBL].[08DP01UX] T1
	LEFT JOIN [broker].[tblDepositoryPerticipant] T2 ON T2.[bo_reference_no]=LEFT(T1.[bo_code],8)
	WHERE
	T2.[bo_reference_no] IS NULL

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[08DP01UX]' TABLE_NAME
	,'Invalid DP' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL


	--File: 08DP01UX-(BO File)------------------------------
	SET @ERROR_MESSAGE=NULL
	--SELECT
	--@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[internal_Ref_No]
	--FROM
	--[CDBL].[08DP01UX] T1
	--LEFT JOIN [Investor].[tblInvestor] T3 ON T3.[client_id]=T1.[internal_Ref_No]
	--WHERE
	--T3.[client_id] IS NULL

	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[internal_Ref_No]
	FROM
	[CDBL].[08DP01UX] T1
	INNER JOIN [Investor].[tblInvestor] T3 ON T3.[client_id]=T1.[internal_Ref_No]

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[08DP01UX]' TBL_NAME
	,'Invalid Internal Ref No#' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL


	--File: 08DP01UX-(BO File)------------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.bo_code
	FROM
	[CDBL].[08DP01UX] T1
	GROUP BY T1.bo_code
	HAVING COUNT(T1.bo_code)>1

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[08DP01UX]' TBL_NAME
	,'Duplicate BO Code' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL



	--File: 08DP01UX-(BO File)------------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT 
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +LEFT(T1.[bo_code],8) 
	FROM
	[CDBL].[08DP01UX] T1
	WHERE
	ISDATE(T1.BIRTH_DATE)!=1

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[08DP01UX]' TBL_NAME
	,'Invalid date of birth' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL
END


IF EXISTS(SELECT @display_names WHERE @display_names LIKE '%Dividend Receivable%')
BEGIN
	--File: 17DP64UX-(Dividend Receivable)------------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[bo_code]
	FROM
	[CDBL].[17DP64UX] T1
	LEFT JOIN [Investor].[tblInvestor] T3 ON T3.[bo_code]=T1.[bo_code]
	WHERE
	T3.[bo_code] IS NULL

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[17DP64UX]' TBL_NAME
	,'Invalid BO Code' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL

	--File: 17DP64UX-(Dividend Receivable)------------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[isin]
	FROM
	[CDBL].[17DP64UX] T1
	LEFT JOIN [Instrument].[tblInstrument] T3 ON T3.[isin]=T1.[isin]
	WHERE
	T3.[isin] IS NULL

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[17DP64UX]' TBL_NAME
	,'Invalid ISIN' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL


	--File: 17DP64UX-(Dividend Receivable)------------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[bo_code] 
	FROM
	[CDBL].[17DP64UX] T1
	GROUP BY T1.bo_code,T1.ISIN
	HAVING COUNT(T1.bo_code)>1

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[17DP64UX]' TBL_NAME
	,'Duplicate BO Code and ISIN' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL
END


IF EXISTS(SELECT @display_names WHERE @display_names LIKE '%Bonus Rights%')
BEGIN
	--File: 17DP70UX--(Bonus Right)-----------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[bo_code] 
	FROM
	[CDBL].[17DP70UX] T1
	LEFT JOIN [Investor].[tblInvestor] T3 ON T3.[bo_code]=T1.[bo_code]
	WHERE
	T3.[bo_code] IS NULL

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[17DP70UX]' TBL_NAME
	,'Invalid BO Code' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL


	--File: 17DP70UX--(Bonus Right)-----------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[isin]
	FROM
	[CDBL].[17DP70UX] T1
	LEFT JOIN [Instrument].[tblInstrument] T3 ON T3.[isin]=T1.[isin]
	WHERE
	T3.[isin] IS NULL

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[17DP70UX]' TBL_NAME
	,'Invalid ISIN' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL



	--File: 17DP70UX--(Bonus Right)-----------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[bo_code]
	FROM
	[CDBL].[17DP70UX] T1
	GROUP BY T1.bo_code,T1.ISIN,T1.share_transaction_type
	HAVING COUNT(T1.bo_code)>1

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[17DP70UX]' TBL_NAME
	,'Duplicate BO Code and ISIN' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL
END


IF EXISTS(SELECT @display_names WHERE @display_names LIKE '%IPO%')
BEGIN
	--File: [16DP95UX]--(IPO)-----------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[bo_code]
	FROM
	[CDBL].[16DP95UX] T1
	LEFT JOIN [Investor].[tblInvestor] T3 ON T3.[bo_code]=T1.[bo_code]
	WHERE
	T3.[bo_code] IS NULL

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[16DP95UX]' TBL_NAME
	,'Invalid BO Code' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL


	--File: [16DP95UX]--(IPO)-----------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[isin]
	FROM
	[CDBL].[16DP95UX] T1
	LEFT JOIN [Instrument].[tblInstrument] T3 ON T3.[isin]=T1.[isin]
	WHERE
	T3.[isin] IS NULL

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[16DP95UX]' TBL_NAME
	,'Invalid ISIN' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL



	--File: [16DP95UX]--(IPO)-----------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[bo_code]
	FROM
	[CDBL].[16DP95UX] T1
	GROUP BY T1.bo_code,T1.ISIN
	HAVING COUNT(T1.bo_code)>1

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[16DP95UX]' TBL_NAME
	,'Duplicate BO Code and ISIN' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL
END



--SELECT INVALID DATA
SELECT
*
FROM
	CDBL.[tmpInvalidUploadedData]






alter table [broker].[tblBrokerBankAccount] add is_default numeric(1,0) not null DEFAULT(0)




WITH UpdateList_view AS (
  SELECT TOP 1  * from [broker].[tblBrokerBankAccount] 
)

update UpdateList_view 
set is_default = 1





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[psp_ft_exp_client_limits_morning]    Script Date: 12/26/2015 6:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 8/12/2015
-- Description:	export ft client limit morning
-- =============================================

-- EXEC [Trade].[psp_ft_exp_client_limits_morning] '20151206', '', '20151220-012552-Limits-BAN.xml', '',62
ALTER PROCEDURE [Trade].[psp_ft_exp_client_limits_morning] 
	 @export_dt as numeric (9,0)
	,@omb_ids as nvarchar(max) 
	,@file_name as nvarchar(max)
	,@branch_ids as nvarchar(max)
	,@membership_id NUMERIC(9)
AS
BEGIN
	DECLARE @default_trader_code varchar(20)
	DECLARE @log_id as numeric(20,0)
	DECLARE @row_count numeric(9,0)
	DECLARE @default_margin_ratio numeric(5,2)

	--GET DEFAULT TRADER CODE
	SELECT  
		TOP 1 @default_trader_code= trader_Code 
	FROM 
		broker.tblTrader 
	WHERE 
		LEN(trader_Code)=10 
		AND CHARINDEX('DLR',trader_code)<1
		AND Is_Default=1
		AND membership_id=@membership_id

	IF(LEN(ISNULL(@default_trader_code,''))!=10)
	BEGIN  
		RAISERROR ('Please setup at least one trader for default trader', 16, 1)  
		RETURN  
	 END  
	
	SELECT  id log_id INTO #SPLITED_OMB_INVESTOR FROM dbo.udfSpliter(@omb_ids)
	SELECT id log_id INTO #SPLITED_BRANCH_INVESTOR FROM dbo.udfSpliter(@branch_ids)

	-------------------------------START morning data validation--------------------
	IF EXISTS(SELECT export_dt FROM Trade.tblFTExportLog WHERE file_type='limits' AND version_no>1
	 		AND export_dt = @export_dt AND membership_id=@membership_id)  
	 BEGIN  
		  RAISERROR ('You are not allow to export morning file after intraday export', 16, 1)  
		  RETURN  
	 END 
	--------------------------------CLOSE morning data validation--------------------------- 

	-------------------------------START Previous data remove is exists--------------------

	 DELETE FROM  Trade.tblFTLimits WHERE membership_id=@membership_id

	 DELETE FROM  Trade.tblFTExportLog WHERE file_type='limits' AND export_dt = @export_dt AND membership_id=@membership_id
	-------------------------------CLOSE Previous data remove is exists--------------------	 
	 
	 INSERT INTO Trade.tblFTExportLog(file_type,[file_name],export_dt,version_no,membership_id)
	 VALUES ('limits',@file_name,@export_dt,1,@membership_id)

	 SELECT @log_id=MAX(log_id) FROM Trade.tblFTExportLog WHERE [file_name]=@file_name AND file_type='limits' AND version_no=1 AND membership_id=@membership_id
	
	---------------------------------------------START: INSERT BROEKR INVESTOR CASH BALANCE---------------------------------------------------------
	
	INSERT INTO Trade.tblFTLimits
		 (
			[ClientCode]
           ,[Cash]
           ,[MaxCapitalBuy]
           ,[MaxCapitalSell]
           ,[TotalTransaction]
           ,[NetTransaction]
           ,[Deposit]
           ,[MarginRatio]
           ,[acc_Type_S_Name]
           ,[import_type]
           ,[import_log_id]
           ,[log_id]
           ,[line_no]
           ,[status]
           ,[failed_reason]
           ,[membership_id]
		 )
	SELECT 
		FB.CLIENT_ID ,
		CASE WHEN ISNULL(FB.[purchase_power],0)<=0 THEN  0
			 ELSE
				  FB.[purchase_power]
			 END
			 AS CASH,
		0 MAXCAPITALBUY,
		0 MAXCAPITALSELL,
		0 TOTALTRANSACTION,
		0 NETTRANSACTION,
		0 DEPOSIT,
		FB.[loan_ratio] MARGINRATIO,
		COV.display_value ACC_TYPE_S_NAME,
		'' IMPORT_TYPE,
		NULL IMPORT_LOG_ID,
		@log_id LOG_ID,
		NULL LINE_NO,
		'' STATUS,
		'' FAILED_REASON,
		FB.membership_id
	FROM
		Investor.tblInvestor INV
	left join 
		[Investor].[vw_InvestorFundBalance] FB
		ON INV.[client_id]=FB.[client_id]
		AND INV.membership_id=FB.membership_id
	left JOIN
		[dbo].[tblConstantObjectValue] COV
		ON COV.object_value_id=FB.account_type_id
	INNER JOIN 
		dbo.tblConstantObjectValue tcovas 
		ON tcovas.object_value_id = INV.active_status_id
	WHERE
		tcovas.display_value = 'Active' 
		AND LEN(ISNULL(INV.bo_code,''))=16
		AND INV.membership_id=@membership_id
	---------------------------------------------END: INSERT BROEKR INVESTOR CASH BALANCE---------------------------------------------------------
	
	---------------------------------------------START: Cash---------------------------------------------------------
	SELECT 
		CASE WHEN tcovas.display_value = 'Active' THEN 1
			 WHEN tcovas.display_value = 'Close' THEN 3
			 ELSE 2 
			 END 
			 AS investor_st
		,ti.client_id ClientCode
		,CASE WHEN LEN(ISNULL(tt.trader_code,''))=10 THEN tt.trader_code
			  ELSE @default_trader_code 
			  END 
			  DealerID
		,ti.bo_code AS BOID
		,'Yes' AS WithNetAdjustment
		,LEFT(ti.first_holder_name,50) Name
		,'' ShortName
		,LEFT(ISNULL(ti.mailing_address,''),160) Address
		,LEFT(ISNULL(CASE WHEN ti.mobile_no IS NOT NULL THEN ti.mobile_no WHEN ti.phone_no IS NOT NULL THEN ti.phone_no ELSE NULL END,''),20) Tel
		,LEFT(ISNULL(ti.national_id,''),14) ICNo
		,ISNULL(tcovtt.display_value,'N') AccountType
		,'No' ShORtSellingAllowed
		,'Suspend' Buy_SuspEND
		,'Suspend' Sell_SuspEND
		,'' SuspEND_Remark
		,@log_id log_id
	FROM 
		Investor.tblInvestor ti
	INNER JOIN 
		dbo.tblConstantObjectValue tcovas 
		ON tcovas.object_value_id = ti.active_status_id
	INNER JOIN 
		dbo.DimDate ddcd 
		ON ddcd.FullDateUSA = CONVERT(VARCHAR,ti.changed_date,101)
	INNER JOIN 
		broker.tblTrader tt 
		ON tt.id = ti.trader_id
		AND TT.membership_id=TI.membership_id
	LEFT JOIN 
		dbo.tblConstantObjectValue tcovtt 
		ON tcovtt.object_value_id = ti.trade_type_id
	WHERE 
		(ddcd.DateKey >= @export_dt OR ISNULL(ti.export_st,0)=0) 
		AND LEN(ISNULL(ti.bo_code,''))=16
		AND TI.membership_id=@membership_id
	ORDER BY 
		ti.active_status_id, ti.client_id
		;
	---------------------------------------------END: Cash---------------------------------------------------------

	---------------------------------------------START: Limit---------------------------------------------------------
	SELECT 
		tfl.ClientCode
	    ,FLOOR(TFL.CASH)  AS Cash
		,ISNULL(tfl.acc_Type_S_Name,'C') acc_Type_S_Name
		,ISNULL(tfl.MarginRatio,0) MarginRatio
		,ISNULL(tfl.MaxCapitalBuy,0) MaxCapitalBuy
		,ISNULL(tfl.MaxCapitalSell,0) MaxCapitalSell
		,ISNULL(tfl.TotalTransaction,0) TotalTransaction
		,ISNULL(tfl.NetTransaction,0) NetTransaction
		,ISNULL(tfl.Deposit,0) Deposit
		,@log_id log_id
	FROM 
		Trade.tblFTLimits tfl 
	WHERE 
		TFL.membership_id=@membership_id
	ORDER BY 
		tfl.ClientCode
	---------------------------------------------END: Limit---------------------------------------------------------
	
	UPDATE bil SET export_st=1, export_log_id=@log_id FROM Trade.tblFTImportLog bil INNER JOIN #SPLITED_BRANCH_INVESTOR sbi on bil.log_id=sbi.log_id
	
	UPDATE bil SET log_id=@log_id FROM Trade.tblFTLimits bil INNER JOIN #SPLITED_BRANCH_INVESTOR sbi on bil.import_log_id=sbi.log_id WHERE bil.import_type='B'
	
	UPDATE Investor.tblInvestor SET export_st=1, export_log_id=@log_id FROM Investor.tblInvestor ti INNER JOIN dbo.tblConstantObjectValue tcovas ON tcovas.object_value_id = ti.active_status_id WHERE LEN(ISNULL(bo_code,'')) =16 AND tcovas.display_value = 'Active'
	
END





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[psp_ft_exp_client_limits]    Script Date: 12/26/2015 7:10:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 8/12/2015
-- Description:	export ft client limit
-- =============================================

-- EXEC [Trade].[psp_ft_exp_client_limits] '20151213', '', 'afds','4',62
ALTER PROCEDURE [Trade].[psp_ft_exp_client_limits] 

	 @export_dt as numeric (9,0)
	,@omb_ids as nvarchar(max) 
	,@file_name as nvarchar(max)
	,@branch_ids as nvarchar(max)
	,@membership_id NUMERIC(9)
AS
BEGIN
	DECLARE @default_trader_code varchar(20)
	DECLARE @log_id as numeric(20,0)
	DECLARE @row_count numeric(9,0)
	DECLARE @default_margin_ratio numeric(5,2)

	SET @default_trader_code=(SELECT  TOP 1 trader_Code FROM broker.tblTrader WHERE LEN(trader_Code)=10 AND CHARINDEX('DLR',trader_code)<1 ORDER BY trader_Code)
	IF(LEN(ISNULL(@default_trader_code,''))!=10)
	BEGIN  
		RAISERROR ('Please setup at least one trader for default trader', 16, 1)  
		RETURN  
	 END  
	
	SELECT  id log_id INTO #SPLITED_OMB_INVESTOR FROM dbo.udfSpliter(@omb_ids)
	SELECT id log_id INTO #SPLITED_BRANCH_INVESTOR FROM dbo.udfSpliter(@branch_ids)

	-------------------------------START morning data validation--------------------
	IF EXISTS(SELECT export_dt FROM Trade.tblFTExportLog WHERE file_type='limits' AND version_no>1
	 		AND export_dt = @export_dt)  
	 BEGIN  
		  RAISERROR ('You are not allow to export morning file after intraday export', 16, 1)  
		  RETURN  
	 END 
	--------------------------------CLOSE morning data validation--------------------------- 

	-------------------------------START Previous data remove is exists--------------------

	 DELETE FROM  Trade.tblFTLimits WHERE membership_id=@membership_id

	 
	 DELETE FROM  Trade.tblFTExportLog WHERE file_type='limits' AND export_dt = @export_dt and membership_id=@membership_id
	-------------------------------CLOSE Previous data remove is exists--------------------	 
	 
	 INSERT INTO Trade.tblFTExportLog(file_type,[file_name],export_dt,version_no,membership_id)
	 VALUES ('limits',@file_name,@export_dt,1,@membership_id)

	 SELECT @log_id=MAX(log_id) FROM Trade.tblFTExportLog WHERE [file_name]=@file_name AND file_type='limits' AND version_no=1 and membership_id=@membership_id
	
	---------------------------------------------START: INSERT BROEKR INVESTOR CASH BALANCE---------------------------------------------------------
	
	INSERT INTO Trade.tblFTLimits
		 (
			[ClientCode]
           ,[Cash]
           ,[MaxCapitalBuy]
           ,[MaxCapitalSell]
           ,[TotalTransaction]
           ,[NetTransaction]
           ,[Deposit]
           ,[MarginRatio]
           ,[acc_Type_S_Name]
           ,[import_type]
           ,[import_log_id]
           ,[log_id]
           ,[line_no]
           ,[status]
           ,[failed_reason]
           ,[membership_id]
		 )
	SELECT 
		FB.CLIENT_ID ,
		CASE WHEN ISNULL(FB.[purchase_power],0)<=0 THEN  0
			 ELSE
				  FB.[purchase_power]
			 END
			 AS CASH,
		0 MAXCAPITALBUY,
		0 MAXCAPITALSELL,
		0 TOTALTRANSACTION,
		0 NETTRANSACTION,
		0 DEPOSIT,
		FB.[loan_ratio] MARGINRATIO,
		COV.display_value ACC_TYPE_S_NAME,
		'' IMPORT_TYPE,
		NULL IMPORT_LOG_ID,
		@log_id LOG_ID,
		NULL LINE_NO,
		'' STATUS,
		'' FAILED_REASON,
		FB.membership_id
	FROM
		Investor.tblInvestor INV
	left join 
		[Investor].[vw_InvestorFundBalance] FB
		ON INV.[client_id]=FB.[client_id]
		AND INV.membership_id=FB.membership_id
	left JOIN
		[dbo].[tblConstantObjectValue] COV
		ON COV.object_value_id=FB.account_type_id
	INNER JOIN 
		dbo.tblConstantObjectValue tcovas 
		ON tcovas.object_value_id = INV.active_status_id
	WHERE
		tcovas.display_value = 'Active' 
		AND LEN(ISNULL(INV.bo_code,''))=16
		AND INV.membership_id=@membership_id
	---------------------------------------------END: INSERT BROEKR INVESTOR CASH BALANCE---------------------------------------------------------
	 
	---------------------------------------------START: Cash---------------------------------------------------------
	SELECT CASE WHEN tcovas.display_value = 'Active' THEN 1
			WHEN tcovas.display_value = 'Close' THEN 3
			ELSE 2 END AS investor_st
		,ti.client_id ClientCode
		,CASE WHEN LEN(ISNULL(tt.trader_code,''))=10 OR LEN(ISNULL(tt.trader_code,''))=8 THEN tt.trader_code
			ELSE @default_trader_code END DealerID
		,ti.bo_code AS BOID
		,'Yes' AS WithNetAdjustment
		,LEFT(ti.first_holder_name,50) Name
		,'' ShortName
		,LEFT(ISNULL(ti.mailing_address,''),160) Address
		,LEFT(ISNULL(CASE WHEN ti.mobile_no IS NOT NULL THEN ti.mobile_no WHEN ti.phone_no IS NOT NULL THEN ti.phone_no ELSE NULL END,''),20) Tel
		,LEFT(ISNULL(ti.national_id,''),14) ICNo
		,ISNULL(tcovtt.display_value,'N') AccountType
		,'No' ShORtSellingAllowed
		,'Suspend' Buy_SuspEND
		,'Suspend' Sell_SuspEND
		,'' SuspEND_Remark
		,@log_id log_id
	FROM InvestOR.tblInvestOR ti
	INNER JOIN dbo.tblConstantObjectValue tcovas ON tcovas.object_value_id = ti.active_status_id
	INNER JOIN broker.tblTrader tt ON tt.id = ti.trader_id
	LEFT JOIN dbo.tblConstantObjectValue tcovtt ON tcovtt.object_value_id = ti.trade_type_id
	WHERE LEN(ISNULL(ti.bo_code,''))=16
	AND tcovas.display_value = 'Active'
	AND ti.membership_id = @membership_id
	ORDER BY ti.active_status_id, ti.client_id;
	---------------------------------------------END: Cash---------------------------------------------------------

	---------------------------------------------START: Limit---------------------------------------------------------
	SELECT tfl.ClientCode
	    ,FLOOR(CASE WHEN tifb.purchase_power<0 THEN 0 else tifb.purchase_power END) AS Cash
		,ISNULL(tfl.acc_Type_S_Name,'C') acc_Type_S_Name
		,ISNULL(tfl.MarginRatio,0) MarginRatio
		,ISNULL(tfl.MaxCapitalBuy,0) MaxCapitalBuy
		,ISNULL(tfl.MaxCapitalSell,0) MaxCapitalSell
		,ISNULL(tfl.TotalTransaction,0) TotalTransaction
		,ISNULL(tfl.NetTransaction,0) NetTransaction
		,ISNULL(tfl.Deposit,0) Deposit
		,@log_id log_id
	FROM 
	Trade.tblFTLimits tfl 
	LEFT JOIN  [Investor].[vw_InvestorFundBalance] tifb ON tifb.client_id = tfl.ClientCode
	WHERE tfl.membership_id  = @membership_id
	ORDER BY tfl.ClientCode
	---------------------------------------------END: Limit---------------------------------------------------------
	
	UPDATE bil 
		SET export_st=1, export_log_id=@log_id 
	FROM 
		Trade.tblFTImportLog bil 
	INNER JOIN 
		#SPLITED_BRANCH_INVESTOR sbi 
		on bil.log_id=sbi.log_id
	WHERE
		bil.membership_id=@membership_id
	


	UPDATE bil 
		SET log_id=@log_id 
	FROM 
		Trade.tblFTLimits bil 
	INNER JOIN 
		#SPLITED_BRANCH_INVESTOR sbi 
		on bil.import_log_id=sbi.log_id 
	WHERE 
		bil.import_type='B'
		AND bil.membership_id=@membership_id
	


	UPDATE Investor.tblInvestor 
		SET export_st=1, export_log_id=@log_id 
	FROM 
		Investor.tblInvestor ti 
	INNER JOIN 
		dbo.tblConstantObjectValue tcovas 
		ON tcovas.object_value_id = ti.active_status_id 
	WHERE 
		LEN(ISNULL(bo_code,'')) =16 
		AND tcovas.display_value = 'Active'
	
END





USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[psp_ft_exp_share_limits_morning]    Script Date: 12/26/2015 7:14:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 9/12/2015
-- Description:	export ft share limit morning
-- =============================================

-- EXEC [Trade].[psp_ft_exp_share_limits_morning] '20151104', '', 'afds','4'
ALTER PROCEDURE [Trade].[psp_ft_exp_share_limits_morning] 

	 @export_dt as numeric (9,0)
	,@omb_ids as nvarchar(max) 
	,@file_name as nvarchar(max)
	,@branch_ids as nvarchar(max)
	,@membership_id NUMERIC(9)
AS
BEGIN
	DECLARE @log_id as numeric(20,0) 
	
	SELECT  id log_id INTO #SPLITED_OMB_INVESTOR FROM dbo.udfSpliter(@omb_ids)
	SELECT id log_id INTO #SPLITED_BRANCH_INVESTOR FROM dbo.udfSpliter(@branch_ids)

	-------------------------------START morning data validation--------------------
	IF EXISTS(SELECT export_dt FROM Trade.tblFTExportLog WHERE file_type='positions' AND version_no>1
	 		AND export_dt = @export_dt AND membership_id=@membership_id)  
	 BEGIN  
		  RAISERROR ('You are not allow to export morning file after intraday export', 16, 1)  
		  RETURN  
	 END 
	--------------------------------CLOSE morning data validation--------------------------- 

	-------------------------------START Previous data remove is exists--------------------
	
	 DELETE FROM  Trade.tblFTPositions WHERE  membership_id=@membership_id

	 DELETE FROM  Trade.tblFTExportLog WHERE file_type='positions' AND export_dt = @export_dt  AND membership_id=@membership_id
	-------------------------------CLOSE Previous data remove is exists--------------------	 
	 
	 INSERT INTO Trade.tblFTExportLog(file_type,[file_name],export_dt,version_no,membership_id)
	 VALUES ('positions',@file_name,@export_dt,1,@membership_id)

	 SELECT @log_id=MAX(log_id) FROM Trade.tblFTExportLog WHERE [file_name]=@file_name AND file_type='positions' AND version_no=1  AND membership_id=@membership_id


	---START--------------------------------INSERT BROKER INVESTOR POSITION-----------------------------------------------------
	INSERT INTO Trade.tblFTPositions
		(
			[ClientCode]
           ,[SecurityCode]
           ,[ISIN]
           ,[Quantity]
           ,[TotalCost]
           ,[PositionType]
           ,[import_type]
           ,[import_log_id]
           ,[log_id]
           ,[line_no]
           ,[status]
           ,[failed_reason]
           ,[membership_id]
		   )
	SELECT 
		ISB.client_id,
		INS.security_code,
		INS.isin,
		ISB.[salable_quantity],
		ISB.[salable_quantity]*ISB.[cost_average],
		'' POSITION_TYPE,
		'' IMPORT_TYPE,
		NULL IMPORT_LOG_ID,
		@log_id LOG_ID,
		ROW_NUMBER() OVER(ORDER BY ISB.client_id,INS.security_code),
		'' STATUS,
		'' FAILED_REASON,
		ISB.membership_id
	FROM
		[Investor].[vw_InvestorShareBalance] ISB
	INNER JOIN 
		[Instrument].[tblInstrument] INS 
		ON INS.ID = ISB.instrument_id
	WHERE
		ISB.[salable_quantity]!=0
		AND ISB.membership_id=@membership_id
		;
	---END--------------------------------INSERT BROKER INVESTOR POSITION-----------------------------------------------------
 
	---------------------------------------------START: Limit---------------------------------------------------------
	SELECT 
		tfp.ClientCode
		,tfp.ISIN AS isin
		,tfp.SecurityCode
		,MIN(CEILING(tfp.Quantity)) Quantity
		,MIN(FLOOR(tfp.TotalCost)) TotalCost
		,'Long' PositionType
		,@log_id log_id
	FROM 
		Trade.tblFTPositions tfp 
	INNER JOIN 
		Investor.tblInvestor ti 
		on ti.client_id = tfp.ClientCode
	INNER JOIN 
		dbo.tblConstantObjectValue tcovas 
		ON tcovas.object_value_id = ti.active_status_id
	INNER JOIN 
		Instrument.tblInstrument tins 
		ON tins.isin = tfp.ISIN
	INNER JOIN 
		dbo.tblConstantObjectValue tcovasins 
		ON tcovasins.object_value_id = tins.active_status_id
	WHERE 
		CEILING(tfp.Quantity) > 0
		AND LEN(isnull(tfp.ISIN,'')) = 12 
		AND tcovas.display_value = 'Active' 
		AND tcovasins.display_value = 'Active'
		AND TFP.membership_id=@membership_id
	GROUP BY 
		tfp.ClientCode, tfp.isin, tfp.SecurityCode
	ORDER BY 
		tfp.ClientCode, tfp.ISIN
	---------------------------------------------END: Limit---------------------------------------------------------
	
	UPDATE bil SET export_st=1, export_log_id=@log_id FROM Trade.tblFTImportLog bil INNER JOIN #SPLITED_BRANCH_INVESTOR sbi on bil.log_id=sbi.log_id
	
	UPDATE bil SET log_id=@log_id FROM Trade.tblFTPositions bil INNER JOIN #SPLITED_BRANCH_INVESTOR sbi on bil.import_log_id=sbi.log_id WHERE bil.import_type='B'
	
END

