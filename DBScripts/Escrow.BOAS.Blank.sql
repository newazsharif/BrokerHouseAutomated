USE [master]
GO
/****** Object:  Database [Escrow.BOAS]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE DATABASE [Escrow.BOAS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Escrow.BOAS', FILENAME = N'D:\Databases\Escrow.BOAS\Escrow.BOAS.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [AccountingManagement] 
( NAME = N'Escrow.BOAS.AccountingManagement', FILENAME = N'D:\Databases\Escrow.BOAS\Escrow.BOAS.AccountingManagement.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [BrokerManagement] 
( NAME = N'Escrow.BOAS.BrokerManagement', FILENAME = N'D:\Databases\Escrow.BOAS\Escrow.BOAS.BrokerManagement.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [CDBLManagement] 
( NAME = N'Escrow.BOAS.CDBLManagement', FILENAME = N'D:\Databases\Escrow.BOAS\Escrow.BOAS.CDBLManagement.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [ChargeManagement] 
( NAME = N'Escrow.BOAS.ChargeManagement', FILENAME = N'D:\Databases\Escrow.BOAS\Escrow.BOAS.ChargeManagement.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [InstrumentManagement] 
( NAME = N'Escrow.BOAS.InstrumentManagement', FILENAME = N'D:\Databases\Escrow.BOAS\Escrow.BOAS.InstrumentManagement.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [InvestorManagement] 
( NAME = N'Escrow.BOAS.InvestorManagement', FILENAME = N'D:\Databases\Escrow.BOAS\Escrow.BOAS.InvestorManagement.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [TradeManagement] 
( NAME = N'Escrow.BOAS.TradeManagement', FILENAME = N'D:\Databases\Escrow.BOAS\Escrow.BOAS.TradeManagement.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [TransactionManagement] 
( NAME = N'Escrow.BOAS.TransactionManagement', FILENAME = N'D:\Databases\Escrow.BOAS\Escrow.BOAS.TransactionManagement.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Escrow.BOAS_log', FILENAME = N'D:\Databases\Escrow.BOAS\Escrow.BOAS_log.ldf' , SIZE = 3072KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Escrow.BOAS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Escrow.BOAS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Escrow.BOAS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET ARITHABORT OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Escrow.BOAS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Escrow.BOAS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Escrow.BOAS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Escrow.BOAS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET RECOVERY FULL 
GO
ALTER DATABASE [Escrow.BOAS] SET  MULTI_USER 
GO
ALTER DATABASE [Escrow.BOAS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Escrow.BOAS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Escrow.BOAS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Escrow.BOAS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Escrow.BOAS] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Escrow.BOAS', N'ON'
GO
USE [Escrow.BOAS]
GO
/****** Object:  DatabaseRole [Investor]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE ROLE [Investor]
GO
/****** Object:  DatabaseRole [Instrument]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE ROLE [Instrument]
GO
/****** Object:  DatabaseRole [broker]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE ROLE [broker]
GO
/****** Object:  DatabaseRole [Accounting]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE ROLE [Accounting]
GO
/****** Object:  Schema [Accounting]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE SCHEMA [Accounting]
GO
/****** Object:  Schema [broker]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE SCHEMA [broker]
GO
/****** Object:  Schema [CDBL]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE SCHEMA [CDBL]
GO
/****** Object:  Schema [Charge]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE SCHEMA [Charge]
GO
/****** Object:  Schema [Instrument]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE SCHEMA [Instrument]
GO
/****** Object:  Schema [Investor]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE SCHEMA [Investor]
GO
/****** Object:  Schema [Trade]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE SCHEMA [Trade]
GO
/****** Object:  Schema [Transaction]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE SCHEMA [Transaction]
GO
/****** Object:  UserDefinedFunction [Charge].[tfun_find_investor_charge_setting]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 3-NOV-2015
-- Description:	Find investor's charge setting by client id or charge id

-- EXEC Charge.ssp_find_investor_charge_setting NULL, 1
-- =============================================
CREATE FUNCTION [Charge].[tfun_find_investor_charge_setting]
(	
	@client_id as varchar(10), 
	@charge_id as numeric(3,0)
)
RETURNS @RESULT TABLE 
( 
	client_id varchar(10), 
	global_charge_id NUMERIC(3,0), 
	charge_amount NUMERIC(15,10), 
	is_percentage NUMERIC(1,0), 
	minimum_charge NUMERIC(15,10)
)  
AS
BEGIN

	with cte as
	(
		select client_id, global_charge_id, charge_amount, is_percentage, minimum_charge, 1 short_order
		from Charge.tblInvestorCharge
		where (@client_id is null or client_id=@client_id) and (@charge_id is null or global_charge_id=@charge_id)

		union all

		select ti.client_id, global_charge_id, charge_amount, is_percentage, minimum_charge, 2 
		from Charge.tblSubAccountCharge tsc 
			inner join dbo.tblConstantObjectValue tcov on tsc.sub_account_id=tcov.object_value_id
			inner join Investor.tblInvestor ti on tcov.object_value_id= ti.sub_account_type_id
		where  TCOV.object_id=186
			and (@client_id is null or client_id=@client_id) 
			and (@charge_id is null or global_charge_id=@charge_id)

		union all

		select client_id, global_charge_id, charge_amount, is_percentage, minimum_charge, 3 
		from Charge.tblBranchCharge tbc
			inner join Investor.tblInvestor ti on tbc.branch_id=ti.branch_id
		where (@client_id is null or client_id=@client_id) and (@charge_id is null or global_charge_id=@charge_id)

		union all

		select client_id, id global_charge_id, charge_amount, is_percentage, minimum_charge, 4 
		from Investor.tblInvestor, Charge.tblGlobalCharge
		where (@client_id is null or client_id=@client_id) and (@charge_id is null or id=@charge_id)
	)

	INSERT INTO @RESULT(client_id, global_charge_id, charge_amount, is_percentage, minimum_charge)
	select client_id, global_charge_id, charge_amount, is_percentage, minimum_charge from cte c
	where c.short_order=(select min(short_order) from cte e where e.client_id=c.client_id and e.global_charge_id = c.global_charge_id and e.short_order<=c.short_order)
	order by client_id, global_charge_id, short_order

	RETURN
END



GO
/****** Object:  UserDefinedFunction [dbo].[sfun_amount_to_word]    Script Date: 12/27/2015 7:46:15 PM ******/
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

GO
/****** Object:  UserDefinedFunction [dbo].[sfun_get_constant_object_default_value_id]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 22-NOV-2015
-- Description:	GET CONSTANT DEFAULT VALUE ID BY OBJECT NAME

-- SELECT dbo.sfun_get_constant_object_default_value_id('FINANCIAL_LEDGER_TYPE')
-- =============================================
CREATE FUNCTION [dbo].[sfun_get_constant_object_default_value_id] 
(
	-- Add the parameters for the function here
	 @object_name as varchar(100)
)
RETURNS NUMERIC(4,0)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @OBJECT_VALUE_ID AS NUMERIC(4,0)

	-- Add the T-SQL statements to compute the return value here
	SELECT @OBJECT_VALUE_ID=TCV.object_value_id 
	FROM DBO.tblConstantObjectValue TCV 
		INNER JOIN DBO.tblConstantObject TCO ON TCV.object_id=TCO.object_id 
	WHERE TCO.object_name=@object_name AND TCV.IS_DEFAULT=1

	-- Return the result of the function
	RETURN @OBJECT_VALUE_ID

END


GO
/****** Object:  UserDefinedFunction [dbo].[sfun_get_constant_object_value_id]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 22-NOV-2015
-- Description:	GET CONSTANT VALUE ID BY OBJECT NAME AND DISPLAY VALUE

-- SELECT dbo.sfun_get_constant_object_value_id('FINANCIAL_LEDGER_TYPE','Account Opening Fee')
-- =============================================
CREATE FUNCTION [dbo].[sfun_get_constant_object_value_id] 
(
	-- Add the parameters for the function here
	 @object_name as varchar(100)
	,@display_value as varchar(100)
)
RETURNS NUMERIC(4,0)
AS
BEGIN

	-- Declare the return variable here
	DECLARE @OBJECT_VALUE_ID AS NUMERIC(4,0)

	-- Add the T-SQL statements to compute the return value here
	SELECT @OBJECT_VALUE_ID=TCV.object_value_id 
	FROM DBO.tblConstantObjectValue TCV 
		INNER JOIN DBO.tblConstantObject TCO ON TCV.object_id=TCO.object_id 
	WHERE TCO.object_name=@object_name AND TCV.display_value=@display_value

	-- Return the result of the function
	RETURN @OBJECT_VALUE_ID

END


GO
/****** Object:  UserDefinedFunction [dbo].[sfun_get_process_date]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 22-NOV-2015
-- Description:	GET CURRENT TRANSACTION/PROCESS DATE

-- SELECT dbo.sfun_get_process_date()
-- =============================================
CREATE FUNCTION [dbo].[sfun_get_process_date]()
RETURNS NUMERIC(9,0)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PROCESS_DATE AS NUMERIC(9,0)

	-- Add the T-SQL statements to compute the return value here
	select @PROCESS_DATE=MAX(process_date) from dbo.tblDayProcess where end_date is null

	-- Return the result of the function
	RETURN @PROCESS_DATE

END


GO
/****** Object:  UserDefinedFunction [dbo].[sfun_get_process_date_as_datetime]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 22-NOV-2015
-- Description:	GET CURRENT TRANSACTION/PROCESS DATE

-- SELECT dbo.sfun_get_process_date_as_datetime()
-- =============================================
CREATE FUNCTION [dbo].[sfun_get_process_date_as_datetime]()
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PROCESS_DATE AS DATETIME

	-- Add the T-SQL statements to compute the return value here
	select @PROCESS_DATE=MAX(Date) 
	from dbo.tblDayProcess DP INNER JOIN DBO.DimDate DD
		ON DP.process_date=DD.DateKey
	where end_date is null

	-- Return the result of the function
	RETURN @PROCESS_DATE

END


GO
/****** Object:  UserDefinedFunction [dbo].[udfSpliter]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[udfSpliter]( @cds nvarchar(max) )  
RETURNS @cd TABLE ( id varchar(20))  
/*  
------------------------------------- 
Input Parameter : @IDs = Comma separated text, example: '1,3,8'  
Sample Execution:   
 select ID from dbo.udfSpliter( 'BD0641AFL004' )  
-------------------------------------  
*/  
AS  
BEGIN  
 declare @iPos int  
 declare @return TABLE ( ID varchar(20))   



declare @Code varchar(20)
declare @Exists int


set @cds = @cds + ','  
 while ( len( @cds ) > 1 ) 
 begin  
	set @iPos = CHARINDEX( ',', @cds )  
	set @code= convert( varchar(50), left( @cds, @iPos - 1 ) )	
	set @Exists=CHARINDEX( '-', @code )
		if(@Exists>=1)--if range data exists
		begin
		if left( @code, @Exists - 1 )<>'' and right( @code, len(@code) - @Exists ) <>'' -- if both range eixists
			begin 

				declare @start varchar(20)
				declare @end varchar(20)
				set 	@start = left( @code, @Exists - 1 )
				set 	@end = right( @code, len(@code) - @Exists )

				if(isnumeric(@start)=1 and isnumeric(@end)=1)-- if numeric range eixists 
				begin
					declare @Value varchar(20)
					declare @ValLen int
					declare @sVal numeric(20)
					declare @eVal numeric(20)
					declare @CodeLen int
			
					set @CodeLen= len(left( @code, @Exists - 1 ))
					set @sVal= convert( numeric(20), left( @code, @Exists - 1 ) )	
					set @eVal = convert(numeric(20), right( @code, len(@code) - @Exists ) )
			
					while(@sVal<=@eVal)
					begin
						set @Value=convert(varchar(20),@sVal)
						set @ValLen=len(@Value)
					
						while(@ValLen<@CodeLen)
						begin
							set @Value='0'+@Value
							set @ValLen=@ValLen+1
						end
							insert @return values (@Value )
							set @sVal=@sVal+1
					end	
				end
			--	else -- if non numeric range exists 
			--	begin 

			--		Declare @Inv varchar(10)
			--		Declare  _cursor cursor for
			--		Select investor_code from trd_investor_account  where upper(investor_code) >= upper(@start)  and  upper(investor_code)<= upper(@end)
			--		open _cursor 
			--		fetch _cursor into @Inv   
			--			WHILE @@FETCH_STATUS=0
			--			BEGIN		
			--					insert @return values (@Inv )
			--			fetch _cursor  into @Inv 
			--			END
			--		close _cursor 
			--		deallocate _cursor 
			--	end
			end
		end
		else if right( @code, len(@code) - @Exists ) <>''
		begin
			insert @return values (@code )  
		end
  set @cds = right( @cds, len( @cds ) - @iPos ) 
 end  

 insert @cd select id from @return 
------------------------

 RETURN  
END


GO
/****** Object:  UserDefinedFunction [Investor].[sfun_get_investor_fund_balance]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Asif
-- Create date: 22/11/15
-- Description:	Get fund balance investor wise
-- =============================================

CREATE FUNCTION [Investor].[sfun_get_investor_fund_balance](@InvID varchar(10),@TRD_DT numeric(9,0))  
RETURNS Numeric(15,4)  
AS   
BEGIN  
     DECLARE @ClosingBalance numeric(30,10)  
       
 SELECT @ClosingBalance = ledger_balance from [Investor].[tblInvestorFundBalance]  
  WHERE client_id = @INVID 
  AND transaction_date =
  (
	  Select MAX(transaction_date)
	  FROM [Investor].[tblInvestorFundBalance] 
	  WHERE client_id = @INVID AND transaction_date <= @TRD_DT
  )  
  
 RETURN(ISNULL(@ClosingBalance,0))  
  
END

GO
/****** Object:  Table [Accounting].[tblBank]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Accounting].[tblBank](
	[id] [numeric](3, 0) IDENTITY(1,1) NOT NULL,
	[short_name] [varchar](4) NOT NULL,
	[bank_name] [varchar](150) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblBank_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblBank_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblBank] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AccountingManagement]
) ON [AccountingManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Accounting].[tblBankBranch]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Accounting].[tblBankBranch](
	[id] [numeric](4, 0) IDENTITY(1,1) NOT NULL,
	[branch_name] [varchar](100) NOT NULL,
	[routing_no] [varchar](20) NOT NULL,
	[bank_id] [numeric](3, 0) NOT NULL,
	[address] [varchar](250) NULL,
	[contact_person] [varchar](150) NULL,
	[contact_number] [varchar](30) NULL,
	[email_address] [varchar](50) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblBankBranch_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblBankBranch_is_dirty]  DEFAULT ((1)),
	[district_id] [numeric](4, 0) NULL,
 CONSTRAINT [PK_tblBankBranch] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AccountingManagement]
) ON [AccountingManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [broker].[tblBrokerBankAccount]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [broker].[tblBrokerBankAccount](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[bank_branch_id] [numeric](4, 0) NOT NULL,
	[account_no] [varchar](20) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
	[is_default] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblBrokerBankAccount] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [broker].[tblBrokerBranch]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [broker].[tblBrokerBranch](
	[id] [numeric](2, 0) IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) NOT NULL,
	[address] [varchar](250) NULL,
	[contact_person] [varchar](100) NULL,
	[contact_no] [varchar](30) NULL,
	[email] [varchar](50) NULL,
	[registration_dt] [numeric](9, 0) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblBrokerBranch_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblBrokerBranch_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblBrokerBranch] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BrokerManagement]
) ON [BrokerManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [broker].[tblDepositoryPerticipant]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [broker].[tblDepositoryPerticipant](
	[id] [numeric](3, 0) IDENTITY(1,1) NOT NULL,
	[dp_no] [varchar](5) NOT NULL,
	[clearance_no] [varchar](16) NULL,
	[bo_reference_no] [varchar](8) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblDepositoryPerticipant_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblDepositoryPerticipant_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblDepositoryPerticipant] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BrokerManagement]
) ON [BrokerManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [broker].[tblEmployee]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [broker].[tblEmployee](
	[id] [numeric](5, 0) IDENTITY(1,1) NOT NULL,
	[employee_code] [varchar](10) NOT NULL,
	[name] [varchar](100) NOT NULL,
	[father_name] [varchar](100) NULL,
	[national_id] [varchar](50) NULL,
	[branch_id] [numeric](2, 0) NOT NULL,
	[birth_date] [datetime] NULL,
	[mailing_address] [varchar](250) NULL,
	[permanent_address] [varchar](250) NULL,
	[contact_no] [varchar](30) NULL,
	[ref1_details] [varchar](250) NULL,
	[ref2_details] [varchar](250) NULL,
	[department_id] [numeric](4, 0) NOT NULL,
	[joining_dt] [numeric](9, 0) NULL,
	[release_dt] [numeric](9, 0) NULL,
	[designation_id] [numeric](4, 0) NOT NULL,
	[gender_id] [numeric](4, 0) NOT NULL,
	[email_address] [varchar](50) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblEmployee_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblEmployee_is_dirty]  DEFAULT ((1)),
	[mother_name] [varchar](100) NULL,
	[photo] [image] NULL,
 CONSTRAINT [PK_tblEmployee] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BrokerManagement]
) ON [BrokerManagement] TEXTIMAGE_ON [BrokerManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [broker].[tblEmployeeUserMapping]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [broker].[tblEmployeeUserMapping](
	[id] [numeric](5, 0) IDENTITY(1,1) NOT NULL,
	[employee_id] [numeric](5, 0) NOT NULL,
	[user_id] [nvarchar](128) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblEmployeeUserMapping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BrokerManagement]
) ON [BrokerManagement]

GO
/****** Object:  Table [broker].[tblTrader]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [broker].[tblTrader](
	[id] [numeric](2, 0) IDENTITY(1,1) NOT NULL,
	[trader_code] [varchar](12) NOT NULL,
	[employee_id] [numeric](5, 0) NOT NULL,
	[ar_no] [varchar](30) NULL,
	[trade_work_station] [varchar](30) NULL,
	[license_renew_dt] [numeric](9, 0) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblTrader_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblTrader_is_dirty]  DEFAULT ((1)),
	[branch_id] [numeric](2, 0) NOT NULL,
	[Is_Default] [bit] NULL DEFAULT ((0)),
	[investor_range] [nvarchar](250) NULL,
 CONSTRAINT [PK_tblTrader] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BrokerManagement]
) ON [BrokerManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[08DP01UX]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[08DP01UX](
	[bo_code] [varchar](50) NULL,
	[operation_Type] [varchar](50) NULL,
	[column3] [varchar](50) NULL,
	[internal_Ref_No] [varchar](50) NULL,
	[first_holder_name] [varchar](150) NULL,
	[second_holder_name] [varchar](150) NULL,
	[column7] [varchar](50) NULL,
	[column8] [varchar](50) NULL,
	[gender] [varchar](50) NULL,
	[birth_date] [varchar](50) NULL,
	[column11] [varchar](50) NULL,
	[father_name] [varchar](150) NULL,
	[mother_name] [varchar](150) NULL,
	[occupation] [varchar](150) NULL,
	[res_flag] [varchar](100) NULL,
	[nationality] [varchar](50) NULL,
	[add1] [varchar](150) NULL,
	[add2] [varchar](150) NULL,
	[add3] [varchar](150) NULL,
	[city] [varchar](150) NULL,
	[state] [varchar](150) NULL,
	[country] [varchar](150) NULL,
	[post_code] [varchar](50) NULL,
	[phone] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[fax] [varchar](50) NULL,
	[column27] [varchar](50) NULL,
	[column28] [varchar](50) NULL,
	[column29] [varchar](50) NULL,
	[column30] [varchar](50) NULL,
	[passport_no] [varchar](50) NULL,
	[passport_issue_dt] [varchar](50) NULL,
	[passport_exp_dt] [varchar](50) NULL,
	[passport_issue_place] [varchar](100) NULL,
	[bank_name] [varchar](150) NULL,
	[bank_branch_name] [varchar](150) NULL,
	[bank_account_no] [varchar](50) NULL,
	[column38] [varchar](50) NULL,
	[column39] [varchar](50) NULL,
	[column40] [varchar](50) NULL,
	[column41] [varchar](50) NULL,
	[column42] [varchar](50) NULL,
	[bank_routing_No] [varchar](50) NULL,
	[column44] [varchar](50) NULL,
	[column45] [varchar](50) NULL,
	[column46] [varchar](50) NULL,
	[opening_date] [varchar](50) NULL,
	[membership_id] [numeric](9, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[11DP81UX]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[11DP81UX](
	[isin] [varchar](50) NULL,
	[company_name] [varchar](150) NULL,
	[column3] [varchar](50) NULL,
	[transferor_bo_code] [varchar](50) NULL,
	[transferor_bo_name] [varchar](150) NULL,
	[column6] [varchar](50) NULL,
	[column7] [varchar](50) NULL,
	[transfree_bo_code] [varchar](50) NULL,
	[transfree_bo_name] [varchar](150) NULL,
	[qty] [varchar](50) NULL,
	[column11] [varchar](50) NULL,
	[transaction_date] [varchar](50) NULL,
	[membership_id] [numeric](9, 0) NULL,
	[Rate] [numeric](25, 10) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[16DP95UX]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[16DP95UX](
	[isin] [varchar](50) NULL,
	[company_name] [varchar](150) NULL,
	[column3] [varchar](50) NULL,
	[trans_date] [varchar](50) NULL,
	[bo_code] [varchar](50) NULL,
	[bo_name] [varchar](150) NULL,
	[column7] [varchar](50) NULL,
	[column8] [varchar](50) NULL,
	[qty] [varchar](50) NULL,
	[lock_qty] [varchar](50) NULL,
	[column11] [varchar](50) NULL,
	[column12] [varchar](50) NULL,
	[transaction_date] [varchar](50) NULL,
	[membership_id] [numeric](9, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[17DP64UX]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[17DP64UX](
	[isin] [varchar](50) NULL,
	[company_name] [varchar](150) NULL,
	[seq_no] [varchar](50) NULL,
	[trans_ref] [varchar](50) NULL,
	[record_dt] [varchar](50) NULL,
	[effective_dt] [varchar](50) NULL,
	[cash_fraction_amt] [varchar](50) NULL,
	[cash_payment_dt] [varchar](50) NULL,
	[remarks] [varchar](150) NULL,
	[benifit_isin] [varchar](50) NULL,
	[benifit_company_name] [varchar](150) NULL,
	[par_ratio] [varchar](50) NULL,
	[ben_ratio] [varchar](50) NULL,
	[bo_code] [varchar](50) NULL,
	[bo_name] [varchar](150) NULL,
	[bo_holding] [varchar](50) NULL,
	[total_entitlement] [varchar](50) NULL,
	[dr_cr_flag] [varchar](50) NULL,
	[transaction_date] [varchar](50) NULL,
	[membership_id] [numeric](9, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[17DP70UX]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[17DP70UX](
	[isin] [varchar](50) NULL,
	[company_name] [varchar](150) NULL,
	[column3] [varchar](50) NULL,
	[share_transaction_type] [varchar](50) NULL,
	[from_date] [varchar](50) NULL,
	[to_date] [varchar](50) NULL,
	[column7] [varchar](50) NULL,
	[column8] [varchar](50) NULL,
	[column9] [varchar](50) NULL,
	[column10] [varchar](50) NULL,
	[bo_code] [varchar](50) NULL,
	[bo_name] [varchar](150) NULL,
	[column13] [varchar](50) NULL,
	[column14] [varchar](50) NULL,
	[qty] [varchar](50) NULL,
	[column16] [varchar](50) NULL,
	[column17] [varchar](50) NULL,
	[column18] [varchar](50) NULL,
	[transaction_date] [varchar](50) NULL,
	[rate] [varchar](20) NULL,
	[membership_id] [numeric](9, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[tblCdblBonusRights]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[tblCdblBonusRights](
	[bonus_rights_id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[isin] [varchar](12) NULL,
	[company_name] [varchar](150) NULL,
	[share_transaction_type] [varchar](6) NULL,
	[from_date] [varchar](50) NULL,
	[to_date] [varchar](50) NULL,
	[bo_code] [varchar](16) NULL,
	[bo_name] [varchar](150) NULL,
	[qty] [numeric](5, 0) NULL,
	[transaction_date] [varchar](50) NULL,
	[rate] [numeric](12, 4) NULL,
	[active_status_id] [int] NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblCdblBonusRights] PRIMARY KEY CLUSTERED 
(
	[bonus_rights_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[tblCdblBoRegistration]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[tblCdblBoRegistration](
	[registration_id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[bo_code] [varchar](16) NULL,
	[operation_type] [varchar](50) NULL,
	[internal_ref_no] [varchar](10) NULL,
	[first_holder_name] [varchar](150) NULL,
	[second_holder_name] [varchar](150) NULL,
	[gender] [varchar](20) NULL,
	[birth_date] [varchar](50) NULL,
	[father_name] [varchar](150) NULL,
	[mother_name] [varchar](150) NULL,
	[occupation] [varchar](150) NULL,
	[res_flag] [varchar](100) NULL,
	[nationality] [varchar](50) NULL,
	[add1] [varchar](100) NULL,
	[add2] [varchar](100) NULL,
	[add3] [varchar](100) NULL,
	[city] [varchar](100) NULL,
	[state] [varchar](100) NULL,
	[country] [varchar](100) NULL,
	[post_code] [varchar](50) NULL,
	[phone] [varchar](30) NULL,
	[email] [varchar](50) NULL,
	[fax] [varchar](50) NULL,
	[passport_no] [varchar](20) NULL,
	[passport_issue_dt] [varchar](50) NULL,
	[passport_exp_dt] [varchar](50) NULL,
	[passport_issue_place] [varchar](50) NULL,
	[bank_name] [varchar](50) NULL,
	[bank_branch_name] [varchar](50) NULL,
	[bank_account_no] [varchar](20) NULL,
	[bank_routing_no] [varchar](50) NULL,
	[opening_date] [varchar](50) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblCdblBoRegistration] PRIMARY KEY CLUSTERED 
(
	[registration_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[tblCdblDividendReceivable]    Script Date: 12/27/2015 7:46:15 PM ******/
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
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblCdblDividendReceivable] PRIMARY KEY CLUSTERED 
(
	[dividend_receivable_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[tblCdblIpo]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[tblCdblIpo](
	[ipo_id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[isin] [varchar](12) NULL,
	[company_name] [varchar](150) NULL,
	[trans_date] [varchar](50) NULL,
	[bo_code] [varchar](16) NULL,
	[bo_name] [varchar](150) NULL,
	[qty] [numeric](5, 0) NULL,
	[lock_qty] [numeric](5, 0) NULL,
	[transaction_date] [varchar](50) NULL,
	[active_status_id] [int] NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblCdblIpo] PRIMARY KEY CLUSTERED 
(
	[ipo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[tblCdblTransmission]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[tblCdblTransmission](
	[transmission_id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[isin] [varchar](12) NULL,
	[company_name] [varchar](150) NULL,
	[transferor_bo_code] [varchar](16) NULL,
	[transferor_bo_name] [varchar](150) NULL,
	[transfree_bo_code] [varchar](16) NULL,
	[transfree_bo_name] [varchar](150) NULL,
	[qty] [numeric](5, 0) NULL,
	[transaction_date] [varchar](50) NULL,
	[active_status_id] [int] NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
	[Rate] [numeric](25, 10) NULL,
 CONSTRAINT [PK_tblCdblTransmission] PRIMARY KEY CLUSTERED 
(
	[transmission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[tblPayinPayoutLog]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[tblPayinPayoutLog](
	[id] [numeric](10, 0) IDENTITY(1,1) NOT NULL,
	[is_payin_out] [varchar](1) NULL,
	[log_id] [numeric](6, 0) NOT NULL,
	[log_date] [numeric](9, 0) NOT NULL,
	[date] [datetime] NULL,
 CONSTRAINT [PK_tblPayinLog_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CDBL].[tmpInvalidUploadedData]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CDBL].[tmpInvalidUploadedData](
	[TABLE_NAME] [varchar](50) NULL,
	[ERROR_TITLE] [varchar](100) NULL,
	[ERROR_DETAILS] [nvarchar](max) NULL
) ON [CDBLManagement] TEXTIMAGE_ON [CDBLManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Charge].[tblBranchCharge]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Charge].[tblBranchCharge](
	[id] [numeric](3, 0) IDENTITY(1,1) NOT NULL,
	[branch_id] [numeric](2, 0) NOT NULL,
	[global_charge_id] [numeric](3, 0) NOT NULL,
	[charge_amount] [numeric](15, 10) NOT NULL,
	[is_percentage] [numeric](1, 0) NOT NULL,
	[is_slab] [numeric](1, 0) NOT NULL,
	[minimum_charge] [numeric](15, 10) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblBranchCharge] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ChargeManagement]
) ON [ChargeManagement]

GO
/****** Object:  Table [Charge].[tblBranchChargeSlab]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Charge].[tblBranchChargeSlab](
	[id] [numeric](2, 0) IDENTITY(1,1) NOT NULL,
	[branch_charge_id] [numeric](3, 0) NOT NULL,
	[amount_from] [numeric](30, 10) NOT NULL,
	[amount_to] [numeric](30, 10) NOT NULL,
	[charge_amount] [numeric](15, 10) NOT NULL,
	[is_percentage] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblBranchChargeSlab] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ChargeManagement]
) ON [ChargeManagement]

GO
/****** Object:  Table [Charge].[tblExchangeCharge]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Charge].[tblExchangeCharge](
	[id] [numeric](3, 0) IDENTITY(1,1) NOT NULL,
	[exchange_id] [numeric](3, 0) NOT NULL,
	[global_charge_id] [numeric](3, 0) NOT NULL,
	[charge_amount] [numeric](15, 10) NOT NULL,
	[is_percentage] [numeric](1, 0) NOT NULL,
	[is_slab] [numeric](1, 0) NOT NULL,
	[minimum_charge] [numeric](15, 10) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblExchangeCharge] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ChargeManagement]
) ON [ChargeManagement]

GO
/****** Object:  Table [Charge].[tblExchangeChargeSlab]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Charge].[tblExchangeChargeSlab](
	[id] [numeric](2, 0) IDENTITY(1,1) NOT NULL,
	[exchange_charge_id] [numeric](3, 0) NOT NULL,
	[amount_from] [numeric](30, 10) NOT NULL,
	[amount_to] [numeric](30, 10) NOT NULL,
	[charge_amount] [numeric](15, 10) NOT NULL,
	[is_percentage] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblExchangeChargeSlab] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ChargeManagement]
) ON [ChargeManagement]

GO
/****** Object:  Table [Charge].[tblGlobalCharge]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Charge].[tblGlobalCharge](
	[id] [numeric](3, 0) IDENTITY(1,1) NOT NULL,
	[short_code] [varchar](5) NOT NULL,
	[name] [varchar](150) NOT NULL,
	[charge_amount] [numeric](15, 10) NOT NULL,
	[minimum_charge] [numeric](15, 10) NOT NULL,
	[is_percentage] [numeric](1, 0) NOT NULL,
	[charge_type_id] [numeric](4, 0) NOT NULL,
	[effective_date] [numeric](9, 0) NOT NULL,
	[is_slab] [numeric](1, 0) NOT NULL,
	[income_account_no] [varchar](50) NOT NULL,
	[payable_account_no] [varchar](50) NULL,
	[payable_amount] [numeric](15, 10) NULL,
	[is_payable_percentage] [numeric](1, 0) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblGlobalCharge_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblGlobalCharge_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblGlobalCharge] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ChargeManagement]
) ON [ChargeManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Charge].[tblGlobalChargeSlab]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Charge].[tblGlobalChargeSlab](
	[id] [numeric](2, 0) IDENTITY(1,1) NOT NULL,
	[global_charge_id] [numeric](3, 0) NOT NULL,
	[amount_from] [numeric](30, 10) NOT NULL,
	[amount_to] [numeric](30, 10) NOT NULL,
	[charge_amount] [numeric](15, 10) NOT NULL,
	[is_percentage] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblGlobalChargeSlab] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ChargeManagement]
) ON [ChargeManagement]

GO
/****** Object:  Table [Charge].[tblInvestorCharge]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Charge].[tblInvestorCharge](
	[id] [numeric](9, 0) IDENTITY(1,1) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[global_charge_id] [numeric](3, 0) NOT NULL,
	[charge_amount] [numeric](15, 10) NOT NULL,
	[is_percentage] [numeric](1, 0) NOT NULL,
	[is_slab] [numeric](1, 0) NOT NULL,
	[minimum_charge] [numeric](15, 10) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblInvestorCharge_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblInvestorCharge_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblInvestorCharge] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ChargeManagement]
) ON [ChargeManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Charge].[tblInvestorChargeSlab]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Charge].[tblInvestorChargeSlab](
	[id] [numeric](2, 0) NOT NULL,
	[investor_charge_id] [numeric](9, 0) NOT NULL,
	[amount_from] [numeric](30, 10) NOT NULL,
	[amount_to] [numeric](30, 10) NOT NULL,
	[charge_amount] [numeric](15, 10) NOT NULL,
	[is_percentage] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblInvestorChargeSlab] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ChargeManagement]
) ON [ChargeManagement]

GO
/****** Object:  Table [Charge].[tblSubAccountCharge]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Charge].[tblSubAccountCharge](
	[id] [numeric](3, 0) IDENTITY(1,1) NOT NULL,
	[sub_account_id] [numeric](4, 0) NOT NULL,
	[global_charge_id] [numeric](3, 0) NOT NULL,
	[charge_amount] [numeric](15, 10) NOT NULL,
	[is_percentage] [numeric](1, 0) NOT NULL,
	[is_slab] [numeric](1, 0) NOT NULL,
	[minimum_charge] [numeric](15, 10) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblSubAccountCharge] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ChargeManagement]
) ON [ChargeManagement]

GO
/****** Object:  Table [Charge].[tblSubAccountChargeSlab]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Charge].[tblSubAccountChargeSlab](
	[id] [numeric](2, 0) IDENTITY(1,1) NOT NULL,
	[sub_account_charge_id] [numeric](3, 0) NOT NULL,
	[amount_from] [numeric](30, 10) NOT NULL,
	[amount_to] [numeric](30, 10) NOT NULL,
	[charge_amount] [numeric](15, 10) NOT NULL,
	[is_percentage] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblSubAccountChargeSlab] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ChargeManagement]
) ON [ChargeManagement]

GO
/****** Object:  Table [dbo].[DimDate]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimDate](
	[DateKey] [numeric](9, 0) NOT NULL,
	[Date] [datetime] NULL,
	[FullDateUK] [char](10) NULL,
	[FullDateUSA] [char](10) NULL,
	[DayOfMonth] [varchar](2) NULL,
	[DaySuffix] [varchar](4) NULL,
	[DayName] [varchar](9) NULL,
	[DayOfWeekUSA] [char](1) NULL,
	[DayOfWeekUK] [char](1) NULL,
	[DayOfWeekInMonth] [varchar](2) NULL,
	[DayOfWeekInYear] [varchar](2) NULL,
	[DayOfQuarter] [varchar](3) NULL,
	[DayOfYear] [varchar](3) NULL,
	[WeekOfMonth] [varchar](1) NULL,
	[WeekOfQuarter] [varchar](2) NULL,
	[WeekOfYear] [varchar](2) NULL,
	[Month] [varchar](2) NULL,
	[MonthName] [varchar](9) NULL,
	[MonthOfQuarter] [varchar](2) NULL,
	[Quarter] [char](1) NULL,
	[QuarterName] [varchar](9) NULL,
	[Year] [char](4) NULL,
	[YearName] [char](7) NULL,
	[MonthYear] [char](10) NULL,
	[MMYYYY] [char](6) NULL,
	[FirstDayOfMonth] [date] NULL,
	[LastDayOfMonth] [date] NULL,
	[FirstDayOfQuarter] [date] NULL,
	[LastDayOfQuarter] [date] NULL,
	[FirstDayOfYear] [date] NULL,
	[LastDayOfYear] [date] NULL,
	[IsHolidayUSA] [bit] NULL,
	[IsWeekday] [bit] NULL,
	[HolidayUSA] [varchar](50) NULL,
	[IsHolidayUK] [bit] NULL,
	[HolidayUK] [varchar](50) NULL,
	[IsHoliday] [bit] NULL,
	[Holiday] [varchar](50) NULL,
	[FiscalDayOfYear] [varchar](3) NULL,
	[FiscalWeekOfYear] [varchar](3) NULL,
	[FiscalMonth] [varchar](2) NULL,
	[FiscalQuarter] [char](1) NULL,
	[FiscalQuarterName] [varchar](9) NULL,
	[FiscalYear] [char](4) NULL,
	[FiscalYearName] [char](7) NULL,
	[FiscalMonthYear] [char](10) NULL,
	[FiscalMMYYYY] [char](6) NULL,
	[FiscalFirstDayOfMonth] [date] NULL,
	[FiscalLastDayOfMonth] [date] NULL,
	[FiscalFirstDayOfQuarter] [date] NULL,
	[FiscalLastDayOfQuarter] [date] NULL,
	[FiscalFirstDayOfYear] [date] NULL,
	[FiscalLastDayOfYear] [date] NULL,
	[FullDateCDBL] [varchar](11) NULL,
 CONSTRAINT [PK__DimDate__40DF45E37AC81A5F] PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblConstantObject]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblConstantObject](
	[object_id] [numeric](3, 0) IDENTITY(1,1) NOT NULL,
	[object_name] [varchar](100) NOT NULL,
	[Purpose] [varchar](150) NULL,
 CONSTRAINT [PK_tblConstantObject] PRIMARY KEY CLUSTERED 
(
	[object_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblConstantObjectValue]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblConstantObjectValue](
	[object_value_id] [numeric](4, 0) IDENTITY(85,1) NOT NULL,
	[display_value] [varchar](100) NOT NULL,
	[object_id] [numeric](3, 0) NOT NULL,
	[remarks] [varchar](150) NULL,
	[sorting_order] [smallint] NULL,
	[is_default] [numeric](1, 0) NULL,
 CONSTRAINT [PK_tblConstantObjectValue] PRIMARY KEY CLUSTERED 
(
	[object_value_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDayProcess]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDayProcess](
	[process_date] [numeric](9, 0) NOT NULL,
	[start_date] [datetime] NOT NULL,
	[start_by] [nvarchar](128) NOT NULL,
	[end_date] [datetime] NULL,
	[end_by] [nvarchar](128) NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
 CONSTRAINT [PK_tbldDayProcess] PRIMARY KEY CLUSTERED 
(
	[process_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tmpBank]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpBank](
	[routing_no] [varchar](20) NULL,
	[bank_name] [varchar](250) NULL,
	[branch_name] [varchar](250) NULL,
	[district] [varchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Instrument].[tblInstrument]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Instrument].[tblInstrument](
	[id] [numeric](4, 0) IDENTITY(1,1) NOT NULL,
	[isin] [varchar](12) NULL,
	[security_code] [varchar](20) NOT NULL,
	[instrument_name] [varchar](150) NULL,
	[sector_id] [numeric](4, 0) NOT NULL,
	[instument_type_id] [numeric](4, 0) NOT NULL,
	[depository_company_id] [numeric](4, 0) NOT NULL,
	[face_value] [numeric](12, 4) NOT NULL,
	[discount] [numeric](12, 4) NULL,
	[premium] [numeric](12, 4) NULL,
	[lot] [numeric](5, 0) NOT NULL,
	[is_marginable] [numeric](1, 0) NOT NULL,
	[group_id] [numeric](4, 0) NOT NULL,
	[closed_price] [numeric](12, 4) NULL,
	[is_foreign] [numeric](1, 0) NOT NULL,
	[authorized_capital] [numeric](24, 4) NULL,
	[paid_up_capital] [numeric](24, 4) NULL,
	[current_eps] [numeric](12, 4) NULL,
	[current_nav] [numeric](12, 4) NULL,
	[current_pe] [numeric](12, 4) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblInstrument_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblInstrument_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblInstrument] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InstrumentManagement]
) ON [InstrumentManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Instrument].[tblInstrumentFundamentalInfo]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Instrument].[tblInstrumentFundamentalInfo](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[instrument_id] [numeric](4, 0) NOT NULL,
	[effective_dt] [numeric](9, 0) NOT NULL,
	[eps] [numeric](12, 4) NOT NULL,
	[pe] [numeric](12, 4) NOT NULL,
	[nav] [numeric](12, 4) NOT NULL,
	[total_asset] [numeric](24, 4) NOT NULL,
	[total_liability] [numeric](24, 4) NOT NULL,
	[total_share] [numeric](24, 0) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblInstrumentFundamentalInfo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InstrumentManagement]
) ON [InstrumentManagement]

GO
/****** Object:  Table [Instrument].[tblInstrumentMarginabilityHistory]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Instrument].[tblInstrumentMarginabilityHistory](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[instrument_id] [numeric](4, 0) NOT NULL,
	[effective_dt] [numeric](9, 0) NOT NULL,
	[is_marginable] [numeric](1, 0) NOT NULL,
	[highest_rate] [numeric](12, 4) NULL,
	[percentage] [numeric](8, 4) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblInstrumentMarginabilityHistory] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InstrumentManagement]
) ON [InstrumentManagement]

GO
/****** Object:  Table [Investor].[tblAccountClosing]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblAccountClosing](
	[client_id] [varchar](10) NOT NULL,
	[closing_date] [numeric](9, 0) NOT NULL,
	[reason] [varchar](250) NOT NULL,
	[ledger_balance] [numeric](25, 4) NOT NULL,
	[available_balance] [numeric](25, 4) NOT NULL,
	[share_cost_value] [numeric](25, 4) NOT NULL,
	[share_market_value] [numeric](25, 4) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblAccountClosing] PRIMARY KEY CLUSTERED 
(
	[client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblIntroducer]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblIntroducer](
	[id] [numeric](3, 0) IDENTITY(1,1) NOT NULL,
	[ref_code] [varchar](20) NOT NULL,
	[introducer_name] [varchar](150) NOT NULL,
	[introducer_type_id] [numeric](4, 0) NOT NULL,
	[occupation_id] [numeric](4, 0) NULL,
	[contact_no] [varchar](30) NULL,
	[national_id] [varchar](20) NULL,
	[tin] [varchar](30) NULL,
	[remarks] [varchar](250) NULL,
	[commission_percentage] [numeric](4, 4) NOT NULL,
	[valid_from] [numeric](9, 0) NOT NULL,
	[valid_to] [numeric](9, 0) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblIntroducer_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblIntroducer_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblIntroducer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblInvestor]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblInvestor](
	[client_id] [varchar](10) NOT NULL,
	[bo_refernce_id] [numeric](3, 0) NULL,
	[bo_code] [varchar](16) NULL,
	[first_holder_name] [varchar](150) NOT NULL,
	[birth_date] [datetime] NULL,
	[gender_id] [numeric](4, 0) NULL,
	[national_id] [varchar](30) NULL,
	[passport_no] [varchar](20) NULL,
	[nibondhon_no] [varchar](20) NULL,
	[father_name] [varchar](150) NULL,
	[mother_name] [varchar](150) NULL,
	[account_type_id] [numeric](4, 0) NULL,
	[operation_type_id] [numeric](4, 0) NOT NULL,
	[sub_account_type_id] [numeric](4, 0) NULL,
	[mailing_address] [varchar](250) NULL,
	[permanent_address] [varchar](250) NULL,
	[thana_id] [numeric](4, 0) NULL,
	[district_id] [numeric](4, 0) NULL,
	[phone_no] [varchar](30) NULL,
	[mobile_no] [varchar](30) NULL,
	[email_address] [varchar](50) NULL,
	[bank_id] [numeric](3, 0) NULL,
	[bank_branch_id] [numeric](4, 0) NULL,
	[banc_account_no] [varchar](20) NULL,
	[beftn_enabled] [numeric](1, 0) NOT NULL,
	[email_enabled] [numeric](1, 0) NOT NULL,
	[internet_enabled] [numeric](1, 0) NOT NULL,
	[sms_enabled] [numeric](1, 0) NOT NULL,
	[branch_id] [numeric](2, 0) NOT NULL,
	[opening_date] [numeric](9, 0) NULL,
	[passport_issue_place] [varchar](50) NULL,
	[passport_issue_date] [datetime] NULL,
	[passport_valid_to_date] [datetime] NULL,
	[trader_id] [numeric](2, 0) NOT NULL,
	[introducer_id] [numeric](3, 0) NULL,
	[ipo_type_id] [numeric](4, 0) NOT NULL,
	[trade_type_id] [numeric](4, 0) NOT NULL,
	[omnibus_master_id] [varchar](10) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblInvestor_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblInvestor_is_dirty]  DEFAULT ((1)),
	[export_st] [numeric](1, 0) NULL,
	[export_log_id] [numeric](20, 0) NULL,
 CONSTRAINT [PK_tblInvestor] PRIMARY KEY CLUSTERED 
(
	[client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblInvestorFinancialLedger]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblInvestorFinancialLedger](
	[id] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[refference_no] [varchar](50) NULL,
	[transaction_type_id] [numeric](4, 0) NOT NULL,
	[narration] [varchar](250) NULL,
	[quantity] [numeric](15, 0) NULL,
	[rate] [numeric](30, 10) NULL,
	[amount] [numeric](30, 10) NULL,
	[comm_amount] [numeric](30, 10) NULL,
	[debit] [numeric](30, 10) NOT NULL,
	[credit] [numeric](30, 10) NOT NULL,
	[transaction_date] [numeric](9, 0) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK__tblInves__DE105D07EA7A11F5] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblInvestorFundBalance]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblInvestorFundBalance](
	[client_id] [varchar](10) NOT NULL,
	[transaction_date] [numeric](9, 0) NOT NULL,
	[account_type_id] [numeric](4, 0) NULL,
	[available_balance] [numeric](30, 10) NOT NULL,
	[sale_receivable] [numeric](30, 10) NOT NULL,
	[un_clear_cheque] [numeric](30, 10) NOT NULL,
	[ledger_balance] [numeric](30, 10) NOT NULL,
	[total_deposit] [numeric](30, 10) NOT NULL,
	[share_transfer_in] [numeric](30, 10) NOT NULL,
	[total_withdraw] [numeric](30, 10) NOT NULL,
	[share_transfer_out] [numeric](30, 10) NOT NULL,
	[realized_interest] [numeric](30, 10) NOT NULL,
	[realized_charge] [numeric](30, 10) NOT NULL,
	[accured_interest] [numeric](30, 10) NOT NULL,
	[fund_withdrawal_request] [numeric](30, 10) NOT NULL,
	[cost_value] [numeric](30, 10) NOT NULL,
	[market_value] [numeric](30, 10) NOT NULL,
	[equity] [numeric](30, 10) NOT NULL,
	[marginable_equity] [numeric](30, 10) NOT NULL,
	[sanction_amount] [numeric](30, 10) NOT NULL,
	[loan_ratio] [numeric](15, 10) NOT NULL,
	[purchase_power] [numeric](30, 10) NOT NULL,
	[max_withdraw_limit] [numeric](30, 10) NOT NULL,
	[excess_over_limit] [numeric](30, 10) NOT NULL,
	[realized_gain] [numeric](30, 10) NOT NULL,
	[unrealized_gain] [numeric](30, 10) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblClientFundBalance] PRIMARY KEY CLUSTERED 
(
	[client_id] ASC,
	[transaction_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblInvestorImage]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblInvestorImage](
	[client_id] [varchar](10) NOT NULL,
	[photo] [image] NULL,
	[signature] [image] NULL,
 CONSTRAINT [PK_tblInvestorImage] PRIMARY KEY CLUSTERED 
(
	[client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement] TEXTIMAGE_ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblInvestorShareBalance]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblInvestorShareBalance](
	[transaction_date] [numeric](9, 0) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[instrument_id] [numeric](4, 0) NOT NULL,
	[ledger_quantity] [numeric](15, 0) NOT NULL,
	[salable_quantity] [numeric](15, 0) NOT NULL,
	[ipo_receivable_quantity] [numeric](15, 0) NOT NULL,
	[bonus_receivable_quantity] [numeric](15, 0) NOT NULL,
	[lock_quantity] [numeric](15, 0) NOT NULL,
	[pledge_quantity] [numeric](15, 0) NOT NULL,
	[cost_average] [numeric](30, 10) NOT NULL,
	[cost_value] [numeric](30, 10) NOT NULL,
	[market_price] [numeric](30, 10) NOT NULL,
	[market_value] [numeric](30, 10) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblInvestorShareBalance_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblInvestorShareBalance_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblInvestorShareBalance] PRIMARY KEY CLUSTERED 
(
	[transaction_date] ASC,
	[client_id] ASC,
	[instrument_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblInvestorShareLedger]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblInvestorShareLedger](
	[id] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[instrument_id] [numeric](4, 0) NOT NULL,
	[transaction_date] [numeric](9, 0) NOT NULL,
	[opening_qty] [numeric](15, 0) NOT NULL,
	[opening_rate] [numeric](30, 10) NOT NULL,
	[opening_cost] [numeric](30, 10) NOT NULL,
	[received_qty] [numeric](15, 0) NOT NULL,
	[received_rate] [numeric](30, 10) NOT NULL,
	[received_cost] [numeric](30, 10) NOT NULL,
	[delivery_qty] [numeric](15, 0) NOT NULL,
	[delivery_rate] [numeric](30, 10) NOT NULL,
	[delivery_cost] [numeric](30, 10) NOT NULL,
	[sale_qty] [numeric](15, 0) NOT NULL,
	[sale_value] [numeric](30, 10) NOT NULL,
	[sale_commission] [numeric](30, 10) NOT NULL,
	[sale_rate] [numeric](30, 10) NOT NULL,
	[sale_amount] [numeric](30, 10) NOT NULL,
	[sale_cost_rate] [numeric](30, 10) NOT NULL,
	[sale_cost] [numeric](30, 10) NOT NULL,
	[gain_loss] [numeric](30, 10) NOT NULL,
	[remaining_qty] [numeric](15, 0) NOT NULL,
	[remaining_rate] [numeric](30, 10) NOT NULL,
	[remaining_cost] [numeric](30, 10) NOT NULL,
	[buy_qty] [numeric](15, 0) NOT NULL,
	[buy_cost] [numeric](30, 10) NOT NULL,
	[buy_commission] [numeric](30, 10) NOT NULL,
	[buy_rate] [numeric](30, 10) NOT NULL,
	[buy_amount] [numeric](30, 10) NOT NULL,
	[closing_qty] [numeric](15, 0) NOT NULL,
	[closing_rate] [numeric](30, 10) NOT NULL,
	[closing_cost] [numeric](30, 10) NOT NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblInvestorShareLedger] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblInvestorTemp]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblInvestorTemp](
	[client_id] [varchar](10) NOT NULL,
	[bo_refernce_id] [numeric](3, 0) NULL,
	[bo_code] [varchar](16) NULL,
	[first_holder_name] [varchar](150) NOT NULL,
	[second_joint_holder] [varchar](150) NULL,
	[birth_date] [datetime] NULL,
	[gender_id] [numeric](4, 0) NULL,
	[national_id] [varchar](30) NULL,
	[passport_no] [varchar](20) NULL,
	[nibondhon_no] [varchar](20) NULL,
	[father_name] [varchar](150) NULL,
	[mother_name] [varchar](150) NULL,
	[account_type_id] [numeric](4, 0) NULL,
	[operation_type_id] [numeric](4, 0) NOT NULL,
	[sub_account_type_id] [numeric](4, 0) NULL,
	[mailing_address] [varchar](250) NULL,
	[permanent_address] [varchar](250) NULL,
	[thana_id] [numeric](4, 0) NULL,
	[district_id] [numeric](4, 0) NULL,
	[phone_no] [varchar](30) NULL,
	[mobile_no] [varchar](30) NULL,
	[email_address] [varchar](50) NULL,
	[bank_id] [numeric](3, 0) NULL,
	[bank_branch_id] [numeric](4, 0) NULL,
	[banc_account_no] [varchar](20) NULL,
	[beftn_enabled] [numeric](1, 0) NOT NULL,
	[email_enabled] [numeric](1, 0) NOT NULL,
	[internet_enabled] [numeric](1, 0) NOT NULL,
	[sms_enabled] [numeric](1, 0) NOT NULL,
	[branch_id] [numeric](2, 0) NOT NULL,
	[opening_date] [numeric](9, 0) NULL,
	[passport_issue_place] [varchar](50) NULL,
	[passport_issue_date] [datetime] NULL,
	[passport_valid_to_date] [datetime] NULL,
	[trader_id] [numeric](2, 0) NOT NULL,
	[introducer_id] [numeric](3, 0) NULL,
	[ipo_type_id] [numeric](4, 0) NOT NULL,
	[trade_type_id] [numeric](4, 0) NOT NULL,
	[omnibus_master_id] [varchar](10) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL
) ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblJoinHolder]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblJoinHolder](
	[client_id] [varchar](10) NOT NULL,
	[join_holder_name] [varchar](150) NOT NULL,
	[father_name] [varchar](150) NULL,
	[mother_name] [varchar](150) NULL,
	[birth_date] [datetime] NULL,
	[gender_id] [numeric](4, 0) NULL,
	[photo] [image] NULL,
	[signature] [image] NULL,
	[active_status_id] [numeric](4, 0) NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblJoinHolder_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblJoinHolder_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblJoinHolder] PRIMARY KEY CLUSTERED 
(
	[client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement] TEXTIMAGE_ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblNominee]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblNominee](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[nominee_name] [varchar](150) NOT NULL,
	[father_name] [varchar](150) NULL,
	[mother_name] [varchar](150) NULL,
	[birth_date] [numeric](9, 0) NULL,
	[open_date] [numeric](9, 0) NULL,
	[gender_id] [numeric](4, 0) NULL,
	[relation_id] [numeric](4, 0) NULL,
	[gurdian_name] [varchar](150) NULL,
	[mailing_address] [varchar](250) NULL,
	[permanent_address] [varchar](250) NULL,
	[phone_no] [varchar](30) NULL,
	[mobile_no] [varchar](30) NULL,
	[email_address] [varchar](50) NULL,
	[equity_percentage] [numeric](8, 4) NULL,
	[photo] [image] NULL,
	[signature] [image] NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblNominee_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblNominee_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblNominee] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement] TEXTIMAGE_ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblOmnibus]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblOmnibus](
	[omnibus_id] [varchar](10) NOT NULL,
	[name] [varchar](150) NOT NULL,
	[short_name] [varchar](4) NOT NULL,
	[contact_person] [varchar](150) NULL,
	[contact_no] [varchar](30) NULL,
	[address] [varchar](250) NULL,
	[email] [varchar](50) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblOmnibus_changed_date]  DEFAULT (getdate()),
	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblOmnibus_is_dirty]  DEFAULT ((1)),
 CONSTRAINT [PK_tblOmnibus] PRIMARY KEY CLUSTERED 
(
	[omnibus_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Investor].[tblPowerOfAtornee]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Investor].[tblPowerOfAtornee](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[poa_name] [varchar](150) NOT NULL,
	[father_name] [varchar](150) NULL,
	[mother_name] [varchar](150) NULL,
	[birth_date] [numeric](9, 0) NULL,
	[open_date] [numeric](9, 0) NOT NULL,
	[valid_from_date] [numeric](9, 0) NOT NULL,
	[valid_to_date] [numeric](9, 0) NULL,
	[authorized_trade] [numeric](1, 0) NULL,
	[authorized_instrument_withdrawal] [numeric](1, 0) NULL,
	[authorized_fund_withdrawal_request] [numeric](1, 0) NULL,
	[gender_id] [numeric](4, 0) NULL,
	[relation_id] [numeric](4, 0) NOT NULL,
	[gurdian_name] [varchar](150) NULL,
	[mailing_address] [varchar](250) NULL,
	[permanent_address] [varchar](250) NULL,
	[phone_no] [varchar](30) NULL,
	[mobile_no] [varchar](30) NULL,
	[email_address] [varchar](50) NULL,
	[equity_percentage] [numeric](8, 4) NULL,
	[photo] [image] NULL,
	[signature] [image] NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblPowerOfAtornee] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InvestorManagement]
) ON [InvestorManagement] TEXTIMAGE_ON [InvestorManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Trade].[tblClosingPrice]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Trade].[tblClosingPrice](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[security_code] [varchar](15) NOT NULL,
	[open_price] [numeric](9, 4) NULL,
	[high_price] [numeric](9, 4) NULL,
	[low_price] [numeric](9, 4) NULL,
	[closing_price] [numeric](9, 4) NOT NULL,
	[group_id] [numeric](3, 0) NULL,
	[trans_dt] [numeric](9, 0) NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[var] [numeric](9, 4) NULL,
	[var_percent] [numeric](9, 4) NULL,
	[active_status] [numeric](3, 0) NOT NULL,
 CONSTRAINT [PK_tblClosingPrice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Trade].[tblFTExportLog]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Trade].[tblFTExportLog](
	[log_id] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[file_type] [varchar](20) NOT NULL,
	[file_name] [varchar](120) NOT NULL,
	[export_dt] [numeric](9, 0) NOT NULL,
	[version_no] [numeric](5, 0) NOT NULL,
	[success] [varchar](50) NULL,
	[wrong] [varchar](50) NULL,
	[membership_id] [numeric](9, 0) NULL,
 CONSTRAINT [PK_tblFTExportLog] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Trade].[tblFTImportLog]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Trade].[tblFTImportLog](
	[log_id] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[file_type] [varchar](20) NOT NULL,
	[file_name] [varchar](120) NOT NULL,
	[import_dt] [numeric](9, 0) NOT NULL,
	[version_no] [numeric](18, 0) NOT NULL,
	[success] [varchar](50) NULL,
	[wrong] [varchar](50) NULL,
	[export_st] [numeric](1, 0) NULL,
	[export_log_id] [numeric](20, 0) NULL,
	[membership_id] [numeric](9, 0) NULL,
	[omnibus_master_id] [varchar](10) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Trade].[tblFTLimits]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Trade].[tblFTLimits](
	[ClientCode] [varchar](10) NULL,
	[Cash] [varchar](50) NULL,
	[MaxCapitalBuy] [varchar](50) NULL,
	[MaxCapitalSell] [varchar](50) NULL,
	[TotalTransaction] [varchar](50) NULL,
	[NetTransaction] [varchar](50) NULL,
	[Deposit] [varchar](50) NULL,
	[MarginRatio] [numeric](18, 0) NULL,
	[acc_Type_S_Name] [varchar](5) NULL,
	[import_type] [varchar](1) NULL,
	[import_log_id] [numeric](20, 0) NULL,
	[log_id] [numeric](20, 0) NULL,
	[line_no] [numeric](20, 0) NULL,
	[status] [varchar](8) NULL,
	[failed_reason] [nvarchar](max) NULL,
	[membership_id] [numeric](9, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [TradeManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Trade].[tblFTLimitsTemp]    Script Date: 12/27/2015 7:46:15 PM ******/
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
/****** Object:  Table [Trade].[tblFTPositions]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Trade].[tblFTPositions](
	[ClientCode] [varchar](10) NULL,
	[SecurityCode] [varchar](50) NULL,
	[ISIN] [varchar](12) NULL,
	[Quantity] [varchar](50) NULL,
	[TotalCost] [varchar](100) NULL,
	[PositionType] [varchar](10) NULL,
	[import_type] [varchar](1) NULL,
	[import_log_id] [numeric](20, 0) NULL,
	[log_id] [numeric](20, 0) NULL,
	[line_no] [numeric](20, 0) NULL,
	[status] [varchar](8) NULL,
	[failed_reason] [nvarchar](max) NULL,
	[membership_id] [numeric](9, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [TradeManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Trade].[tblFTPositionsTemp]    Script Date: 12/27/2015 7:46:15 PM ******/
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
/****** Object:  Table [Trade].[tblNonTradingDetail]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Trade].[tblNonTradingDetail](
	[Id] [numeric](10, 0) IDENTITY(1,1) NOT NULL,
	[non_trading_date] [numeric](9, 0) NOT NULL,
	[master_id] [int] NOT NULL,
 CONSTRAINT [PK_Trade.tblNonTradingDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [TradeManagement]
) ON [TradeManagement]

GO
/****** Object:  Table [Trade].[tblNonTradingMaster]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Trade].[tblNonTradingMaster](
	[Id] [numeric](10, 0) IDENTITY(1,1) NOT NULL,
	[from_date] [numeric](9, 0) NOT NULL,
	[to_date] [numeric](9, 0) NOT NULL,
	[non_trading_type_id] [numeric](4, 0) NOT NULL,
	[input_info] [varchar](150) NULL,
	[remarks] [varchar](150) NULL,
	[active_status_id] [numeric](4, 0) NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblNonTradeMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Trade].[tblSettlementSchedule]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Trade].[tblSettlementSchedule](
	[id] [numeric](9, 0) IDENTITY(1,1) NOT NULL,
	[stock_exchange_id] [numeric](4, 0) NOT NULL,
	[market_type_id] [numeric](4, 0) NOT NULL,
	[instrument_group_id] [numeric](4, 0) NOT NULL,
	[trade_date] [numeric](9, 0) NOT NULL,
	[settle_date] [numeric](9, 0) NOT NULL,
 CONSTRAINT [PK_tblSettlementSchedule] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [TradeManagement]
) ON [TradeManagement]

GO
/****** Object:  Table [Trade].[tblTradeData]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Trade].[tblTradeData](
	[trade_id] [numeric](10, 0) IDENTITY(1,1) NOT NULL,
	[instrument_id] [numeric](4, 0) NOT NULL,
	[AssetClass] [varchar](15) NOT NULL,
	[OrderId] [varchar](10) NOT NULL,
	[transaction_type] [varchar](3) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[stock_exchange_id] [numeric](4, 0) NULL,
	[market_type_id] [numeric](4, 0) NOT NULL,
	[Date] [numeric](9, 0) NOT NULL,
	[Time] [varchar](8) NOT NULL,
	[Quantity] [numeric](15, 0) NULL,
	[Unit_Price] [numeric](30, 10) NULL,
	[ExecID] [varchar](15) NOT NULL,
	[FillType] [varchar](15) NULL,
	[group_id] [numeric](4, 0) NULL,
	[CompulsorySpot] [varchar](3) NULL,
	[TraderDealerID] [varchar](10) NOT NULL,
	[OwnerDealerID] [varchar](10) NULL,
	[commission_rate] [numeric](30, 10) NULL,
	[commission_amount] [numeric](30, 10) NULL CONSTRAINT [DF_tblTradeData_commission_amount]  DEFAULT ((0)),
	[transaction_fee] [numeric](30, 10) NULL,
	[ait] [numeric](30, 10) NULL,
	[trader_branch_id] [numeric](2, 0) NULL,
	[client_branch_id] [numeric](2, 0) NOT NULL,
	[membership_id] [numeric](9, 0) NULL,
	[changed_user_id] [nvarchar](128) NULL,
	[changed_date] [datetime] NULL,
 CONSTRAINT [PK_tblTradeData] PRIMARY KEY CLUSTERED 
(
	[trade_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Trade].[tmpClosePriceData]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Trade].[tmpClosePriceData](
	[SecurityCode] [varchar](15) NULL,
	[ISIN] [varchar](12) NULL,
	[AssetClass] [varchar](5) NULL,
	[CompulsorySpot] [varchar](5) NULL,
	[TradeDate] [numeric](8, 0) NULL,
	[Close] [numeric](9, 5) NULL,
	[Open] [numeric](9, 5) NULL,
	[High] [numeric](9, 5) NULL,
	[Low] [numeric](9, 5) NULL,
	[Var] [numeric](9, 5) NULL,
	[VarPercent] [numeric](9, 5) NULL,
	[Category] [varchar](5) NULL,
	[Sector] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Trade].[tmpTradeData]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Trade].[tmpTradeData](
	[Action] [varchar](10) NULL,
	[Status] [varchar](15) NULL,
	[Isin] [varchar](12) NULL,
	[AssetClass] [varchar](15) NULL,
	[OrderId] [varchar](10) NULL,
	[ReOrderId] [varchar](10) NULL,
	[Side] [varchar](3) NULL,
	[BoId] [varchar](16) NULL,
	[SecurityCode] [varchar](15) NULL,
	[Board] [varchar](15) NULL,
	[Date] [decimal](8, 0) NULL,
	[Time] [varchar](8) NULL,
	[Quantity] [decimal](10, 0) NULL,
	[Price] [decimal](20, 6) NULL,
	[Value] [decimal](20, 6) NULL,
	[ExecID] [varchar](15) NULL,
	[Session] [varchar](15) NULL,
	[FillType] [varchar](15) NULL,
	[Category] [varchar](3) NULL,
	[CompulsorySpot] [varchar](3) NULL,
	[ClientCode] [varchar](10) NULL,
	[TraderDealerID] [varchar](10) NULL,
	[OwnerDealerID] [varchar](10) NULL,
	[TradeReportType] [varchar](10) NULL,
	[Id] [numeric](4, 0) IDENTITY(1,1) NOT NULL,
	[Comission] [decimal](10, 4) NULL,
	[membership_id] [numeric](9, 0) NULL,
 CONSTRAINT [PK_tmpTradeData] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Transaction].[tblForceChargeApply]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Transaction].[tblForceChargeApply](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[charge_id] [numeric](3, 0) NOT NULL,
	[transaction_type_id] [numeric](4, 0) NOT NULL,
	[amount] [numeric](30, 10) NOT NULL,
	[transaction_date] [numeric](9, 0) NOT NULL,
	[value_date] [numeric](9, 0) NOT NULL,
	[remarks] [varchar](250) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
	[approve_by] [varchar](128) NULL,
	[approve_date] [numeric](9, 0) NULL,
 CONSTRAINT [PK_tblForceChargeApply] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [TransactionManagement]
) ON [TransactionManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Transaction].[tblForceChargeApplyTemp]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Transaction].[tblForceChargeApplyTemp](
	[client_id] [varchar](50) NULL,
	[bo_code] [varchar](56) NULL,
	[amount] [varchar](10) NULL,
	[remarks] [varchar](250) NULL,
	[is_processed] [numeric](1, 0) NULL
) ON [TransactionManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Transaction].[tblFundReceive]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Transaction].[tblFundReceive](
	[id] [numeric](8, 0) IDENTITY(1,1) NOT NULL,
	[voucher_no] [varchar](15) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[transaction_mode_id] [numeric](4, 0) NOT NULL,
	[bank_id] [numeric](3, 0) NULL,
	[bank_branch_name] [varchar](150) NULL,
	[cheque_no] [varchar](15) NULL,
	[cheque_date] [numeric](9, 0) NULL,
	[amount] [numeric](30, 10) NOT NULL,
	[doc_ref_no] [varchar](10) NULL,
	[receive_date] [numeric](9, 0) NOT NULL,
	[value_date] [numeric](9, 0) NULL,
	[broker_branch_id] [numeric](2, 0) NOT NULL,
	[remarks] [varchar](250) NULL,
	[approve_by] [varchar](128) NULL,
	[approve_date] [numeric](9, 0) NULL,
	[deposit_by] [varchar](128) NULL,
	[deposit_date] [numeric](9, 0) NULL,
	[clear_by] [varchar](128) NULL,
	[clear_date] [numeric](9, 0) NULL,
	[dishonor_by] [varchar](128) NULL,
	[dishonor_date] [numeric](9, 0) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
	[deposit_bank_branch_id] [numeric](18, 0) NULL,
 CONSTRAINT [PK_tblFundReceive] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [TransactionManagement]
) ON [TransactionManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Transaction].[tblFundTransfer]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Transaction].[tblFundTransfer](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[transferor_id] [varchar](10) NOT NULL,
	[transferor_balance] [numeric](30, 10) NOT NULL,
	[tranferee_id] [varchar](10) NOT NULL,
	[transferee_balance] [numeric](30, 10) NOT NULL,
	[transfer_date] [numeric](9, 0) NOT NULL,
	[value_date] [numeric](9, 0) NULL,
	[amount] [numeric](30, 10) NOT NULL,
	[remarks] [varchar](250) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblFundTransfer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [TransactionManagement]
) ON [TransactionManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Transaction].[tblFundWithdraw]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Transaction].[tblFundWithdraw](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[voucher_no] [varchar](15) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[transaction_mode_id] [numeric](4, 0) NOT NULL,
	[bank_branch_id] [numeric](4, 0) NULL,
	[cheque_no] [varchar](15) NULL,
	[cheque_date] [numeric](9, 0) NULL,
	[amount] [numeric](30, 10) NOT NULL,
	[withdraw_date] [numeric](9, 0) NOT NULL,
	[value_date] [numeric](9, 0) NOT NULL,
	[broker_branch_id] [numeric](2, 0) NOT NULL,
	[remarks] [varchar](250) NULL,
	[approve_by] [varchar](128) NULL,
	[approve_date] [numeric](9, 0) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblFundWithdraw] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [TransactionManagement]
) ON [TransactionManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Transaction].[tblFundWithdrawalRequest]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Transaction].[tblFundWithdrawalRequest](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[voucher_no] [varchar](15) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[transaction_mode_id] [numeric](4, 0) NOT NULL,
	[bank_branch_id] [numeric](4, 0) NULL,
	[cheque_no] [varchar](15) NULL,
	[cheque_date] [numeric](9, 0) NULL,
	[amount] [numeric](30, 10) NOT NULL,
	[request_date] [numeric](9, 0) NOT NULL,
	[effective_date] [numeric](9, 0) NOT NULL,
	[broker_branch_id] [numeric](2, 0) NOT NULL,
	[remarks] [varchar](250) NULL,
	[approve_by] [varchar](128) NULL,
	[approve_date] [numeric](9, 0) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblFundWithdrawalRequest] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [TransactionManagement]
) ON [TransactionManagement]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [Charge].[vw_all_investors_charges]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Charge].[vw_all_investors_charges]
AS
WITH cte AS (SELECT        client_id, global_charge_id, charge_amount, is_percentage, minimum_charge, 1 AS short_order
                             FROM            Charge.tblInvestorCharge
                             UNION ALL
                             SELECT        ti.client_id, tsc.global_charge_id, tsc.charge_amount, tsc.is_percentage, tsc.minimum_charge, 2 AS Expr1
                             FROM            Charge.tblSubAccountCharge AS tsc INNER JOIN
                                                      dbo.tblConstantObjectValue AS tcov ON tsc.sub_account_id = tcov.object_value_id INNER JOIN
                                                      Investor.tblInvestor AS ti ON tcov.object_value_id = ti.sub_account_type_id
                             WHERE        (tcov.object_id = 186)
                             UNION ALL
                             SELECT        ti.client_id, tbc.global_charge_id, tbc.charge_amount, tbc.is_percentage, tbc.minimum_charge, 3 AS Expr1
                             FROM            Charge.tblBranchCharge AS tbc INNER JOIN
                                                      Investor.tblInvestor AS ti ON tbc.branch_id = ti.branch_id
                             UNION ALL
                             SELECT        Investor.tblInvestor.client_id, Charge.tblGlobalCharge.id AS global_charge_id, Charge.tblGlobalCharge.charge_amount, Charge.tblGlobalCharge.is_percentage, 
                                                      Charge.tblGlobalCharge.minimum_charge, 4 AS Expr1
                             FROM            Investor.tblInvestor CROSS JOIN
                                                      Charge.tblGlobalCharge)
    SELECT        TOP (100) PERCENT client_id, global_charge_id, charge_amount, is_percentage, minimum_charge
     FROM            cte AS c
     WHERE        (short_order =
                                  (SELECT        MIN(short_order) AS Expr1
                                    FROM            cte AS e
                                    WHERE        (client_id = c.client_id) AND (global_charge_id = c.global_charge_id) AND (short_order <= c.short_order)))


GO
/****** Object:  View [Investor].[vw_InvestorFundBalance]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Investor].[vw_InvestorFundBalance]
AS
select * from 
investor.tblInvestorFundBalance IFB
WHERE
IFB.transaction_date=(
		        SELECT MAX(IFB2.transaction_date)
		        FROM
			 Investor.tblInvestorFundBalance IFB2 
		        WHERE
			 IFB2.client_id=IFB.client_id
			 AND IFB2.transaction_date<=[dbo].[sfun_get_process_date]()
		      )



GO
/****** Object:  View [Investor].[vw_InvestorShareBalance]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Investor].[vw_InvestorShareBalance]
AS
SELECT * 
FROM 
[Investor].[tblInvestorShareBalance] ISB
WHERE
ISB.transaction_date=(
						SELECT MAX(ISB2.transaction_date)
						FROM
							[Investor].[tblInvestorShareBalance] ISB2
						WHERE
							ISB2.client_id=ISB.client_id
							AND ISB2.instrument_id=ISB.instrument_id
							AND ISB2.transaction_date<=[dbo].[sfun_get_process_date]()
						)



GO
/****** Object:  View [Trade].[vw_today_maturity]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Trade].[vw_today_maturity]
AS
SELECT        TTD.instrument_id, TTD.client_id, TTD.transaction_type, TTD.market_type_id, TTD.Date, TTD.Quantity, TTD.Unit_Price, TTD.TraderDealerID, TTD.OwnerDealerID, TTD.commission_rate, TTD.commission_amount, 
                         TTD.group_id, TTD.transaction_fee, TTD.ait, TTD.membership_id, TSS.settle_date
FROM            Trade.tblTradeData AS TTD INNER JOIN
                         Trade.tblSettlementSchedule AS TSS ON TTD.market_type_id = TSS.market_type_id AND TTD.group_id = TSS.instrument_group_id AND TTD.Date = TSS.trade_date AND TTD.stock_exchange_id=TSS.stock_exchange_id
WHERE        (TSS.settle_date = dbo.sfun_get_process_date())





GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_tblEmployeeUserMapping]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblEmployeeUserMapping] ON [broker].[tblEmployeeUserMapping]
(
	[employee_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BrokerManagement]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_tblInstrument_securitycode]    Script Date: 12/27/2015 7:46:15 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblInstrument_securitycode] ON [Instrument].[tblInstrument]
(
	[security_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [broker].[tblBrokerBankAccount] ADD  CONSTRAINT [DF_tblBrokerBankAccount_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [broker].[tblBrokerBankAccount] ADD  CONSTRAINT [DF_tblBrokerBankAccount_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [broker].[tblBrokerBankAccount] ADD  DEFAULT ((0)) FOR [is_default]
GO
ALTER TABLE [broker].[tblEmployeeUserMapping] ADD  CONSTRAINT [DF_tblEmployeeUserMapping_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [broker].[tblEmployeeUserMapping] ADD  CONSTRAINT [DF_tblEmployeeUserMapping_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [CDBL].[17DP70UX] ADD  CONSTRAINT [DF_17DP70UX_rate]  DEFAULT ((0)) FOR [rate]
GO
ALTER TABLE [CDBL].[tblCdblBonusRights] ADD  CONSTRAINT [DF_tblCdblBonusRights_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [CDBL].[tblCdblBoRegistration] ADD  CONSTRAINT [DF_tblCdblBoRegistration_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [CDBL].[tblCdblDividendReceivable] ADD  CONSTRAINT [DF_tblCdblDividendReceivable_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [CDBL].[tblCdblIpo] ADD  CONSTRAINT [DF_tblCdblIpo_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [CDBL].[tblCdblTransmission] ADD  CONSTRAINT [DF_tblCdblTransmission_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Charge].[tblBranchCharge] ADD  CONSTRAINT [DF_tblBranchCharge_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Charge].[tblBranchCharge] ADD  CONSTRAINT [DF_tblBranchCharge_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Charge].[tblExchangeCharge] ADD  CONSTRAINT [DF_tblExchangeCharge_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Charge].[tblExchangeCharge] ADD  CONSTRAINT [DF_tblExchangeCharge_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Charge].[tblSubAccountCharge] ADD  CONSTRAINT [DF_tblSubAccountCharge_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Charge].[tblSubAccountCharge] ADD  CONSTRAINT [DF_tblSubAccountCharge_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Instrument].[tblInstrumentFundamentalInfo] ADD  CONSTRAINT [DF_tblInstrumentFundamentalInfo_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Instrument].[tblInstrumentFundamentalInfo] ADD  CONSTRAINT [DF_tblInstrumentFundamentalInfo_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Instrument].[tblInstrumentMarginabilityHistory] ADD  CONSTRAINT [DF_tblInstrumentMarginabilityHistory_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Instrument].[tblInstrumentMarginabilityHistory] ADD  CONSTRAINT [DF_tblInstrumentMarginabilityHistory_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Investor].[tblAccountClosing] ADD  CONSTRAINT [DF_tblAccountClosing_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Investor].[tblAccountClosing] ADD  CONSTRAINT [DF_tblAccountClosing_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Investor].[tblInvestorFundBalance] ADD  CONSTRAINT [DF_tblInvestorFundBalance_ledger_balance]  DEFAULT ((0)) FOR [ledger_balance]
GO
ALTER TABLE [Investor].[tblInvestorFundBalance] ADD  CONSTRAINT [DF_tblClientFundBalance_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Investor].[tblInvestorFundBalance] ADD  CONSTRAINT [DF_tblClientFundBalance_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Investor].[tblInvestorTemp] ADD  CONSTRAINT [DF_tblInvestorTemp_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Investor].[tblInvestorTemp] ADD  CONSTRAINT [DF_tblInvestorTemp_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Investor].[tblPowerOfAtornee] ADD  CONSTRAINT [DF_tblPowerOfAtornee_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Investor].[tblPowerOfAtornee] ADD  CONSTRAINT [DF_tblPowerOfAtornee_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Trade].[tmpTradeData] ADD  CONSTRAINT [DF_tmpTradeData_Comission]  DEFAULT ((0)) FOR [Comission]
GO
ALTER TABLE [Transaction].[tblForceChargeApply] ADD  CONSTRAINT [DF_tblForceChargeApply_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Transaction].[tblForceChargeApply] ADD  CONSTRAINT [DF_tblForceChargeApply_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Transaction].[tblForceChargeApplyTemp] ADD  CONSTRAINT [DF_tblForceChargeApplyTemp_is_processed]  DEFAULT ((0)) FOR [is_processed]
GO
ALTER TABLE [Transaction].[tblFundReceive] ADD  CONSTRAINT [DF_tblFundReceive_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Transaction].[tblFundReceive] ADD  CONSTRAINT [DF_tblFundReceive_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Transaction].[tblFundTransfer] ADD  CONSTRAINT [DF_tblFundTransfer_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Transaction].[tblFundTransfer] ADD  CONSTRAINT [DF_tblFundTransfer_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Transaction].[tblFundWithdraw] ADD  CONSTRAINT [DF_tblFundWithdraw_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Transaction].[tblFundWithdraw] ADD  CONSTRAINT [DF_tblFundWithdraw_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest] ADD  CONSTRAINT [DF_tblFundWithdrawalRequest_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest] ADD  CONSTRAINT [DF_tblFundWithdrawalRequest_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO
ALTER TABLE [Accounting].[tblBankBranch]  WITH CHECK ADD  CONSTRAINT [FK_tblBankBranch_tblBank] FOREIGN KEY([bank_id])
REFERENCES [Accounting].[tblBank] ([id])
GO
ALTER TABLE [Accounting].[tblBankBranch] CHECK CONSTRAINT [FK_tblBankBranch_tblBank]
GO
ALTER TABLE [broker].[tblBrokerBankAccount]  WITH CHECK ADD  CONSTRAINT [FK_tblBrokerBankAccount_tblBankBranch] FOREIGN KEY([bank_branch_id])
REFERENCES [Accounting].[tblBankBranch] ([id])
GO
ALTER TABLE [broker].[tblBrokerBankAccount] CHECK CONSTRAINT [FK_tblBrokerBankAccount_tblBankBranch]
GO
ALTER TABLE [broker].[tblBrokerBranch]  WITH CHECK ADD  CONSTRAINT [FK_tblBrokerBranch_BrokerBranchRegistrationDate] FOREIGN KEY([registration_dt])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [broker].[tblBrokerBranch] CHECK CONSTRAINT [FK_tblBrokerBranch_BrokerBranchRegistrationDate]
GO
ALTER TABLE [broker].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_EmployeeDepartment] FOREIGN KEY([department_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [broker].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_EmployeeDepartment]
GO
ALTER TABLE [broker].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_EmployeeDesignation] FOREIGN KEY([designation_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [broker].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_EmployeeDesignation]
GO
ALTER TABLE [broker].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_EmployeeGender] FOREIGN KEY([gender_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [broker].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_EmployeeGender]
GO
ALTER TABLE [broker].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_EmployeeJoiningDate] FOREIGN KEY([joining_dt])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [broker].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_EmployeeJoiningDate]
GO
ALTER TABLE [broker].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_EmployeeReleaseDate] FOREIGN KEY([release_dt])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [broker].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_EmployeeReleaseDate]
GO
ALTER TABLE [broker].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_tblBrokerBranch] FOREIGN KEY([branch_id])
REFERENCES [broker].[tblBrokerBranch] ([id])
GO
ALTER TABLE [broker].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_tblBrokerBranch]
GO
ALTER TABLE [broker].[tblEmployeeUserMapping]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployeeUserMapping_tblEmployee] FOREIGN KEY([employee_id])
REFERENCES [broker].[tblEmployee] ([id])
GO
ALTER TABLE [broker].[tblEmployeeUserMapping] CHECK CONSTRAINT [FK_tblEmployeeUserMapping_tblEmployee]
GO
ALTER TABLE [broker].[tblTrader]  WITH CHECK ADD  CONSTRAINT [FK_tblTrader_tblEmployee] FOREIGN KEY([employee_id])
REFERENCES [broker].[tblEmployee] ([id])
GO
ALTER TABLE [broker].[tblTrader] CHECK CONSTRAINT [FK_tblTrader_tblEmployee]
GO
ALTER TABLE [broker].[tblTrader]  WITH CHECK ADD  CONSTRAINT [FK_tblTrader_TraderLicenseRenewDate] FOREIGN KEY([license_renew_dt])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [broker].[tblTrader] CHECK CONSTRAINT [FK_tblTrader_TraderLicenseRenewDate]
GO
ALTER TABLE [CDBL].[tblPayinPayoutLog]  WITH CHECK ADD  CONSTRAINT [FK_tblPayinLog_DimDate] FOREIGN KEY([log_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [CDBL].[tblPayinPayoutLog] CHECK CONSTRAINT [FK_tblPayinLog_DimDate]
GO
ALTER TABLE [Charge].[tblBranchCharge]  WITH CHECK ADD  CONSTRAINT [FK_tblBranchCharge_tblBrokerBranch] FOREIGN KEY([branch_id])
REFERENCES [broker].[tblBrokerBranch] ([id])
GO
ALTER TABLE [Charge].[tblBranchCharge] CHECK CONSTRAINT [FK_tblBranchCharge_tblBrokerBranch]
GO
ALTER TABLE [Charge].[tblBranchCharge]  WITH CHECK ADD  CONSTRAINT [FK_tblBranchCharge_tblGlobalCharge] FOREIGN KEY([global_charge_id])
REFERENCES [Charge].[tblGlobalCharge] ([id])
GO
ALTER TABLE [Charge].[tblBranchCharge] CHECK CONSTRAINT [FK_tblBranchCharge_tblGlobalCharge]
GO
ALTER TABLE [Charge].[tblBranchChargeSlab]  WITH CHECK ADD  CONSTRAINT [FK_tblBranchChargeSlab_tblBranchCharge] FOREIGN KEY([branch_charge_id])
REFERENCES [Charge].[tblBranchCharge] ([id])
GO
ALTER TABLE [Charge].[tblBranchChargeSlab] CHECK CONSTRAINT [FK_tblBranchChargeSlab_tblBranchCharge]
GO
ALTER TABLE [Charge].[tblExchangeCharge]  WITH CHECK ADD  CONSTRAINT [FK_tblExchangeCharge_tblGlobalCharge] FOREIGN KEY([id])
REFERENCES [Charge].[tblGlobalCharge] ([id])
GO
ALTER TABLE [Charge].[tblExchangeCharge] CHECK CONSTRAINT [FK_tblExchangeCharge_tblGlobalCharge]
GO
ALTER TABLE [Charge].[tblExchangeChargeSlab]  WITH CHECK ADD  CONSTRAINT [FK_tblExchangeChargeSlab_tblExchangeCharge] FOREIGN KEY([exchange_charge_id])
REFERENCES [Charge].[tblExchangeCharge] ([id])
GO
ALTER TABLE [Charge].[tblExchangeChargeSlab] CHECK CONSTRAINT [FK_tblExchangeChargeSlab_tblExchangeCharge]
GO
ALTER TABLE [Charge].[tblGlobalCharge]  WITH CHECK ADD  CONSTRAINT [FK_tblGlobalCharge_DimDate] FOREIGN KEY([effective_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Charge].[tblGlobalCharge] CHECK CONSTRAINT [FK_tblGlobalCharge_DimDate]
GO
ALTER TABLE [Charge].[tblGlobalCharge]  WITH CHECK ADD  CONSTRAINT [FK_tblGlobalCharge_tblConstantObjectValue] FOREIGN KEY([charge_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Charge].[tblGlobalCharge] CHECK CONSTRAINT [FK_tblGlobalCharge_tblConstantObjectValue]
GO
ALTER TABLE [Charge].[tblGlobalChargeSlab]  WITH CHECK ADD  CONSTRAINT [FK_tblGlobalChargeSlab_tblGlobalCharge] FOREIGN KEY([global_charge_id])
REFERENCES [Charge].[tblGlobalCharge] ([id])
GO
ALTER TABLE [Charge].[tblGlobalChargeSlab] CHECK CONSTRAINT [FK_tblGlobalChargeSlab_tblGlobalCharge]
GO
ALTER TABLE [Charge].[tblInvestorCharge]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorCharge_tblGlobalCharge] FOREIGN KEY([global_charge_id])
REFERENCES [Charge].[tblGlobalCharge] ([id])
GO
ALTER TABLE [Charge].[tblInvestorCharge] CHECK CONSTRAINT [FK_tblInvestorCharge_tblGlobalCharge]
GO
ALTER TABLE [Charge].[tblInvestorCharge]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorCharge_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Charge].[tblInvestorCharge] CHECK CONSTRAINT [FK_tblInvestorCharge_tblInvestor]
GO
ALTER TABLE [Charge].[tblInvestorChargeSlab]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorChargeSlab_tblInvestorCharge] FOREIGN KEY([investor_charge_id])
REFERENCES [Charge].[tblInvestorCharge] ([id])
GO
ALTER TABLE [Charge].[tblInvestorChargeSlab] CHECK CONSTRAINT [FK_tblInvestorChargeSlab_tblInvestorCharge]
GO
ALTER TABLE [Charge].[tblSubAccountCharge]  WITH CHECK ADD  CONSTRAINT [FK_tblSubAccountCharge_tblConstantObjectValue] FOREIGN KEY([sub_account_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Charge].[tblSubAccountCharge] CHECK CONSTRAINT [FK_tblSubAccountCharge_tblConstantObjectValue]
GO
ALTER TABLE [Charge].[tblSubAccountCharge]  WITH CHECK ADD  CONSTRAINT [FK_tblSubAccountCharge_tblGlobalCharge] FOREIGN KEY([global_charge_id])
REFERENCES [Charge].[tblGlobalCharge] ([id])
GO
ALTER TABLE [Charge].[tblSubAccountCharge] CHECK CONSTRAINT [FK_tblSubAccountCharge_tblGlobalCharge]
GO
ALTER TABLE [Charge].[tblSubAccountChargeSlab]  WITH CHECK ADD  CONSTRAINT [FK_tblSubAccountChargeSlab_tblSubAccountCharge] FOREIGN KEY([sub_account_charge_id])
REFERENCES [Charge].[tblSubAccountCharge] ([id])
GO
ALTER TABLE [Charge].[tblSubAccountChargeSlab] CHECK CONSTRAINT [FK_tblSubAccountChargeSlab_tblSubAccountCharge]
GO
ALTER TABLE [dbo].[tblConstantObjectValue]  WITH CHECK ADD  CONSTRAINT [FK_tblConstantObjectValue_ConstantObjects] FOREIGN KEY([object_id])
REFERENCES [dbo].[tblConstantObject] ([object_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblConstantObjectValue] CHECK CONSTRAINT [FK_tblConstantObjectValue_ConstantObjects]
GO
ALTER TABLE [dbo].[tblDayProcess]  WITH CHECK ADD  CONSTRAINT [FK_tblDayProcess_DimDate] FOREIGN KEY([process_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[tblDayProcess] CHECK CONSTRAINT [FK_tblDayProcess_DimDate]
GO
ALTER TABLE [Instrument].[tblInstrument]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrument_InstrumentDepositoryCompany] FOREIGN KEY([depository_company_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Instrument].[tblInstrument] CHECK CONSTRAINT [FK_tblInstrument_InstrumentDepositoryCompany]
GO
ALTER TABLE [Instrument].[tblInstrument]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrument_InstrumentGroup] FOREIGN KEY([group_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Instrument].[tblInstrument] CHECK CONSTRAINT [FK_tblInstrument_InstrumentGroup]
GO
ALTER TABLE [Instrument].[tblInstrument]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrument_InstrumentSector] FOREIGN KEY([sector_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Instrument].[tblInstrument] CHECK CONSTRAINT [FK_tblInstrument_InstrumentSector]
GO
ALTER TABLE [Instrument].[tblInstrument]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrument_InstrumentType] FOREIGN KEY([instument_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Instrument].[tblInstrument] CHECK CONSTRAINT [FK_tblInstrument_InstrumentType]
GO
ALTER TABLE [Instrument].[tblInstrumentFundamentalInfo]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrumentFundamentalInfo_InstrumentFundamentalInfoEffectiveDate] FOREIGN KEY([effective_dt])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Instrument].[tblInstrumentFundamentalInfo] CHECK CONSTRAINT [FK_tblInstrumentFundamentalInfo_InstrumentFundamentalInfoEffectiveDate]
GO
ALTER TABLE [Instrument].[tblInstrumentFundamentalInfo]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrumentFundamentalInfo_tblInstrument] FOREIGN KEY([instrument_id])
REFERENCES [Instrument].[tblInstrument] ([id])
GO
ALTER TABLE [Instrument].[tblInstrumentFundamentalInfo] CHECK CONSTRAINT [FK_tblInstrumentFundamentalInfo_tblInstrument]
GO
ALTER TABLE [Instrument].[tblInstrumentMarginabilityHistory]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrumentMarginabilityHistory_InstrumentMarginabilityHistoryEffectiveDate] FOREIGN KEY([effective_dt])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Instrument].[tblInstrumentMarginabilityHistory] CHECK CONSTRAINT [FK_tblInstrumentMarginabilityHistory_InstrumentMarginabilityHistoryEffectiveDate]
GO
ALTER TABLE [Instrument].[tblInstrumentMarginabilityHistory]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrumentMarginabilityHistory_tblInstrument] FOREIGN KEY([instrument_id])
REFERENCES [Instrument].[tblInstrument] ([id])
GO
ALTER TABLE [Instrument].[tblInstrumentMarginabilityHistory] CHECK CONSTRAINT [FK_tblInstrumentMarginabilityHistory_tblInstrument]
GO
ALTER TABLE [Investor].[tblAccountClosing]  WITH CHECK ADD  CONSTRAINT [FK_tblAccountClosing_AccountClosingDate] FOREIGN KEY([closing_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblAccountClosing] CHECK CONSTRAINT [FK_tblAccountClosing_AccountClosingDate]
GO
ALTER TABLE [Investor].[tblAccountClosing]  WITH CHECK ADD  CONSTRAINT [FK_tblAccountClosing_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Investor].[tblAccountClosing] CHECK CONSTRAINT [FK_tblAccountClosing_tblInvestor]
GO
ALTER TABLE [Investor].[tblIntroducer]  WITH CHECK ADD  CONSTRAINT [FK_tblIntroducer_IntroducerValidFrom] FOREIGN KEY([valid_from])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblIntroducer] CHECK CONSTRAINT [FK_tblIntroducer_IntroducerValidFrom]
GO
ALTER TABLE [Investor].[tblIntroducer]  WITH CHECK ADD  CONSTRAINT [FK_tblIntroducer_IntroducerValidTo] FOREIGN KEY([valid_to])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblIntroducer] CHECK CONSTRAINT [FK_tblIntroducer_IntroducerValidTo]
GO
ALTER TABLE [Investor].[tblIntroducer]  WITH CHECK ADD  CONSTRAINT [FK_tblIntroducer_tblConstantObjectValue] FOREIGN KEY([occupation_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblIntroducer] CHECK CONSTRAINT [FK_tblIntroducer_tblConstantObjectValue]
GO
ALTER TABLE [Investor].[tblIntroducer]  WITH CHECK ADD  CONSTRAINT [FK_tblIntroducer_tblIntroducer] FOREIGN KEY([id])
REFERENCES [Investor].[tblIntroducer] ([id])
GO
ALTER TABLE [Investor].[tblIntroducer] CHECK CONSTRAINT [FK_tblIntroducer_tblIntroducer]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_DimDate] FOREIGN KEY([opening_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_DimDate]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblBank] FOREIGN KEY([bank_id])
REFERENCES [Accounting].[tblBank] ([id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblBank]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblBankBranch] FOREIGN KEY([bank_branch_id])
REFERENCES [Accounting].[tblBankBranch] ([id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblBankBranch]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblBrokerBranch] FOREIGN KEY([branch_id])
REFERENCES [broker].[tblBrokerBranch] ([id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblBrokerBranch]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblConstantObjectValue] FOREIGN KEY([gender_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblConstantObjectValue]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblConstantObjectValue1] FOREIGN KEY([account_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblConstantObjectValue1]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblConstantObjectValue2] FOREIGN KEY([operation_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblConstantObjectValue2]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblConstantObjectValue3] FOREIGN KEY([sub_account_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblConstantObjectValue3]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblConstantObjectValue4] FOREIGN KEY([thana_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblConstantObjectValue4]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblConstantObjectValue5] FOREIGN KEY([district_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblConstantObjectValue5]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblConstantObjectValue6] FOREIGN KEY([ipo_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblConstantObjectValue6]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblConstantObjectValue7] FOREIGN KEY([trade_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblConstantObjectValue7]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblDepositoryPerticipant] FOREIGN KEY([bo_refernce_id])
REFERENCES [broker].[tblDepositoryPerticipant] ([id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblDepositoryPerticipant]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblIntroducer] FOREIGN KEY([introducer_id])
REFERENCES [Investor].[tblIntroducer] ([id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblIntroducer]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblOmnibus] FOREIGN KEY([omnibus_master_id])
REFERENCES [Investor].[tblOmnibus] ([omnibus_id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblOmnibus]
GO
ALTER TABLE [Investor].[tblInvestor]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestor_tblTrader] FOREIGN KEY([trader_id])
REFERENCES [broker].[tblTrader] ([id])
GO
ALTER TABLE [Investor].[tblInvestor] CHECK CONSTRAINT [FK_tblInvestor_tblTrader]
GO
ALTER TABLE [Investor].[tblInvestorFinancialLedger]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorFinancialLedger_DimDate] FOREIGN KEY([transaction_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblInvestorFinancialLedger] CHECK CONSTRAINT [FK_tblInvestorFinancialLedger_DimDate]
GO
ALTER TABLE [Investor].[tblInvestorFinancialLedger]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorFinancialLedger_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Investor].[tblInvestorFinancialLedger] CHECK CONSTRAINT [FK_tblInvestorFinancialLedger_tblInvestor]
GO
ALTER TABLE [Investor].[tblInvestorFinancialLedger]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorFinancialLedger_tblInvestorFinancialLedger] FOREIGN KEY([transaction_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblInvestorFinancialLedger] CHECK CONSTRAINT [FK_tblInvestorFinancialLedger_tblInvestorFinancialLedger]
GO
ALTER TABLE [Investor].[tblInvestorFundBalance]  WITH CHECK ADD  CONSTRAINT [FK_tblClientFundBalance_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Investor].[tblInvestorFundBalance] CHECK CONSTRAINT [FK_tblClientFundBalance_tblInvestor]
GO
ALTER TABLE [Investor].[tblInvestorFundBalance]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorFundBalance_DimDate] FOREIGN KEY([transaction_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblInvestorFundBalance] CHECK CONSTRAINT [FK_tblInvestorFundBalance_DimDate]
GO
ALTER TABLE [Investor].[tblInvestorFundBalance]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorFundBalance_tblConstantObjectValue] FOREIGN KEY([account_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblInvestorFundBalance] CHECK CONSTRAINT [FK_tblInvestorFundBalance_tblConstantObjectValue]
GO
ALTER TABLE [Investor].[tblInvestorImage]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorImage_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Investor].[tblInvestorImage] CHECK CONSTRAINT [FK_tblInvestorImage_tblInvestor]
GO
ALTER TABLE [Investor].[tblInvestorShareBalance]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorShareBalance_DimDate] FOREIGN KEY([transaction_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblInvestorShareBalance] CHECK CONSTRAINT [FK_tblInvestorShareBalance_DimDate]
GO
ALTER TABLE [Investor].[tblInvestorShareBalance]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorShareBalance_tblInstrument] FOREIGN KEY([instrument_id])
REFERENCES [Instrument].[tblInstrument] ([id])
GO
ALTER TABLE [Investor].[tblInvestorShareBalance] CHECK CONSTRAINT [FK_tblInvestorShareBalance_tblInstrument]
GO
ALTER TABLE [Investor].[tblInvestorShareBalance]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorShareBalance_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Investor].[tblInvestorShareBalance] CHECK CONSTRAINT [FK_tblInvestorShareBalance_tblInvestor]
GO
ALTER TABLE [Investor].[tblInvestorShareLedger]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorShareLedger_DimDate] FOREIGN KEY([transaction_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblInvestorShareLedger] CHECK CONSTRAINT [FK_tblInvestorShareLedger_DimDate]
GO
ALTER TABLE [Investor].[tblInvestorShareLedger]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorShareLedger_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Investor].[tblInvestorShareLedger] CHECK CONSTRAINT [FK_tblInvestorShareLedger_tblInvestor]
GO
ALTER TABLE [Investor].[tblInvestorShareLedger]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorShareLedger_tblInvestorShareLedger] FOREIGN KEY([instrument_id])
REFERENCES [Instrument].[tblInstrument] ([id])
GO
ALTER TABLE [Investor].[tblInvestorShareLedger] CHECK CONSTRAINT [FK_tblInvestorShareLedger_tblInvestorShareLedger]
GO
ALTER TABLE [Investor].[tblJoinHolder]  WITH CHECK ADD  CONSTRAINT [FK_tblJoinHolder_tblConstantObjectValue] FOREIGN KEY([gender_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblJoinHolder] CHECK CONSTRAINT [FK_tblJoinHolder_tblConstantObjectValue]
GO
ALTER TABLE [Investor].[tblJoinHolder]  WITH CHECK ADD  CONSTRAINT [FK_tblJoinHolder_tblConstantObjectValue1] FOREIGN KEY([active_status_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblJoinHolder] CHECK CONSTRAINT [FK_tblJoinHolder_tblConstantObjectValue1]
GO
ALTER TABLE [Investor].[tblJoinHolder]  WITH CHECK ADD  CONSTRAINT [FK_tblJoinHolder_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Investor].[tblJoinHolder] CHECK CONSTRAINT [FK_tblJoinHolder_tblInvestor]
GO
ALTER TABLE [Investor].[tblNominee]  WITH CHECK ADD  CONSTRAINT [FK_tblNominee_NomineeBirthDate] FOREIGN KEY([birth_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblNominee] CHECK CONSTRAINT [FK_tblNominee_NomineeBirthDate]
GO
ALTER TABLE [Investor].[tblNominee]  WITH CHECK ADD  CONSTRAINT [FK_tblNominee_NomineeGender] FOREIGN KEY([gender_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblNominee] CHECK CONSTRAINT [FK_tblNominee_NomineeGender]
GO
ALTER TABLE [Investor].[tblNominee]  WITH CHECK ADD  CONSTRAINT [FK_tblNominee_NomineeOpenDate] FOREIGN KEY([open_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblNominee] CHECK CONSTRAINT [FK_tblNominee_NomineeOpenDate]
GO
ALTER TABLE [Investor].[tblNominee]  WITH CHECK ADD  CONSTRAINT [FK_tblNominee_NomineeRelation] FOREIGN KEY([relation_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblNominee] CHECK CONSTRAINT [FK_tblNominee_NomineeRelation]
GO
ALTER TABLE [Investor].[tblNominee]  WITH CHECK ADD  CONSTRAINT [FK_tblNominee_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Investor].[tblNominee] CHECK CONSTRAINT [FK_tblNominee_tblInvestor]
GO
ALTER TABLE [Investor].[tblPowerOfAtornee]  WITH CHECK ADD  CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeBirthDate] FOREIGN KEY([birth_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblPowerOfAtornee] CHECK CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeBirthDate]
GO
ALTER TABLE [Investor].[tblPowerOfAtornee]  WITH CHECK ADD  CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeGender] FOREIGN KEY([gender_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblPowerOfAtornee] CHECK CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeGender]
GO
ALTER TABLE [Investor].[tblPowerOfAtornee]  WITH CHECK ADD  CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeOpenDate] FOREIGN KEY([open_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblPowerOfAtornee] CHECK CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeOpenDate]
GO
ALTER TABLE [Investor].[tblPowerOfAtornee]  WITH CHECK ADD  CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeRelation] FOREIGN KEY([relation_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Investor].[tblPowerOfAtornee] CHECK CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeRelation]
GO
ALTER TABLE [Investor].[tblPowerOfAtornee]  WITH CHECK ADD  CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeValidFromDate] FOREIGN KEY([valid_from_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblPowerOfAtornee] CHECK CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeValidFromDate]
GO
ALTER TABLE [Investor].[tblPowerOfAtornee]  WITH CHECK ADD  CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeValidToDate] FOREIGN KEY([valid_to_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Investor].[tblPowerOfAtornee] CHECK CONSTRAINT [FK_tblPowerOfAtornee_PowerOfAtorneeValidToDate]
GO
ALTER TABLE [Investor].[tblPowerOfAtornee]  WITH CHECK ADD  CONSTRAINT [FK_tblPowerOfAtornee_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Investor].[tblPowerOfAtornee] CHECK CONSTRAINT [FK_tblPowerOfAtornee_tblInvestor]
GO
ALTER TABLE [Trade].[tblFTExportLog]  WITH CHECK ADD  CONSTRAINT [FK_tblFTExportLog_DimDate] FOREIGN KEY([export_dt])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Trade].[tblFTExportLog] CHECK CONSTRAINT [FK_tblFTExportLog_DimDate]
GO
ALTER TABLE [Trade].[tblFTImportLog]  WITH CHECK ADD  CONSTRAINT [FK_tblFTImportLog_DimDate] FOREIGN KEY([import_dt])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Trade].[tblFTImportLog] CHECK CONSTRAINT [FK_tblFTImportLog_DimDate]
GO
ALTER TABLE [Trade].[tblNonTradingDetail]  WITH CHECK ADD  CONSTRAINT [FK_tblNonTradingDetail_DimDate] FOREIGN KEY([non_trading_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Trade].[tblNonTradingDetail] CHECK CONSTRAINT [FK_tblNonTradingDetail_DimDate]
GO
ALTER TABLE [Trade].[tblNonTradingMaster]  WITH CHECK ADD  CONSTRAINT [FK_tblNonTradeMaster_DimDate] FOREIGN KEY([from_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Trade].[tblNonTradingMaster] CHECK CONSTRAINT [FK_tblNonTradeMaster_DimDate]
GO
ALTER TABLE [Trade].[tblNonTradingMaster]  WITH CHECK ADD  CONSTRAINT [FK_tblNonTradeMaster_DimDate1] FOREIGN KEY([to_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Trade].[tblNonTradingMaster] CHECK CONSTRAINT [FK_tblNonTradeMaster_DimDate1]
GO
ALTER TABLE [Trade].[tblNonTradingMaster]  WITH CHECK ADD  CONSTRAINT [FK_tblNonTradeMaster_tblConstantObjectValue] FOREIGN KEY([non_trading_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Trade].[tblNonTradingMaster] CHECK CONSTRAINT [FK_tblNonTradeMaster_tblConstantObjectValue]
GO
ALTER TABLE [Trade].[tblSettlementSchedule]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementSchedule_DimDate] FOREIGN KEY([trade_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Trade].[tblSettlementSchedule] CHECK CONSTRAINT [FK_tblSettlementSchedule_DimDate]
GO
ALTER TABLE [Trade].[tblSettlementSchedule]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementSchedule_tblConstantObjectValue] FOREIGN KEY([stock_exchange_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Trade].[tblSettlementSchedule] CHECK CONSTRAINT [FK_tblSettlementSchedule_tblConstantObjectValue]
GO
ALTER TABLE [Trade].[tblSettlementSchedule]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementSchedule_tblConstantObjectValue1] FOREIGN KEY([market_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Trade].[tblSettlementSchedule] CHECK CONSTRAINT [FK_tblSettlementSchedule_tblConstantObjectValue1]
GO
ALTER TABLE [Trade].[tblSettlementSchedule]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementSchedule_tblConstantObjectValue2] FOREIGN KEY([instrument_group_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Trade].[tblSettlementSchedule] CHECK CONSTRAINT [FK_tblSettlementSchedule_tblConstantObjectValue2]
GO
ALTER TABLE [Trade].[tblTradeData]  WITH CHECK ADD  CONSTRAINT [FK_tblTradeData_tblConstantObjectValue] FOREIGN KEY([stock_exchange_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Trade].[tblTradeData] CHECK CONSTRAINT [FK_tblTradeData_tblConstantObjectValue]
GO
ALTER TABLE [Transaction].[tblForceChargeApply]  WITH CHECK ADD  CONSTRAINT [FK_tblForceChargeApply_DimDate] FOREIGN KEY([transaction_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblForceChargeApply] CHECK CONSTRAINT [FK_tblForceChargeApply_DimDate]
GO
ALTER TABLE [Transaction].[tblForceChargeApply]  WITH CHECK ADD  CONSTRAINT [FK_tblForceChargeApply_DimDate1] FOREIGN KEY([value_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblForceChargeApply] CHECK CONSTRAINT [FK_tblForceChargeApply_DimDate1]
GO
ALTER TABLE [Transaction].[tblForceChargeApply]  WITH CHECK ADD  CONSTRAINT [FK_tblForceChargeApply_DimDate2] FOREIGN KEY([approve_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblForceChargeApply] CHECK CONSTRAINT [FK_tblForceChargeApply_DimDate2]
GO
ALTER TABLE [Transaction].[tblForceChargeApply]  WITH CHECK ADD  CONSTRAINT [FK_tblForceChargeApply_tblConstantObjectValue] FOREIGN KEY([transaction_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Transaction].[tblForceChargeApply] CHECK CONSTRAINT [FK_tblForceChargeApply_tblConstantObjectValue]
GO
ALTER TABLE [Transaction].[tblForceChargeApply]  WITH CHECK ADD  CONSTRAINT [FK_tblForceChargeApply_tblGlobalCharge] FOREIGN KEY([charge_id])
REFERENCES [Charge].[tblGlobalCharge] ([id])
GO
ALTER TABLE [Transaction].[tblForceChargeApply] CHECK CONSTRAINT [FK_tblForceChargeApply_tblGlobalCharge]
GO
ALTER TABLE [Transaction].[tblForceChargeApply]  WITH CHECK ADD  CONSTRAINT [FK_tblForceChargeApply_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Transaction].[tblForceChargeApply] CHECK CONSTRAINT [FK_tblForceChargeApply_tblInvestor]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_DimDate] FOREIGN KEY([receive_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_DimDate]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_DimDate1] FOREIGN KEY([value_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_DimDate1]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_DimDate2] FOREIGN KEY([approve_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_DimDate2]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_DimDate3] FOREIGN KEY([deposit_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_DimDate3]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_DimDate4] FOREIGN KEY([clear_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_DimDate4]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_DimDate5] FOREIGN KEY([dishonor_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_DimDate5]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_DimDate6] FOREIGN KEY([cheque_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_DimDate6]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_tblBank] FOREIGN KEY([bank_id])
REFERENCES [Accounting].[tblBank] ([id])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_tblBank]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_tblBrokerBranch] FOREIGN KEY([broker_branch_id])
REFERENCES [broker].[tblBrokerBranch] ([id])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_tblBrokerBranch]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_tblConstantObjectValue] FOREIGN KEY([transaction_mode_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_tblConstantObjectValue]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_tblFundReceive] FOREIGN KEY([deposit_bank_branch_id])
REFERENCES [broker].[tblBrokerBankAccount] ([id])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_tblFundReceive]
GO
ALTER TABLE [Transaction].[tblFundReceive]  WITH CHECK ADD  CONSTRAINT [FK_tblFundReceive_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Transaction].[tblFundReceive] CHECK CONSTRAINT [FK_tblFundReceive_tblInvestor]
GO
ALTER TABLE [Transaction].[tblFundTransfer]  WITH CHECK ADD  CONSTRAINT [FK_tblFundTransfer_DimDate] FOREIGN KEY([transfer_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundTransfer] CHECK CONSTRAINT [FK_tblFundTransfer_DimDate]
GO
ALTER TABLE [Transaction].[tblFundTransfer]  WITH CHECK ADD  CONSTRAINT [FK_tblFundTransfer_DimDate1] FOREIGN KEY([value_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundTransfer] CHECK CONSTRAINT [FK_tblFundTransfer_DimDate1]
GO
ALTER TABLE [Transaction].[tblFundTransfer]  WITH CHECK ADD  CONSTRAINT [FK_tblFundTransfer_tblInvestor] FOREIGN KEY([transferor_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Transaction].[tblFundTransfer] CHECK CONSTRAINT [FK_tblFundTransfer_tblInvestor]
GO
ALTER TABLE [Transaction].[tblFundTransfer]  WITH CHECK ADD  CONSTRAINT [FK_tblFundTransfer_tblInvestor1] FOREIGN KEY([tranferee_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Transaction].[tblFundTransfer] CHECK CONSTRAINT [FK_tblFundTransfer_tblInvestor1]
GO
ALTER TABLE [Transaction].[tblFundWithdraw]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdraw_DimDate] FOREIGN KEY([cheque_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundWithdraw] CHECK CONSTRAINT [FK_tblFundWithdraw_DimDate]
GO
ALTER TABLE [Transaction].[tblFundWithdraw]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdraw_DimDate1] FOREIGN KEY([withdraw_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundWithdraw] CHECK CONSTRAINT [FK_tblFundWithdraw_DimDate1]
GO
ALTER TABLE [Transaction].[tblFundWithdraw]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdraw_DimDate2] FOREIGN KEY([value_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundWithdraw] CHECK CONSTRAINT [FK_tblFundWithdraw_DimDate2]
GO
ALTER TABLE [Transaction].[tblFundWithdraw]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdraw_DimDate3] FOREIGN KEY([approve_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundWithdraw] CHECK CONSTRAINT [FK_tblFundWithdraw_DimDate3]
GO
ALTER TABLE [Transaction].[tblFundWithdraw]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdraw_tblBankBranch] FOREIGN KEY([bank_branch_id])
REFERENCES [Accounting].[tblBankBranch] ([id])
GO
ALTER TABLE [Transaction].[tblFundWithdraw] CHECK CONSTRAINT [FK_tblFundWithdraw_tblBankBranch]
GO
ALTER TABLE [Transaction].[tblFundWithdraw]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdraw_tblBrokerBranch] FOREIGN KEY([broker_branch_id])
REFERENCES [broker].[tblBrokerBranch] ([id])
GO
ALTER TABLE [Transaction].[tblFundWithdraw] CHECK CONSTRAINT [FK_tblFundWithdraw_tblBrokerBranch]
GO
ALTER TABLE [Transaction].[tblFundWithdraw]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdraw_tblConstantObjectValue] FOREIGN KEY([transaction_mode_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Transaction].[tblFundWithdraw] CHECK CONSTRAINT [FK_tblFundWithdraw_tblConstantObjectValue]
GO
ALTER TABLE [Transaction].[tblFundWithdraw]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdraw_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Transaction].[tblFundWithdraw] CHECK CONSTRAINT [FK_tblFundWithdraw_tblInvestor]
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdrawalRequest_DimDate] FOREIGN KEY([cheque_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest] CHECK CONSTRAINT [FK_tblFundWithdrawalRequest_DimDate]
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdrawalRequest_DimDate1] FOREIGN KEY([request_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest] CHECK CONSTRAINT [FK_tblFundWithdrawalRequest_DimDate1]
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdrawalRequest_DimDate2] FOREIGN KEY([effective_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest] CHECK CONSTRAINT [FK_tblFundWithdrawalRequest_DimDate2]
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdrawalRequest_DimDate3] FOREIGN KEY([approve_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest] CHECK CONSTRAINT [FK_tblFundWithdrawalRequest_DimDate3]
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdrawalRequest_tblBankBranch] FOREIGN KEY([bank_branch_id])
REFERENCES [Accounting].[tblBankBranch] ([id])
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest] CHECK CONSTRAINT [FK_tblFundWithdrawalRequest_tblBankBranch]
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdrawalRequest_tblBrokerBranch] FOREIGN KEY([broker_branch_id])
REFERENCES [broker].[tblBrokerBranch] ([id])
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest] CHECK CONSTRAINT [FK_tblFundWithdrawalRequest_tblBrokerBranch]
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdrawalRequest_tblConstantObjectValue] FOREIGN KEY([transaction_mode_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest] CHECK CONSTRAINT [FK_tblFundWithdrawalRequest_tblConstantObjectValue]
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest]  WITH CHECK ADD  CONSTRAINT [FK_tblFundWithdrawalRequest_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO
ALTER TABLE [Transaction].[tblFundWithdrawalRequest] CHECK CONSTRAINT [FK_tblFundWithdrawalRequest_tblInvestor]
GO
/****** Object:  StoredProcedure [broker].[ssp_branches_by_user_id]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 10-DEC-2015
-- Description:	GET BRANCH LIST BASED ON USER
-- =============================================
CREATE PROCEDURE [broker].[ssp_branches_by_user_id]
	  @user_id as varchar(128)
	, @membership_id AS NUMERIC(9,0)
AS
BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
	DECLARE @active_status_id AS NUMERIC(4,0)
	SET @active_status_id=DBO.sfun_get_constant_object_value_id('ACTIVE_STATUS','Active')

	IF EXISTS(SELECT * FROM [Escrow.Security].dbo.tblBrokerUser TBU WHERE TBU.UserId=@user_id AND TBU.membership_id=@membership_id AND is_admin=1)
	BEGIN
		SELECT DISTINCT TBB.id, TBB.name, TBB.address, TBB.contact_person, TBB.contact_no, TBB.email, TBB.registration_dt, TBB.active_status_id
		FROM broker.tblBrokerBranch TBB
		WHERE TBB.active_status_id=@active_status_id AND TBB.membership_id=@membership_id
	END
	ELSE
	BEGIN
		SELECT DISTINCT TBB.id, TBB.name, TBB.address, TBB.contact_person, TBB.contact_no, TBB.email, TBB.registration_dt, TBB.active_status_id
		FROM [Escrow.Security].dbo.tblBrokerUser TBU
			INNER JOIN broker.tblEmployeeUserMapping EUM ON TBU.UserId=EUM.user_id AND TBU.membership_id=EUM.membership_id
			INNER JOIN broker.tblEmployee TE ON EUM.employee_id=TE.id AND EUM.membership_id=TE.membership_id
			INNER JOIN broker.tblBrokerBranch TBB ON TE.branch_id=TBB.id AND TE.membership_id=TBB.membership_id
		WHERE TBB.active_status_id=@active_status_id
	END
END


GO
/****** Object:  StoredProcedure [CDBL].[psp_bo_registration]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- exec CDBL.psp_bo_registration '01-NOV-2015', '16-NOV-2015', 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
-- =============================================
-- Author:		Asif
-- Create date: 13/10/15
-- Description:	Process BO Registration
-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 04/11/15
-- Description:	Modify for add to bank, bank branch, thana, district, existing investor update, investor insert, ledger and financial balance
-- =============================================
CREATE PROCEDURE [CDBL].[psp_bo_registration]
(
@from_date varchar(50),
@to_date varchar(50),
@membership_id numeric(9,0),
@changed_user_id nvarchar(128),
@result VARCHAR(MAX) OUT
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
	 SET @result = 'success'
	 
	 BEGIN TRANSACTION
	 
		BEGIN TRY

			DECLARE @PROCESS_DATE AS NUMERIC(9,0)
				,@DEFAULT_INVESTOR_ACC_TYPE AS NUMERIC(4,0)
				,@DEFAULT_IPO_TYPE AS NUMERIC(4,0)
				,@DEFAULT_TRADE_TYPE AS NUMERIC(4,0)
				,@DEFAULT_ACTIVE_STATUS AS NUMERIC(4,0)
				,@DEFAULT_INVESTOR_SUB_ACC AS NUMERIC(4,0)
				,@trader_id as numeric(2)
				,@branch_id as numeric(2)
				,@GENDER_OBJECT_ID AS NUMERIC(3)
				,@OPERATION_TYPE_OBJECT_ID AS NUMERIC(3)
				,@THANA_OBJECT_ID AS NUMERIC(3)
				,@DISTRICT_OBJECT_ID AS NUMERIC(3)
				,@FINANCIAL_LEDGER_TYPE_ID AS NUMERIC(4,0) --FOR ACCOUNT OPENING TYPE 
				,@transaction_type_id AS NUMERIC(4,0) -- FOR CHARGE APPLY FOR RECEIVE
			
			SELECT @PROCESS_DATE=dbo.sfun_get_process_date()

			SELECT @DEFAULT_INVESTOR_ACC_TYPE=dbo.sfun_get_constant_object_default_value_id('INVESTOR_ACC_TYPE')
			SELECT @DEFAULT_IPO_TYPE=dbo.sfun_get_constant_object_default_value_id('IPO_TYPE')
			SELECT @DEFAULT_TRADE_TYPE=dbo.sfun_get_constant_object_default_value_id('TRADE_TYPE')
			SELECT @DEFAULT_ACTIVE_STATUS=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
			SELECT @DEFAULT_INVESTOR_SUB_ACC=dbo.sfun_get_constant_object_default_value_id('INVESTOR_SUB_ACC')

			SELECT @FINANCIAL_LEDGER_TYPE_ID=dbo.sfun_get_constant_object_value_id('FINANCIAL_LEDGER_TYPE','Account Opening Fee')
			SELECT @transaction_type_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','Receive')

			SELECT @GENDER_OBJECT_ID=TCO.object_id FROM DBO.tblConstantObject TCO WHERE TCO.object_name='GENDER'
			SELECT @OPERATION_TYPE_OBJECT_ID=TCO.object_id FROM DBO.tblConstantObject TCO WHERE TCO.object_name='INVESTOR_OPERATION_TYPE'
			SELECT @THANA_OBJECT_ID=TCO.object_id FROM DBO.tblConstantObject TCO WHERE TCO.object_name='THANA'
			SELECT @DISTRICT_OBJECT_ID=TCO.object_id FROM DBO.tblConstantObject TCO WHERE TCO.object_name='DISTRICT'

			set @trader_id = (select top 1 id from broker.tblTrader order by id)
			set @branch_id = (select top 1 id from broker.tblBrokerBranch order by id)

			-----------------------Insert data from temp table to bo registration-----------------------
			print 'tblCdblBoRegistration'

			INSERT INTO [CDBL].[tblCdblBoRegistration] (bo_code,operation_Type,internal_Ref_No,first_holder_name,second_holder_name,gender,birth_date,father_name,mother_name,occupation,res_flag,nationality,add1,add2,add3,city,state,
				country,post_code,phone,email,fax,passport_no,passport_issue_dt,passport_exp_dt,passport_issue_place,bank_name,bank_branch_name,bank_account_no,bank_routing_No,opening_date,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			SELECT a.bo_code,a.operation_Type,a.internal_Ref_No,a.first_holder_name,a.second_holder_name,a.gender,a.birth_date,a.father_name,a.mother_name,a.occupation,a.res_flag,a.nationality,a.add1,a.add2,a.add3,a.city,a.state,a.country,
				a.post_code,a.phone,a.email,a.fax,a.passport_no,a.passport_issue_dt,a.passport_exp_dt,a.passport_issue_place,a.bank_name,a.bank_branch_name,a.bank_account_no,a.bank_routing_No,a.opening_date,@DEFAULT_ACTIVE_STATUS,@membership_id,@changed_user_id,
				GETDATE(),1
			FROM [CDBL].[08DP01UX] a
				LEFT JOIN (SELECT * FROM [CDBL].[tblCdblBoRegistration] WHERE membership_id=@membership_id) tcbr ON a.bo_code = tcbr.bo_code AND a.internal_Ref_No = tcbr.internal_ref_no
			WHERE CONVERT(Datetime, a.opening_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120)
				AND tcbr.registration_id IS NULL
							
			-----------------------End insert data from temp table to bo registration-----------------------

			-----------------------insert data from temp table to bank-----------------------
			print 'tblBank'

			insert into Accounting.tblBank(short_name,bank_name,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			select SUBSTRING(dp.bank_name,1,3), dp.bank_name,@DEFAULT_ACTIVE_STATUS,@membership_id,@changed_user_id,GETDATE(),1
			from (
				select distinct bank_name from CDBL.[08DP01UX] dp
					left join (SELECT * FROM Accounting.tblBankBranch WHERE membership_id=@membership_id) tbb on dp.bank_routing_No=tbb.routing_no
				where tbb.id is null
			) as dp left join (SELECT * FROM Accounting.tblBank WHERE membership_id=@membership_id) tb on dp.bank_name=tb.bank_name
			where tb.bank_name is null

			-----------------------End insert data from temp table to bank-----------------------

			-----------------------insert data from temp table to bank branch-----------------------
			print 'tblBankBranch'

			insert into Accounting.tblBankBranch(branch_name,routing_no,bank_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			select distinct DP.bank_branch_name, dp.bank_routing_No, tb.id,@DEFAULT_ACTIVE_STATUS,@membership_id,@changed_user_id,GETDATE(),1
			from CDBL.[08DP01UX] dp
				inner join (SELECT * FROM Accounting.tblBank WHERE membership_id=@membership_id) tb on dp.bank_name=tb.bank_name
				left join (SELECT * FROM Accounting.tblBankBranch WHERE membership_id=@membership_id) tbb on dp.bank_routing_No=tbb.routing_no
			where tbb.id is null

			-----------------------End insert data from temp table to bank branch-----------------------

			-----------------------insert district from temp table to object value-----------------------
			print 'DISTRICT'

			insert into dbo.tblConstantObjectValue(display_value, object_id, is_default)
			select t.state, (select object_id from DBO.tblConstantObject WHERE object_name='DISTRICT'), 0
			from
				(select distinct state from [CDBL].[08DP01UX]) t 
				left join (SELECT tcv.object_value_id, tcv.display_value FROM 
					DBO.tblConstantObjectValue TCV 
						INNER JOIN DBO.tblConstantObject TCO ON TCV.object_id=TCO.object_id WHERE TCO.object_name='DISTRICT') as v
					on t.state=v.display_value
			where v.object_value_id is null
			-----------------------insert district from temp table to object value-----------------------

			-----------------------insert thana from temp table to object value-----------------------
			print 'THANA'
			insert into dbo.tblConstantObjectValue(display_value, object_id, is_default)
			select t.state, (select object_id from DBO.tblConstantObject WHERE object_name='THANA'), 0
			from
				(select distinct state from [CDBL].[08DP01UX]) t 
				left join (SELECT tcv.object_value_id, tcv.display_value FROM 
					DBO.tblConstantObjectValue TCV 
						INNER JOIN DBO.tblConstantObject TCO ON TCV.object_id=TCO.object_id WHERE TCO.object_name='THANA') as v
					on t.state=v.display_value
			where v.object_value_id is null
			-----------------------End insert thana from temp table to object value-----------------------
			
			-----------------------update data at investor table from temp-----------------------
			print 'Update Investor' 

			UPDATE TI
			SET 
				TI.bo_refernce_id=TDP.id,TI.bo_code= DP.bo_code,TI.first_holder_name = DP.first_holder_name,TI.birth_date = DP.birth_date,TI.gender_id = gcov.object_value_id,TI.passport_no = DP.passport_no,TI.father_name = DP.father_name
				,TI.mother_name = DP.mother_name,TI.operation_type_id = otcov.object_value_id,TI.mailing_address = DP.add2,TI.permanent_address = DP.add1
				,TI.thana_id = thanacov.object_value_id,TI.district_id = distcov.object_value_id,TI.phone_no = DP.phone,TI.email_address = DP.email,TI.bank_id = tbb.bank_id,TI.bank_branch_id = TBB.id,TI.banc_account_no = DP.bank_account_no
				,TI.opening_date = oddd.DateKey,TI.passport_issue_place = DP.passport_issue_place
				,TI.passport_issue_date = CASE WHEN LEN(dp.passport_issue_dt)>0 THEN DP.passport_issue_dt ELSE NULL END
				,TI.passport_valid_to_date = CASE WHEN LEN(dp.passport_exp_dt)>0 THEN DP.passport_exp_dt ELSE NULL END
				,TI.changed_user_id = @changed_user_id,TI.changed_date = GETDATE(),TI.is_dirty = 1
			FROM [CDBL].[08DP01UX] dp
				INNER JOIN (select * from [Investor].[tblInvestor] where membership_id=@membership_id) ti ON DP.internal_Ref_No = ti.client_id
				INNER JOIN (select * from [Accounting].[tblBankBranch] where membership_id=@membership_id) tbb ON UPPER(dp.bank_branch_name) = UPPER(tbb.branch_name)
				INNER JOIN (SELECT * FROM broker.tblDepositoryPerticipant WHERE membership_id=@membership_id) TDP ON SUBSTRING(DP.BO_CODE,1,8)=TDP.bo_reference_no
				INNER JOIN [dbo].[DimDate] oddd ON DP.opening_date = oddd.FullDateCDBL
				INNER JOIN [dbo].[tblConstantObjectValue] gcov ON UPPER(DP.gender) = UPPER(gcov.display_value) AND gcov.object_id=@GENDER_OBJECT_ID
				INNER JOIN [dbo].[tblConstantObjectValue] otcov ON UPPER(DP.operation_type) = UPPER(otcov.display_value) AND otcov.object_id=@OPERATION_TYPE_OBJECT_ID
				INNER JOIN [dbo].[tblConstantObjectValue] thanacov ON UPPER(DP.state) = UPPER(thanacov.display_value) AND thanacov.object_id=@THANA_OBJECT_ID
				INNER JOIN [dbo].[tblConstantObjectValue] distcov ON UPPER(DP.city) = UPPER(distcov.display_value) AND distcov.object_id=@DISTRICT_OBJECT_ID
			WHERE ISDATE(dp.opening_date)=1 
				and ((len(dp.birth_date)>0 and ISDATE(dp.birth_date)=1) or LEN(dp.birth_date)=0)  
				and ((len(dp.passport_issue_dt)>0 and ISDATE(dp.passport_issue_dt)=1) or LEN(dp.passport_issue_dt)=0)
				and ((len(dp.passport_exp_dt)>0 and ISDATE(dp.passport_exp_dt)=1) or LEN(dp.passport_exp_dt)=0)
				AND ( CONVERT(Datetime, dp.opening_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))

			-----------------------End update data at investor table from temp-----------------------

			-----------------------Insert data from bo registration to investor temporary-----------------------
			print 'tblInvestorTemp'

			TRUNCATE TABLE [Investor].[tblInvestorTemp]

			INSERT INTO [Investor].[tblInvestorTemp](client_id,bo_refernce_id,bo_code,first_holder_name, second_joint_holder,birth_date,gender_id,passport_no,father_name,mother_name,account_type_id,operation_type_id,sub_account_type_id,mailing_address
				,permanent_address,thana_id,district_id,phone_no,email_address,bank_id,bank_branch_id,banc_account_no,beftn_enabled,email_enabled,internet_enabled,sms_enabled,branch_id,opening_date,passport_issue_place
				,passport_issue_date
				,passport_valid_to_date
				,trader_id,ipo_type_id,trade_type_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty
			)

			SELECT dp.internal_Ref_No, TDP.id,dp.bo_code,dp.first_holder_name, dp.second_holder_name, dp.birth_date,gcov.object_value_id,dp.passport_no,dp.father_name,dp.mother_name,@DEFAULT_INVESTOR_ACC_TYPE,otcov.object_value_id,@DEFAULT_INVESTOR_SUB_ACC,dp.add2
				,dp.add1, thanacov.object_value_id, distcov.object_value_id,dp.phone,dp.email,tbb.bank_id,tbb.id bank_branch_id,dp.bank_account_no,0,0,0,0,@branch_id,oddd.DateKey,dp.passport_issue_place
				,CASE WHEN LEN(dp.passport_issue_dt)>0 THEN DP.passport_issue_dt ELSE NULL END
				,CASE WHEN LEN(dp.passport_exp_dt)>0 THEN DP.passport_exp_dt ELSE NULL END
				,@trader_id, @DEFAULT_IPO_TYPE, @DEFAULT_TRADE_TYPE,@DEFAULT_ACTIVE_STATUS,@membership_id,@changed_user_id,GETDATE(),1
			FROM [CDBL].[08DP01UX] dp
				LEFT JOIN (select * from [Investor].[tblInvestor] where membership_id=@membership_id) ti ON DP.internal_Ref_No = ti.client_id
				LEFT JOIN (select * from [Accounting].[tblBank] where membership_id=@membership_id) tb ON dp.bank_name = tb.bank_name
				LEFT JOIN (select * from [Accounting].[tblBankBranch] where membership_id=@membership_id) tbb ON UPPER(dp.bank_branch_name) = UPPER(tbb.branch_name) and tb.id=tbb.bank_id
				LEFT JOIN (SELECT * FROM broker.tblDepositoryPerticipant WHERE membership_id=@membership_id) TDP ON SUBSTRING(DP.BO_CODE,1,8)=TDP.bo_reference_no
				LEFT JOIN [dbo].[DimDate] oddd ON DP.opening_date = oddd.FullDateCDBL
				LEFT JOIN [dbo].[tblConstantObjectValue] gcov ON UPPER(DP.gender) = UPPER(gcov.display_value) AND gcov.object_id=@GENDER_OBJECT_ID
				LEFT JOIN [dbo].[tblConstantObjectValue] otcov ON UPPER(DP.operation_type) = UPPER(otcov.display_value) AND otcov.object_id=@OPERATION_TYPE_OBJECT_ID
				LEFT JOIN [dbo].[tblConstantObjectValue] thanacov ON UPPER(DP.state) = UPPER(thanacov.display_value) AND thanacov.object_id=@THANA_OBJECT_ID
				LEFT JOIN [dbo].[tblConstantObjectValue] distcov ON UPPER(DP.city) = UPPER(distcov.display_value) AND distcov.object_id=@DISTRICT_OBJECT_ID
			WHERE TI.client_id IS NULL 
				and ISDATE(dp.opening_date)=1 
				and ((len(dp.birth_date)>0 and ISDATE(dp.birth_date)=1) or LEN(dp.birth_date)=0)  
				and ((len(dp.passport_issue_dt)>0 and ISDATE(dp.passport_issue_dt)=1) or LEN(dp.passport_issue_dt)=0)
				and ((len(dp.passport_exp_dt)>0 and ISDATE(dp.passport_exp_dt)=1) or LEN(dp.passport_exp_dt)=0)
				AND ( CONVERT(Datetime, dp.opening_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			
			-----------------------End insert data from bo registration to investor temporary-----------------------

			-----------------------Insert data from investor temporary to investor-----------------------
			print 'tblInvestor'
			INSERT INTO [Investor].[tblInvestor](client_id,bo_refernce_id,bo_code,first_holder_name,birth_date,gender_id,passport_no,father_name,mother_name,account_type_id,operation_type_id,sub_account_type_id,mailing_address
				,permanent_address,thana_id,district_id,phone_no,email_address,bank_id,bank_branch_id,banc_account_no,beftn_enabled,email_enabled,internet_enabled,sms_enabled,branch_id,opening_date,passport_issue_place
				,passport_issue_date
				,passport_valid_to_date
				,trader_id,ipo_type_id,trade_type_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			select client_id,bo_refernce_id,bo_code,first_holder_name,birth_date,gender_id,passport_no,father_name,mother_name,account_type_id,operation_type_id,sub_account_type_id,mailing_address
				,permanent_address,thana_id,district_id,phone_no,email_address,bank_id,bank_branch_id,banc_account_no,beftn_enabled,email_enabled,internet_enabled,sms_enabled,branch_id,opening_date,passport_issue_place
				,passport_issue_date
				,passport_valid_to_date
				,trader_id,ipo_type_id,trade_type_id,active_status_id,membership_id,changed_user_id,changed_date,is_dirty
			from Investor.tblInvestorTemp tmp
			WHERE membership_id=@membership_id
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to investor-----------------------

			-----------------------Insert data from investor temporary to JOINT HOLDER-----------------------
			print 'tblJoinHolder'
			INSERT INTO [Investor].[tblJoinHolder](client_id,join_holder_name,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			select client_id,second_joint_holder,active_status_id,membership_id,changed_user_id,changed_date,is_dirty
			from Investor.tblInvestorTemp tmp
			WHERE membership_id=@membership_id AND ISNULL(second_joint_holder,'')!=''
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to JOINT HOLDER-----------------------

			-----------------------Insert data from investor temporary to Finuncial Ledger-----------------------
			print 'tblForceChargeApply'

			INSERT INTO [Transaction].tblForceChargeApply(client_id,charge_id,transaction_type_id,amount,transaction_date,value_date,remarks,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,approve_by,approve_date)
			select tmp.client_id, 5 charge_id, @transaction_type_id, apf.charge_amount amount,@PROCESS_DATE transaction_date,@PROCESS_DATE value_date,TGC.name remarks,@DEFAULT_ACTIVE_STATUS active_status_id,@membership_id
				,@changed_user_id, GETDATE() changed_date,1 is_dirty, @changed_user_id approve_by, @PROCESS_DATE approve_date
			from Investor.tblInvestorTemp tmp 
				inner join (select * from charge.vw_all_investors_charges where global_charge_id=5) apf on tmp.client_id=apf.client_id
				inner join Charge.tblGlobalCharge tgc on apf.global_charge_id=tgc.id
			where apf.charge_amount>0 AND TMP.membership_id=@membership_id
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to Finuncial Ledger-----------------------

			-----------------------Insert data from investor temporary to Finuncial Ledger-----------------------
			print 'tblInvestorFinancialLedger'

			insert into Investor.tblInvestorFinancialLedger(client_id,transaction_type_id,narration,debit,credit,transaction_date,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
			select tmp.client_id, @FINANCIAL_LEDGER_TYPE_ID, tgc.name, apf.charge_amount, 0, @PROCESS_DATE, tmp.active_status_id, tmp.membership_id, tmp.changed_user_id, tmp.changed_date, tmp.is_dirty 
			from Investor.tblInvestorTemp tmp 
				inner join (select * from charge.vw_all_investors_charges where global_charge_id=5) apf on tmp.client_id=apf.client_id
				inner join Charge.tblGlobalCharge tgc on apf.global_charge_id=tgc.id
			where apf.charge_amount>0 AND TMP.membership_id=@membership_id
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to Finuncial Ledger-----------------------

			-----------------------Insert data from investor temporary to fund balance-----------------------
			print 'tblInvestorFundBalance'

			insert into Investor.tblInvestorFundBalance(client_id,transaction_date,account_type_id,available_balance,sale_receivable,un_clear_cheque, ledger_balance,total_deposit,share_transfer_in,total_withdraw,share_transfer_out,realized_interest,
				realized_charge,accured_interest,fund_withdrawal_request,cost_value,market_value,equity,marginable_equity,sanction_amount,loan_ratio,purchase_power,max_withdraw_limit,excess_over_limit,realized_gain,unrealized_gain,
				active_status_id, membership_id, changed_user_id, changed_date, is_dirty)
			select tmp.client_id, @PROCESS_DATE, account_type_id, -1 * apf.charge_amount, 0, 0, -1 * apf.charge_amount, 0, 0, 0, 0, 0, apf.charge_amount, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
				, tmp.active_status_id, tmp.membership_id, tmp.changed_user_id, tmp.changed_date, tmp.is_dirty
			from Investor.tblInvestorTemp tmp
				inner join (select * from charge.vw_all_investors_charges where global_charge_id=5) apf on tmp.client_id=apf.client_id
			where apf.charge_amount>0 AND TMP.membership_id=@membership_id
				AND (CONVERT(Datetime, CONVERT(VARCHAR,TMP.opening_date),120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120))
			-----------------------End Insert data from investor temporary to fund balance-----------------------

			TRUNCATE TABLE [CDBL].[08DP01UX]

			COMMIT TRANSACTION
			
		END TRY
		
		BEGIN CATCH
		
			SELECT @result = ERROR_MESSAGE()
			ROLLBACK TRANSACTION
			RAISERROR(@result,16,1)
		END CATCH	 
END

GO
/****** Object:  StoredProcedure [CDBL].[psp_bonus_rights]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- exec CDBL.psp_bonus_rights '16-JUN-2015', '16-JUN-2015', 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a', getdate(), 1
-- =============================================
-- Author:		Asif
-- Create date: 13/10/15
-- Description:	Process Bonus Rights
-- Updated by : Sarwar
-- Update Date: 12/07/2015
-- Description: Add validation for invalid dividend uploaded data
-- =============================================
CREATE PROCEDURE [CDBL].[psp_bonus_rights]
(
@from_date varchar(50),
@to_date varchar(50),
@membership_id numeric(9,0),
@changed_user_id nvarchar(128),
@changed_date datetime,
@is_dirty numeric(1,0)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF

	 DECLARE @ERROR_MESSAGE VARCHAR(MAX)
	 DECLARE @active_status_id int;
	 DECLARE @object_value_id NUMERIC(4)

	 SELECT @active_status_id = tcov.object_value_id
	 FROM dbo.tblConstantObject tco
	 INNER JOIN dbo.tblConstantObjectValue tcov ON tcov.object_id = tco.object_id
	 WHERE tco.object_name = 'ACTIVE_STATUS'
	 AND tcov.display_value = 'Active'
	 

	 --GET OBJECT ID
	SELECT @object_value_id= A.object_value_id 
	FROM
	tblConstantObjectValue A
	INNER JOIN tblConstantObject B ON B.object_id=A.object_id
	where 
	B.object_name='SHARE_LEDGER_TYPE'
	AND A.display_value='BONUS/RIGHTS'


	 BEGIN TRANSACTION
	
		BEGIN TRY
			-----------------------Insert data from temp table to bonus rights-----------------------
			
			INSERT INTO [CDBL].[tblCdblBonusRights] 
			(
				isin,
				company_name,
				share_transaction_type,
				from_date,
				to_date,
				bo_code,
				bo_name,
				qty,
				transaction_date,
				rate,
				active_status_id,
				membership_id,
				changed_user_id,
				changed_date,
				is_dirty
			)
			SELECT 
			a.isin,
			a.company_name,
			a.share_transaction_type,
			a.from_date,
			a.to_date,
			a.bo_code,
			a.bo_name,
			CONVERT(numeric(5,0),a.qty) qty,
			a.transaction_date,
			CONVERT(numeric(5,0),a.rate) rate,
			@active_status_id,
			@membership_id,
			@changed_user_id,
			@changed_date,
			@is_dirty
			FROM 
				[CDBL].[17DP70UX] a
			LEFT JOIN 
				[CDBL].[tblCdblBonusRights] tcbr 
				ON a.bo_code = tcbr.bo_code 
				AND a.isin = tcbr.isin 
				AND CONVERT(DATETIME,  a.from_date) = CONVERT(DATETIME, tcbr.from_date)
				AND TCBR.share_transaction_type=A.share_transaction_type
			WHERE 
				CONVERT(Datetime, a.transaction_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120)
				AND tcbr.isin IS NULL
			
			-----------------------End insert data from temp table to bonus rights-----------------------
			

			----------IF DATA INSERTED SUCCESSFULLY THEN EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE BONUS RIGHT---------
			--CALL SHARE TRANSACTION PROCESS
			  EXEC [Investor].[psp_investor_share_transaction] NULL,@object_value_id,@membership_id,@changed_user_id
			------------------END OF  EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE BONUS RIGHT---------


			TRUNCATE TABLE [CDBL].[17DP70UX] 

			COMMIT TRANSACTION
		END TRY
		
		BEGIN CATCH
		
			ROLLBACK TRANSACTION
			SET @ERROR_MESSAGE=ERROR_MESSAGE()
			RAISERROR(@ERROR_MESSAGE,16,1)
		END CATCH	 
END


GO
/****** Object:  StoredProcedure [CDBL].[psp_cdbl]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 /*
DECLARE @result VARCHAR(200)
SET @result='S'
exec CDBL.psp_cdbl 'Dividend Receivable,', '14-DEC-2015', '14-DEC-2015', 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a', '26-DEC-2015', 1,@result
SELECT @result
*/

-- =============================================
-- Author:		Asif
-- Create date: 13/10/15
-- Description:	Process CDBL
-- =============================================
CREATE PROCEDURE [CDBL].[psp_cdbl]
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
	 DECLARE @ERROR_MESSAGE VARCHAR(MAX)
	 SET @result = 'success'
	
	 BEGIN TRANSACTION
	 BEGIN TRY
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
					PRINT 'Dividend Receivable'
					EXEC CDBL.psp_dividend_receivable @from_date, @to_date, @membership_id, @changed_user_id, @changed_date
				--END OF VALIDATION
				END
			END

	 COMMIT TRANSACTION
	 END TRY
	 BEGIN CATCH
	 SET @ERROR_MESSAGE= ERROR_MESSAGE()
	 SELECT @ERROR_MESSAGE
		ROLLBACK TRANSACTION
		SET @result=ERROR_MESSAGE()
		

		RAISERROR(@ERROR_MESSAGE,16,1)
	 END CATCH

END

GO
/****** Object:  StoredProcedure [CDBL].[psp_dividend_receivable]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- exec CDBL.[psp_dividend_receivable] '15-DEC-2015', '15-DEC-2015', 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a', '26-DEC-2015'
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
	 DECLARE @active_status_id int
	 DECLARE @object_value_id NUMERIC(4)

	 SELECT @active_status_id = tcov.object_value_id
	 FROM dbo.tblConstantObject tco
	 INNER JOIN dbo.tblConstantObjectValue tcov ON tcov.object_id = tco.object_id
	 WHERE tco.object_name = 'ACTIVE_STATUS'
	 AND tcov.display_value = 'Active'
	 

	 --GET OBJECT ID
	 SELECT @object_value_id= A.object_value_id 
	 FROM
	 tblConstantObjectValue A
	 INNER JOIN tblConstantObject B ON B.object_id=A.object_id
	 where 
	 B.object_name='SHARE_LEDGER_TYPE'
	 AND A.display_value='Devidend Receivable'


	 BEGIN TRANSACTION
	 
		BEGIN TRY

						
			-----------------------Insert data from temp table to devident receivable-----------------------
			PRINT 'INSERT INTO [CDBL].[tblCdblDividendReceivable]'
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
			PRINT 'EXEC [Investor].[psp_investor_share_transaction]'
			--CALL SHARE TRANSACTION PROCESS
			EXEC [Investor].[psp_investor_share_transaction] NULL,@object_value_id,@membership_id,@changed_user_id
			------------------END OF  EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE DIVIDEND RECEIVABLE---------

			TRUNCATE TABLE [CDBL].[17DP64UX]
			COMMIT TRANSACTION
		END TRY
		
		BEGIN CATCH
		
			ROLLBACK 
			SET @ERROR_MESSAGE=ERROR_MESSAGE()
			RAISERROR(@ERROR_MESSAGE,16,1)
		END CATCH	 
END

GO
/****** Object:  StoredProcedure [CDBL].[psp_export_pay_in_pay_out]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 03/12/2015
-- Description:	export pay in
-- =============================================

--[CDBL].[psp_export_pay_in_pay_out] 'I',20151206
CREATE PROCEDURE [CDBL].[psp_export_pay_in_pay_out]
(
	@is_payin_payout varchar(1),
	@trd_dt numeric(9,0)
)
AS
BEGIN
SET NOCOUNT ON;
	SET FMTONLY OFF;

	DECLARE @running_sl_no numeric(2,0)
	DECLARE @date varchar(9)
	DECLARE @total_quantity numeric(16,0)
	DECLARE @total_records numeric(8,0)

	SELECT @running_sl_no = (count(log_id)+1) from CDBL.tblPayinPayoutLog where log_date = @trd_dt and is_payin_out = @is_payin_payout
	SELECT @date = format(GETDATE(),'ddMMyyyy')

	


	
	--is_payin_out
	INSERT INTO CDBL.tblPayinPayoutLog
		values(@is_payin_payout,@running_sl_no,@trd_dt,getdate())
	if(@is_payin_payout = 'I')
	BEGIN
		
		SELECT @total_quantity = sum(ttd.quantity), @total_records = count(ttd.client_id) from Trade.tblTradeData ttd

		 inner join Investor.tblInvestor ti on ttd.client_id = ti.client_id
		 inner join broker.tblDepositoryPerticipant tdp on left(ti.bo_code,8) = tdp.bo_reference_no
		 inner join Instrument.tblInstrument tii on ttd.instrument_id = tii.id
		where transaction_type = 'S'
		and len(isnull(tii.isin,'')) = 12
		and len(isnull(ti.bo_code,'')) = 16
		and ttd.date = @trd_dt

		select 
			@date+ ti.bo_code+
			tdp.clearance_no+right('000000'+convert(varchar(6),tdp.membership_id),6)
			+tii.isin+right('000000000000000'+(convert(varchar(12),sum(ttd.Quantity))),12)+'I'
			+right('0000000000000000'+ttd.client_id,16)
			+right('000000000000'+convert(varchar(12),ROW_NUMBER() over(order by ti.bo_code)),12) as body
			,'01'+right('000000'+tdp.dp_no,6)+@date+right('00'+convert(varchar(2),@running_sl_no),2) as fName
			,right('0000000'+convert(varchar(7),@total_records),7)
			+right('0000000000000'+convert(varchar(13),@total_quantity),13)
			+' Admin'+right('000000'+tdp.dp_no,6)+'10' as head
			 from Trade.tblTradeData ttd
			 inner join Investor.tblInvestor ti on ttd.client_id = ti.client_id
			 inner join broker.tblDepositoryPerticipant tdp on left(ti.bo_code,8) = tdp.bo_reference_no
			 inner join Instrument.tblInstrument tii on ttd.instrument_id = tii.id
			where transaction_type = 'S'
			and len(isnull(tii.isin,'')) = 12
			and len(isnull(ti.bo_code,'')) = 16
			and ttd.date = @trd_dt
			group by ti.bo_code
			,tdp.clearance_no
			,tdp.membership_id
			,tii.isin
			,ttd.client_id
			,tdp.dp_no

	END
	else if(@is_payin_payout = 'O')
	BEGIN
	SELECT @total_quantity = sum(vtm.quantity), @total_records = count(vtm.client_id) from [Trade].[vw_today_maturity] vtm

		 inner join Investor.tblInvestor ti on vtm.client_id = ti.client_id
		 inner join broker.tblDepositoryPerticipant tdp on left(ti.bo_code,8) = tdp.bo_reference_no
		 inner join Instrument.tblInstrument tii on vtm.instrument_id = tii.id
		where transaction_type = 'B'
		and len(isnull(tii.isin,'')) = 12
		and len(isnull(ti.bo_code,'')) = 16
		and vtm.settle_date = @trd_dt

		select 
			@date+ tdp.clearance_no+ti.bo_code+right('000000'+convert(varchar(6),tdp.membership_id),6)+
			
			+tii.isin+right('000000000000000'+(convert(varchar(12),sum(vtm.Quantity))),12)+'O'
			+right('0000000000000000'+vtm.client_id,16)
			+right('000000000000'+convert(varchar(12),ROW_NUMBER() over(order by ti.bo_code)),12) as body
			,'02'+right('000000'+tdp.dp_no,6)+@date+right('00'+convert(varchar(2),@running_sl_no),2) as fName
			,right('0000000'+convert(varchar(7),@total_records),7)
			+right('0000000000000'+convert(varchar(13),@total_quantity),13)
			+' Admin'+right('000000'+tdp.dp_no,6)+'10' as head
			 from 
			 [Trade].[vw_today_maturity] vtm
			 inner join Investor.tblInvestor ti on vtm.client_id = ti.client_id
			 inner join broker.tblDepositoryPerticipant tdp on left(ti.bo_code,8) = tdp.bo_reference_no
			 inner join Instrument.tblInstrument tii on vtm.instrument_id = tii.id
			where transaction_type = 'B'
			and len(isnull(tii.isin,'')) = 12
			and len(isnull(ti.bo_code,'')) = 16
			and vtm.settle_date = @trd_dt
			group by ti.bo_code
			,tdp.clearance_no
			,tdp.membership_id
			,tii.isin
			,vtm.client_id
			,tdp.dp_no
	END
	
	
END


GO
/****** Object:  StoredProcedure [CDBL].[psp_ipo]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- exec CDBL.psp_ipo '14-Dec-2015', '14-Dec-2015', 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a',  '14-Dec-2015', 1
-- =============================================
-- Author:		Asif
-- Create date: 17/10/15
-- Description:	Process ipo
-- Updated by : Sarwar
-- Update Date: 12/07/2015
-- Description: Add validation for invalid IPO uploaded data
-- =============================================
CREATE PROCEDURE [CDBL].[psp_ipo]
(
@from_date varchar(50),
@to_date varchar(50),
@membership_id numeric(9,0),
@changed_user_id nvarchar(128),
@changed_date datetime,
@is_dirty numeric(1,0)
)

AS

BEGIN
	 SET NOCOUNT OFF
	

	 DECLARE @ERROR_MESSAGE VARCHAR(MAX)
	 DECLARE @active_status_id int;
	 DECLARE @object_value_id NUMERIC(4)

	 SELECT @active_status_id = tcov.object_value_id
	 FROM dbo.tblConstantObject tco
	 INNER JOIN dbo.tblConstantObjectValue tcov ON tcov.object_id = tco.object_id
	 WHERE tco.object_name = 'ACTIVE_STATUS'
	 AND tcov.display_value = 'Active'
	 
	--GET OBJECT ID
	SELECT @object_value_id= A.object_value_id 
	FROM
	tblConstantObjectValue A
	INNER JOIN tblConstantObject B ON B.object_id=A.object_id
	where 
	B.object_name='SHARE_LEDGER_TYPE'
	AND A.display_value='IPO'

	 BEGIN TRANSACTION
	 
		BEGIN TRY

		   	-----------------------Insert data from temp table to ipo-----------------------
			
			INSERT INTO [CDBL].[tblCdblIpo]
			(
				isin,
				company_name,
				trans_date,
				bo_code,
				bo_name,
				qty,
				lock_qty,
				transaction_date,
				active_status_id,
				membership_id,
				changed_user_id,
				changed_date,
				is_dirty
			)
			SELECT
			a.isin,
			a.company_name,
			a.trans_date,
			a.bo_code,
			a.bo_name,
			CONVERT(numeric(5,0),a.qty) qty,
			CONVERT(numeric(5,0),a.lock_qty) lock_qty,
			a.transaction_date,
			@active_status_id,
			@membership_id,
			@changed_user_id,
			@changed_date,
			@is_dirty
			FROM [CDBL].[16DP95UX] a
			LEFT JOIN [CDBL].[tblCdblIpo] tci ON a.isin = tci.isin AND a.bo_code = tci.bo_code AND CONVERT(DATETIME, tci.trans_date)=CONVERT(DATETIME, a.trans_date)
			WHERE
			CONVERT(Datetime, a.transaction_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120)
			AND tci.isin IS NULL
			
			-----------------------End insert data from temp table to ipo-----------------------


			----------IF DATA INSERTED SUCCESSFULLY THEN EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE IPO---------
			--CALL SHARE TRANSACTION PROCESS
				EXEC [Investor].[psp_investor_share_transaction] NULL,@object_value_id,@membership_id,@changed_user_id
			------------------END OF  EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE IPO---------

			TRUNCATE TABLE [CDBL].[16DP95UX]
			COMMIT TRANSACTION
		END TRY
		
		BEGIN CATCH
		
			ROLLBACK TRANSACTION
			SET @ERROR_MESSAGE=ERROR_MESSAGE()
			RAISERROR(@ERROR_MESSAGE,16,1)
		END CATCH	 
END


GO
/****** Object:  StoredProcedure [CDBL].[psp_transmission]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- exec CDBL.psp_transmission '16-JUN-2015', '16-JUN-2015', 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a', getdate(), 1
-- =============================================
-- Author:		Asif
-- Create date: 17/10/15
-- Description:	Process Transmission
-- =============================================
CREATE PROCEDURE [CDBL].[psp_transmission]
(
@from_date varchar(50),
@to_date varchar(50),
@membership_id numeric(9,0),
@changed_user_id nvarchar(128),
@changed_date datetime,
@is_dirty numeric(1,0)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF

	 DECLARE @ERROR_MESSAGE VARCHAR(MAX)
	 DECLARE @active_status_id int;
	 DECLARE @object_value_id NUMERIC(4)

	 SELECT @active_status_id = tcov.object_value_id
	 FROM dbo.tblConstantObject tco
	 INNER JOIN dbo.tblConstantObjectValue tcov ON tcov.object_id = tco.object_id
	 WHERE tco.object_name = 'ACTIVE_STATUS'
	 AND tcov.display_value = 'Active'
	 

	 --GET OBJECT ID
	SELECT @object_value_id= A.object_value_id 
	FROM
	tblConstantObjectValue A
	INNER JOIN tblConstantObject B ON B.object_id=A.object_id
	where 
	B.object_name='SHARE_LEDGER_TYPE'
	AND A.display_value='TRANSMISSION'


	 BEGIN TRANSACTION
	 
		BEGIN TRY

		
			-----------------------Insert data from temp table to transmission-----------------------
			
			INSERT INTO [CDBL].[tblCdblTransmission]
			(
				isin,
				company_name,
				transferor_bo_code,
				transferor_bo_name,
				transfree_bo_code,
				transfree_bo_name,
				qty,
				transaction_date,
				active_status_id,
				membership_id,
				changed_user_id,
				changed_date,
				is_dirty,
				RATE
			)
			SELECT
			a.isin,
			a.company_name,
			a.transferor_bo_code,
			a.transferor_bo_name,
			a.transfree_bo_code,
			a.transfree_bo_name,
			CONVERT(numeric(5,0),a.qty) qty,
			a.transaction_date,
			@active_status_id,
			@membership_id,
			@changed_user_id,
			@changed_date,
			@is_dirty,
			A.RATE
			FROM [CDBL].[11DP81UX] a
			LEFT JOIN [CDBL].[tblCdblTransmission] tct ON a.isin = tct.isin AND a.transferor_bo_code = tct.transferor_bo_code AND a.transfree_bo_code = tct.transfree_bo_code AND CONVERT(DATETIME,A.transaction_date)=CONVERT(DATETIME,TCT.transaction_date)
			WHERE CONVERT(Datetime, a.transaction_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120)
			AND tct.isin IS NULL
			
			-----------------------End insert data from temp table to transmission-----------------------


			----------IF DATA INSERTED SUCCESSFULLY THEN EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE TRANSMISSION DATA---------
			--CALL SHARE TRANSACTION PROCESS
			EXEC [Investor].[psp_investor_share_transaction] null,@object_value_id,@membership_id,@changed_user_id
			------------------END OF  EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE TRANSMISSION DATA---------

			TRUNCATE TABLE  [CDBL].[11DP81UX] 
			COMMIT TRANSACTION
		END TRY
		
		BEGIN CATCH
		
			ROLLBACK TRANSACTION
			SET @ERROR_MESSAGE=ERROR_MESSAGE()
			RAISERROR(@ERROR_MESSAGE,16,1)
		END CATCH	 
END


GO
/****** Object:  StoredProcedure [CDBL].[ssp_CDBL_invalid_data_list]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [CDBL].[ssp_CDBL_invalid_data_list]
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
	DISTINCT @ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) + T1.[isin]
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
	DISTINCT @ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[isin]
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
	DISTINCT @ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[isin]
	FROM
	[CDBL].[17DP70UX] T1
	LEFT JOIN [Instrument].[tblInstrument] T3 ON T3.[isin]=T1.[isin]
	WHERE
	T1.share_transaction_type ='RIGHTS'
	AND ISNULL(T1.rate,0) =0

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[17DP70UX]' TBL_NAME
	,'Right value cannot be zero' ERROR_TITLE
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
	DISTINCT @ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[isin]
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
	DISTINCT @ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[isin]
	FROM
	[CDBL].[16DP95UX] T1
	LEFT JOIN [Instrument].[tblInstrument] T3 ON T3.[isin]=T1.[isin]
	WHERE
	(ISNULL(T3.face_value,0) + ISNULL(T3.premium,0)) =0

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[16DP95UX]' TBL_NAME
	,'IPO share rate cannot be zero' ERROR_TITLE
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



IF EXISTS(SELECT @display_names WHERE @display_names LIKE '%TRANSMISSION%')
BEGIN
	--File: [11DP81UX]--(TRANSMISSION)-----------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.transferor_bo_code
	FROM
	[CDBL].[11DP81UX] T1
	LEFT JOIN [Investor].[tblInvestor] T3 ON T3.[bo_code]=T1.transferor_bo_code
	WHERE
	T3.[bo_code] IS NULL

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[11DP81UX]' TBL_NAME
	,'Invalid BO Code' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL


	--File: [11DP81UX]--(TRANSMISSION)-----------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	DISTINCT @ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.[isin]
	FROM
	[CDBL].[11DP81UX] T1
	LEFT JOIN [Instrument].[tblInstrument] T3 ON T3.[isin]=T1.[isin]
	WHERE
	T3.[isin] IS NULL

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[11DP81UX]' TBL_NAME
	,'Invalid ISIN' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL


	--File: [11DP81UX]--(TRANSMISSION)-----------------------------
	SET @ERROR_MESSAGE=NULL
	SELECT
	DISTINCT @ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +T1.transferor_bo_code
	FROM
	[CDBL].[11DP81UX] T1
	WHERE
	ISNULL(T1.Rate,0) =0

	INSERT INTO CDBL.[tmpInvalidUploadedData]
	SELECT 
	'[11DP81UX]' TBL_NAME
	,'Transmission share rate cannot be zero' ERROR_TITLE
	,@ERROR_MESSAGE
	WHERE 
	@ERROR_MESSAGE IS NOT NULL
	
END



--SELECT INVALID DATA
SELECT
*
FROM
	CDBL.[tmpInvalidUploadedData]


GO
/****** Object:  StoredProcedure [CDBL].[ssp_cdbl_search]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [CDBL].[ssp_cdbl_search]
(
@table_name varchar(100),
@display_name varchar(100),
@from_date varchar(100),
@to_date varchar(100),
@isin varchar(12),
@cliend_id varchar(10),
@bo_code varchar(16)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
	 DECLARE @sqlCommand nvarchar(1000)
	
	IF(@display_name = 'BO Registration')
		BEGIN
			SET @sqlCommand = 'SELECT a.*
			FROM ' + @table_name + ' a
			LEFT JOIN [Escrow.BOAS].[Investor].[tblInvestor] ti ON a.bo_code = ti.bo_code
			WHERE CONVERT(Datetime, a.opening_date, 120) BETWEEN CONVERT(Datetime,''' + @from_date + ''', 120) AND CONVERT(Datetime,''' + @to_date + ''', 120)
			AND (ti.client_id = @cliend_id OR @cliend_id IS NULL)
			AND (a.bo_code = @bo_code OR @bo_code IS NULL)'
		END
	ELSE IF(@display_name = 'Transmission')
		BEGIN
			SET @sqlCommand = 'SELECT a.*
			FROM ' + @table_name + ' a
			LEFT JOIN [Escrow.BOAS].[Investor].[tblInvestor] transferorti ON a.transferor_bo_code = transferorti.bo_code
			LEFT JOIN [Escrow.BOAS].[Investor].[tblInvestor] transfreeti ON a.transfree_bo_code = transfreeti.bo_code
			WHERE CONVERT(Datetime, a.transaction_date, 120) BETWEEN CONVERT(Datetime,''' + @from_date + ''', 120) AND CONVERT(Datetime,''' + @to_date + ''', 120)
			AND (a.isin = @isin OR @isin IS NULL)
			AND (transferorti.client_id = @cliend_id OR transfreeti.client_id = @cliend_id OR @cliend_id IS NULL)
			AND (a.transferor_bo_code = @bo_code OR a.transfree_bo_code = @bo_code OR @bo_code IS NULL)'
		END
	ELSE
		BEGIN
			SET @sqlCommand = 'SELECT a.*
			FROM ' + @table_name + ' a
			LEFT JOIN [Escrow.BOAS].[Investor].[tblInvestor] ti ON a.bo_code = ti.bo_code
			WHERE CONVERT(Datetime, a.transaction_date, 120) BETWEEN CONVERT(Datetime,''' + @from_date + ''', 120) AND CONVERT(Datetime,''' + @to_date + ''', 120)
			AND (a.isin = @isin OR @isin IS NULL)
			AND (ti.client_id = @cliend_id OR @cliend_id IS NULL)
			AND (a.bo_code = @bo_code OR @bo_code IS NULL)'
		END
		
		EXECUTE sp_executesql @sqlCommand, N'@isin varchar(12),@cliend_id varchar(10),@bo_code varchar(16)', @isin = @isin, @cliend_id = @cliend_id, @bo_code = @bo_code
END

GO
/****** Object:  StoredProcedure [CDBL].[usp_rights_market_price]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [CDBL].[usp_rights_market_price]
(
@from_date varchar(100),
@to_date varchar(100),
@isin varchar(12),
@cliend_id varchar(10),
@bo_code varchar(16)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
	 UPDATE a
	 SET a.rate = CONVERT(varchar(10),ti.face_value)
	 FROM [CDBL].[17DP70UX] a
	 INNER JOIN [Instrument].[tblInstrument] ti ON ti.isin = a.isin
	 LEFT JOIN [Investor].[tblInvestor] tinv ON a.bo_code = tinv.bo_code
	 WHERE CONVERT(Datetime, a.transaction_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120)
	 AND a.share_transaction_type = 'RIGHTS'
	 AND (a.isin = @isin OR @isin IS NULL)
	 AND (tinv.client_id = @cliend_id OR @cliend_id IS NULL)
	 AND (a.bo_code = @bo_code OR @bo_code IS NULL)
	 
END

GO
/****** Object:  StoredProcedure [CDBL].[usp_rights_unit_price]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [CDBL].[usp_rights_unit_price]
(
@from_date varchar(100),
@to_date varchar(100),
@isin varchar(12),
@cliend_id varchar(10),
@bo_code varchar(16),
@unit_price varchar(20)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
	 UPDATE a
	 SET a.rate = @unit_price
	 FROM [CDBL].[17DP70UX] a
	 LEFT JOIN [Investor].[tblInvestor] ti ON a.bo_code = ti.bo_code
	 WHERE CONVERT(Datetime, a.transaction_date, 120) BETWEEN CONVERT(Datetime,@from_date, 120) AND CONVERT(Datetime,@to_date, 120)
	 AND a.share_transaction_type = 'RIGHTS'
	 AND (a.isin = @isin OR @isin IS NULL)
	 AND (ti.client_id = @cliend_id OR @cliend_id IS NULL)
	 AND (a.bo_code = @bo_code OR @bo_code IS NULL)
	 
END

GO
/****** Object:  StoredProcedure [dbo].[psp_day_end]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 11/1/2015
-- =============================================

--[dbo].[psp_day_end] 20151102,'1bf1c0e7-fa04-4266-9ce4-d20d6516737a',62
CREATE PROCEDURE [dbo].[psp_day_end]
	@process_dt numeric(8,0)
	,@end_by nvarchar(MAX)
	,@membership_id numeric(9,0)
AS
BEGIN


		
	-------Update day end Started-------------
	SET NOCOUNT ON;
	
	DECLARE @result VARCHAR(MAX)
	
	BEGIN TRANSACTION
	BEGIN TRY
		update tblDayProcess 
		set end_date = GETDATE(),
		end_by = @end_by
		where process_date = @process_dt
		-------Update day end Completed-------------

		-------Insert day Start-----------
	
		EXEC psp_day_start @process_dt,@end_by,@membership_id

		-------Insert day Start Completed-----------
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT @result = ERROR_MESSAGE()
		ROLLBACK TRANSACTION
		RAISERROR(@result,16,1)
	END CATCH

	

END


GO
/****** Object:  StoredProcedure [dbo].[psp_day_start]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 01/11/2015
-- Description:	Go for Day Start
-- Updated by : Sarwar
-- Update Date: 12/08/2015
-- Description: Added block for CASH AND SHARE MATURITY PROCESS CALL
-- =============================================
CREATE PROCEDURE [dbo].[psp_day_start]
	-- Add the parameters for the stored procedure here
	@process_dt numeric(8,0)
	,@start_by nvarchar(MAX)
    ,@membership_id numeric(9,0)
AS
BEGIN
declare 
		@isTradePermitted bit
		set  @isTradePermitted = 0

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
	-------Insert day Start-----------
	
		while(@isTradePermitted = 0)
		BEGIN
			select @process_dt = datekey from DimDate where Date = DateAdd(day,1,(select Date  from DimDate where DateKey= @process_dt))
			if not exists (select non_trading_date from Trade.tblNonTradingDetail where non_trading_date = @process_dt)
			BEGIN
				INSERT INTO [dbo].[tblDayProcess]
				   ([process_date]
				   ,[start_date]
				   ,[start_by]
				   ,[membership_id])
				VALUES
				   (@process_dt
				   ,getdate()
				   ,@start_by
				   ,@membership_id)

			   SET @isTradePermitted = 1
			END
		END
		-------Insert day Start Completed-----------
		
		DECLARE @PROCESS_DATE AS NUMERIC(9,0),
		@MAX_VOUCHER_NO AS varchar(15),
		@ids AS varchar(MAX),
		@FINANCIAL_LEDGER_TYPE_ID AS NUMERIC(4,0),
		@result VARCHAR(MAX)

		SELECT @PROCESS_DATE=dbo.sfun_get_process_date()

		SELECT @MAX_VOUCHER_NO = voucher_no 
		FROM [Transaction].[tblFundWithdraw] 
		WHERE (SELECT MAX(id) FROM [Transaction].[tblFundWithdraw]) = id
		
		SELECT @FINANCIAL_LEDGER_TYPE_ID = tcov.object_value_id 
		FROM dbo.tblConstantObjectValue tcov 
		INNER JOIN dbo.tblConstantObject tco ON tco.object_id = tcov.object_id 
		WHERE tco.object_name = 'FINANCIAL_LEDGER_TYPE'
		AND tcov.display_value = 'Withdraw Request'
		
		
		
		
		----start---------------------------------------------------------Insert fund payment start-------------------------------------------------------------------------
		
		INSERT INTO [Transaction].tblFundWithdraw
		(
			voucher_no
			,client_id
			,transaction_mode_id
			,bank_branch_id
			,cheque_no
			,cheque_date
			,amount
			,withdraw_date
			,value_date
			,broker_branch_id
			,remarks
			,active_status_id
			,membership_id
			,changed_user_id
			,changed_date
			,is_dirty
		)
		SELECT CASE WHEN CAST(REPLACE(CONVERT(VARCHAR(30), GETDATE(), 111),'/','') AS numeric(15,0)) = SUBSTRING(@MAX_VOUCHER_NO,1,8) THEN CAST(@MAX_VOUCHER_NO AS numeric(15,0)) + ROW_NUMBER() OVER(ORDER BY tfwr.id ASC)
			ELSE CAST(REPLACE(CONVERT(VARCHAR(30), GETDATE(), 111),'/','') + '00000' AS numeric(15,0)) + ROW_NUMBER() OVER(ORDER BY tfwr.id DESC) END AS voucher_no
			,tfwr.client_id
			,tfwr.transaction_mode_id
			,tfwr.bank_branch_id
			,tfwr.cheque_no
			,tfwr.cheque_date
			,tfwr.amount
			,tfwr.effective_date
			,@PROCESS_DATE AS value_date
			,tfwr.broker_branch_id
			,tfwr.remarks
			,tfwr.active_status_id
			,@membership_id
			,@start_by
			,GETDATE()
			,tfwr.is_dirty
			FROM [Transaction].[tblFundWithdrawalRequest] tfwr
			INNER JOIN dbo.tblConstantObjectValue tcovas ON tcovas.object_value_id = tfwr.active_status_id
			INNER JOIN Investor.tblInvestor ti ON ti.client_id = tfwr.client_id
			INNER JOIN dbo.tblConstantObjectValue tcovias ON tcovias.object_value_id = ti.active_status_id
			WHERE tfwr.approve_date IS NOT NULL
			AND tfwr.approve_by IS NOT NULL
			AND tfwr.is_dirty = 1
			AND tfwr.effective_date <= @PROCESS_DATE
			AND tcovas.display_value = 'Active'
			AND tcovias.display_value = 'Active'
			AND tfwr.membership_id = @membership_id
			
		SELECT *
			INTO #temp
			FROM
			(
				SELECT tfwr.id
				,1 AS p_id
				FROM [Transaction].[tblFundWithdrawalRequest] tfwr
				INNER JOIN dbo.tblConstantObjectValue tcovas ON tcovas.object_value_id = tfwr.active_status_id
				INNER JOIN Investor.tblInvestor ti ON ti.client_id = tfwr.client_id
				INNER JOIN dbo.tblConstantObjectValue tcovias ON tcovias.object_value_id = ti.active_status_id
				WHERE tfwr.approve_date IS NOT NULL
				AND tfwr.approve_by IS NOT NULL
				AND tfwr.is_dirty = 1
				AND tfwr.effective_date <= @PROCESS_DATE
				AND tcovas.display_value = 'Active'
				AND tcovias.display_value = 'Active'
				AND tfwr.membership_id = @membership_id
			) a
			
		SELECT @ids = b.ids
			FROM
			(
				SELECT
				STUFF
				(
					(
						SELECT ',' + CAST(id AS varchar(18)) 
						FROM #temp
						WHERE p_id = t.p_id FOR XML path('')
					),1,1,''
				) AS ids
				FROM 
				(
					SELECT DISTINCT p_id
					FROM #temp
				) t
			) b
			
		EXEC Investor.psp_investor_financial_transaction @ids, @FINANCIAL_LEDGER_TYPE_ID, @membership_id, @start_by
		
		UPDATE tfwr
		SET tfwr.is_dirty = 0
		FROM [Transaction].[tblFundWithdrawalRequest] tfwr
		INNER JOIN dbo.tblConstantObjectValue tcovas ON tcovas.object_value_id = tfwr.active_status_id
		INNER JOIN Investor.tblInvestor ti ON ti.client_id = tfwr.client_id
		INNER JOIN dbo.tblConstantObjectValue tcovias ON tcovias.object_value_id = ti.active_status_id
		WHERE tfwr.approve_date IS NOT NULL
		AND tfwr.approve_by IS NOT NULL
		AND tfwr.is_dirty = 1
		AND tfwr.effective_date <= @PROCESS_DATE
		AND tcovas.display_value = 'Active'
		AND tcovias.display_value = 'Active'
		AND tfwr.membership_id = @membership_id
		
		----end-----------------------------------------------------------Insert fund payment completed--------------------------------------------------------------------

		----start---------------------------------------------------------Share Settlement Process--------------------------------------------------------------------
		SELECT 
		@FINANCIAL_LEDGER_TYPE_ID= A.object_value_id 
		FROM
		tblConstantObjectValue A
		INNER JOIN tblConstantObject B ON B.object_id=A.object_id
		where 
		B.object_name='SHARE_LEDGER_TYPE'
		AND A.display_value='Share Settlement'

		--Call share transaction execution process
		EXEC Investor.psp_investor_share_transaction @PROCESS_DATE, @FINANCIAL_LEDGER_TYPE_ID, @membership_id, @start_by

		----end-----------------------------------------------------------Share Settlement Process--------------------------------------------------------------------

		----start---------------------------------------------------------Cash Settlement Process--------------------------------------------------------------------
		SELECT 
		@FINANCIAL_LEDGER_TYPE_ID= A.object_value_id 
		FROM
		tblConstantObjectValue A
		INNER JOIN tblConstantObject B ON B.object_id=A.object_id
		where 
		B.object_name='FINANCIAL_LEDGER_TYPE'
		AND A.display_value='Fund Mature'

		--Call cash transaction execution process
		EXEC Investor.psp_investor_financial_transaction @PROCESS_DATE, @FINANCIAL_LEDGER_TYPE_ID, @membership_id, @start_by

		----end-----------------------------------------------------------Cash Settlement Process--------------------------------------------------------------------





	END TRY
	BEGIN CATCH
		SELECT @result = ERROR_MESSAGE()
		RAISERROR(@result,16,1)
	END CATCH

   
END



GO
/****** Object:  StoredProcedure [dbo].[psp_db_backup]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 12/02/15
-- Description:	Take database backup
-- =============================================

---psp_db_backup "Escrow","C:\BK\"
CREATE PROCEDURE [dbo].[psp_db_backup]
(
	 @name VARCHAR(50),
	 @path VARCHAR(256)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @fileName VARCHAR(256) 
	DECLARE @fileDate VARCHAR(20) 
	DECLARE @db_name  VARCHAR(20) 

SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

set @db_name = (SELECT name 
FROM master.dbo.sysdatabases 
WHERE name = 'Escrow.BOAS')


SET @fileName = @path + @name + '_' + @fileDate + '.BAK'

BACKUP DATABASE @db_name TO DISK = @fileName


END


GO
/****** Object:  StoredProcedure [dbo].[psp_generate_dimensionDate]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec psp_generate_dimensionDate '2000-01-01', '2021-12-31'
-- =============================================
CREATE PROCEDURE [dbo].[psp_generate_dimensionDate]
	 @StartDate DATETIME
	,@EndDate DATETIME 
AS
BEGIN

	SET @EndDate=DATEADD(D,1,@EndDate)
	--Temporary Variables To Hold the Values During Processing of Each Date of Year
	DECLARE
		@DayOfWeekInMonth INT,
		@DayOfWeekInYear INT,
		@DayOfQuarter INT,
		@WeekOfMonth INT,
		@CurrentYear INT,
		@CurrentMonth INT,
		@CurrentQuarter INT

	/*Table Data type to store the day of week count for the month and year*/
	DECLARE @DayOfWeek TABLE (DOW INT, MonthCount INT, QuarterCount INT, YearCount INT)

	INSERT INTO @DayOfWeek VALUES (1, 0, 0, 0)
	INSERT INTO @DayOfWeek VALUES (2, 0, 0, 0)
	INSERT INTO @DayOfWeek VALUES (3, 0, 0, 0)
	INSERT INTO @DayOfWeek VALUES (4, 0, 0, 0)
	INSERT INTO @DayOfWeek VALUES (5, 0, 0, 0)
	INSERT INTO @DayOfWeek VALUES (6, 0, 0, 0)
	INSERT INTO @DayOfWeek VALUES (7, 0, 0, 0)

	--Extract and assign part of Values from Current Date to Variable

	DECLARE @CurrentDate AS DATETIME = @StartDate
	SET @CurrentMonth = DATEPART(MM, @CurrentDate)
	SET @CurrentYear = DATEPART(YY, @CurrentDate)
	SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)

	/********************************************************************************************/
	--Proceed only if Start Date(Current date ) is less than End date you specified above

	WHILE @CurrentDate < @EndDate
	BEGIN
		IF NOT EXISTS (SELECT * FROM DimDate WHERE Date=@CurrentDate)
		BEGIN
			/*Begin day of week logic*/

			 /*Check for Change in Month of the Current date if Month changed then 
			  Change variable value*/
			IF @CurrentMonth != DATEPART(MM, @CurrentDate) 
			BEGIN
				UPDATE @DayOfWeek
				SET MonthCount = 0
				SET @CurrentMonth = DATEPART(MM, @CurrentDate)
			END

				/* Check for Change in Quarter of the Current date if Quarter changed then change 
				 Variable value*/

			IF @CurrentQuarter != DATEPART(QQ, @CurrentDate)
			BEGIN
				UPDATE @DayOfWeek
				SET QuarterCount = 0
				SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)
			END
       
				/* Check for Change in Year of the Current date if Year changed then change 
				 Variable value*/
	

			IF @CurrentYear != DATEPART(YY, @CurrentDate)
			BEGIN
				UPDATE @DayOfWeek
				SET YearCount = 0
				SET @CurrentYear = DATEPART(YY, @CurrentDate)
			END
	
				-- Set values in table data type created above from variables 

			UPDATE @DayOfWeek
			SET 
				MonthCount = MonthCount + 1,
				QuarterCount = QuarterCount + 1,
				YearCount = YearCount + 1
			WHERE DOW = DATEPART(DW, @CurrentDate)

			SELECT
				@DayOfWeekInMonth = MonthCount,
				@DayOfQuarter = QuarterCount,
				@DayOfWeekInYear = YearCount
			FROM @DayOfWeek
			WHERE DOW = DATEPART(DW, @CurrentDate)
	
		/*End day of week logic*/


		/* Populate Your Dimension Table with values*/
	
			INSERT INTO [dbo].[DimDate](DateKey,[Date],FullDateUK,FullDateUSA,[DayOfMonth],DaySuffix,[DayName],DayOfWeekUSA,DayOfWeekUK,DayOfWeekInMonth,DayOfWeekInYear,DayOfQuarter,[DayOfYear],WeekOfMonth
				,WeekOfQuarter,WeekOfYear,[Month],[MonthName],MonthOfQuarter,[Quarter],QuarterName,[Year],YearName,MonthYear,MMYYYY,FirstDayOfMonth,LastDayOfMonth,FirstDayOfQuarter,LastDayOfQuarter,FirstDayOfYear
				,LastDayOfYear,IsHolidayUSA,IsWeekday,HolidayUSA,IsHolidayUK,HolidayUK,IsHoliday,Holiday)
			SELECT
		
				CONVERT (char(8),@CurrentDate,112) as DateKey,
				@CurrentDate AS Date,
				CONVERT (char(10),@CurrentDate,103) as FullDateUK,
				CONVERT (char(10),@CurrentDate,101) as FullDateUSA,
				DATEPART(DD, @CurrentDate) AS DayOfMonth,
				--Apply Suffix values like 1st, 2nd 3rd etc..
				CASE 
					WHEN DATEPART(DD,@CurrentDate) IN (11,12,13) THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'th'
					WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 1 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'st'
					WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 2 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'nd'
					WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 3 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'rd'
					ELSE CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'th' 
					END AS DaySuffix,
		
				DATENAME(DW, @CurrentDate) AS DayName,
				DATEPART(DW, @CurrentDate) AS DayOfWeekUSA,
				-- check for day of week as Per US and change it as per UK format 
				CASE DATEPART(DW, @CurrentDate)
					WHEN 1 THEN 7
					WHEN 2 THEN 1
					WHEN 3 THEN 2
					WHEN 4 THEN 3
					WHEN 5 THEN 4
					WHEN 6 THEN 5
					WHEN 7 THEN 6
					END 
					AS DayOfWeekUK,
		
				@DayOfWeekInMonth AS DayOfWeekInMonth,
				@DayOfWeekInYear AS DayOfWeekInYear,
				@DayOfQuarter AS DayOfQuarter,
				DATEPART(DY, @CurrentDate) AS DayOfYear,
				DATEPART(WW, @CurrentDate) + 1 - DATEPART(WW, CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)) + '/1/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS WeekOfMonth,
				(DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0), @CurrentDate) / 7) + 1 AS WeekOfQuarter,
				DATEPART(WW, @CurrentDate) AS WeekOfYear,
				DATEPART(MM, @CurrentDate) AS Month,
				DATENAME(MM, @CurrentDate) AS MonthName,
				CASE
					WHEN DATEPART(MM, @CurrentDate) IN (1, 4, 7, 10) THEN 1
					WHEN DATEPART(MM, @CurrentDate) IN (2, 5, 8, 11) THEN 2
					WHEN DATEPART(MM, @CurrentDate) IN (3, 6, 9, 12) THEN 3
					END AS MonthOfQuarter,
				DATEPART(QQ, @CurrentDate) AS Quarter,
				CASE DATEPART(QQ, @CurrentDate)
					WHEN 1 THEN 'First'
					WHEN 2 THEN 'Second'
					WHEN 3 THEN 'Third'
					WHEN 4 THEN 'Fourth'
					END AS QuarterName,
				DATEPART(YEAR, @CurrentDate) AS Year,
				'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
				LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MonthYear,
				RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)),2) + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
				CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, @CurrentDate) - 1), @CurrentDate))) AS FirstDayOfMonth,
				CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, (DATEADD(MM, 1, @CurrentDate)))), DATEADD(MM, 1, @CurrentDate)))) AS LastDayOfMonth,
				DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0) AS FirstDayOfQuarter,
				DATEADD(QQ, DATEDIFF(QQ, -1, @CurrentDate), -1) AS LastDayOfQuarter,
				CONVERT(DATETIME, '01/01/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS FirstDayOfYear,
				CONVERT(DATETIME, '12/31/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS LastDayOfYear,
				NULL AS IsHolidayUSA,
				CASE DATEPART(DW, @CurrentDate)
					WHEN 1 THEN 0
					WHEN 2 THEN 1
					WHEN 3 THEN 1
					WHEN 4 THEN 1
					WHEN 5 THEN 1
					WHEN 6 THEN 1
					WHEN 7 THEN 0
					END AS IsWeekday,
				NULL AS HolidayUSA, Null, Null, Null, Null
		END
		SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
	END






	/*Add HOLIDAYS UK*/
	
	-- Good Friday  April 18 
		UPDATE [dbo].[DimDate]
			SET HolidayUK = 'Good Friday'
		WHERE [Month] = 4 AND [DayOfMonth]  = 18
	-- Easter Monday  April 21 
		UPDATE [dbo].[DimDate]
			SET HolidayUK = 'Easter Monday'
		WHERE [Month] = 4 AND [DayOfMonth]  = 21
	-- Early May Bank Holiday   May 5 
	   UPDATE [dbo].[DimDate]
			SET HolidayUK = 'Early May Bank Holiday'
		WHERE [Month] = 5 AND [DayOfMonth]  = 5
	-- Spring Bank Holiday  May 26 
		UPDATE [dbo].[DimDate]
			SET HolidayUK = 'Spring Bank Holiday'
		WHERE [Month] = 5 AND [DayOfMonth]  = 26
	-- Summer Bank Holiday  August 25 
		UPDATE [dbo].[DimDate]
			SET HolidayUK = 'Summer Bank Holiday'
		WHERE [Month] = 8 AND [DayOfMonth]  = 25
	-- Boxing Day  December 26  	
		UPDATE [dbo].[DimDate]
			SET HolidayUK = 'Boxing Day'
		WHERE [Month] = 12 AND [DayOfMonth]  = 26	
	--CHRISTMAS
		UPDATE [dbo].[DimDate]
			SET HolidayUK = 'Christmas Day'
		WHERE [Month] = 12 AND [DayOfMonth]  = 25
	--New Years Day
		UPDATE [dbo].[DimDate]
			SET HolidayUK  = 'New Year''s Day'
		WHERE [Month] = 1 AND [DayOfMonth] = 1
	
		UPDATE [dbo].[DimDate] 
		SET IsHolidayUK = CASE WHEN HolidayUK IS NULL THEN 0 WHEN HolidayUK IS NOT NULL THEN 1 END 


		/*Add HOLIDAYS USA*/
		/*THANKSGIVING - Fourth THURSDAY in November*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Thanksgiving Day'
		WHERE
			[Month] = 11 
			AND [DayOfWeekUSA] = 'Thursday' 
			AND DayOfWeekInMonth = 4

		/*CHRISTMAS*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Christmas Day'
		
		WHERE [Month] = 12 AND [DayOfMonth]  = 25

		/*4th of July*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Independance Day'
		WHERE [Month] = 7 AND [DayOfMonth] = 4

		/*New Years Day*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'New Year''s Day'
		WHERE [Month] = 1 AND [DayOfMonth] = 1

		/*Memorial Day - Last Monday in May*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Memorial Day'
		FROM [dbo].[DimDate]
		WHERE DateKey IN 
			(
			SELECT
				MAX(DateKey)
			FROM [dbo].[DimDate]
			WHERE
				[MonthName] = 'May'
				AND [DayOfWeekUSA]  = 'Monday'
			GROUP BY
				[Year],
				[Month]
			)

		/*Labor Day - First Monday in September*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Labor Day'
		FROM [dbo].[DimDate]
		WHERE DateKey IN 
			(
			SELECT
				MIN(DateKey)
			FROM [dbo].[DimDate]
			WHERE
				[MonthName] = 'September'
				AND [DayOfWeekUSA] = 'Monday'
			GROUP BY
				[Year],
				[Month]
			)

		/*Valentine's Day*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Valentine''s Day'
		WHERE
			[Month] = 2 
			AND [DayOfMonth] = 14

		/*Saint Patrick's Day*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Saint Patrick''s Day'
		WHERE
			[Month] = 3
			AND [DayOfMonth] = 17

		/*Martin Luthor King Day - Third Monday in January starting in 1983*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Martin Luthor King Jr Day'
		WHERE
			[Month] = 1
			AND [DayOfWeekUSA]  = 'Monday'
			AND [Year] >= 1983
			AND DayOfWeekInMonth = 3

		/*President's Day - Third Monday in February*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'President''s Day'
		WHERE
			[Month] = 2
			AND [DayOfWeekUSA] = 'Monday'
			AND DayOfWeekInMonth = 3

		/*Mother's Day - Second Sunday of May*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Mother''s Day'
		WHERE
			[Month] = 5
			AND [DayOfWeekUSA] = 'Sunday'
			AND DayOfWeekInMonth = 2

		/*Father's Day - Third Sunday of June*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Father''s Day'
		WHERE
			[Month] = 6
			AND [DayOfWeekUSA] = 'Sunday'
			AND DayOfWeekInMonth = 3

		/*Halloween 10/31*/
		UPDATE [dbo].[DimDate]
			SET HolidayUSA = 'Halloween'
		WHERE
			[Month] = 10
			AND [DayOfMonth] = 31

		/*Election Day - The first Tuesday after the first Monday in November*/
		BEGIN
			DECLARE @Holidays TABLE (ID INT IDENTITY(1,1), DateID int, Week TINYINT, YEAR CHAR(4), DAY CHAR(2))

			INSERT INTO @Holidays(DateID, [Year],[Day])
			SELECT
				DateKey,
				[Year],
				[DayOfMonth] 
			FROM [dbo].[DimDate]
			WHERE
				[Month] = 11
				AND [DayOfWeekUSA] = 'Monday'
			ORDER BY
				YEAR,
				DayOfMonth 

			DECLARE @CNTR INT, @POS INT, @STARTYEAR INT, @ENDYEAR INT, @MINDAY INT

			SELECT
				@CURRENTYEAR = MIN([Year])
				, @STARTYEAR = MIN([Year])
				, @ENDYEAR = MAX([Year])
			FROM @Holidays

			WHILE @CURRENTYEAR <= @ENDYEAR
			BEGIN
				SELECT @CNTR = COUNT([Year])
				FROM @Holidays
				WHERE [Year] = @CURRENTYEAR

				SET @POS = 1

				WHILE @POS <= @CNTR
				BEGIN
					SELECT @MINDAY = MIN(DAY)
					FROM @Holidays
					WHERE
						[Year] = @CURRENTYEAR
						AND [Week] IS NULL

					UPDATE @Holidays
						SET [Week] = @POS
					WHERE
						[Year] = @CURRENTYEAR
						AND [Day] = @MINDAY

					SELECT @POS = @POS + 1
				END

				SELECT @CURRENTYEAR = @CURRENTYEAR + 1
			END

			UPDATE [dbo].[DimDate]
				SET HolidayUSA  = 'Election Day'				
			FROM [dbo].[DimDate] DT
				JOIN @Holidays HL ON (HL.DateID + 1) = DT.DateKey
			WHERE
				[Week] = 1
		END
	
		UPDATE [dbo].[DimDate]
			SET IsHolidayUSA = CASE WHEN HolidayUSA  IS NULL THEN 0 WHEN HolidayUSA  IS NOT NULL THEN 1 END

	/*******************************************************************************************************************************************************/


	--select * from DimDate 


	--Script 2 fiscal calendar setting in Date dimension
	/*******************************************************************************************************************************************************/
		


	/*******************************************************************************************************************************************************
	The following section needs to be populated for defining the fiscal calendar
	*******************************************************************************************************************************************************/

	DECLARE
		@dtFiscalYearStart SMALLDATETIME = 'January 01, 1995',
		@FiscalYear INT = 1995,
		@LastYear INT = 2025,
		@FirstLeapYearInPeriod INT = 1996

	/*******************************************************************************************************************************************************/

	DECLARE
		@iTemp INT,
		@LeapWeek INT,
		@FiscalDayOfYear INT,
		@FiscalWeekOfYear INT,
		@FiscalMonth INT,
		@FiscalQuarter INT,
		@FiscalQuarterName VARCHAR(10),
		@FiscalYearName VARCHAR(7),
		@LeapYear INT,
		@FiscalFirstDayOfYear DATE,
		@FiscalFirstDayOfQuarter DATE,
		@FiscalFirstDayOfMonth DATE,
		@FiscalLastDayOfYear DATE,
		@FiscalLastDayOfQuarter DATE,
		@FiscalLastDayOfMonth DATE

	/*Holds the years that have 455 in last quarter*/
	DECLARE @LeapTable TABLE (leapyear INT)

	/*TABLE to contain the fiscal year calendar*/
	DECLARE @tb TABLE(
		PeriodDate DATETIME,
		[FiscalDayOfYear] VARCHAR(3),
		[FiscalWeekOfYear] VARCHAR(3),
		[FiscalMonth] VARCHAR(2), 
		[FiscalQuarter] VARCHAR(1),
		[FiscalQuarterName] VARCHAR(9),
		[FiscalYear] VARCHAR(4),
		[FiscalYearName] VARCHAR(7),
		[FiscalMonthYear] VARCHAR(10),
		[FiscalMMYYYY] VARCHAR(6),
		[FiscalFirstDayOfMonth] DATE,
		[FiscalLastDayOfMonth] DATE,
		[FiscalFirstDayOfQuarter] DATE,
		[FiscalLastDayOfQuarter] DATE,
		[FiscalFirstDayOfYear] DATE,
		[FiscalLastDayOfYear] DATE)

	/*Populate the table with all leap years*/
	SET @LeapYear = @FirstLeapYearInPeriod
	WHILE (@LeapYear < @LastYear)
		BEGIN
			INSERT INTO @leapTable VALUES (@LeapYear)
			SET @LeapYear = @LeapYear + 5
		END

	/*Initiate parameters before loop*/
	SET @CurrentDate = @dtFiscalYearStart
	SET @FiscalDayOfYear = 1
	SET @FiscalWeekOfYear = 1
	SET @FiscalMonth = 1
	SET @FiscalQuarter = 1
	SET @FiscalWeekOfYear = 1

	IF (EXISTS (SELECT * FROM @LeapTable WHERE @FiscalYear = leapyear))
		BEGIN
			SET @LeapWeek = 1
		END
		ELSE
		BEGIN
			SET @LeapWeek = 0
		END

	/*******************************************************************************************************************************************************/

	/* Loop on days in interval*/
	WHILE (DATEPART(yy,@CurrentDate) <= @LastYear)
	BEGIN
	
	/*SET fiscal Month*/
		SELECT @FiscalMonth = CASE 
			/*Use this section for a 4-5-4 calendar.  Every leap year the result will be a 4-5-5*/
			WHEN @FiscalWeekOfYear BETWEEN 1 AND 4 THEN 1 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 5 AND 9 THEN 2 /*5 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 10 AND 13 THEN 3 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 14 AND 17 THEN 4 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 18 AND 22 THEN 5 /*5 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 23 AND 26 THEN 6 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 27 AND 30 THEN 7 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 31 AND 35 THEN 8 /*5 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 36 AND 39 THEN 9 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 40 AND 43 THEN 10 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 44 AND (48+@LeapWeek) THEN 11 /*5 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN (49+@LeapWeek) AND (52+@LeapWeek) THEN 12 /*4 weeks (5 weeks on leap year)*/
		
			/*Use this section for a 4-4-5 calendar.  Every leap year the result will be a 4-5-5*/
			/*
			WHEN @FiscalWeekOfYear BETWEEN 1 AND 4 THEN 1 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 5 AND 8 THEN 2 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 9 AND 13 THEN 3 /*5 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 14 AND 17 THEN 4 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 18 AND 21 THEN 5 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 22 AND 26 THEN 6 /*5 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 27 AND 30 THEN 7 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 31 AND 34 THEN 8 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 35 AND 39 THEN 9 /*5 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 40 AND 43 THEN 10 /*4 weeks*/
			WHEN @FiscalWeekOfYear BETWEEN 44 AND (47+@leapWeek) THEN 11 /*4 weeks (5 weeks on leap year)*/
			WHEN @FiscalWeekOfYear BETWEEN (48+@leapWeek) AND (52+@leapWeek) THEN 12 /*5 weeks*/
			*/
		END

		/*SET Fiscal Quarter*/
		SELECT @FiscalQuarter = CASE 
			WHEN @FiscalMonth BETWEEN 1 AND 3 THEN 1
			WHEN @FiscalMonth BETWEEN 4 AND 6 THEN 2
			WHEN @FiscalMonth BETWEEN 7 AND 9 THEN 3
			WHEN @FiscalMonth BETWEEN 10 AND 12 THEN 4
		END
	
		SELECT @FiscalQuarterName = CASE 
			WHEN @FiscalMonth BETWEEN 1 AND 3 THEN 'First'
			WHEN @FiscalMonth BETWEEN 4 AND 6 THEN 'Second'
			WHEN @FiscalMonth BETWEEN 7 AND 9 THEN 'Third'
			WHEN @FiscalMonth BETWEEN 10 AND 12 THEN 'Fourth'
		END
	
		/*Set Fiscal Year Name*/
		SELECT @FiscalYearName = 'FY ' + CONVERT(VARCHAR, @FiscalYear)

		INSERT INTO @tb (PeriodDate, FiscalDayOfYear, FiscalWeekOfYear, fiscalMonth, FiscalQuarter, FiscalQuarterName, FiscalYear, FiscalYearName) VALUES 
		(@CurrentDate, @FiscalDayOfYear, @FiscalWeekOfYear, @FiscalMonth, @FiscalQuarter, @FiscalQuarterName, @FiscalYear, @FiscalYearName)

		/*SET next day*/
		SET @CurrentDate = DATEADD(dd, 1, @CurrentDate)
		SET @FiscalDayOfYear = @FiscalDayOfYear + 1
		SET @FiscalWeekOfYear = ((@FiscalDayOfYear-1) / 7) + 1


		IF (@FiscalWeekOfYear > (52+@LeapWeek))
		BEGIN
			/*Reset a new year*/
			SET @FiscalDayOfYear = 1
			SET @FiscalWeekOfYear = 1
			SET @FiscalYear = @FiscalYear + 1
			IF ( EXISTS (SELECT * FROM @leapTable WHERE @FiscalYear = leapyear))
			BEGIN
				SET @LeapWeek = 1
			END
			ELSE
			BEGIN
				SET @LeapWeek = 0
			END
		END
	END

	/*******************************************************************************************************************************************************/

	/*Set first and last days of the fiscal months*/
	UPDATE @tb
	SET
		FiscalFirstDayOfMonth = minmax.StartDate,
		FiscalLastDayOfMonth = minmax.EndDate
	FROM
	@tb t,
		(
		SELECT FiscalMonth, FiscalQuarter, FiscalYear, MIN(PeriodDate) AS StartDate, MAX(PeriodDate) AS EndDate
		FROM @tb
		GROUP BY FiscalMonth, FiscalQuarter, FiscalYear
		) minmax
	WHERE
		t.FiscalMonth = minmax.FiscalMonth AND
		t.FiscalQuarter = minmax.FiscalQuarter AND
		t.FiscalYear = minmax.FiscalYear 

	/*Set first and last days of the fiscal quarters*/
	UPDATE @tb
	SET
		FiscalFirstDayOfQuarter = minmax.StartDate,
		FiscalLastDayOfQuarter = minmax.EndDate
	FROM
	@tb t,
		(
		SELECT FiscalQuarter, FiscalYear, min(PeriodDate) as StartDate, max(PeriodDate) as EndDate
		FROM @tb
		GROUP BY FiscalQuarter, FiscalYear
		) minmax
	WHERE
		t.FiscalQuarter = minmax.FiscalQuarter AND
		t.FiscalYear = minmax.FiscalYear 

	/*Set first and last days of the fiscal years*/
	UPDATE @tb
	SET
		FiscalFirstDayOfYear = minmax.StartDate,
		FiscalLastDayOfYear = minmax.EndDate
	FROM
	@tb t,
		(
		SELECT FiscalYear, min(PeriodDate) as StartDate, max(PeriodDate) as EndDate
		FROM @tb
		GROUP BY FiscalYear
		) minmax
	WHERE
		t.FiscalYear = minmax.FiscalYear 

	/*Set FiscalYearMonth*/
	UPDATE @tb
	SET
		FiscalMonthYear = 
			CASE FiscalMonth
			WHEN 1 THEN 'Jan'
			WHEN 2 THEN 'Feb'
			WHEN 3 THEN 'Mar'
			WHEN 4 THEN 'Apr'
			WHEN 5 THEN 'May'
			WHEN 6 THEN 'Jun'
			WHEN 7 THEN 'Jul'
			WHEN 8 THEN 'Aug'
			WHEN 9 THEN 'Sep'
			WHEN 10 THEN 'Oct'
			WHEN 11 THEN 'Nov'
			WHEN 12 THEN 'Dec'
			END + '-' + CONVERT(VARCHAR, FiscalYear)

	/*Set FiscalMMYYYY*/
	UPDATE @tb
	SET
		FiscalMMYYYY = RIGHT('0' + CONVERT(VARCHAR, FiscalMonth),2) + CONVERT(VARCHAR, FiscalYear)

	/*******************************************************************************************************************************************************/

	UPDATE [dbo].[DimDate]
		SET
		FiscalDayOfYear = a.FiscalDayOfYear
		, FiscalWeekOfYear = a.FiscalWeekOfYear
		, FiscalMonth = a.FiscalMonth
		, FiscalQuarter = a.FiscalQuarter
		, FiscalQuarterName = a.FiscalQuarterName
		, FiscalYear = a.FiscalYear
		, FiscalYearName = a.FiscalYearName
		, FiscalMonthYear = a.FiscalMonthYear
		, FiscalMMYYYY = a.FiscalMMYYYY
		, FiscalFirstDayOfMonth = a.FiscalFirstDayOfMonth
		, FiscalLastDayOfMonth = a.FiscalLastDayOfMonth
		, FiscalFirstDayOfQuarter = a.FiscalFirstDayOfQuarter
		, FiscalLastDayOfQuarter = a.FiscalLastDayOfQuarter
		, FiscalFirstDayOfYear = a.FiscalFirstDayOfYear
		, FiscalLastDayOfYear = a.FiscalLastDayOfYear
		, FullDateCDBL = UPPER(REPLACE(CONVERT(VARCHAR,B.Date,106),' ','-'))
	FROM @tb a
		INNER JOIN [dbo].[DimDate] b ON a.PeriodDate = b.[Date]

	/*******************************************************************************************************************************************************/

END



GO
/****** Object:  StoredProcedure [dbo].[rsp_employee_information]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[rsp_employee_information]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime,
@employee_code varchar(10),
@name varchar(100),
@national_id varchar(50),
@branch_id numeric(2,0),
@designation_id numeric(4,0),
@department_id numeric(4,0)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF

	SELECT id
	,employee_code
	,name
	,father_name
	,national_id
	,mailing_address,
	permanent_address,
	contact_no,
	email_address
	FROM [broker].[tblEmployee]
	inner join DimDate ddf on @from_dt = ddf.Date
	inner join DimDate ddt on @to_dt = ddt.Date
	WHERE joining_dt between ddf.DateKey AND ddt.DateKey
	AND (employee_code = @employee_code OR @employee_code IS NULL OR @employee_code = '')
	AND (name = @name OR @name IS NULL OR @name = '')
	AND (national_id = @national_id OR @national_id IS NULL OR @national_id = '')
	AND (branch_id = @branch_id OR @branch_id IS NULL OR @branch_id = 0)
	AND (designation_id = @designation_id OR @designation_id IS NULL OR @designation_id = 0)
	AND (department_id = @department_id OR @department_id IS NULL OR @department_id = 0)
	ORDER BY employee_code
	
END



GO
/****** Object:  StoredProcedure [dbo].[ssp_validate_inconsistent_transaction]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_validate_inconsistent_transaction]
AS


	
DECLARE @ERROR_MESSAGE nvarchar(MAX)
		,@PROCESS_DATE AS NUMERIC(9,0)
		,@LAST_PROCESS_DATE AS NUMERIC(9,0)
		,@PROCESS_DATETIME AS DATETIME

--DECLARE TEMP TABLE FOR VALIDATION
DECLARE @tmpInconsistentTransaction TABLE
(
	[TABLE_NAME] [varchar](50) NULL,
	[ERROR_TITLE] [varchar](100) NULL,
	[ERROR_DETAILS] [nvarchar](max) NULL
)

-- GET PROCESS DATE
SELECT @PROCESS_DATE=[dbo].[sfun_get_process_date]()
SELECT @LAST_PROCESS_DATE=MAX(PROCESS_DATE) FROM DBO.TBLDAYPROCESS WHERE END_DATE IS NOT NULL
SET @PROCESS_DATETIME=[dbo].[sfun_get_process_date_as_datetime]()

--VALIDATE UNAPPROVED CASH CHEQUE COLLECTION INPUT
PRINT('STEP1:')
SET @ERROR_MESSAGE=NULL
SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +FR.CLIENT_ID
FROM
	[Transaction].[tblFundReceive] FR
WHERE
	FR.receive_date=@PROCESS_DATE
	AND FR.approve_date IS NULL
INSERT INTO @tmpInconsistentTransaction 
SELECT '[tblFundReceive]','Unapprove Receive',@ERROR_MESSAGE WHERE @ERROR_MESSAGE IS NOT NULL


--VALIDATE UNAPPROVED CASH CHEQUE WITHDRAW INPUT
PRINT('STEP2:')
SET @ERROR_MESSAGE=NULL
SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +FW.CLIENT_ID
FROM
	[Transaction].[tblFundWithdraw] FW
WHERE
	FW.withdraw_date=@PROCESS_DATE
	AND FW.approve_date IS NULL
INSERT INTO @tmpInconsistentTransaction 
SELECT '[tblFundWithdraw]','Unapprove Withdraw',@ERROR_MESSAGE WHERE @ERROR_MESSAGE IS NOT NULL


--VALIDATE UNAPPROVED CHARGE INPUT
PRINT('STEP3:')
SET @ERROR_MESSAGE=NULL
SELECT
	@ERROR_MESSAGE=COALESCE(@ERROR_MESSAGE+ ', ','' ) +FCA.CLIENT_ID
FROM
	[Transaction].[tblForceChargeApply] FCA
WHERE
	FCA.transaction_date = @PROCESS_DATE
	AND FCA.approve_date IS NULL
INSERT INTO @tmpInconsistentTransaction
SELECT '[tblForceChargeApply]','Unapprove Charge Apply',@ERROR_MESSAGE WHERE @ERROR_MESSAGE IS NOT NULL


--VALIDATE MARKET CLOSING PRICE
PRINT('STEP4:')
SET @ERROR_MESSAGE=NULL
IF NOT EXISTS(SELECT 1 FROM [Trade].[tblTradeData])
BEGIN
	INSERT INTO @tmpInconsistentTransaction
	SELECT '[tblTradeData]','Trade data not found',@ERROR_MESSAGE WHERE @ERROR_MESSAGE IS NOT NULL
END


--VALIDATE MARKET TRADE FILE
PRINT('STEP5:')
SET @ERROR_MESSAGE=NULL
IF NOT EXISTS(SELECT 1 FROM [Trade].[tblClosingPrice])
BEGIN
	INSERT INTO @tmpInconsistentTransaction
	SELECT '[tblClosingPrice]','Market closing price not found',@ERROR_MESSAGE WHERE @ERROR_MESSAGE IS NOT NULL
END

--GET TRANSACTION VALIDATION RESULT
SELECT * FROM @tmpInconsistentTransaction


/****************************************************************INVESTOR FINANCIAL TRANSACTION*********************************************************************************/

--DECLARE TEMP TABLE FOR FINANCIAL TRANSATION
DECLARE  @TMPFUNDTRANSACTION TABLE
(
	[client_id] VARCHAR(10)
	,DEBIT NUMERIC(30,10)
	,CREDIT NUMERIC(30,10)
	,DEBIT_IMMATURE NUMERIC(30,10)
	,CREDIT_IMMATURE  NUMERIC(30,10)
	,DEBIT_UN_CHQ_BAL NUMERIC(30,10)
	,CREDIT_UN_CHQ_BAL NUMERIC(30,10)
	,[transaction_type] VARCHAR(50) 
)

--Get Investor wise today's transaction
PRINT('STEP6:')
INSERT INTO @TMPFUNDTRANSACTION
SELECT
	FR.CLIENT_ID
	,0 DEBIT
	,FR.AMOUNT CREDIT 
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE 
	,0 DEBIT_UN_CHQ_BAL
	,0 CREDIT_UN_CHQ_BAL
	,DTL.DISPLAY_VALUE transaction_type
FROM
	[Transaction].[tblFundReceive] FR
LEFT JOIN	
	tblConstantObjectValue DTL 
	ON DTL.object_value_id=FR.[transaction_mode_id]
WHERE
	FR.approve_date=@PROCESS_DATE
	AND DTL.DISPLAY_VALUE = 'CS'

UNION

SELECT
	FR.CLIENT_ID
	,0 DEBIT
	,0 CREDIT
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE
	,0 DEBIT_UN_CHQ_BAL
	,FR.AMOUNT CREDIT_UN_CHQ_BAL 
	,DTL.DISPLAY_VALUE transaction_type
FROM
	[Transaction].[tblFundReceive] FR
LEFT JOIN	
	tblConstantObjectValue DTL 
	ON DTL.object_value_id=FR.[transaction_mode_id]
WHERE
	FR.APPROVE_DATE=@PROCESS_DATE
	AND DTL.DISPLAY_VALUE = 'CH'

UNION

SELECT
	FR.CLIENT_ID
	,0 DEBIT
	,FR.AMOUNT CREDIT
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE 
	,0 DEBIT_UN_CHQ_BAL
	,0 CREDIT_UN_CHQ_BAL
	,DTL.DISPLAY_VALUE transaction_type
FROM
	[Transaction].[tblFundReceive] FR
LEFT JOIN	
	tblConstantObjectValue DTL 
	ON DTL.object_value_id=FR.[transaction_mode_id]
WHERE
	FR.clear_date=@PROCESS_DATE
	AND DTL.DISPLAY_VALUE = 'CH'

UNION

SELECT
	FW.CLIENT_ID
	,FW.AMOUNT DEBIT
	,0 CREDIT
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE 
	,0 DEBIT_UN_CHQ_BAL
	,0 CREDIT_UN_CHQ_BAL
	,DTL.DISPLAY_VALUE
FROM
	[Transaction].[tblFundWithdraw] FW
LEFT JOIN	
	tblConstantObjectValue DTL 
	ON DTL.object_value_id=FW.[transaction_mode_id]
WHERE
	FW.[withdraw_date]=@PROCESS_DATE
	AND FW.[approve_date] IS NOT NULL

UNION

SELECT
	TD.[client_id]
	,0 DEBIT
	,0 CREDIT
	,0 DEBIT_IMMATURE
	,SUM(TD.Quantity*TD.Unit_Price + TD.commission_amount) CREDIT_IMMATURE 
	,0 DEBIT_UN_CHQ_BAL
	,0 CREDIT_UN_CHQ_BAL
	,TD.[transaction_type] 
FROM
	[Trade].[tblTradeData] TD
WHERE
	TD.[Date]=@PROCESS_DATE
	AND TD.[transaction_type]='S'
GROUP BY TD.[client_id],TD.[transaction_type]

UNION

SELECT
	TD.[client_id]
	,SUM(TD.Quantity*TD.Unit_Price + TD.commission_amount) DEBIT
	,0 CREDIT
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE 
	,0 DEBIT_UN_CHQ_BAL
	,0 CREDIT_UN_CHQ_BAL
	,TD.[transaction_type] 
FROM
	[Trade].[tblTradeData] TD
WHERE
	TD.[Date]=@PROCESS_DATE
	AND TD.[transaction_type]='B'
GROUP BY TD.[client_id],TD.[transaction_type]

UNION

SELECT
	FCA.[client_id]
	,0 DEBIT
	,SUM(FCA.[amount]) CREDIT
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE 
	,0 DEBIT_UN_CHQ_BAL
	,0 CREDIT_UN_CHQ_BAL
	,NULL 
FROM
	[Transaction].[tblForceChargeApply] FCA
INNER JOIN	
	tblConstantObjectValue DTL 
	ON DTL.object_value_id=FCA.transaction_type_id
	AND DTL.display_value='Pay'
INNER JOIN 
	tblConstantObject MST 
	ON MST.object_id=DTL.object_id 
	AND MST.object_name='TRANSACTION_TYPE'
WHERE
	FCA.[transaction_date]=@PROCESS_DATE
	AND FCA.[approve_date] IS NOT NULL
GROUP BY FCA.[client_id]

UNION

SELECT
	FCA.[client_id]
	,0 DEBIT
	,SUM(FCA.[amount]) CREDIT
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE 
	,0 DEBIT_UN_CHQ_BAL
	,0 CREDIT_UN_CHQ_BAL
	,NULL
FROM
	[Transaction].[tblForceChargeApply] FCA
INNER JOIN	
	tblConstantObjectValue DTL 
	ON DTL.object_value_id=FCA.transaction_type_id
	AND DTL.display_value='Receive'
INNER JOIN 
	tblConstantObject MST 
	ON MST.object_id=DTL.object_id 
	AND MST.object_name='TRANSACTION_TYPE'
WHERE
	FCA.[transaction_date]=@PROCESS_DATE
	AND FCA.[approve_date] IS NOT NULL
GROUP BY FCA.[client_id]

--Get inconsistant trasaction info FOR CASH,CHEQUE CLEAR
PRINT('STEP7:')
select 
	TR.CLIENT_ID
from 
	@TMPFUNDTRANSACTION TR
LEFT JOIN
	[Investor].[vw_InvestorFundBalance] VFB 
	ON VFB.[client_id]=TR.[client_id]
LEFT JOIN 
	investor.tblInvestorFundBalance IFB 
	ON IFB.[client_id]=TR.[client_id]
	AND
	IFB.transaction_date=
		(
		SELECT MAX(IFB2.transaction_date)
		FROM
			Investor.tblInvestorFundBalance IFB2 
		WHERE
			IFB2.client_id=IFB.client_id
			AND IFB2.transaction_date<=@LAST_PROCESS_DATE
		)
WHERE
	( 
		ISNULL(IFB.ledger_balance,0) 
		+ ISNULL(TR.CREDIT,0)  
		- ISNULL(TR.DEBIT,0)
		+ ISNULL(TR.CREDIT_IMMATURE,0)
		- ISNULL(TR.DEBIT_IMMATURE,0)  
	) 
	!= ISNULL(VFB.ledger_balance,0)

/****************************************************************INVESTOR SHARE TRANSACTION*********************************************************************************/

--DECLARE INVESTOR SHARE TRANSACTION TEMP TABLE
DECLARE  @TMP_SHARE_TRANSACTION TABLE
(
	[client_id] VARCHAR(10)
	,INSTRUMENT_ID NUMERIC(4)
	,DEBIT NUMERIC(15)
	,CREDIT NUMERIC(15)
	,DEBIT_IMMATURE NUMERIC(15)
	,CREDIT_IMMATURE  NUMERIC(15)
	,DEBIT_AMOUNT NUMERIC(30,10)
	,CREDIT_AMOUNT NUMERIC(30,10)
	,[transaction_type] VARCHAR(50) 
)

--INSERT INVESTOR AND INSTRUMENT WISE SHARE TRANSACTION 
PRINT('STEP8:')
INSERT INTO @TMP_SHARE_TRANSACTION
SELECT 
	INV.client_id
	,INS.id
	,0 DEBIT_QTY
	,IPO.[qty] CREDIT_QTY
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE
	,0 DEBIT_AMT
	,IPO.[qty]*10  CREDIT_AMT
	,'IPO' TRANSACTION_TYPE
FROM
	[CDBL].[tblCdblIpo] IPO
INNER JOIN 
	[Investor].[tblInvestor] INV 
	ON INV.[bo_code] = IPO.[bo_code]
INNER JOIN 
	[Instrument].[tblInstrument] INS 
	ON INS.isin=IPO.isin
WHERE
	CONVERT(DATE,IPO.[transaction_date]) = CONVERT(DATE,@PROCESS_DATETIME)

UNION

SELECT 
	INV.client_id
	,INS.id
	,0 DEBIT_QTY
	,BR.[qty] CREDIT_QTY
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE
	,0 DEBIT_AMT
	,0  CREDIT_AMT
	,'BONUS' TRANSACTION_TYPE
FROM
	[CDBL].[tblCdblBonusRights] BR
INNER JOIN 
	[Investor].[tblInvestor] INV 
	ON INV.[bo_code] = BR.[bo_code]
INNER JOIN 
	[Instrument].[tblInstrument] INS 
	ON INS.isin=BR.isin
WHERE
	CONVERT(DATE,BR.[transaction_date]) = CONVERT(DATE,@PROCESS_DATETIME)
	AND [share_transaction_type]='BONUS'

UNION

SELECT 
	INV.client_id
	,INS.id
	,0 DEBIT
	,BR.[qty] CREDIT
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE
	,0 DEBIT_AMT
	,(BR.[qty] * BR.rate)  CREDIT_AMT
	,'RIGHTS' TRANSACTION_TYPE
FROM
	[CDBL].[tblCdblBonusRights] BR
INNER JOIN 
	[Investor].[tblInvestor] INV 
	ON INV.[bo_code] = BR.[bo_code]
INNER JOIN 
	[Instrument].[tblInstrument] INS 
	ON INS.isin=BR.isin
WHERE
	CONVERT(DATE,BR.[transaction_date]) = CONVERT(DATE,@PROCESS_DATETIME)
	AND [share_transaction_type]='RIGHTS'

UNION

SELECT 
	INV.client_id
	,INS.id
	,0 DEBIT_QTY
	,0 CREDIT_QTY
	,0 DEBIT_IMMATURE
	,[total_entitlement] CREDIT_IMMATURE
	,0 DEBIT_AMT
	,0  CREDIT_AMT
	,'DIVIDEND' TRANSACTION_TYPE
FROM
	[CDBL].[tblCdblDevidendReceivable] DI
INNER JOIN 
	[Investor].[tblInvestor] INV 
	ON INV.[bo_code] = DI.[bo_code]
INNER JOIN 
	[Instrument].[tblInstrument] INS 
	ON INS.isin=DI.isin
WHERE
	CONVERT(DATE,DI.[transaction_date]) = CONVERT(DATE,@PROCESS_DATETIME)
	AND DI.[trans_ref] ='BONUS'

UNION

SELECT 
	INV.client_id
	,INS.id
	,0 DEBIT_QTY
	,[qty] CREDIT_QTY
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE
	,0 DEBIT_AMT
	,0 CREDIT_AMT
	,'TRANSMISSION' TRANSACTION_TYPE
FROM
	[CDBL].[tblCdblTransmission] TMS
INNER JOIN 
	[Investor].[tblInvestor] INV 
	ON INV.[bo_code] = TMS.[transferor_bo_code]
INNER JOIN 
	[Instrument].[tblInstrument] INS 
	ON INS.isin=TMS.isin
WHERE
	CONVERT(DATE,TMS.[transaction_date]) = CONVERT(DATE,@PROCESS_DATETIME)

UNION

SELECT
	TD.[client_id]
	,TD.instrument_id
	,0 DEBIT_QTY
	,0 CREDIT_QTY
	,0 DEBIT_IMMATURE
	,SUM(TD.Quantity) CREDIT_IMMATURE
	,0 DEBIT_AMT
	,SUM(TD.Quantity*TD.Unit_Price + TD.commission_amount) CREDIT_AMT
	,'BUY' TRANSACTION_TYPE
FROM
	[Trade].[tblTradeData] TD
WHERE
	TD.[Date]=@PROCESS_DATE
	AND TD.[transaction_type]='B'
GROUP BY TD.[client_id],TD.instrument_id

UNION

SELECT
	TD.[client_id]
	,TD.instrument_id
	,SUM(TD.Quantity) DEBIT_QTY
	,0 CREDIT_QTY
	,0 DEBIT_IMMATURE
	,0 CREDIT_IMMATURE
	,0 DEBIT_AMT
	,0 CREDIT_AMT
	,'SELL' TRANSACTION_TYPE
FROM
	[Trade].[tblTradeData] TD
WHERE
	TD.[Date]=@PROCESS_DATE
	AND TD.[transaction_type]='S'
GROUP BY TD.[client_id],TD.instrument_id


--SHOW INCONSISTENT SHARE TRANSACITON
PRINT('STEP9:')
SELECT
	SHT.client_id
FROM 
	@TMP_SHARE_TRANSACTION SHT
LEFT JOIN 
	[Investor].[vw_InvestorShareBalance] ISH 
	ON ISH.client_id=SHT.client_id
	AND ISH.instrument_id=SHT.instrument_id
LEFT JOIN 
	[Investor].[tblInvestorShareBalance] ISHB
	ON ISHB.client_id=SHT.client_id
	AND ISHB.instrument_id=SHT.instrument_id
	AND	ISHB.transaction_date=
		(
			SELECT MAX(ISB2.transaction_date)
			FROM
				[Investor].[tblInvestorShareBalance] ISB2
			WHERE
				ISB2.client_id=SHT.client_id
				AND ISB2.instrument_id=SHT.instrument_id
				AND ISB2.transaction_date<=@LAST_PROCESS_DATE
		)
WHERE
	(
		ISNULL(ISH.[salable_quantity],0 ) 
		+ ISNULL(SHT.CREDIT,0) 
		- ISNULL(SHT.DEBIT,0)
	) 
	!= 
	ISNULL(ISHB.salable_quantity,0)
OR 
	(
		ISNULL(ISH.ledger_quantity,0 ) 
		+ ISNULL(SHT.CREDIT,0) 
		+ ISNULL(SHT.CREDIT_IMMATURE,0) 
		- ISNULL(SHT.DEBIT,0)
		- ISNULL(SHT.DEBIT_IMMATURE,0)
	) 
	!= ISNULL(ISHB.ledger_quantity,0) 




SELECT * FROM @TMPFUNDTRANSACTION


SELECT * FROM @TMP_SHARE_TRANSACTION

GO
/****** Object:  StoredProcedure [Instrument].[rsp_instrument_ledger_client_wise]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 19/12/2015
-- Description:	Instrument ledger report
-- =============================================
---[Instrument].[rsp_instrument_ledger_client_wise] 62,'7359','391','2015-01-01','2015-12-12'
CREATE PROCEDURE [Instrument].[rsp_instrument_ledger_client_wise]
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
		dd.FullDateUK Date,
		case when(tisl.sale_qty > 0) then  'Sale'  when (tisl.buy_qty > 0) then 'Buy' when(tisl.received_qty > 0) then 'Receive' when(tisl.delivery_qty > 0) then 'Delivered' end as Type,
		case when (tisl.sale_qty > 0) then tisl.sale_qty when (tisl.delivery_qty> 0 ) then tisl.delivery_qty end as debit,
		case when (tisl.buy_qty > 0) then tisl.buy_qty when (tisl.received_qty> 0 ) then tisl.received_qty end as credit,
		tisl.opening_qty
		--tisl.sale_qty,tisl.buy_qty,tisl.received_qty,tisl.delivery_qty
	from Investor.tblInvestorShareLedger tisl
	inner join Instrument.tblInstrument ti on tisl.instrument_id = ti.id
	inner join Investor.tblInvestor tii on tisl.client_id = tii.client_id
	inner join DimDate dd on tisl.transaction_date = dd.DateKey
	inner join Dimdate ddf on @from_dt = ddf.Date
	inner join Dimdate ddt on @to_dt = ddt.Date
	where (tisl.sale_qty > 0 or tisl.buy_qty > 0 or tisl.received_qty > 0 or tisl.delivery_qty > 0)
	and tisl.transaction_date between ddf.DateKey  and ddt.DateKey
	and tisl.client_id = @client_id and tisl.membership_id = @membership_id
	and tisl.instrument_id = ISNULL(@instrument_id,tisl.instrument_id)
    
	
END


GO
/****** Object:  StoredProcedure [Investor].[psp_investor_financial_transaction]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 22-NOV-2015
-- Description:	HANDLE ALL KINDS OF FINANCIAL TRANSACTION (ACCOUNT OPENING, CHARGE APPLY, DEPOSIT, WITHDRAW, SHARE IN VALUE, SHARE OUT VALUE, BUY, SALE)FROM A SINGLE SP
-- Updated by : Sarwar
-- Update Date: 12/08/2015
-- Description: 1. Added block for CASH MATURITY
				2. GET INVESTOR SHARE INFO FROM MAX HIST DATA FOR 'COST_VALUE/MARKET_VALUE'
*/
-- EXEC Investor.psp_investor_financial_transaction '',154, 62, '1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
-- =============================================
CREATE PROCEDURE [Investor].[psp_investor_financial_transaction] 
	-- Add the parameters for the stored procedure here
	  @id AS VARCHAR(MAX)
	, @FINANCIAL_LEDGER_TYPE_ID AS NUMERIC(4,0)
	, @membership_id numeric(9,0)
	, @changed_user_id VARCHAR(128)
AS
BEGIN

PRINT 'psp_investor_financial_transaction'
	DECLARE @result VARCHAR(MAX)
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE
		 @PROCESS_DATE AS NUMERIC(9,0)
		,@global_charge_id AS NUMERIC(3,0)
		,@narration AS VARCHAR(250)
		,@active_status_id AS NUMERIC(4,0)
		,@transaction_type_id AS NUMERIC(4,0)


	SELECT @PROCESS_DATE=dbo.sfun_get_process_date()
	SELECT @active_status_id=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
	
	PRINT 'CREATE TEMP TABLE'
	CREATE TABLE #trans
	(
		client_id VARCHAR(10) 
		,narration  VARCHAR(250)
		,refference_no VARCHAR(20)
		,quantity NUMERIC(15,0)
		,rate NUMERIC(30,10)
		,amount NUMERIC(30,10)
		,comm_amount NUMERIC(30,10)
		,debit  NUMERIC(30,10)
		,credit NUMERIC(30,10)
		,additional_available_balance NUMERIC(30,10)
		,additional_sale_receivable NUMERIC(30,10)
		,additional_un_clear_cheque NUMERIC(30,10)
		,additional_ledger_balance NUMERIC(30,10)
		,additional_total_deposit NUMERIC(30,10)
		,additional_share_transfer_in NUMERIC(30,10)
		,additional_total_withdraw NUMERIC(30,10)
		,additional_share_transfer_out NUMERIC(30,10)
		,additional_realized_interest NUMERIC(30,10)
		,additional_realized_charge NUMERIC(30,10)
		,additional_accured_interest NUMERIC(30,10)
		,additional_fund_withdrawal_request NUMERIC(30,10)
		,additional_cost_value NUMERIC(30,10)
		,additional_market_value NUMERIC(30,10)
		,additional_realized_gain NUMERIC(30,10)
		,membership_id NUMERIC(9,0)
	)
	
	-----------------------CALCULATE BALANCE-----------------------
	IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @FINANCIAL_LEDGER_TYPE_ID) AND (display_value='Account Opening Fee'))
	BEGIN
		PRINT 'Account Opening Fee'
		SET @global_charge_id=5
		SELECT @narration = TGC.name FROM Charge.tblGlobalCharge TGC WHERE membership_id=@membership_id AND id=@global_charge_id
		SELECT @transaction_type_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','Receive')

		INSERT INTO #trans(client_id,narration,debit,credit,additional_available_balance,additional_sale_receivable ,additional_un_clear_cheque ,additional_ledger_balance ,additional_total_deposit 
			,additional_share_transfer_in ,additional_total_withdraw ,additional_share_transfer_out ,additional_realized_interest ,additional_realized_charge ,additional_accured_interest ,additional_fund_withdrawal_request ,additional_cost_value 
			,additional_market_value ,additional_realized_gain, membership_id )
		SELECT id client_id,@narration narration, charge_amount debit, 0 credit, charge_amount * -1 additional_available_balance, 0 additional_sale_receivable, 0 additional_un_clear_cheque
			, charge_amount * -1 additional_ledger_balance, 0 additional_total_deposit, 0 additional_share_transfer_in, 0 additional_total_withdraw, 0 additional_share_transfer_out, 0 additional_realized_interest, charge_amount additional_realized_charge
			, 0 additional_accured_interest, 0 additional_fund_withdrawal_request, 0 additional_cost_value, 0 additional_market_value, 0 additional_realized_gain, @membership_id
		FROM DBO.udfSpliter(@ID) TI -- CLIENT ID = @ID
			INNER JOIN Charge.vw_all_investors_charges AIC ON TI.id=AIC.client_id
		AND AIC.global_charge_id=@global_charge_id

		INSERT INTO [Transaction].tblForceChargeApply(client_id,charge_id,transaction_type_id,amount,transaction_date,value_date,remarks,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,approve_by,approve_date)
		SELECT client_id, @global_charge_id charge_id, @transaction_type_id, SUM(debit) amount,@PROCESS_DATE transaction_date,@PROCESS_DATE value_date,@narration remarks, @active_status_id,@membership_id,@changed_user_id
			,GETDATE() changed_date,1 is_dirty,@changed_user_id approve_by,@PROCESS_DATE approve_date
		FROM #trans
		GROUP BY client_id
	END
	ELSE IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @FINANCIAL_LEDGER_TYPE_ID) AND (display_value='Deposit'))
	BEGIN
		PRINT 'Deposit'
		INSERT INTO #trans
			(
			client_id,refference_no,narration,debit,credit,additional_available_balance,additional_sale_receivable ,additional_un_clear_cheque ,additional_ledger_balance ,additional_total_deposit 
			,additional_share_transfer_in ,additional_total_withdraw ,additional_share_transfer_out ,additional_realized_interest ,additional_realized_charge ,additional_accured_interest ,additional_fund_withdrawal_request ,additional_cost_value 
			,additional_market_value ,additional_realized_gain, membership_id 
			)
		SELECT 
			client_id, 
			ISNULL(TFR.doc_ref_no,'') + ISNULL('CH# '+TFR.cheque_no ,''),
			TMCOV.display_value + ISNULL('('+TFR.remarks+')','') narration, 
			0 debit	, 
			CASE WHEN approve_date IS NOT NULL AND deposit_date IS NULL THEN amount ELSE 0 END credit
			, CASE WHEN TMCOV.display_value='CS' AND approve_date IS NOT NULL THEN amount 
				ELSE 
					CASE WHEN TMCOV.display_value!='CS' AND approve_date IS NOT NULL AND deposit_date IS NOT NULL AND clear_date IS NOT NULL THEN amount ELSE 0 END
				END additional_available_balance
			, 0 additional_sale_receivable
			, CASE WHEN TMCOV.display_value='CS'THEN 0 -- ONLY CASH
				ELSE 
					CASE WHEN TMCOV.display_value!='CS' AND approve_date IS NOT NULL AND deposit_date IS NULL THEN amount -- CHEQUE APPROVE BUT NOT DEPOSIT
					ELSE 
						CASE WHEN TMCOV.display_value!='CS' AND approve_date IS NOT NULL AND deposit_date IS NOT NULL AND (clear_date IS NOT NULL OR dishonor_date IS NOT NULL) THEN amount * -1 ELSE 0 END --CHEQUE CLEAR OR DISHONOR
					END 
				END additional_un_clear_cheque
			, CASE WHEN approve_date IS NOT NULL AND deposit_date IS NULL THEN amount ELSE 0 END additional_ledger_balance -- ONLY WHEN APPROVE
			, CASE WHEN approve_date IS NOT NULL AND deposit_date IS NULL THEN amount ELSE 0 END additional_total_deposit -- ONLY WHEN APPROVE
			, 0 additional_share_transfer_in, 0 additional_total_withdraw, 0 additional_share_transfer_out, 0 additional_realized_interest, 0 additional_realized_charge, 0 additional_accured_interest, 0 additional_fund_withdrawal_request
			, 0 additional_cost_value, 0 additional_market_value, 0 additional_realized_gain, @membership_id
		FROM DBO.udfSpliter(@ID) TI -- DEPOSIT ID = @ID
			INNER JOIN [Transaction].tblFundReceive TFR ON TI.id=TFR.id
			INNER JOIN DBO.tblConstantObjectValue TMCOV ON TFR.transaction_mode_id=TMCOV.object_value_id

/**START***********FOR CHEQUE DISHONOUR********************************************************************************************************************************************/
		DECLARE @WITHDRAW_VOUCHER_NO VARCHAR(15)
		SELECT @WITHDRAW_VOUCHER_NO=MAX(CONVERT(NUMERIC,[voucher_no]))+1 FROM [Transaction].[tblFundWithdraw]
		
		--REVERSE INPUT FOR CHEQUE DISHONOUR
		INSERT INTO [Transaction].[tblFundWithdraw]
           (
		   [voucher_no]
           ,[client_id]
           ,[transaction_mode_id]
           ,[bank_branch_id]
           ,[cheque_no]
           ,[cheque_date]
           ,[amount]
           ,[withdraw_date]
           ,[value_date]
           ,[broker_branch_id]
           ,[remarks]
           ,[active_status_id]
           ,[membership_id]
           ,[changed_user_id]
           ,[changed_date]
           ,[is_dirty]
		   )
		SELECT
		     @WITHDRAW_VOUCHER_NO
			,TFR.CLIENT_ID
			,TFR.transaction_mode_id
			,TFR.deposit_bank_branch_id
			,TFR.cheque_no
			,TFR.cheque_date
			,TFR.amount
			,TFR.dishonor_date
			,TFR.dishonor_date
			,TFR.broker_branch_id
			,'AUTO PAYMENT FOR DISHONOUR(Cheque # ' + TFR.cheque_no + ')' remarks
			,TFR.active_status_id
			,TFR.membership_id
			,TFR.changed_user_id
			,GETDATE()
			,0
		FROM 
			DBO.udfSpliter(@ID) TI -- DEPOSIT ID = @ID
		INNER JOIN 
			[Transaction].tblFundReceive TFR 
			ON TI.id=TFR.id
			AND approve_date IS NOT NULL 
			AND deposit_date IS NOT NULL
			AND clear_date IS NULL 
			AND dishonor_date IS NOT NULL
		INNER JOIN 
			DBO.tblConstantObjectValue TMCOV 
			ON TFR.transaction_mode_id=TMCOV.object_value_id
			AND TMCOV.display_value='CH'

	-------------INPUT CHARGE FOR CHEQUE DISHONOUR IF CHARGE IS APPLICABLE FOR THE INVESTOR------------------------

		--GET CHARGE ID
		SELECT 
			@global_charge_id=ID 
		FROM 
			[Charge].[tblGlobalCharge] CH
		WHERE
			CH.SHORT_CODE='CDC'

		--GET OBJECT ID
		SELECT 
			@transaction_type_id= A.object_value_id 
		FROM
			tblConstantObjectValue A
		INNER JOIN 
			tblConstantObject B 
			ON B.object_id=A.object_id
		where 
			B.object_name='TRANSACTION_TYPE'
			AND A.display_value='Receive'
		
		--INSERT CHARGE INPUT FOR DISHONOUR
		INSERT INTO [Transaction].[tblForceChargeApply]
           (
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
		 SELECT
		    TFR.CLIENT_ID
			,@global_charge_id
			,@transaction_type_id
			,ICH.CHARGE_AMOUNT
			,TFR.[dishonor_date]
			,TFR.[dishonor_date]
			,'AUTO CHARGE ADDITION FOR DISHONOUR' remarks
			,TFR.active_status_id
			,TFR.membership_id
			,TFR.changed_user_id
			,GETDATE()
			,0
		FROM 
			DBO.udfSpliter(@ID) TI -- DEPOSIT ID = @ID
		INNER JOIN 
			[Transaction].tblFundReceive TFR 
			ON TI.id=TFR.id
			AND approve_date IS NOT NULL 
			AND deposit_date IS NOT NULL
			AND clear_date IS NULL 
			AND dishonor_date IS NOT NULL
		INNER JOIN 
			DBO.tblConstantObjectValue TMCOV 
			ON TFR.transaction_mode_id=TMCOV.object_value_id
			AND TMCOV.display_value='CH'
		INNER JOIN 
			[Charge].[vw_all_investors_charges] ICH 
			ON ICH.client_id=TFR.client_id
			AND ICH.global_charge_id=@global_charge_id
		INNER JOIN 
			[Charge].[tblGlobalCharge] CH
			ON CH.id=ICH.global_charge_id
			AND CH.SHORT_CODE='CDC'
	/**END***********FOR CHEQUE DISHONOUR********************************************************************************************************************************************/

	END
	ELSE IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @FINANCIAL_LEDGER_TYPE_ID) AND (display_value='Withdraw'))
	BEGIN
		PRINT 'Withdraw'
		INSERT INTO #trans(client_id,refference_no,narration,debit,credit,additional_available_balance,additional_sale_receivable ,additional_un_clear_cheque ,additional_ledger_balance ,additional_total_deposit 
			,additional_share_transfer_in ,additional_total_withdraw ,additional_share_transfer_out ,additional_realized_interest ,additional_realized_charge ,additional_accured_interest ,additional_fund_withdrawal_request ,additional_cost_value 
			,additional_market_value ,additional_realized_gain, membership_id )
		SELECT client_id, TFR.cheque_no,TFR.remarks narration
			, CASE WHEN approve_date IS NOT NULL THEN amount ELSE 0 END debit
			, 0 credit
			, CASE WHEN approve_date IS NOT NULL THEN amount * -1 ELSE 0 END additional_available_balance
			, 0 additional_sale_receivable, 0 additional_un_clear_cheque
			, CASE WHEN approve_date IS NOT NULL THEN amount * -1 ELSE 0 END additional_ledger_balance -- ONLY WHEN APPROVE
			, 0 additional_total_deposit , 0 additional_share_transfer_in
			, CASE WHEN approve_date IS NOT NULL THEN amount ELSE 0 END additional_total_withdraw
			, 0 additional_share_transfer_out, 0 additional_realized_interest, 0 additional_realized_charge, 0 additional_accured_interest, 0 additional_fund_withdrawal_request
			, 0 additional_cost_value, 0 additional_market_value, 0 additional_realized_gain, @membership_id
		FROM DBO.udfSpliter(@ID) TI -- WITHDRAW ID = @ID
			INNER JOIN [Transaction].tblFundWithdraw TFR ON TI.id=TFR.id
			INNER JOIN DBO.tblConstantObjectValue TMCOV ON TFR.transaction_mode_id=TMCOV.object_value_id
	END
	ELSE IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @FINANCIAL_LEDGER_TYPE_ID) AND (display_value='Withdraw Request'))
	BEGIN
		PRINT 'Withdraw Request'
		INSERT INTO #trans(client_id,narration,debit,credit,additional_available_balance,additional_sale_receivable ,additional_un_clear_cheque ,additional_ledger_balance ,additional_total_deposit 
			,additional_share_transfer_in ,additional_total_withdraw ,additional_share_transfer_out ,additional_realized_interest ,additional_realized_charge ,additional_accured_interest ,additional_fund_withdrawal_request ,additional_cost_value 
			,additional_market_value ,additional_realized_gain, membership_id )
		SELECT client_id,TFR.remarks narration
			, 0 debit
			, 0 credit
			, 0 additional_available_balance
			, 0 additional_sale_receivable, 0 additional_un_clear_cheque
			, 0 additional_ledger_balance -- ONLY WHEN APPROVE
			, 0 additional_total_deposit , 0 additional_share_transfer_in
			, 0 additional_total_withdraw
			, 0 additional_share_transfer_out, 0 additional_realized_interest, 0 additional_realized_charge, 0 additional_accured_interest
			, CASE WHEN TFR.approve_date IS NOT NULL AND TFR.effective_date>@PROCESS_DATE THEN TFR.amount --- REQUEST APPROVE
				ELSE CASE WHEN (TFR.approve_date IS NOT NULL AND TFR.effective_date<=@PROCESS_DATE) ---- ON DAY START
						OR (TFR.approve_date IS NULL) THEN TFR.amount * -1 ELSE 0 END --- REQUEST UNAPPROVE
				END additional_fund_withdrawal_request
			, 0 additional_cost_value, 0 additional_market_value, 0 additional_realized_gain, @membership_id
		FROM DBO.udfSpliter(@ID) TI ---- REQUEST ID = @ID
			INNER JOIN [Transaction].tblFundWithdrawalRequest TFR ON TI.id=TFR.id
			INNER JOIN DBO.tblConstantObjectValue TMCOV ON TFR.transaction_mode_id=TMCOV.object_value_id
		WHERE TFR.is_dirty = 1
	END
	ELSE IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @FINANCIAL_LEDGER_TYPE_ID) AND (display_value='Charge Apply'))
	BEGIN
		PRINT 'Charge Apply'
		SELECT @transaction_type_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','Receive')

		INSERT INTO #trans(client_id,refference_no,narration,debit,credit,additional_available_balance,additional_sale_receivable ,additional_un_clear_cheque ,additional_ledger_balance ,additional_total_deposit 
			,additional_share_transfer_in ,additional_total_withdraw ,additional_share_transfer_out ,additional_realized_interest ,additional_realized_charge ,additional_accured_interest ,additional_fund_withdrawal_request ,additional_cost_value 
			,additional_market_value ,additional_realized_gain, membership_id )
		SELECT FCA.client_id,FCA.id,FCA.remarks narration
			, CASE WHEN FCA.transaction_type_id=@transaction_type_id THEN FCA.amount ELSE 0 END debit
			, CASE WHEN FCA.transaction_type_id!=@transaction_type_id THEN FCA.amount ELSE 0 END credit
			, CASE WHEN FCA.transaction_type_id=@transaction_type_id THEN FCA.amount * -1 ELSE FCA.amount END additional_available_balance
			, 0 additional_sale_receivable, 0 additional_un_clear_cheque
			, CASE WHEN FCA.transaction_type_id=@transaction_type_id THEN FCA.amount * -1 ELSE FCA.amount END additional_ledger_balance
			, 0 additional_total_deposit, 0 additional_share_transfer_in, 0 additional_total_withdraw, 0 additional_share_transfer_out, 0 additional_realized_interest 
			, CASE WHEN FCA.transaction_type_id=@transaction_type_id THEN FCA.amount * -1 ELSE FCA.amount END additional_realized_charge
			, 0 additional_accured_interest, 0 additional_fund_withdrawal_request, 0 additional_cost_value, 0 additional_market_value, 0 additional_realized_gain, membership_id
		FROM DBO.udfSpliter(@ID) TI -- FORCE APPLY ID = @ID
			INNER JOIN [Transaction].tblForceChargeApply FCA ON TI.id=FCA.id
		WHERE FCA.membership_id=@membership_id
		
	END
	ELSE IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @FINANCIAL_LEDGER_TYPE_ID) AND (display_value='BUY/SALE'))
	BEGIN
		PRINT 'BUY/SALE'
		INSERT INTO #trans(client_id,narration,quantity,rate,amount,comm_amount,debit,credit,additional_available_balance,additional_sale_receivable ,additional_un_clear_cheque ,additional_ledger_balance ,additional_total_deposit 
			,additional_share_transfer_in ,additional_total_withdraw ,additional_share_transfer_out ,additional_realized_interest ,additional_realized_charge ,additional_accured_interest ,additional_fund_withdrawal_request ,additional_cost_value 
			,additional_market_value ,additional_realized_gain, membership_id )
		SELECT TTD.client_id, INS.instrument_name narration,SUM(TTD.Quantity) quantity
			,CASE WHEN TTD.transaction_type='B' --IF BUY
				THEN SUM((TTD.Quantity*TTD.Unit_Price)+(TTD.commission_amount))/SUM(TTD.Quantity) --BUY AVERAGE
				ELSE SUM((TTD.Quantity*TTD.Unit_Price)-(TTD.commission_amount))/SUM(TTD.Quantity) --SALE AVERAGE
			 END rate
			,SUM(TTD.Quantity*TTD.Unit_Price) amount
			,SUM(TTD.commission_amount) comm_amount
			,CASE WHEN TTD.transaction_type='B' THEN SUM((TTD.Quantity*TTD.Unit_Price)+(TTD.commission_amount)) ELSE 0 END debit
			,CASE WHEN TTD.transaction_type='S' THEN SUM((TTD.Quantity*TTD.Unit_Price)-(TTD.commission_amount)) ELSE 0 END credit
			,CASE WHEN TTD.transaction_type='B' THEN (SUM((TTD.Quantity*TTD.Unit_Price)+(TTD.commission_amount)))*-1 ELSE 0 END additional_available_balance
			,CASE WHEN TTD.transaction_type='S' THEN SUM((TTD.Quantity*TTD.Unit_Price)-(TTD.commission_amount)) ELSE 0 END additional_sale_receivable
			,0 additional_un_clear_cheque
			,CASE WHEN TTD.transaction_type='B' THEN (SUM((TTD.Quantity*TTD.Unit_Price)+(TTD.commission_amount)))*-1 ELSE SUM((TTD.Quantity*TTD.Unit_Price)-(TTD.commission_amount)) END additional_ledger_balance
			,0 additional_total_deposit, 0 additional_share_transfer_in, 0 additional_total_withdraw, 0 additional_share_transfer_out, 0 additional_realized_interest, SUM(TTD.commission_amount) additional_realized_charge
			, 0 additional_accured_interest, 0 additional_fund_withdrawal_request, 0 additional_cost_value, 0 additional_market_value, SUM(ISNULL(ISL.gain_loss,0)) additional_realized_gain, TTD.membership_id
		FROM DBO.udfSpliter(@ID) TI -- PROCESS DATE = @ID
			INNER JOIN Trade.tblTradeData TTD ON TI.id=TTD.Date
			INNER JOIN Instrument.tblInstrument INS ON TTD.instrument_id=INS.id AND TTD.membership_id=INS.membership_id
			LEFT JOIN Investor.tblInvestorShareLedger ISL ON TTD.client_id=ISL.client_id AND TTD.instrument_id=ISL.instrument_id AND TTD.Date=ISL.transaction_date AND TTD.membership_id=ISL.membership_id
		WHERE TTD.membership_id=@membership_id
		GROUP BY TTD.client_id,INS.instrument_name,TTD.transaction_type, TTD.membership_id

		SELECT @transaction_type_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','Receive')
		SET @global_charge_id=1

		INSERT INTO [Transaction].tblForceChargeApply(client_id,charge_id,transaction_type_id,amount,transaction_date,value_date,remarks,active_status_id,membership_id,changed_user_id,changed_date,is_dirty,approve_by,approve_date)
		SELECT client_id, @global_charge_id charge_id, @transaction_type_id, SUM(comm_amount) amount,@PROCESS_DATE transaction_date,@PROCESS_DATE value_date,'BROKERAGE COMMISSION' remarks, @active_status_id,@membership_id
			,@changed_user_id,GETDATE() changed_date,1 is_dirty,@changed_user_id approve_by,@PROCESS_DATE approve_date
		FROM #trans
		GROUP BY client_id
	END
	ELSE IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @FINANCIAL_LEDGER_TYPE_ID) AND (display_value='Reverse BUY/SALE'))
	BEGIN
		PRINT 'Reverse BUY/SALE'
		INSERT INTO #trans
		(
		client_id
		,narration
		,quantity
		,rate
		,amount
		,comm_amount
		,debit
		,credit
		,additional_available_balance
		,additional_sale_receivable 
		,additional_un_clear_cheque 
		,additional_ledger_balance 
		,additional_total_deposit 
		,additional_share_transfer_in 
		,additional_total_withdraw 
		,additional_share_transfer_out 
		,additional_realized_interest 
		,additional_realized_charge 
		,additional_accured_interest 
		,additional_fund_withdrawal_request 
		,additional_cost_value 
		,additional_market_value 
		,additional_realized_gain
		,membership_id 
		)
		SELECT 
			TTD.client_id
			,INS.instrument_name narration
			,0 quantity
			,0 rate
			,0 amount
			,0 comm_amount
			,0 debit
			,0 credit
			,CASE WHEN TTD.transaction_type='B' THEN (SUM((TTD.Quantity*TTD.Unit_Price)+(TTD.commission_amount))) ELSE 0 END additional_available_balance
			,CASE WHEN TTD.transaction_type='S' THEN SUM((TTD.Quantity*TTD.Unit_Price)-(TTD.commission_amount))*-1 ELSE 0 END additional_sale_receivable
			,0 additional_un_clear_cheque
			,CASE WHEN TTD.transaction_type='B' THEN (SUM((TTD.Quantity*TTD.Unit_Price)+(TTD.commission_amount))) ELSE SUM((TTD.Quantity*TTD.Unit_Price)-(TTD.commission_amount))*-1 END additional_ledger_balance
			,0 additional_total_deposit
			,0 additional_share_transfer_in
			,0 additional_total_withdraw
			,0 additional_share_transfer_out
			,0 additional_realized_interest
			,SUM(TTD.commission_amount)*-1 additional_realized_charge
			,0 additional_accured_interest
			,0 additional_fund_withdrawal_request
			,CASE WHEN TTD.transaction_type='B' THEN (SUM((TTD.Quantity*TTD.Unit_Price)+(TTD.commission_amount))) *-1 ELSE 0 END  additional_cost_value
			,SUM(TTD.Quantity*INS.closed_price)*-1 additional_market_value
			,SUM(ISNULL(ISL.gain_loss,0))*-1 additional_realized_gain
			,TTD.membership_id
		FROM 
			DBO.udfSpliter(@ID) TI -- PROCESS DATE = @ID
			INNER JOIN Trade.tblTradeData TTD ON TI.id=TTD.Date
			INNER JOIN Instrument.tblInstrument INS ON TTD.instrument_id=INS.id AND TTD.membership_id=INS.membership_id
			LEFT JOIN Investor.tblInvestorShareLedger ISL ON TTD.client_id=ISL.client_id AND TTD.instrument_id=ISL.instrument_id AND TTD.Date=ISL.transaction_date AND TTD.membership_id=ISL.membership_id
		WHERE 
			TTD.membership_id=@membership_id
		GROUP BY 
			TTD.client_id,INS.instrument_name,TTD.transaction_type, TTD.membership_id



		---Remove commission charge and investor financial ledger entry---------------------
		SELECT @transaction_type_id=dbo.sfun_get_constant_object_value_id('TRANSACTION_TYPE','Receive')
		SET @global_charge_id=1

		DELETE CRG
		FROM 
			#trans TR
		INNER JOIN  
			[Transaction].tblForceChargeApply CRG 
			ON  CRG.client_id=TR.client_id
				AND CRG.charge_id=@global_charge_id
				AND CRG.transaction_date=@PROCESS_DATE
				AND CRG.transaction_type_id=@transaction_type_id

		-----Remove investor financial ledger table input
		DELETE FL
		FROM
			#trans TR
		INNER JOIN Investor.tblInvestorFinancialLedger FL 
			ON  FL.client_id=TR.client_id
				AND FL.refference_no=TR.refference_no
				AND FL.transaction_type_id = @FINANCIAL_LEDGER_TYPE_ID
				AND FL.transaction_date = @PROCESS_DATE
				AND ISNULL(FL.quantity,0) !=0
				AND ISNULL(FL.amount,0) !=0 

	END
	ELSE IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @FINANCIAL_LEDGER_TYPE_ID) AND (display_value='COST_VALUE/MARKET_VALUE')) -- THERE IS NO @ID IS NEEDED
	BEGIN
		PRINT 'UPDATE COST_VALUE/MARKET_VALUE'
		INSERT INTO #trans(client_id,narration,debit,credit,additional_available_balance,additional_sale_receivable ,additional_un_clear_cheque ,additional_ledger_balance ,additional_total_deposit 
			,additional_share_transfer_in ,additional_total_withdraw ,additional_share_transfer_out ,additional_realized_interest ,additional_realized_charge ,additional_accured_interest ,additional_fund_withdrawal_request ,additional_cost_value 
			,additional_market_value ,additional_realized_gain, membership_id )
		SELECT ISB.client_id,'' narration, 0 debit, 0 credit, 0 additional_available_balance, 0 additional_sale_receivable, 0 additional_un_clear_cheque
			, 0 additional_ledger_balance, 0 additional_total_deposit, 0 additional_share_transfer_in, 0 additional_total_withdraw, 0 additional_share_transfer_out, 0 additional_realized_interest, 0 additional_realized_charge
			, 0 additional_accured_interest, 0 additional_fund_withdrawal_request
			, SUM(ISB.cost_value) additional_cost_value
			, SUM(ISB.ledger_quantity*INS.closed_price) additional_market_value
			, 0 additional_realized_gain, ISB.membership_id
		FROM dbo.udfSpliter(@ID) TI -- PROCESS DATE = @ID
			INNER JOIN Investor.tblInvestorShareBalance ISB 
						ON ISB.transaction_date=(
												SELECT MAX(ISB2.transaction_date) 
												FROM 
													Investor.tblInvestorShareBalance ISB2 
												WHERE 
													ISB2.client_id= ISB.client_id 
													AND ISB2.instrument_id=ISB.instrument_id 
													AND ISB2.transaction_date <= TI.id 
												) 
			INNER JOIN Instrument.tblInstrument INS ON ISB.instrument_id=INS.id
		WHERE ISB.membership_id=@membership_id
		GROUP BY ISB.membership_id, ISB.client_id
	END
	--FOR CASH SETTLEMENT
	ELSE IF EXISTS(SELECT * FROM DBO.tblConstantObjectValue WHERE (object_value_id = @FINANCIAL_LEDGER_TYPE_ID) AND (display_value='Fund Mature'))
	BEGIN
		PRINT 'Fund Mature'
		INSERT INTO #trans
		(
		client_id
		,narration
		,quantity
		,rate
		,amount
		,comm_amount
		,debit
		,credit
		,additional_available_balance
		,additional_sale_receivable 
		,additional_un_clear_cheque 
		,additional_ledger_balance 
		,additional_total_deposit 
		,additional_share_transfer_in 
		,additional_total_withdraw 
		,additional_share_transfer_out 
		,additional_realized_interest 
		,additional_realized_charge 
		,additional_accured_interest 
		,additional_fund_withdrawal_request 
		,additional_cost_value 
		,additional_market_value 
		,additional_realized_gain
		,membership_id 
		)
		SELECT 
		TTD.client_id
		,INS.instrument_name narration
		,0 quantity
		,0 rate
		,0 amount
		,0 comm_amount
		,0 debit
		,0 credit
		,SUM((TTD.Quantity*TTD.Unit_Price)-(TTD.commission_amount)) additional_available_balance
		,SUM((TTD.Quantity*TTD.Unit_Price)-(TTD.commission_amount))*-1 additional_sale_receivable
		,0 additional_un_clear_cheque
		,0 additional_ledger_balance
		,0 additional_total_deposit
		,0 additional_share_transfer_in
		,0 additional_total_withdraw
		,0 additional_share_transfer_out
		,0 additional_realized_interest
		,0 additional_realized_charge
		,0 additional_accured_interest
		,0 additional_fund_withdrawal_request
		,0 additional_cost_value
		,0 additional_market_value
		,0 additional_realized_gain
		,TTD.membership_id
		FROM 
		DBO.udfSpliter(@ID) TI -- SETTLEMENT DATE = @ID
		INNER JOIN [Trade].[vw_today_maturity] TTD ON TI.ID=TTD.settle_date AND TTD.transaction_type = 'S'
		INNER JOIN Instrument.tblInstrument INS ON TTD.instrument_id=INS.id AND TTD.membership_id=INS.membership_id
		WHERE 
		TTD.membership_id=@membership_id
		GROUP BY TTD.client_id,INS.instrument_name,TTD.membership_id
	END
	-----------------------END CALCULATE BALANCE-----------------------
	BEGIN TRY
		
		-----------------------Insert data from investor temporary to Finuncial Ledger-----------------------
		print '1:insert into Investor.tblInvestorFinancialLedger'--
		insert into Investor.tblInvestorFinancialLedger(client_id,refference_no,transaction_type_id,narration,quantity,rate,amount,comm_amount,debit,credit,transaction_date,active_status_id,membership_id,changed_user_id,changed_date,is_dirty)
		SELECT 
			client_id, 
			refference_no, 
			@FINANCIAL_LEDGER_TYPE_ID transaction_type_id, 
			narration, 
			quantity, 
			rate, 
			amount, 
			comm_amount, 
			debit, 
			credit, 
			@PROCESS_DATE transaction_date, 
			@active_status_id active_status_id, 
			membership_id, 
			@changed_user_id changed_user_id, 
			GETDATE() changed_date, 
			1  is_dirty
		FROM 
			#trans
		WHERE 
			debit>0 OR credit>0

		-----------------------End Insert data from investor temporary to Finuncial Ledger-----------------------


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
						#trans
					) TRN 
					ON TI.client_id=TRN.client_id 
					AND TI.membership_id=TRN.membership_id
		LEFT JOIN Investor.tblInvestorFundBalance IFB 
			ON TRN.client_id=IFB.client_id 
			AND TRN.membership_id=IFB.membership_id
		WHERE 
			IFB.client_id IS NULL 
			AND TI.active_status_id=@active_status_id


		PRINT '2 insert into Investor.tblInvestorFundBalance'
		insert into Investor.tblInvestorFundBalance(client_id,transaction_date,account_type_id,available_balance,sale_receivable,un_clear_cheque,ledger_balance,total_deposit
			,share_transfer_in,total_withdraw,share_transfer_out,realized_interest,realized_charge,accured_interest,fund_withdrawal_request
			,cost_value,market_value,equity,marginable_equity,sanction_amount,loan_ratio,purchase_power,max_withdraw_limit,excess_over_limit,realized_gain,unrealized_gain
			,active_status_id, membership_id, changed_user_id, changed_date, is_dirty)
		SELECT 
			IFB.client_id,
			@PROCESS_DATE transaction_date,
			TI.account_type_id,
			available_balance,
			sale_receivable,
			un_clear_cheque,
			ledger_balance,
			total_deposit,
			share_transfer_in,
			total_withdraw,
			share_transfer_out,
			realized_interest,
			realized_charge,
			accured_interest,
			fund_withdrawal_request,
			cost_value,
			market_value,
			equity,
			marginable_equity,
			sanction_amount,
			loan_ratio,
			purchase_power,
			max_withdraw_limit,
			excess_over_limit,
			realized_gain,
			unrealized_gain,
			TI.active_status_id, 
			@membership_id membership_id,
			@changed_user_id changed_user_id, 
			GETDATE() changed_date, 
			1 is_dirty
		FROM 
			Investor.tblInvestor TI
			INNER JOIN Investor.tblInvestorFundBalance IFB
					ON TI.client_id=IFB.client_id
					AND IFB.client_id not in (
											  select 
												distinct client_id 
											  from 
												Investor.tblInvestorFundBalance 
											  where 
												transaction_date =@PROCESS_DATE 
												AND membership_id=TI.membership_id
											  ) 
			
					
		WHERE 
			IFB.transaction_date= (
									SELECT 
										MAX(transaction_date) 
									FROM 
										Investor.tblInvestorFundBalance TMP 
									WHERE 
										TMP.membership_id=IFB.membership_id 
										AND TMP.client_id=IFB.client_id 
										AND TMP.transaction_date<@PROCESS_DATE
								   )
			AND 
			(IFB.available_balance!=0 OR IFB.ledger_balance!=0 OR IFB.market_value!=0 OR IFB.cost_value!=0)
			AND 
			TI.active_status_id=@active_status_id


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
			, purchase_power = CASE WHEN loan_ratio<=0 THEN 
									CASE WHEN (ledger_balance + additional_ledger_balance +  additional_market_value)>0 -- EQUEITY MUST GREATER THAN 0
										THEN ledger_balance + additional_ledger_balance +  additional_market_value -- LEDGER BALANCE + MARKET VALUE
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
				FROM #trans GROUP BY membership_id,client_id
			) TRN 
			INNER JOIN Investor.tblInvestor TI ON TRN.client_id=TI.client_id
			INNER JOIN Investor.tblInvestorFundBalance IFB ON TRN.client_id=IFB.client_id AND TRN.membership_id=IFB.membership_id
		WHERE IFB.transaction_date= @PROCESS_DATE


	 --   print 'show investor fund balance data'

		--SELECT client_id,membership_id,SUM(additional_available_balance) additional_available_balance, SUM(additional_sale_receivable) additional_sale_receivable,SUM(additional_un_clear_cheque) additional_un_clear_cheque
		--			,SUM(additional_ledger_balance) additional_ledger_balance,SUM(additional_total_deposit) additional_total_deposit,SUM(additional_share_transfer_in) additional_share_transfer_in,SUM(additional_total_withdraw) additional_total_withdraw
		--			,SUM(additional_share_transfer_out) additional_share_transfer_out,SUM(additional_realized_interest) additional_realized_interest,SUM(additional_realized_charge) additional_realized_charge,SUM(additional_accured_interest) additional_accured_interest
		--			,SUM(additional_fund_withdrawal_request) additional_fund_withdrawal_request,SUM(additional_cost_value) additional_cost_value,SUM(additional_market_value) additional_market_value,SUM(additional_realized_gain) additional_realized_gain
		--		FROM #trans GROUP BY membership_id,client_id




		-----------------------End Insert data from investor temporary to fund balance-----------------------
		DROP TABLE #trans
			
	END TRY		
	BEGIN CATCH
			
		SELECT @result = ERROR_MESSAGE()
		RAISERROR(@result,16,1)
	END CATCH	 
END



GO
/****** Object:  StoredProcedure [Investor].[psp_investor_share_transaction]    Script Date: 12/27/2015 7:46:15 PM ******/
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
CREATE PROCEDURE [Investor].[psp_investor_share_transaction]
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
			TINS.closed_price market_price,
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
			TINS.closed_price market_price,
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
			TINS.closed_price market_price,
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
			,TINS.closed_price market_price
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
			,TINS.closed_price market_price
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
			,TINS.closed_price market_price,TTD.membership_id
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
		,0 pledge_quantity,0 cost_average,0 cost_value,TINS.closed_price market_price,0 market_value, TI.active_status_id, @membership_id membership_id, @changed_user_id changed_user_id, GETDATE() changed_date, 1 is_dirty
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
		ISB.market_price,
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
									  (ISB.ledger_quantity + TRN.additional_ledger_quantity) * (ISB.cost_value / ISB.ledger_quantity)
								  END
		,ISB.market_price=CASE WHEN TRN.market_price!=0 THEN TRN.market_price ELSE ISB.market_price END
		,ISB.market_value=CASE WHEN (ISB.ledger_quantity + TRN.additional_ledger_quantity) !=0 THEN 
									(ISB.ledger_quantity + TRN.additional_ledger_quantity)*(CASE WHEN TRN.market_price!=0 THEN TRN.market_price ELSE ISB.market_price END)
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



GO
/****** Object:  StoredProcedure [Investor].[rsp_client_exposure_statement]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 01/12/2015
-- Description:	Client exposure report
-- =============================================


---- exec [Investor].[rsp_client_exposure_statement] 62,20151101,0,250000,null
CREATE PROCEDURE [Investor].[rsp_client_exposure_statement]
(
	@membership_id numeric(9,0),
	@user_id nvarchar(128),
	@report_date datetime,
	@min_bal numeric(15,4),
	@max_bal numeric(15,4),
	@branch_id numeric(4,0)
)
AS
BEGIN
	SET NOCOUNT ON;
	declare @transaction_date as numeric(9,0)
	set @transaction_date=(select convert(numeric,convert(varchar,@report_date,112)))

	SELECT 
		tifb.client_id,
		ti.first_holder_name,
		tbb.name,
		dd.FullDateUK,
		tifb.ledger_balance,
		tifb.market_value,
		case when tifb.market_value <> 0 
		then (tifb.ledger_balance/isnull(tifb.market_value,1))*100  
		else 0 end as expousure  
	FROM
		Investor.tblInvestorFundBalance tifb
	INNER JOIN 
		Investor.tblInvestor ti 
		on tifb.client_id = ti.client_id
	INNER JOIN 
		broker.tblBrokerBranch tbb 
		on ti.branch_id = tbb.id
	inner join 
		DimDate dd 
		on tifb.transaction_date = dd.DateKey
	WHERE 
		tifb.ledger_balance between @min_bal and @max_bal
		AND transaction_date = (
									select 
										MAX(transaction_date) 
									from 
										Investor.tblInvestorFundBalance fb2
									where 
										fb2.transaction_date <= @transaction_date 
										and fb2.active_status_id = 47
										and fb2.client_id=tifb.client_id
										and fb2.membership_id=tifb.membership_id
								)
	AND (ti.branch_id = @branch_id OR @branch_id IS NULL OR @branch_id = 0)
	AND tifb.membership_id = @membership_id
	
END


GO
/****** Object:  StoredProcedure [Investor].[rsp_client_ledger]    Script Date: 12/27/2015 7:46:15 PM ******/
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
CREATE PROCEDURE [Investor].[rsp_client_ledger]
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
			case when(tcov.display_value ='BUY/SALE') then (case when(tif.debit > 0)then 'BUY' else 'SALE' end) else tcov.display_value end  AS finintial_ledger_type,
			tif.refference_no,
			tif.narration,
			tif.quantity,
			tif.rate,
			(tif.quantity*tif.rate) as amount,
			tif.comm_amount,
			tif.debit,
			tif.credit,
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
			NULL transaction_date,
			NULL FullDateUK,
			NULL finintial_ledger_type,
			NULL refference_no,
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


GO
/****** Object:  StoredProcedure [Investor].[rsp_client_payable]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[Investor].[rsp_client_payable] 62,'2015-12-08',0

CREATE PROCEDURE [Investor].[rsp_client_payable]
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
ORDER BY TIFB.CLIENT_ID ASC
END











GO
/****** Object:  StoredProcedure [Investor].[rsp_client_portfolio_statement_as_on]    Script Date: 12/27/2015 7:46:15 PM ******/
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
CREATE PROCEDURE [Investor].[rsp_client_portfolio_statement_as_on]
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



GO
/****** Object:  StoredProcedure [Investor].[rsp_client_receivable]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Investor].[rsp_client_receivable]
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
	,receivable = CASE WHEN ([ledger_balance]) > 0 THEN ([ledger_balance]) ELSE 0 END
	,payable = CASE WHEN ([ledger_balance]) < 0 THEN (abs([ledger_balance])) ELSE 0 END
FROM 
	INVESTOR.TBLINVESTORFUNDBALANCE TIFB
INNER JOIN 
	INVESTOR.TBLINVESTOR TI 
	ON TIFB.CLIENT_ID = TI.CLIENT_ID
INNER JOIN 
	DIMDATE DD 
	ON DD.DATE = @REPORT_DATE
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
ORDER BY TIFB.CLIENT_ID ASC
END











GO
/****** Object:  StoredProcedure [Investor].[rsp_client_receivable_payable]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Investor].[rsp_client_receivable_payable]
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
order by tifb.client_id asc
END











GO
/****** Object:  StoredProcedure [Investor].[rsp_investor_list]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Investor.rsp_investor_list 62, 47, null, null, null
-- =============================================
-- Author:		Asif
-- Create date: 17/11/15
-- Description:	Investor list
-- =============================================

CREATE PROCEDURE [Investor].[rsp_investor_list]
(
@membership_id numeric(9,0) = null,
@user_id nvarchar(128),
@active_status_id int=null,
@branch_id numeric(2,0)=null,
@account_type_id numeric(4,0)=null,
@sub_account_type_id numeric(4,0)=null
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
	 SELECT ti.client_id
	 ,ti.bo_code
	 ,ti.first_holder_name
	 ,(CASE WHEN ti.mobile_no IS NOT NULL THEN ti.mobile_no WHEN ti.phone_no IS NOT NULL THEN ti.phone_no ELSE NULL END) AS contact_no
	 ,tcovot.display_value AS operation_type
	 ,tcovat.display_value AS account_type
	 ,tcovsat.display_value AS sub_account_type
	 ,tcovas.display_value AS active_status
	 ,(CASE WHEN ti.internet_enabled = 0 THEN 'No' WHEN ti.internet_enabled = 1 THEN 'Yes' END) AS internet_enabled
	 ,(CASE WHEN ISNULL(ti.sms_enabled,0) = 0 THEN 'No' WHEN ISNULL(ti.sms_enabled,0) = 1 THEN 'Yes' END) AS sms_enabled
	 ,(CASE WHEN ti.email_enabled = 0 THEN 'No' WHEN ti.email_enabled = 1 THEN 'Yes' END) AS email_enabled
	 ,(CASE WHEN ti.beftn_enabled = 0 THEN 'No' WHEN ti.beftn_enabled = 1 THEN 'Yes' END) AS beftn_enabled
	 FROM [Investor].[tblInvestor] ti
	 INNER JOIN [dbo].[tblConstantObjectValue] tcovot ON tcovot.object_value_id = ti.operation_type_id
	 LEFT JOIN [dbo].[tblConstantObjectValue] tcovat ON tcovat.object_value_id = ti.account_type_id
	 LEFT JOIN [dbo].[tblConstantObjectValue] tcovsat ON tcovsat.object_value_id = ti.sub_account_type_id
	 INNER JOIN [dbo].[tblConstantObjectValue] tcovas ON tcovas.object_value_id = ti.active_status_id
	 WHERE ti.membership_id = @membership_id
	 AND (ti.active_status_id = @active_status_id OR @active_status_id IS NULL OR @active_status_id = 0)
	 AND (ti.branch_id = @branch_id OR @branch_id IS NULL OR @branch_id = 0)
	 AND (ti.sub_account_type_id = @sub_account_type_id OR @sub_account_type_id IS NULL OR @sub_account_type_id = 0)
	 AND (ti.account_type_id = @account_type_id OR @account_type_id IS NULL OR @account_type_id = 0)
	 
END

GO
/****** Object:  StoredProcedure [Investor].[rsp_realize_gain_detail]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 17/12/2015
-- Description:	realize gain summary
-- =============================================

-- EXEC [Investor].[rsp_realize_gain_detail] '12-19-2015', '12-19-2015', '62','106', null
CREATE PROCEDURE [Investor].[rsp_realize_gain_detail] 

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
		,tihl.transaction_date
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
	FROM Investor.tblInvestorShareLedger tihl
		INNER JOIN Investor.tblInvestor tinv 
			ON tinv.client_id = tihl.client_id
		INNER JOIN Instrument.tblInstrument tins
			ON tins.id = tihl.instrument_id
		INNER JOIN dbo.DimDate ddtd
			ON ddtd.DateKey = tihl.transaction_date
	WHERE 
		ddtd.Date BETWEEN @from_dt AND @to_dt
		AND (tihl.client_id = @client_id OR @client_id IS NULL OR @client_id = '')
		AND (tihl.instrument_id = @instrument_id OR @instrument_id IS NULL OR @instrument_id = 0)
		AND tihl.membership_id = @membership_id
	ORDER BY tihl.transaction_date
	
END


GO
/****** Object:  StoredProcedure [Trade].[isp_non_trading_day]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 21/09/15
-- Description:	Save non trading day
-- =============================================
-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 23/12/15
-- Description:	ADD CODE IN CATCH AREA FOR SHOW ERROR MESSAGE AFTER ROLLBACK
-- =============================================

/*
exec insert_non_trading_day
	'20150101'
	,'20160103' 
	,'121'
	,'Friday,Saturday'
	,''
	,'47'
	,'62'
	,'1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
*/

CREATE PROCEDURE [Trade].[isp_non_trading_day]
	-- Add the parameters for the stored procedure here
	@from_date numeric(9,0)
	,@to_date numeric(9,0)
	, @non_trading_type_id numeric(4,0)
	,@input_info varchar(150)
	,@remarks varchar(150)
	,@active_status_id numeric(4, 0)
	,@membership_id numeric(9, 0)
	,@changed_user_id nvarchar(128)
	
	
AS
BEGIN

	SET NOCOUNT ON;

	Declare @non_trading_type varchar(100);
	
	declare @insert_id int
	Select @non_trading_type = display_value from tblConstantObjectValue where object_value_id = @non_trading_type_id;
    -- Insert statements for procedure here

	begin transaction
	--------------Start Insert for master table------------------
	
	Begin Try
		insert into Trade.tblNonTradingMaster 
		values(@from_date
		,@to_date
		,@non_trading_type_id
		,@input_info
		,@remarks
		,@active_status_id
		,@membership_id
		,@changed_user_id
		,GETDATE()
		,1);
     --------------End Insert for master table------------------

		SELECT @insert_id = SCOPE_IDENTITY();

		-------------start Insert Statement for on Demand-----------------
		if(@non_trading_type = 'On Demand')
		BEGIN
			insert into Trade.tblNonTradingDetail
			select DateKey,@insert_id from  DimDate--,Trade.tblNonTradingMaster ntm
			
			where DateKey >=@from_date and DateKey <= @to_date
		END
	
	
	---------------End Insert Statement for on Demand------------------

	print @non_trading_type
		----------------Start Insert Statement for Weekly------------------
		if(@non_trading_type = 'Weekly')
		BEGIN
		create table #SPLITED_DAY (ID varchar(10))
			insert into #SPLITED_DAY(ID) SELECT ID FROM dbo.udfSpliter(@input_info) 
			insert into Trade.tblNonTradingDetail
				select DateKey,@insert_id from  DimDate
			
				where (DateKey >=@from_date and DateKey <= @to_date)
				and(Dayname in (select ID from #SPLITED_DAY))
		drop table #SPLITED_DAY
		END

		----------------End Insert Statement for Weekly------------------


		----------------Start Insert Statement for Weekly------------------
		if(@non_trading_type = 'Yearly')
		BEGIN

		
			insert into Trade.tblNonTradingDetail
				select DateKey,@insert_id from  DimDate
			
				where DateKey >=@from_date 
				and DateKey <= @to_date
				and DayOfMonth =  RIGHT(@input_info,2)
				and MonthName =  LEFT(@input_info, LEN(@input_info) - 2)
		END

		EXEC [Trade].[psp_settlement_schedule] @from_date
		commit transaction
	----------------End Insert Statement for Weekly------------------
	end try

	Begin Catch
            rollback transaction
            DECLARE @ERROR AS NVARCHAR(MAX)
			SELECT @ERROR=ERROR_MESSAGE()
            RAISERROR(@ERROR,16,1)
    End Catch

    
	
	
END


GO
/****** Object:  StoredProcedure [Trade].[psp_execute_close_price_file]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- exec execute_close_price_file '1bf1c0e7-fa04-4266-9ce4-d20d6516737a',62
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 7/10/15
-- Description:	Execute Close Price File
-- =============================================

---exec [Trade].[psp_execute_close_price_file]  '1bf1c0e7-fa04-4266-9ce4-d20d6516737a',62
CREATE PROCEDURE [Trade].[psp_execute_close_price_file] 
(
	@changed_user_id  varchar(150)
	,@membership_id numeric(9,0)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ERROR_MESSAGE VARCHAR(MAX)
	begin transaction

	Begin Try
-----------------------Insert to original table-----------------------
	INSERT INTO [Trade].[tblClosingPrice]
           (security_code
           ,open_price
           ,high_price
           ,low_price
           ,closing_price
           ,group_id
           ,trans_dt
		   ,membership_id
           ,changed_user_id
           ,changed_date
           ,[var]
           ,var_percent
           ,active_status)
     select
           SecurityCode
           ,[Open]
           ,High
           ,Low
           ,[Close]
           ,tco.object_value_id
           ,TradeDate
		   ,@membership_id
           ,@changed_user_id
           ,getdate()
           ,[Var]
           ,VarPercent
           ,47
		   from Trade.tmpClosePriceData tcpd
		   inner join dbo.tblConstantObjectValue tco on tcpd.Category = tco.display_value
		   inner join dbo.tblConstantObject tc on tco.object_id = tc.object_id and tc.object_name = 'INSTRUMENT_GROUP'
		   where AssetClass <> 'IN'
	
-----------------------------End Insert to original table-------------------------------

-----------------------------insert to non existed instrument----------------------------
INSERT INTO [Instrument].[tblInstrument]
           ([isin]
           ,[security_code]
           ,[sector_id]
           ,[instument_type_id]
           ,[depository_company_id]
           ,[face_value]
           ,[lot]
           ,[is_marginable]
           ,[group_id]
           ,[closed_price]
           ,[is_foreign]
           ,[active_status_id]
           ,[membership_id]
           ,[changed_user_id]
           ,[changed_date]
           ,[is_dirty])
     select
           tcpd.isin   
		   ,tcpd.SecurityCode 
           ,tcos.object_value_id
           ,(select object_value_id from tblConstantObjectValue tco
		   inner join tblConstantObject tbc on tco.object_id = tbc.object_id
		   where display_value='Share' and tbc.object_name='INSTRUMENT_TYPE')
           ,(select object_value_id from tblConstantObjectValue tco
		   inner join tblConstantObject tbc on tco.object_id = tbc.object_id
		    where tco.display_value='CDBL' and tbc.object_name='DEPOSITORY_COMPANY')
           ,[Close]
           ,0
           ,0
           ,tcog.object_value_id
           ,[Close]
           ,0
           ,47
		   ,@membership_id
		   ,@changed_user_id
           ,GETDATE()
           ,1
		   from Trade.tmpClosePriceData tcpd
		   inner join dbo.tblConstantObjectValue tcog on tcpd.Category = tcog.display_value
		   inner join dbo.tblConstantObject tc on tcog.object_id = tc.object_id and tc.object_name = 'INSTRUMENT_GROUP' 
		   inner join dbo.tblConstantObjectValue tcos on  tcpd.Sector =tcos.display_value
		   left join Instrument.tblInstrument ti on tcpd.SecurityCode =ti.security_code
		   
		   where AssetClass <> 'IN'
		   and ti.security_code is null
		 
		  
		   order by SecurityCode

		   
-----------------------------end to non existed instrument-------------------------------


----------------------------Update Instrument Group------------------------------------

update ti 
	set ti.group_id= tco.object_value_id
		,ti.closed_price=[tcp].[Close]
	from tblConstantObjectValue tco
	inner join  Trade.tmpClosePriceData tcp on  tco.display_value = tcp.Category
	inner join Instrument.tblInstrument ti on tcp.SecurityCode = ti.security_code
	where tcp.AssetClass<> 'IN'
----------------------------end update instrument group-------------------------------


truncate table [Trade].[tmpClosePriceData]
commit transaction
end try

	Begin Catch
            rollback transaction
            SET @ERROR_MESSAGE=ERROR_MESSAGE()
			RAISERROR(@ERROR_MESSAGE,16,1)
    End Catch
	
END


GO
/****** Object:  StoredProcedure [Trade].[psp_execute_trade_file]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 20/10/15
-- Description:	Execute Trade File
-- Updated by : Sarwar
-- Update Date: 12/07/2015
-- Description: CALL SHARE AND FINANCIAL EXECUTION PROCESS FOR TRADE DATA
-- =============================================


-- [Trade].[psp_execute_trade_file] 62,'1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
CREATE PROCEDURE [Trade].[psp_execute_trade_file]
	(
		@membership_id numeric(9, 0)
		,@changed_user_id nvarchar(128)
		,@stock_exchange_id numeric(4,0)
	)
AS
BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF
	DECLARE @ERROR_MESSAGE VARCHAR(MAX)
	DECLARE
		@PROCESS_DATE AS NUMERIC(9,0)
		,@SHARE_LEDGER_TYPE_ID AS NUMERIC(4,0)

		SET @PROCESS_DATE=[dbo].[sfun_get_process_date]()

	BEGIN TRANSACTION
	BEGIN TRY

	if EXISTS(SELECT 1 FROM tblConstantObjectValue tcov 
	INNER JOIN tblConstantObject  tco on tcov.object_id = tco.object_id 
	WHERE object_value_id=@stock_exchange_id 
	and tco.object_name = 'STOCK_EXCHANGE'
	and display_value='Dhaka Stock Exchange Limited')
	BEGIN
    ---------===========Insert into trade table==============-----------------
		INSERT INTO [Trade].[tblTradeData]
			   ([instrument_id]
			   ,[AssetClass]
			   ,[OrderId]
			   ,[transaction_type]
			   ,[client_id]
			   ,[market_type_id]
			   ,[Date]
			   ,[Time]
			   ,[Quantity]
			   ,[Unit_Price]
			   ,[ExecID]
			   ,[FillType]
			   ,[group_id]
			   ,[CompulsorySpot]
			   ,[TraderDealerID]
			   ,[OwnerDealerID]
			   ,[commission_rate]
			   ,[commission_amount]
			   ,[trader_branch_id]
			   ,[client_branch_id]
			   ,membership_id
			   ,changed_user_id
			   ,changed_date)
		 Select
			   ti.id
			   ,AssetClass
			   ,OrderId
			   ,Side
			   ,ClientCode
			   ,tcov.object_value_id
			   ,Date
			   ,Time
			   ,Quantity
			   ,Price
			   ,ExecID
			   ,FillType
			   ,tcovg.object_value_id
			   ,CompulsorySpot
			   ,TraderDealerID
			   ,OwnerDealerID
			   ,AIC.charge_amount
			   ,CASE WHEN AIC.is_percentage=0 THEN AIC.charge_amount 
				ELSE 
					CASE WHEN (TTD.Quantity*TTD.Price*AIC.charge_amount)/100 < AIC.minimum_charge THEN AIC.minimum_charge ELSE (TTD.Quantity*TTD.Price*AIC.charge_amount)/100 END
				END
			  ,ttb.branch_id
			  ,tic.branch_id
			  ,@membership_id
			  ,@changed_user_id
			  ,GETDATE()

			   from Trade.tmpTradeData ttd
			   inner join Instrument.tblInstrument ti on  ttd.SecurityCode = ti.security_code
			   inner join dbo.tblConstantObjectValue tcov on ttd.Board = tcov.display_value
			   inner join Investor.tblInvestor tic on ttd.ClientCode = tic.client_id
			   inner join broker.tblTrader ttb on ttd.TraderDealerID = ttb.trader_code
			   INNER JOIN Charge.vw_all_investors_charges AIC ON TTD.ClientCode=AIC.client_id
			   inner join dbo.tblConstantObjectValue tcovg on ttd.Category = tcovg.display_value
			   inner join dbo.tblConstantObject tco on tcovg.object_id=tco.object_id and tco.object_name='INSTRUMENT_GROUP'
			   inner join dbo.tblConstantObject tcomt on tcov.object_id = tcomt.object_id and tcomt.object_name = 'MARKET_TYPE'
			   WHERE AIC.global_charge_id=1
				AND TTD.Action='EXEC' AND (TTD.FillType='FILL' OR TTD.FillType='PF')
			END
	--------=============Close Insert Into trade table=============--------------



			----------IF DATA INSERTED SUCCESSFULLY THEN EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE TRADE DATA---------
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
				AND A.display_value='BUY/SALE'
			
				--CALL SHARE TRANSACTION PROCESS
				EXEC [Investor].[psp_investor_share_transaction] @PROCESS_DATE,@object_value_id,@membership_id,@changed_user_id

				--END OF VALIDATEION
			END
			------------------END OF  EXECEUTE SHARE TRANSACTION PROCESS FOR ALL OF THE TRADE DATA---------

			-----------------TRUNCATE TRADE TEMP TABLE--------------------------------------------------------------------------------------------------------------------
			--DELETE FROM Trade.tmpTradeData WHERE membership_id=@membership_id
			/* as after trade reverse to reduce edit trade data work temo table data cannot  be deleted*/

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @ERROR_MESSAGE=ERROR_MESSAGE()
		RAISERROR(@ERROR_MESSAGE,16,1)
	END CATCH	
END



GO
/****** Object:  StoredProcedure [Trade].[psp_export_omnibus_trade]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 27/12/2015
-- Description:	Export Trade file for merchant bank
-- =============================================

--exec [Trade].[psp_export_omnibus_trade] 123,20151224,'T'
CREATE PROCEDURE [Trade].[psp_export_omnibus_trade]
(
	@stock_Exchange_id numeric(4,0),
	@trd_dt numeric(9,0),
	@isTxtOrXml varchar(1)
)
	
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @date varchar(10), 
			@process_dt numeric(9,0)

	SELECT @process_dt = dbo.sfun_get_process_date()
	SELECT @date = replace(FullDateUK,'/','-') from DimDate where DateKey='20151224'
	if(@process_dt = @trd_dt)
	BEGIN
		SELECT 
			ttd.OrderId+'~'+
			ttd.SecurityCode+'~'+
			ttd.Isin+'~'+
			ttd.TraderDealerID+'~'+
			ttd.Side+'~'+
			CONVERT(varchar(10),ttd.Quantity)+'~'+
			CONVERT(varchar(10),ttd.Price)+'~'+
			@date+'~'+
			ttd.Time+'~'+
			SUBSTRING(ttd.Board,1,1)+'~'+
			SUBSTRING(ttd.FillType,1,1)+'~'+
			'N'+'~'+
			'N'+'~'+
			 ttd.ClientCode+'~'+
			ttd.BoId+'~'+
			CONVERT(varchar(9),ttd.Date)+'0 '+ttd.ExecID++'~'+
			ttd.CompulsorySpot+'~'+
			ttd.Category as TradeData
			
		FROM 
			Trade.tmpTradeData ttd
			--INNER JOIN Instrument.tblInstrument tii ON ttd. = tii.id
			INNER JOIN Investor.tblInvestor ti on ttd.ClientCode = ti.client_id
			INNER JOIN DimDate dd on ttd.Date = dd.DateKey
	END
	
END

GO
/****** Object:  StoredProcedure [Trade].[psp_ft_exp_client_limits]    Script Date: 12/27/2015 7:46:15 PM ******/
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
CREATE PROCEDURE [Trade].[psp_ft_exp_client_limits] 

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


GO
/****** Object:  StoredProcedure [Trade].[psp_ft_exp_client_limits_intraday]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 8/12/2015
-- Description:	export ft client limit intraday
-- =============================================

-- EXEC [Trade].[psp_ft_exp_client_limits_intraday] '20151214', '', 'afds','4',62
CREATE PROCEDURE [Trade].[psp_ft_exp_client_limits_intraday] 

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
	DECLARE @version_no numeric(18,0)
	DECLARE @export_prev_datetime numeric(9,0)

	
	--SET DEFAULT TRADER CODE
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
	IF NOT EXISTS(
					SELECT 
						1 
					FROM 
						Trade.tblFTExportLog 
					WHERE 
						file_type='limits' 
						AND version_no=1
	 					AND export_dt = @export_dt
						AND membership_id=@membership_id
				  )  
	 BEGIN  
		  RAISERROR ('You are not allow to export intraday file before morning export', 16, 1)  
		  RETURN  
	 END 
	--------------------------------CLOSE morning data validation--------------------------- 
	
	SELECT @version_no= MAX(version_no) + 1 FROM Trade.tblFTExportLog WHERE file_type='limits' AND membership_id=@membership_id
	SELECT @export_prev_datetime=export_dt FROM Trade.tblFTExportLog WHERE file_type='limits' and version_no=@version_no-1 AND membership_id=@membership_id

	INSERT INTO Trade.tblFTExportLog(file_type,[file_name],export_dt,version_no,membership_id)
	VALUES ('limits',@file_name,@export_dt,@version_no,@membership_id)

	SELECT @log_id=MAX(log_id) from Trade.tblFTExportLog WHERE [file_name]=@file_name AND file_type='limits' AND version_no=@version_no  AND membership_id=@membership_id

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
		InvestOR.tblInvestOR ti
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
		ISNULL(ti.export_st,0)=0 
		AND LEN(ISNULL(ti.bo_code,''))=16
		AND TI.membership_id=@membership_id
	ORDER BY 
		ti.active_status_id, ti.client_id;
	---------------------------------------------END: Cash---------------------------------------------------------

	---------------------------------------------START: Limit---------------------------------------------------------

	SELECT 
		tfl.ClientCode
	    ,FLOOR(ISNULL(IFB.purchase_power,0)-ISNULL(tfl.CASH,0) ) AS Cash
		,ISNULL(tfl.acc_Type_S_Name,'C') acc_Type_S_Name
		,ISNULL(tfl.MarginRatio,0) MarginRatio
		,ISNULL(tfl.MaxCapitalBuy,0) MaxCapitalBuy
		,ISNULL(tfl.MaxCapitalSell,0) MaxCapitalSell
		,ISNULL(tfl.TotalTransaction,0) TotalTransaction
		,ISNULL(tfl.NetTransaction,0) NetTransaction
		,ISNULL(tfl.Deposit,0) Deposit
		,@log_id log_id
	FROM
	    [Investor].[vw_InvestorFundBalance] IFB
	INNER JOIN 
		Trade.tblFTLimits tfl 
		ON tfl.ClientCode=IFB.client_id
		AND TFL.Cash!=IFB.purchase_power
	INNER JOIN 
		Investor.tblInvestor ti 
		on ti.client_id = tfl.ClientCode
		AND TI.membership_id=TFL.membership_id
	INNER JOIN 
		dbo.tblConstantObjectValue tcovas 
		ON tcovas.object_value_id = ti.active_status_id
	WHERE 
		tcovas.display_value = 'Active' 
		AND LEN(ISNULL(ti.bo_code,''))=16
		AND (ISNULL(IFB.purchase_power,0)-ISNULL(tfl.CASH,0) )!= 0
		AND TFL.membership_id=@membership_id
	ORDER BY 
		tfl.ClientCode
	---------------------------------------------END: Limit---------------------------------------------------------
	
	UPDATE bil SET export_st=1, export_log_id=@log_id FROM Trade.tblFTImportLog bil INNER JOIN #SPLITED_BRANCH_INVESTOR sbi on bil.log_id=sbi.log_id
	
	UPDATE bil SET log_id=@log_id FROM Trade.tblFTLimits bil INNER JOIN #SPLITED_BRANCH_INVESTOR sbi on bil.import_log_id=sbi.log_id WHERE bil.import_type='B'
	
	UPDATE 
		Investor.tblInvestor 
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


GO
/****** Object:  StoredProcedure [Trade].[psp_ft_exp_client_limits_morning]    Script Date: 12/27/2015 7:46:15 PM ******/
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
CREATE PROCEDURE [Trade].[psp_ft_exp_client_limits_morning] 
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


GO
/****** Object:  StoredProcedure [Trade].[psp_ft_exp_rollback]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 8/12/2015
-- Description:	Manual Rolback when error found on exporting
-- =============================================
CREATE PROCEDURE [Trade].[psp_ft_exp_rollback]
	-- Add the parameters for the stored procedure here
	@log_id as numeric(20,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update Trade.tblFTImportLog set export_st=0, export_log_id=null where export_log_id=@log_id
	update Trade.tblFTLimits set log_id=null where log_id=@log_id
	--update tblFTPositions set log_id=null where log_id=@log_id
	delete from Trade.tblFTLimits where log_id=@log_id and import_log_id is null
	--delete from tblFTPositions where log_id=@log_id and import_log_id is null
	delete from Trade.tblFTExportLog where log_id=@log_id
END

GO
/****** Object:  StoredProcedure [Trade].[psp_ft_exp_share_limits_intraday]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 9/12/2015
-- Description:	export ft share limit intraday
-- =============================================

-- EXEC [Trade].[psp_ft_exp_share_limits_intraday] '20151214', '', 'DDDDD','4',62
CREATE PROCEDURE [Trade].[psp_ft_exp_share_limits_intraday] 
	 @export_dt as numeric (9,0)
	,@omb_ids as nvarchar(max) 
	,@file_name as nvarchar(max)
	,@branch_ids as nvarchar(max)
	,@membership_id NUMERIC(9)
AS
BEGIN
	DECLARE @log_id as numeric(20,0)
	DECLARE @version_no numeric(5,0)
	DECLARE @export_prev_datetime numeric(9,0) 
	
	SELECT  id log_id INTO #SPLITED_OMB_INVESTOR FROM dbo.udfSpliter(@omb_ids)
	SELECT id log_id INTO #SPLITED_BRANCH_INVESTOR FROM dbo.udfSpliter(@branch_ids)

	-------------------------------START morning data validation--------------------
	IF NOT EXISTS(SELECT 1 FROM Trade.tblFTExportLog WHERE file_type='positions' AND version_no=1
	 		AND export_dt = @export_dt AND membership_id=@membership_id)  
	 BEGIN  
		  RAISERROR ('You are not allow to export intraday file before morning export', 16, 1)  
		  RETURN  
	 END 
	--------------------------------CLOSE morning data validation--------------------------- 
	
	SELECT @version_no= MAX(version_no) + 1 FROM Trade.tblFTExportLog WHERE file_type='positions' AND membership_id=@membership_id
	SELECT @export_prev_datetime=export_dt FROM Trade.tblFTExportLog WHERE file_type='positions' and version_no=@version_no-1 AND membership_id=@membership_id
	 
	 INSERT INTO Trade.tblFTExportLog(file_type,[file_name],export_dt,version_no,membership_id)
	 VALUES ('positions',@file_name,@export_dt,@version_no,@membership_id)

	 SELECT @log_id=MAX(log_id) FROM Trade.tblFTExportLog WHERE [file_name]=@file_name AND file_type='positions' AND version_no=@version_no AND membership_id=@membership_id;


	---------------------------------------------START: Limit---------------------------------------------------------
	--WITH prev 
	--AS
	--(
	--	SELECT 
	--		tfp.ClientCode, tfp.ISIN, SUM(CAST(tfp.Quantity as numeric)) Quantity
	--	FROM 
	--		Trade.tblFTPositions tfp 
	--	INNER JOIN 
	--		Trade.tblFTExportLog tfel 
	--		on tfp.log_id=tfel.log_id
	--	WHERE 
	--		tfel.export_dt = @export_dt
	--		AND isnull(tfp.status,'')!='Wrong' 
	--		AND tfp.log_id IS NOT NULL
	--		AND TFP.membership_id=@membership_id
	--	GROUP BY 
	--		tfp.ClientCode, tfp.ISIN
	--)
	
	SELECT 
		tfp.ClientCode
		,tfp.ISIN AS isin
		,tfp.SecurityCode
		,MIN(CEILING(isnull(tfp.Quantity,0)-ISNULL(ISB.salable_quantity,0))) Quantity
		,MIN(FLOOR(tfp.TotalCost)) TotalCost
		,'Long' PositionType
		,@log_id log_id
	FROM 
		[Investor].[vw_InvestorShareBalance] ISB
	INNER JOIN 
		[Instrument].[tblInstrument] INS
		ON INS.ID=ISB.instrument_id
	INNER JOIN
		Trade.tblFTPositions tfp 
		ON TFP.ClientCode=ISB.client_id 
		AND TFP.ISIN=INS.security_code
		AND ISNULL(TFP.Quantity,0) != ISNULL(ISB.salable_quantity,0)
	INNER JOIN 
		Investor.tblInvestor ti 
		on ti.client_id = tfp.ClientCode
		AND ti.membership_id=tfp.membership_id
	INNER JOIN 
		dbo.tblConstantObjectValue tcovas 
		ON tcovas.object_value_id = ti.active_status_id
	--LEFT JOIN 
	--	prev 
	--	on tfp.ClientCode=prev.ClientCode 
	--	and tfp.ISIN=prev.ISIN
	WHERE 
		CEILING(isnull(tfp.Quantity,0)-isnull(ISB.salable_quantity,0))!= 0
		AND LEN(isnull(tfp.ISIN,'')) = 12 
		AND tcovas.display_value = 'Active' 
		AND TFP.membership_id=@membership_id
	GROUP BY 
		tfp.ClientCode, tfp.isin, tfp.SecurityCode
	ORDER BY 
		tfp.ClientCode, tfp.ISIN
	---------------------------------------------END: Limit---------------------------------------------------------
	
	UPDATE bil SET export_st=1, export_log_id=@log_id FROM Trade.tblFTImportLog bil INNER JOIN #SPLITED_BRANCH_INVESTOR sbi on bil.log_id=sbi.log_id
	
	UPDATE bil SET log_id=@log_id FROM Trade.tblFTPositions bil INNER JOIN #SPLITED_BRANCH_INVESTOR sbi on bil.import_log_id=sbi.log_id WHERE bil.import_type='B'
	
END


GO
/****** Object:  StoredProcedure [Trade].[psp_ft_exp_share_limits_morning]    Script Date: 12/27/2015 7:46:15 PM ******/
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
CREATE PROCEDURE [Trade].[psp_ft_exp_share_limits_morning] 

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


GO
/****** Object:  StoredProcedure [Trade].[psp_ft_imp_client_limits]    Script Date: 12/27/2015 7:46:15 PM ******/
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
	@omnibus_master_id varchar(10)
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

	SELECT @account_type_id = dbo.sfun_get_constant_object_value_id('INVESTOR_ACC_TYPE','C')

	SELECT @active_status_id = dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
    
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

GO
/****** Object:  StoredProcedure [Trade].[psp_ft_imp_positions]    Script Date: 12/27/2015 7:46:15 PM ******/
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

GO
/****** Object:  StoredProcedure [Trade].[psp_reverse_trade_file]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 25/10/15
-- Description:	<Description,,>
-- Updated by : Sarwar
-- Update Date: 12/08/2015
-- Description: CALL SHARE AND SHARE EXECUTION PROCESS FOR TRADE DATA AND SET VALIDATION
-- =============================================
CREATE PROCEDURE [Trade].[psp_reverse_trade_file]
	@date numeric(9, 0)
	,@stock_exchange_id numeric(4,0)
	,@membership_id numeric(9,0)
	,@changed_user_id nvarchar(128)
AS
BEGIN
	 SET NOCOUNT ON;
	 DECLARE @ERROR_MESSAGE VARCHAR(MAX)
			,@object_value_id NUMERIC(4)
	 BEGIN TRANSACTION
		BEGIN TRY
--**************************************************************************************************************************************--
			--validate day end process
			IF NOT EXISTS(SELECT 1 FROM DBO.tblDayProcess WHERE [end_date] IS NULL AND [start_date] IS NOT NULL AND [process_date]=@DATE )
			BEGIN
				RAISERROR('Day end is done',16,1)
			END

			--validate trade file 
			IF NOT EXISTS(SELECT 1 FROM TRADE.TBLTRADEDATA WHERE [DATE]=@DATE )
			BEGIN
				RAISERROR('Trade data not found',16,1)
			END

			--PROCESS SHARE TRANSACTION FOR REVERSE BUY SELL
			SELECT @object_value_id= A.object_value_id 
			FROM
			tblConstantObjectValue A
			INNER JOIN tblConstantObject B ON B.object_id=A.object_id
			where 
			B.object_name='SHARE_LEDGER_TYPE'
			AND A.display_value='Reverse BUY/SALE'

			--CALL SHARE TRANSACTION PROCESS
			EXEC [Investor].[psp_investor_share_transaction] @DATE,@object_value_id,@membership_id,@changed_user_id			

			--DELETE TRADE DATA
			DELETE 
			FROM 
				TRADE.TBLTRADEDATA
			WHERE 
				DATE = @DATE
				AND stock_exchange_id = @stock_exchange_id

			--DELETE TRADE DATA FROM FINANCIAL LEDGER
			DELETE FROM
			[Investor].[tblInvestorFinancialLedger]
			where
			ISNULL(QUANTITY,0) !=0
			AND transaction_date=@DATE

			--DELETE TRADE DATA FROM SHARE LEDGER
			DELETE FROM
			[Investor].[tblInvestorShareLedger]
			where
			(ISNULL(sale_qty,0) + ISNULL(buy_qty,0)) !=0
			AND transaction_date=@DATE
--**************************************************************************************************************************************--
		COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SET @ERROR_MESSAGE=ERROR_MESSAGE()
			RAISERROR(@ERROR_MESSAGE,16,1)
		END CATCH  
END



GO
/****** Object:  StoredProcedure [Trade].[psp_settlement_schedule]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 06-DEC-2015
-- Description:	UPDATE SETTELEMENT SCHEDULE OF TRADING DATE DEPENDS ON HOLIDAYS
-- EXEC psp_settlement_schedule 20160101, 20161231
-- =============================================
CREATE PROCEDURE [Trade].[psp_settlement_schedule]
	 @FROM_DATE AS NUMERIC(9,0)
AS
BEGIN
	DECLARE @WORKING_TO_DATE AS NUMERIC(9,0)
	
	IF (dbo.sfun_get_process_date()>@FROM_DATE) SET @FROM_DATE=dbo.sfun_get_process_date()

	DELETE FROM Trade.tblSettlementSchedule WHERE trade_date>=@FROM_DATE
	
	SET @WORKING_TO_DATE=(SELECT TOP 1 DateKey FROM (SELECT TOP 9 DateKey FROM DimDate ORDER BY DateKey DESC) AS M ORDER BY DateKey ASC) ;

	
	WITH WORKING_DAY AS
	(
		SELECT DateKey trade_date
		FROM dbo.DimDate DD
			LEFT JOIN (SELECT DISTINCT non_trading_date FROM Trade.tblNonTradingDetail) NTD ON DD.DateKey=NTD.non_trading_date
		WHERE NTD.non_trading_date IS NULL
			AND (DateKey >= @FROM_DATE)
	)
	, STOCK_EXCHANGE AS
	(
		SELECT CO.object_id, COV.object_value_id stock_exchange_id, COV.display_value stock_exchange_name, COV.is_default, COV.remarks, COV.sorting_order
		FROM dbo.tblConstantObject CO
			INNER JOIN dbo.tblConstantObjectValue COV ON CO.object_id=COV.object_id
		WHERE CO.object_name='STOCK_EXCHANGE'
	)
	, MARKET_TYPE AS
	(
		SELECT CO.object_id, COV.object_value_id market_type_id, COV.display_value market_type_name, COV.is_default, COV.remarks, COV.sorting_order
		FROM dbo.tblConstantObject CO
			INNER JOIN dbo.tblConstantObjectValue COV ON CO.object_id=COV.object_id
		WHERE CO.object_name='MARKET_TYPE'
	)
	, INSTRUMENT_GROUP AS
	(
		SELECT CO.object_id, COV.object_value_id instrument_group_id, COV.display_value instrument_group_name, COV.is_default, COV.remarks, COV.sorting_order
		FROM dbo.tblConstantObject CO
			INNER JOIN dbo.tblConstantObjectValue COV ON CO.object_id=COV.object_id
		WHERE CO.object_name='INSTRUMENT_GROUP'
	)

	INSERT INTO Trade.tblSettlementSchedule(stock_exchange_id,market_type_id,instrument_group_id,trade_date,settle_date)
	SELECT SE.stock_exchange_id, MT.market_type_id, IG.instrument_group_id, WD.trade_date trade_date
		, CASE WHEN market_type_name='SPOT' THEN WD.trade_date 
			WHEN market_type_name!='SPOT' AND instrument_group_name='Z' THEN (SELECT TOP 1 trade_date FROM (SELECT TOP 9 trade_date FROM WORKING_DAY SWD WHERE SWD.trade_date>WD.trade_date ORDER BY trade_date ASC) AS M ORDER BY trade_date DESC)
			ELSE (SELECT TOP 1 trade_date FROM (SELECT TOP 2 trade_date FROM WORKING_DAY SWD WHERE SWD.trade_date>WD.trade_date ORDER BY trade_date ASC) AS M ORDER BY trade_date DESC)
			END settle_date
	FROM WORKING_DAY WD 
		CROSS JOIN STOCK_EXCHANGE SE 
		CROSS JOIN MARKET_TYPE MT 
		CROSS JOIN INSTRUMENT_GROUP IG 
	WHERE WD.trade_date BETWEEN @FROM_DATE AND @WORKING_TO_DATE
	ORDER BY SE.stock_exchange_id, MT.market_type_id, IG.instrument_group_id, WD.trade_date ASC
END


GO
/****** Object:  StoredProcedure [Trade].[psp_upload_trade]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Shrif
-- Create date: 14/10/2015
-- Description:	Check Invalid and inactive investor for trade file
-- =============================================
CREATE PROCEDURE [Trade].[psp_upload_trade]
	
	
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @PROCESS_DATE AS NUMERIC(9,0)
	
	-- GET PROCESS DATE
	SELECT @PROCESS_DATE=[dbo].[sfun_get_process_date]()	
	----------------------Delete unwanted data------------------------

	delete from 
	 trade.tmpTradeData 
	 where  Action<>'EXEC' 
	 and (FillType<>'FILL' or FillType<>'PF')
	----------------------Delete unwanted data ends------------------------

  ---------------------Checking mismatch file with system----------------------
	select * from
	(

		----start----------------------Check whether market closing price uploaded--------------------------
		SELECT 
			'' ClientCode,
			'Market Closing Price file not uploaded' error 
		WHERE
			NOT EXISTS
			(
				SELECT 1
				from 
					[Trade].[tblClosingPrice] CP
				where 
					CP.[trans_dt]=@PROCESS_DATE
					--TO DO: MEMBERSHIP_ID
			)
		UNION
		----end----------------------Check whether market closing price uploaded--------------------------
		-----------------------Check not existed Clients----------------------
		(
			SELECT ttd.ClientCode,'Client Not Exist' error from Trade.tmpTradeData ttd
			left join Investor.tblInvestor ti  on ttd.ClientCode =  ti.client_id
			where ti.client_id is null
		)
		-----------------------Check not existed Clients ends----------------------
		-----------------------Check Inactive Clients------------------------------
		UNION
		(
			SELECT ttd.ClientCode,'Client Not Active' error from Trade.tmpTradeData ttd
			inner join Investor.tblInvestor ti  on ttd.ClientCode =  ti.client_id
			where ti.active_status_id <>47
		)
		-----------------------Check Inactive Clients ends------------------------------
		UNION
		(
			SELECT distinct ttd.TraderDealerID,'TraderDealer Not Exist' error from Trade.tmpTradeData ttd
			left join broker.tblTrader tt  on ttd.TraderDealerID =  tt.trader_code
			where tt.trader_code is null
		)
		-----------------------Check not existed and inactive Trader----------------------
		UNION
		(
			SELECT distinct ttd.TraderDealerID,'TraderDealer Not Active' error from Trade.tmpTradeData ttd
			inner join broker.tblTrader tt  on ttd.TraderDealerID =  tt.trader_code
			where tt.active_status_id <>47
		)
		UNION
		(
			SELECT distinct ttd.OwnerDealerID,'OwnerDealer Not Exist' error from Trade.tmpTradeData ttd
			left join broker.tblTrader tt  on ttd.OwnerDealerID =  tt.trader_code
			where tt.trader_code is null
		)
		UNION
		(
			SELECT distinct ttd.OwnerDealerID,'OwnerDealer Not Active' error from Trade.tmpTradeData ttd
			inner join broker.tblTrader tt  on ttd.OwnerDealerID =  tt.trader_code
			where tt.active_status_id <>47
		)
		----------------------------------------------Check not existed and inactive Trader ends----------------------

		--------------------------Check not existed instruments--------------------------
		UNION
		(
			SELECT distinct ttd.SecurityCode,'Instruments Not Exist' error from Trade.tmpTradeData ttd
			left join Instrument.tblInstrument iti  on ttd.SecurityCode =  iti.security_code
			where iti.security_code is null
		)
		UNION
		(
			SELECT distinct ttd.SecurityCode,'Instruments Not Active' error from Trade.tmpTradeData ttd
			inner join Instrument.tblInstrument iti  on ttd.SecurityCode =  iti.security_code
			where iti.active_status_id <>47
		)
		--------------------------end check nit existed instruments----------------------

		--------------------------Check System Bo and File Bo mismatch----------------------
		union
		(
			SELECT ttd.ClientCode,' BO code does not match with File BO Code' error from Trade.tmpTradeData ttd
			left join Investor.tblInvestor ti  on ttd.ClientCode =  ti.client_id
			where ti.bo_code <> ttd.BoId
		)
		--------------------------Check System Bo and File Bo mismatch Ends----------------------

	) clientCodeError
	  ---------------------end Checking mismatch file with system----------------------
END


GO
/****** Object:  StoredProcedure [Trade].[rsp_brokerage_commission_income_agent_wise]    Script Date: 12/27/2015 7:46:15 PM ******/
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

CREATE PROCEDURE [Trade].[rsp_brokerage_commission_income_agent_wise]
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
			,ttd.commission_rate
			,SUM(ttd.commission_rate - (ISNULL(ttd.transaction_fee,0) + ISNULL(ttd.ait,0))) AS commission_amount
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
			GROUP BY ttd.client_id, tinv.first_holder_name, ttd.transaction_type, ttd.commission_rate, tcovmt.display_value, tint.ref_code, tint.introducer_name
		) AS a
		GROUP BY a.client_id, a.introducer_code, a.introducer_name, a.first_holder_name, a.market_name
		ORDER BY a.client_id
	 
END

GO
/****** Object:  StoredProcedure [Trade].[rsp_brokerage_commission_income_branch_wise]    Script Date: 12/27/2015 7:46:15 PM ******/
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

CREATE PROCEDURE [Trade].[rsp_brokerage_commission_income_branch_wise]
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
	 ,SUM(ttd.commission_rate) AS total_com
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

GO
/****** Object:  StoredProcedure [Trade].[rsp_brokerage_commission_income_client_wise]    Script Date: 12/27/2015 7:46:15 PM ******/
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

CREATE PROCEDURE [Trade].[rsp_brokerage_commission_income_client_wise]
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
			,SUM(ttd.commission_rate) AS total_com
			,SUM(ISNULL(ttd.transaction_fee,0)) AS transaction_fee
			,SUM(ISNULL(ttd.ait,0)) AS ait
			,SUM(ttd.commission_rate) - (SUM(ISNULL(ttd.transaction_fee,0)) + SUM(ISNULL(ttd.ait,0))) AS net_income
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

GO
/****** Object:  StoredProcedure [Trade].[rsp_brokerage_commission_income_trader_wise]    Script Date: 12/27/2015 7:46:15 PM ******/
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

CREATE PROCEDURE [Trade].[rsp_brokerage_commission_income_trader_wise]
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
	 ,SUM(ttd.commission_rate) AS total_com
	 ,SUM(ISNULL(ttd.transaction_fee,0)) AS transaction_fee
	 ,SUM(ISNULL(ttd.ait,0)) AS ait
	 ,SUM(ttd.commission_rate) - (SUM(ISNULL(ttd.transaction_fee,0)) + SUM(ISNULL(ttd.ait,0))) AS net_income
	 ,tcovmt.display_value AS market_name
	 ,ttd.TraderDealerID AS trader_code
	 FROM [Trade].[tblTradeData] ttd
	 INNER JOIN [dbo].[tblConstantObjectValue] tcovmt ON tcovmt.object_value_id = ttd.market_type_id
	 inner join DimDate dd on ttd.Date = dd.DateKey
	 WHERE ttd.membership_id = @membership_id
	 AND dd.Date BETWEEN @from_dt AND @to_dt
	 GROUP BY ttd.membership_id, ttd.transaction_type, tcovmt.display_value, ttd.TraderDealerID
	 
END

GO
/****** Object:  StoredProcedure [Trade].[rsp_trade_confirmation_note_broker_copy]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec Trade.rsp_trade_confirmation_note_broker_copy 62, 20141020, 20151231, null, null
-- =============================================
-- Author:		Asif
-- Create date: 22/11/15
-- Description:	Trade confirmation note broker copy
-- =============================================
--[Trade].[rsp_trade_confirmation_note_broker_copy] 62,'2015-01-01','2015-12-12',null,null
CREATE PROCEDURE [Trade].[rsp_trade_confirmation_note_broker_copy]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime,
@client_id varchar(10),
@branch_id numeric(2,0)
)

AS

BEGIN
	SET NOCOUNT OFF
	SET FMTONLY OFF
	
	DECLARE @opening_dt numeric(9,0);
	
	SELECT @opening_dt = MAX(DateKey) FROM dbo.DimDate WHERE DateKey < (select DateKey from dimdate where Date = @from_dt)
	 
	SELECT 
		ttd.OrderId
		,CASE WHEN ttd.transaction_type = 'B' THEN 'Buy' WHEN ttd.transaction_type = 'S' THEN 'Sell' END AS transaction_type
		,ttd.client_id
		,CAST(ttd.Quantity AS int) AS qty
		,ttd.Unit_Price
		,ttd.commission_rate
		,tins.instrument_name
		,tinv.bo_code
		,tinv.first_holder_name
		,tjh.join_holder_name AS second_holder_name
		,tinv.mailing_address
		,tbb.name AS branch_name
		,[Investor].[sfun_get_investor_fund_balance](ttd.client_id,@opening_dt) AS opening_balance
		,[Investor].[sfun_get_investor_fund_balance](ttd.client_id,ddt.DateKey) AS ledger_balance
		,tcovmt.display_value AS market_name
		,tins.security_code
		,CAST(ttd.Quantity AS int) * ttd.Unit_Price AS amount
		,CASE WHEN ttd.transaction_type = 'B' THEN CAST(ttd.Quantity AS int) * ttd.Unit_Price + ttd.commission_rate ELSE CAST(ttd.Quantity AS int) * ttd.Unit_Price + ttd.commission_rate END AS balance
		,(CASE WHEN tinv.mobile_no IS NOT NULL THEN tinv.mobile_no WHEN tinv.phone_no IS NOT NULL THEN tinv.phone_no ELSE NULL END) AS contact_no
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
		AND (tinv.branch_id = @branch_id OR @branch_id IS NULL OR @branch_id = 0)
	 
END

GO
/****** Object:  StoredProcedure [Trade].[rsp_trade_confirmation_statement]    Script Date: 12/27/2015 7:46:15 PM ******/
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

CREATE PROCEDURE [Trade].[rsp_trade_confirmation_statement]
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
		,(CASE WHEN ttd.transaction_type = 'S' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price)ELSE 0 END) - (CASE WHEN ttd.transaction_type = 'B' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price)ELSE 0 END) - (SUM(ttd.commission_rate)) AS balance
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

GO
/****** Object:  StoredProcedure [Trade].[rsp_trade_confirmation_statement_client_wise]    Script Date: 12/27/2015 7:46:15 PM ******/
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
CREATE PROCEDURE [Trade].[rsp_trade_confirmation_statement_client_wise]
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
		,CAST(ttd.Quantity AS int) AS qty
		,ttd.Unit_Price
		,ttd.commission_rate
		,[Investor].[sfun_get_investor_fund_balance](ttd.client_id,@opening_dt) AS opening_balance
		,[Investor].[sfun_get_investor_fund_balance](ttd.client_id,ddt.DateKey) AS ledger_balance
		,CASE WHEN ttd.transaction_type = 'B' THEN CAST(ttd.Quantity AS int) * ttd.Unit_Price + ttd.commission_rate ELSE CAST(ttd.Quantity AS int) * ttd.Unit_Price + ttd.commission_rate END AS balance
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
	 
END

GO
/****** Object:  StoredProcedure [Trade].[rsp_trade_confirmation_statement_consolidate]    Script Date: 12/27/2015 7:46:15 PM ******/
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
CREATE PROCEDURE [Trade].[rsp_trade_confirmation_statement_consolidate]
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
		,(CASE WHEN ttd.transaction_type = 'S' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price)ELSE 0 END) - ((CASE WHEN ttd.transaction_type = 'B' THEN SUM(CAST(ttd.Quantity AS int) * ttd.Unit_Price)ELSE 0 END) + (SUM(ttd.commission_rate))) AS net_balance
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

GO
/****** Object:  StoredProcedure [Trade].[ssp_ft_exp_log_list]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Asif
-- Create date: 9/12/2015
-- Description:	export ft log list
-- =============================================

CREATE PROCEDURE [Trade].[ssp_ft_exp_log_list]
	-- Add the parameters for the stored procedure here
	@file_type as varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	 SET NOCOUNT OFF
	 SET FMTONLY OFF

    -- Insert statements for procedure here
	SELECT tfel.log_id, upper(tfel.file_type) file_type, tfel.file_name, SUBSTRING(tfel.file_name,1,LEN(tfel.file_name)-4) + '-ctrl.xml' control_name, dded.FullDateUK import_dt, tfel.version_no, tfel.success, tfel.wrong 
	FROM Trade.tblFTExportLog tfel
	INNER JOIN dbo.DimDate dded ON dded.DateKey = tfel.export_dt
	WHERE file_type=@file_type
END

GO
/****** Object:  StoredProcedure [Trade].[ssp_ft_import_client_limits]    Script Date: 12/27/2015 7:46:15 PM ******/
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




GO
/****** Object:  StoredProcedure [Trade].[ssp_ft_import_positions]    Script Date: 12/27/2015 7:46:15 PM ******/
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
		investor_code IS NOT NULL 
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




GO
/****** Object:  StoredProcedure [Trade].[usp_ft_trader_by_investor_range_mapping]    Script Date: 12/27/2015 7:46:15 PM ******/
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
		, @DealerID as varchar(10)
	
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
									tinv.trader_id = @DealerID 
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

GO
/****** Object:  StoredProcedure [Transaction].[isp_on_dem_char_all_inv]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Transaction].[isp_on_dem_char_all_inv]
(
@charge_id numeric(3,0),
@transaction_type_id numeric(4,0),
@amount numeric (30,10),
@transaction_date numeric (9,0),
@value_date numeric(9,0),
@remarks varchar (250),
@membership_id numeric (9,0),
@changed_user_id nvarchar(128),
@changed_date datetime,
@is_dirty numeric (1,0)
)

AS


BEGIN

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
	SELECT ti.client_id
			,@charge_id
			,@transaction_type_id
			,@amount
			,@transaction_date
			,@value_date
			,@remarks
			,ti.active_status_id
			,@membership_id
			,@changed_user_id
			,@changed_date
			,@is_dirty
	FROM 
		[Investor].[tblInvestor] ti
	INNER JOIN 
		[dbo].[tblConstantObjectValue] titcov 
		ON titcov.object_value_id = ti.active_status_id
	LEFT JOIN 
		[Transaction].[tblForceChargeApply] tfca 
		ON ti.client_id = tfca.client_id 
		AND tfca.transaction_date = @transaction_date 
		AND tfca.transaction_type_id = @transaction_type_id 
		AND tfca.charge_id = @charge_id
		AND tfca.membership_id =TI.membership_id
	LEFT JOIN 
		[dbo].[tblConstantObjectValue] tfcatcov 
		ON tfcatcov.object_value_id = tfca.active_status_id
	WHERE 
		titcov.display_value = 'ACTIVE'
		AND tfca.id IS NULL
		AND TI.membership_id=@membership_id
END



GO
/****** Object:  StoredProcedure [Transaction].[psp_on_dem_char_xl_dt]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Transaction].[psp_on_dem_char_xl_dt]
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
		UPDATE tfca
			SET tfca.amount = tfcat.amount,
			tfca.remarks = tfcat.remarks
			FROM [Transaction].[tblForceChargeApplyTemp] tfcat
			INNER JOIN [Transaction].[tblForceChargeApply] tfca ON tfca.client_id = tfcat.client_id
			WHERE tfca.transaction_date = @transaction_date 
			AND tfca.transaction_type_id = @transaction_type_id 
			AND tfca.charge_id = @charge_id
		
		
		UPDATE tfcat
			SET tfcat.is_processed = 1
			FROM [Transaction].[tblForceChargeApplyTemp] tfcat
			INNER JOIN [Transaction].[tblForceChargeApply] tfca ON tfca.client_id = tfcat.client_id
			WHERE tfca.transaction_date = @transaction_date 
			AND tfca.transaction_type_id = @transaction_type_id 
			AND tfca.charge_id = @charge_id
	END
		
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


GO
/****** Object:  StoredProcedure [Transaction].[rsp_et_list]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 12/09/2015
-- Description:	Et list report
-- =============================================
CREATE PROCEDURE [Transaction].[rsp_et_list] 
	@membership_id numeric(9,0),
	@user_id nvarchar(128),
	@report_date datetime
AS
BEGIN

	SET NOCOUNT ON;

	 SELECT 
		tfw.client_id,
		ti.first_holder_name,
		ti.bo_code,
		tb.bank_name,
		tbb.branch_name,
		tbb.routing_no,
		tfw.amount 
	 from
		[Transaction].tblFundWithdraw tfw
	 inner join 
		Investor.tblInvestor ti 
		on tfw.client_id = ti.client_id
		AND TI.membership_id=TFW.membership_id
	 inner join 
		Accounting.tblBankBranch tbb 
		on tfw.bank_branch_id = tbb.id
		AND tbb.membership_id=TFW.membership_id
	 inner join 
		Accounting.tblBank tb 
		on tbb.bank_id = tb.id
	 inner join 
		tblConstantObjectValue tcov 
		on tfw.transaction_mode_id = tcov.object_value_id
	 inner join 
		tblConstantObject tco 
		on tcov.object_id = tco.object_id
	 inner join 
		DimDate dd 
		on tfw.cheque_date = dd.DateKey
	 where 
		 tco.object_name='TRANSACTION_MODE'
		 and tcov.display_value = 'ET'
		 and tfw.membership_id = @membership_id
		 and dd.Date = @report_date

END


GO
/****** Object:  StoredProcedure [Transaction].[rsp_manual_charge_branch_wise]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newaz Sharif
-- Create date: 28/11/2015
-- Description:	Manual charge type wise report
-- =============================================

--[Transaction].[rsp_manual_charge_branch_wise]  62,'000155','2015/01/01','2015/12/06',null,null
CREATE PROCEDURE [Transaction].[rsp_manual_charge_branch_wise] 
	  @membership_id					NUMERIC(9,0)
	 ,@client_id						VARCHAR(10)
	 ,@from_dt						DATETIME
	 ,@to_dt						DATETIME
	 ,@branch_id					NUMERIC(4,0)
	 ,@charge_id					NUMERIC(3,0),
	 @user_id						nvarchar(128)
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT
		tfc.client_id
		,ti.first_holder_name
		,tcov.display_value
		,tbb.name as branch_name
		,tgc.name as charge_name
		,dd.FullDateUK as transaction_date
		,tfc.remarks
		,tfc.amount
	FROM
	[Transaction].[tblForceChargeApply] tfc
	INNER JOIN Investor.tblInvestor ti on tfc.client_id = ti.client_id
	INNER JOIN broker.tblBrokerBranch tbb on ti.branch_id = tbb.id
	INNER JOIN Charge.tblGlobalCharge tgc on tfc.charge_id = tgc.id
	INNER JOIN tblConstantObjectValue tcov on tfc.transaction_type_id = tcov.object_value_id
	INNER JOIN DimDate ddf on @from_dt = ddf.Date
	inner join DimDate ddt on @to_dt = ddt.Date
	inner join Dimdate dd on tfc.transaction_date = dd.DateKey

	WHERE tfc.client_id = ISNULL(@client_id,tfc.client_id)
	AND ti.branch_id = ISNULL(@branch_id,ti.branch_id)
	AND tfc.charge_id = ISNULL(@charge_id,tfc.charge_id)
	AND tfc.transaction_date BETWEEN ddf.DateKey AND ddt.DateKey
	
	AND tfc.membership_id = @membership_id
END


GO
/****** Object:  StoredProcedure [Transaction].[rsp_money_receipt]    Script Date: 12/27/2015 7:46:15 PM ******/
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

GO
/****** Object:  StoredProcedure [Transaction].[rsp_payment]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec [Transaction].rsp_payment 62, 20140113, 20151231, null, null, null, null, 2
-- =============================================
-- Author:		Asif
-- Create date: 18/11/15
-- Description:	Payment report
-- =============================================

CREATE PROCEDURE [Transaction].[rsp_payment]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime,
@voucher_no varchar(15),
@client_id varchar(10),
@branch_id numeric(2,0),
@transaction_mode_id numeric(4,0),
@is_approved numeric(1,0)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 

		 SELECT tbrokbran.name AS branch
		 ,tfw.voucher_no
		 ,tfw.client_id
		 ,ti.first_holder_name
		 ,tcovtm.display_value AS transaction_mode
		 ,tb.short_name AS bank_name
		 ,tbb.branch_name AS bank_branch_name
		 ,tfw.cheque_no
		 ,ddcd.FullDateUK AS cheque_date
		 ,tfw.amount
		 FROM [Transaction].[tblFundWithdraw] tfw
		 INNER JOIN [broker].[tblBrokerBranch] tbrokbran ON tbrokbran.id = tfw.broker_branch_id
		 INNER JOIN [Investor].[tblInvestor] ti ON ti.client_id = tfw.client_id
		 INNER JOIN [dbo].tblConstantObjectValue tcovtm ON tcovtm.object_value_id = tfw.transaction_mode_id
		 LEFT JOIN [Accounting].[tblBankBranch] tbb ON tbb.id = tfw.bank_branch_id
		 LEFT JOIN [Accounting].[tblBank] tb ON tb.id = tbb.bank_id
		 LEFT JOIN [dbo].[DimDate] ddcd ON tfw.withdraw_date=ddcd.DateKey 
		 WHERE tfw.membership_id = @membership_id
		 AND ddcd.Date BETWEEN @from_dt AND @to_dt
		 AND (tfw.voucher_no = @voucher_no OR @voucher_no IS NULL OR @voucher_no = '')
		 AND (tfw.client_id = @client_id OR @client_id IS NULL OR @client_id = '')
		 AND (tfw.broker_branch_id = @branch_id OR @branch_id IS NULL OR @branch_id = 0)
		 AND (tfw.transaction_mode_id = @transaction_mode_id OR @transaction_mode_id IS NULL OR @transaction_mode_id = 0)
		 and (@is_approved is null or (@is_approved=1 and tfw.approve_by is not null) or (@is_approved=0 and tfw.approve_by is null))
		 ORDER BY tfw.withdraw_date, tfw.client_id

	 
END

GO
/****** Object:  StoredProcedure [Transaction].[rsp_receive]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--- exec [Transaction].rsp_receive 62, '2014-01-13', '2015-12-31', null, null, null, null, 1
-- =============================================
-- Author:		Asif
-- Create date: 18/11/15
-- Description:	Receive report
-- =============================================

CREATE PROCEDURE [Transaction].[rsp_receive]
(
@membership_id numeric(9,0),
@user_id nvarchar(128),
@from_dt datetime,
@to_dt datetime,
@voucher_no varchar(15),
@client_id varchar(10),
@branch_id numeric(2,0),
@transaction_mode_id numeric(4,0),
@is_approved numeric(1,0)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF
	 
		 SELECT tbrokbran.name AS branch
		 ,tfr.voucher_no
		 ,tfr.client_id
		 ,ti.first_holder_name
		 ,tcovtm.display_value AS transaction_mode
		 ,tb.short_name AS bank_name
		 ,tfr.bank_branch_name
		 ,tfr.cheque_no
		 ,ddcd.FullDateUK AS cheque_date
		 ,tfr.amount
		 ,tfr.approve_by
		 FROM [Transaction].[tblFundReceive] tfr
		 INNER JOIN [broker].[tblBrokerBranch] tbrokbran ON tbrokbran.id = tfr.broker_branch_id
		 INNER JOIN [Investor].[tblInvestor] ti ON ti.client_id = tfr.client_id
		 INNER JOIN [dbo].tblConstantObjectValue tcovtm ON tcovtm.object_value_id = tfr.transaction_mode_id
		 LEFT JOIN [Accounting].[tblBank] tb ON tb.id = tfr.bank_id
		 LEFT JOIN [dbo].[DimDate] ddcd ON tfr.receive_date=ddcd.DateKey
		 WHERE tfr.membership_id = @membership_id
		 AND ddcd.Date BETWEEN @from_dt AND @to_dt
		 AND (tfr.voucher_no = @voucher_no OR @voucher_no IS NULL OR @voucher_no = '')
		 AND (tfr.client_id = @client_id OR @client_id IS NULL OR @client_id = '')
		 AND (tfr.broker_branch_id = @branch_id OR @branch_id IS NULL OR @branch_id = 0)
		 AND (tfr.transaction_mode_id = @transaction_mode_id OR @transaction_mode_id IS NULL OR @transaction_mode_id = 0)
		 and (@is_approved is null or (@is_approved=1 and tfr.approve_by is not null) or (@is_approved=0 and tfr.approve_by is null))
		 ORDER BY tfr.receive_date, tfr.client_id
	 
END

GO
/****** Object:  StoredProcedure [Transaction].[rsp_unclear_cheque_list]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Newaz Sharif
-- Create date: 12/12/2015
-- Description:	Get unclear cheque list
-- =============================================
CREATE PROCEDURE [Transaction].[rsp_unclear_cheque_list]
	@membership_id numeric(9,0),
	@user_id nvarchar(128),
	@from_dt datetime,
	@to_dt datetime
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT tfr.voucher_no,tfr.client_id,ti.first_holder_name,tcov.display_value as transactionMode,tb.bank_name,tfr.bank_branch_name,tfr.cheque_no,tbb.name as brokerBranchName
		 FROM [Escrow.BOAS].[Transaction].[tblFundReceive] tfr
		inner join Investor.tblInvestor ti on tfr.client_id = ti.client_id
		inner join Accounting.tblBank tb on tfr.bank_id = tb.id
		inner join broker.tblBrokerBranch tbb on tfr.broker_branch_id = tbb.id
		inner join tblConstantObjectValue tcov on tfr.transaction_mode_id = tcov.object_value_id
		inner join tblConstantObject tco on tcov.object_id = tco.object_id
		inner join DimDate dd on tfr.cheque_date = dd.DateKey

		where tfr.clear_by is null and tfr.clear_date is null
		and tco.object_name = 'TRANSACTION_MODE'
		and tfr.deposit_by is not null and tfr.deposit_date  is not null
		and tfr.membership_id = @membership_id
		and dd.Date between @from_dt and @to_dt
		
END


GO
/****** Object:  StoredProcedure [Transaction].[ssp_already_processed_on_dem_char]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Transaction].[ssp_already_processed_on_dem_char]
(
@charge_id numeric(3,0),
@transaction_type_id numeric(4,0),
@transaction_date numeric (9,0)
)

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF

	SELECT tfcat.client_id,
	tfca.transaction_date
	FROM [Transaction].[tblForceChargeApplyTemp] tfcat
	INNER JOIN [Transaction].[tblForceChargeApply] tfca ON tfca.client_id = tfcat.client_id 
	WHERE tfca.transaction_date = @transaction_date 
	AND tfca.transaction_type_id = @transaction_type_id 
	AND tfca.charge_id = @charge_id
	ORDER BY tfcat.client_id
	
END

GO
/****** Object:  StoredProcedure [Transaction].[ssp_on_dem_char_upl]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Transaction].[ssp_on_dem_char_upl]

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF

	SELECT client_id
	,bo_code
	,amount
	,remarks
	,CASE WHEN is_processed = 1 THEN 'Yes' ELSE 'No' END processed
	FROM [Transaction].[tblForceChargeApplyTemp]
	ORDER BY client_id
	
END



GO
/****** Object:  StoredProcedure [Transaction].[ssp_on_dem_char_xl_upl_err]    Script Date: 12/27/2015 7:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Transaction].[ssp_on_dem_char_xl_upl_err]

AS

BEGIN
	 SET NOCOUNT OFF
	 SET FMTONLY OFF

	IF OBJECT_ID('tempdb..#error_table') IS NOT NULL DROP TABLE #error_table

	SELECT *
	into #error_table
	FROM
	(
		(
			SELECT client_id AS Investor_Code, 'Duplicate Investor' AS Error
			FROM [Transaction].[tblForceChargeApplyTemp]
			GROUP BY client_id
			HAVING COUNT(client_id) > 1
		)
		UNION ALL
		(
			SELECT bo_code AS Investor_Code, 'Duplicate BO Code' AS Error
			FROM [Transaction].[tblForceChargeApplyTemp]
			GROUP BY bo_code
			HAVING COUNT(bo_code) > 1
		)
		UNION ALL
		(
			SELECT DISTINCT a.bo_code AS Investor_Code, 'BO Code Not Found for Investor Code ' + a.client_id AS Error
			FROM [Transaction].[tblForceChargeApplyTemp] a
			LEFT JOIN [Investor].[tblInvestor] b ON b.bo_code = a.bo_code AND a.client_id = b.client_id
			WHERE b.bo_code IS NULL
		)
		UNION ALL
		(
			SELECT bo_code AS Investor_Code, 'BO Code must be 16 digit' AS Error
			FROM [Transaction].[tblForceChargeApplyTemp]
			WHERE LEN(ISNULL(bo_code,'')) != 16
		)
		UNION ALL
		(
			SELECT DISTINCT client_id AS Investor_Code, 'Invalid Amount' AS Error
			FROM [Transaction].[tblForceChargeApplyTemp]
			WHERE amount IS NULL
		)
		UNION ALL
		(
			SELECT DISTINCT a.client_id AS Investor_Code, 'Investor Not Found' AS Error
			FROM [Transaction].[tblForceChargeApplyTemp] a
			LEFT JOIN [Investor].[tblInvestor] b ON b.client_id = a.client_id
			WHERE b.client_id IS NULL
		)
		UNION ALL
		(
			SELECT DISTINCT a.client_id AS Investor_Code, c.display_value + ' Investor' AS Error
			FROM [Escrow.BOAS].[Transaction].[tblForceChargeApplyTemp] a
			INNER JOIN [Investor].[tblInvestor] b ON b.client_id = a.client_id
			INNER JOIN dbo.tblConstantObjectValue c ON c.object_value_id = b.active_status_id
			WHERE c.display_value != 'Active'
		)
	) a


	SELECT Investor_Code,
	STUFF
	(
		(
			SELECT ', ' + Error 
			FROM #error_table
			WHERE Investor_Code = t.Investor_Code FOR XML path('')
		),1,1,''
	) AS Error
	FROM 
	(
		SELECT DISTINCT Investor_Code
		FROM #error_table
	) t
	
END



GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Charge', @level1type=N'VIEW',@level1name=N'vw_all_investors_charges'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Charge', @level1type=N'VIEW',@level1name=N'vw_all_investors_charges'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[36] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TTD"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 282
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TSS"
            Begin Extent = 
               Top = 6
               Left = 277
               Bottom = 224
               Right = 476
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 17
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Investor', @level1type=N'VIEW',@level1name=N'vw_InvestorFundBalance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Investor', @level1type=N'VIEW',@level1name=N'vw_InvestorFundBalance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[36] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TTD"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 282
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TSS"
            Begin Extent = 
               Top = 6
               Left = 277
               Bottom = 224
               Right = 476
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 17
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Investor', @level1type=N'VIEW',@level1name=N'vw_InvestorShareBalance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Investor', @level1type=N'VIEW',@level1name=N'vw_InvestorShareBalance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[36] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TTD"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 282
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TSS"
            Begin Extent = 
               Top = 6
               Left = 277
               Bottom = 224
               Right = 476
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 17
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Trade', @level1type=N'VIEW',@level1name=N'vw_today_maturity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Trade', @level1type=N'VIEW',@level1name=N'vw_today_maturity'
GO
USE [master]
GO
ALTER DATABASE [Escrow.BOAS] SET  READ_WRITE 
GO
