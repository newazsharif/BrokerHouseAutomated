USE [Escrow.BOAS]
GO
/****** Object:  StoredProcedure [Trade].[ssp_ft_omb_limits_validate]    Script Date: 12/29/2015 12:33:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Asif
-- Create date: 27/12/2015
-- Description:	Import client limits validation
-- =============================================

ALTER PROCEDURE [Trade].[ssp_ft_omb_limits_validate](
	@membership_id numeric(9,0),
	@import_dt numeric(9,0),
	@omnibus_master_id varchar(10)
	)
AS
begin
	DECLARE @DEFAULT_ACTIVE_STATUS_ID AS NUMERIC(4,0)
	SET @DEFAULT_ACTIVE_STATUS_ID=dbo.sfun_get_constant_object_default_value_id('ACTIVE_STATUS')
	-----------------START CHECK TRANSACTION DAY WITH IMPORT DAY-------------------------  
	
	IF (dbo.sfun_get_process_date()!=@import_dt)  
	BEGIN  
		RAISERROR ('Transaction date is mismatch with import file date.', 16, 1)  
		RETURN  
	END  
	-----------------CLOSE CHECK TRANSACTION DAY WITH IMPORT DAY------------------------- 

	---------------------------------START: Duplication checking----------------------------------------
	IF EXISTS(SELECT import_dt FROM Trade.tblFTOmnibusImportLog tfoil WHERE tfoil.omnibus_master_id=@omnibus_master_id AND tfoil.file_type='limits' AND tfoil.import_dt=@import_dt
		AND membership_id=@membership_id)
	BEGIN
		RAISERROR('Client limits file already imported for your selected omnibus account',16,1)
		RETURN
	END
	---------------------------------END: Duplication checking----------------------------------------

	-------------------START INVESTOR CODE NOT FOUND BUT BO CODE FOUND IN Trade.tblFTOmnibusLimitsTemp---------  
    SELECT boid, 'Investor code missing for following BO: ' FROM Trade.tblFTOmnibusLimitsTemp 
    WHERE len(isnull(client_code,'')) = 0 AND membership_id=@membership_id
	-------------------CLOSE INVESTOR CODE NOT FOUND BUT BO CODE FOUND IN Trade.tblFTOmnibusLimitsTemp--------- 
	
	-------------------START BO CODE NOT FOUND BUT INVESTOR CODE FOUND IN Trade.tblFTOmnibusLimitsTemp---------  
    SELECT client_code, 'BO Code mismatch for following investors: ' FROM Trade.tblFTOmnibusLimitsTemp
    WHERE len(isnull(boid,'')) != 16 AND membership_id=@membership_id
	-------------------CLOSE BO CODE NOT FOUND BUT INVESTOR CODE FOUND IN Trade.tblFTOmnibusLimitsTemp--------- 

	-------------------START INVESTOR CODE FOUND IN Trade.tblFTOmnibusLimitsTemp BUT NOT IN INVESTOR---------  
    SELECT tfolt.client_code, 'Found New Investors :' FROM  
      (SELECT DISTINCT client_code, membership_id FROM Trade.tblFTOmnibusLimitsTemp WHERE membership_id=@membership_id) AS tfolt left join  
    Investor.tblInvestor tinv ON tfolt.client_code =tinv.client_id AND tfolt.membership_id=tinv.membership_id
    WHERE tinv.client_id is null  
	-------------------CLOSE INVESTOR CODE FOUND IN Trade.tblFTOmnibusLimitsTemp BUT NOT IN TRD_INVESTOR_ACCOUNT---------

	-------------------START BO CODE FOUND IN Trade.tblFTOmnibusLimitsTemp BUT NOT IN TRD_INVESTOR_ACCOUNT---------  
    SELECT tfolt.boid, 'Found New BO Codes :' FROM  
      (SELECT DISTINCT boid, membership_id FROM Trade.tblFTOmnibusLimitsTemp WHERE membership_id=@membership_id) AS tfolt left join  
    Investor.tblInvestor tinv ON tfolt.boid =tinv.bo_Code AND tfolt.membership_id=tinv.membership_id
    WHERE tinv.bo_Code is null  
	-------------------CLOSE BO CODE FOUND IN Trade.tblFTOmnibusLimitsTemp BUT NOT IN TRD_INVESTOR_ACCOUNT---------

	-------------------START Mismatch in Investor Code---------  
    SELECT tfolt.client_code, 'Found Mismatch in BO Code of following investors: ' FROM  
      (SELECT DISTINCT client_code, boid, membership_id FROM Trade.tblFTOmnibusLimitsTemp WHERE membership_id=@membership_id) AS tfolt 
	  inner join Investor.tblInvestor tinv ON tfolt.client_code =tinv.client_id AND tfolt.membership_id=tinv.membership_id
    WHERE tinv.bo_Code!=tfolt.boid  
	-------------------CLOSE Mismatch in Investor Code---------

	-------------------START Mismatch in Code Code---------  
    SELECT tfolt.boid, 'Found Mismatch in Investor Code of following BO: ' FROM  
      (SELECT DISTINCT client_code, boid, membership_id FROM Trade.tblFTOmnibusLimitsTemp WHERE membership_id=@membership_id) AS tfolt 
	  inner join Investor.tblInvestor tinv ON tfolt.boid =tinv.bo_Code AND tfolt.membership_id=tinv.membership_id
    WHERE tinv.client_id!=tfolt.client_code
	-------------------CLOSE Mismatch in Code Code---------

	-------------------START INACTIVE INVESTOR CODE FOUND---------  
    SELECT tfolt.client_code, 'Found Inactive/Closed Investors: ' FROM  
      (SELECT DISTINCT client_code, membership_id FROM Trade.tblFTOmnibusLimitsTemp WHERE membership_id=@membership_id) AS tfolt inner join  
    Investor.tblInvestor tinv ON tfolt.client_code =tinv.client_id AND tfolt.membership_id=tinv.membership_id
    WHERE tinv.active_status_id!=@DEFAULT_ACTIVE_STATUS_ID
	-------------------CLOSE INACTIVE INVESTOR CODE FOUND---------

	-------------------START INVESTOR CODE NOT MAPPED WITH OMNIBUS MASTER CODE PROPERLY---------  
    SELECT tfolt.client_code, 'Found Investors which not mapped with master code: ' FROM  
      (SELECT DISTINCT client_code, membership_id FROM Trade.tblFTOmnibusLimitsTemp WHERE membership_id=@membership_id) AS tfolt inner join  
    Investor.tblInvestor tinv ON tfolt.client_code =tinv.client_id AND tfolt.membership_id=tinv.membership_id
    WHERE isnull(tinv.omnibus_master_id,'')!=@omnibus_master_id
	-------------------CLOSE INVESTOR CODE NOT MAPPED WITH OMNIBUS MASTER CODE PROPERLY---------

	-------------------START TRADER MAPPING WITH INVESTOR CODE PROPERLY---------  
    SELECT tfolt.client_code, 'Found Investors which not mapped with trader: ' FROM  
      (SELECT DISTINCT client_code, membership_id FROM Trade.tblFTOmnibusLimitsTemp WHERE membership_id=@membership_id) AS tfolt inner join  
    Investor.tblInvestor tinv ON tfolt.client_code =tinv.client_id AND tfolt.membership_id=tinv.membership_id
    WHERE tinv.trader_id IS NULL
	-------------------CLOSE TRADER MAPPING WITH INVESTOR CODE PROPERLY--------- 

	-------------------START BUY LIMIT CAN NOT BE NEGETIVE---------  
    SELECT client_code, 'Found Negetive limit: ' FROM Trade.tblFTOmnibusLimitsTemp
    WHERE CONVERT(numeric(15,0), isnull(buy_limit,-1))<0 AND membership_id=@membership_id
	-------------------CLOSE BUY LIMIT CAN NOT BE NEGETIVE--------- 
END




