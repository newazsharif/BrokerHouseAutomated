USE [CBO]
GO
/****** Object:  StoredProcedure [dbo].[udp_ReProcessAverageGainLossFromBegining]    Script Date: 1/3/2016 5:46:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MD. SAIFULLAH AL AZAD
-- Create date: 19-OCT-2015
-- Description:	TO RE-CALCULATE AVERAGE PRICE, GAIN LOSS OF EACH INSTRUMENT TRANSACTION OF CLIENTS FROM THE BEGINING
-- TRUNCATE TABLE tbl_Instrument_Transaction_History
-- udp_ReProcessAverageGainLossFromBegining NULL, NULL
-- =============================================
ALTER PROCEDURE [dbo].[udp_ReProcessAverageGainLossFromBegining] 
	-- Add the parameters for the stored procedure here
	  @pClientId AS VARCHAR(10)
	, @pTradingCode AS VARCHAR(20)
AS
BEGIN
	DECLARE @date AS DATETIME
	
	UPDATE CBO.dbo.tbl_Client_Ledger SET CashCheque=LTRIM(RTRIM(CashCheque)) WHERE CashCheque IS NOT NULL
	UPDATE CBO.dbo.tbl_Client_Ledger SET BS=LTRIM(RTRIM(BS)) WHERE BS IS NOT NULL

	UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'BEDL', 'BARKAPOWER')) WHERE Particulars LIKE '%BEDL%'
	UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'BDBUILDING', 'BBS')) WHERE Particulars LIKE '%BDBUILDING%'
	UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'FLEASEINT', 'FIRSTFIN')) WHERE Particulars LIKE '%FLEASEINT%'
	UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'APEXADELFT', 'APEXFOOT')) WHERE Particulars LIKE '%APEXADELFT%'
	UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'MTBL', 'MTB')) WHERE Particulars LIKE '%MTBL%'
	UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'ULC', 'UNITEDFIN')) WHERE Particulars LIKE '%ULC%'
	UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'BXTEX', 'BEXIMCO')) WHERE Particulars LIKE '%BXTEX%'
	UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'CTGVEG', 'CVOPRL')) WHERE Particulars LIKE '%CTGVEG%'
	UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=LTRIM(REPLACE(Particulars, 'UCBL', 'UCB')) WHERE Particulars LIKE '%UCBL%'
	UPDATE CBO.dbo.tbl_Client_Ledger SET Particulars=RTRIM(LEFT(Particulars,CHARINDEX(' ',LTRIM(Particulars),1))) 
		WHERE (ISNULL(BS,'')='BUY' OR ISNULL(BS,'')='SELL') AND CashCheque IS NULL AND CHARINDEX(' ',LTRIM(Particulars),1)>0
	UPDATE CBO.dbo.L_tbl_Tesa_Trades SET [O/P/S]='P' WHERE [O/P/S]='O'
	UPDATE CBO.dbo.L_tbl_Tesa_Trades SET TradeCounter=LEFT(TradeCounter, LEN(TradeCounter)-2) + '0' + RIGHT(TradeCounter,2) WHERE LEN(TradeCounter)!=10 AND TradeCounter NOT LIKE '%DLR%'


	SELECT @date = CAST(CONVERT(VARCHAR,MIN(Date),101) AS DATE) FROM tbl_Client_Ledger WHERE (BS='BUY' OR BS='SELL') AND CashCheque IS NULL AND Particulars != '--x--For'

	SELECT TCH.BONumber, ISIN, HoldingDate, 0 CurrentBalance, 0 ClosingPrice INTO #TCH
	FROM L_tbl_CDBL_Holding TCH
		INNER JOIN LU_tbl_CompanyISIN TCI ON TCH.ISIN=TCI.ISINCode
		INNER JOIN tbl_Client_Details TCd ON TCH.BONumber=TCD.BONumber
	WHERE (@pTradingCode IS NULL OR TCI.TESACode=@pTradingCode) AND (@pClientId IS NULL OR TCD.ClientID=@pClientId) AND HoldingDate=(SELECT MAX(HoldingDate) FROM L_tbl_CDBL_Holding WHERE HoldingDate<@DATE)
	GROUP BY TCH.BONumber, ISIN, HoldingDate


	UPDATE TCHT
	SET CurrentBalance=TCH.CurrentBalance
	--SELECT TCH.BONumber, TCH.ISIN, TCH.HoldingDate, TCH.CurrentBalance
	FROM L_tbl_CDBL_Holding TCH
		INNER JOIN #TCH TCHT
		ON TCH.BONumber=TCHT.BONumber AND TCH.ISIN=TCHT.ISIN AND TCH.HoldingDate=TCHT.HoldingDate

	UPDATE TCH
	SET ClosingPrice=ISNULL(TPI.LastTradePrice,0)
	--SELECT TCH.BONumber, TCH.ISIN, TCH.HoldingDate, TCH.CurrentBalance, TPI.LastTradePrice, TCI.TESACode
	FROM #TCH TCH
		INNER JOIN LU_tbl_CompanyISIN TCI ON TCH.ISIN=TCI.ISINCode
		LEFT JOIN L_tbl_PriceIndex TPI ON TCI.TESACode =TPI.Instrument AND TCH.HoldingDate=TPI.FileDatetime


	SELECT ClientID, TradingCode, TR_DATE, SUM(OPENING_QTY) OPENING_QTY, AVG(OPENTING_RATE) OPENTING_RATE, SUM(BUY_QTY) BUY_QTY, SUM(BUY_COST) BUY_COST, SUM(BUY_COMM) BUY_COMM, SUM(SALE_QTY) SALE_QTY, SUM(SALE_VALUE) SALE_VALUE, SUM(SALE_COMM) SALE_COMM
		, SUM(BONUS_QTY) BONUS_QTY, SUM(RIGHTS_QTY) RIGHTS_QTY, SUM(SPLIT_QTY) SPLIT_QTY, SUM(IPO_QTY) IPO_QTY, AVG(IPO_PRICE) IPO_PRICE
	INTO #TRANS
	FROM
	(
		SELECT TCD.ClientID, TCI.TESACode TradingCode, #TCH.HoldingDate TR_DATE, #TCH.CurrentBalance OPENING_QTY, #TCH.ClosingPrice OPENTING_RATE
			, 0 BUY_QTY, 0 BUY_COST, 0 BUY_COMM, 0 SALE_QTY, 0 SALE_VALUE, 0 SALE_COMM, 0 BONUS_QTY, 0 RIGHTS_QTY, 0 SPLIT_QTY, 0 IPO_QTY, 0 IPO_PRICE
		FROM #TCH 
			INNER JOIN LU_tbl_CompanyISIN TCI ON #TCH.ISIN=TCI.ISINCode
			INNER JOIN tbl_Client_Details TCd ON #TCH.BONumber=TCD.BONumber
		WHERE (@pTradingCode IS NULL OR TCI.TESACode=@pTradingCode) AND (@pClientId IS NULL OR TCD.ClientID=@pClientId)

		UNION ALL

		SELECT TTT.ClientID, TTT.Particulars
			, CAST(CONVERT(VARCHAR,Date,101) AS DATE) TR_DATE
			, 0 OPENING_QTY, 0 OPENTING_RATE
			, SUM(CASE WHEN BS = 'BUY' THEN Quantity ELSE 0 END) BUY_QTY
			, SUM(CASE WHEN BS = 'BUY' THEN Amount ELSE 0 END) BUY_COST
			, SUM(ISNULL(CASE WHEN BS = 'BUY' THEN Comm ELSE 0 END,0)) BUY_COMM
			, SUM(CASE WHEN BS = 'SELL' THEN Quantity ELSE 0 END) SALE_QTY
			, SUM(CASE WHEN BS = 'SELL' THEN Amount ELSE 0 END) SALE_VALUE
			, SUM(ISNULL(CASE WHEN BS = 'SELL' THEN Comm ELSE 0 END,0)) SALE_COMM
			, 0 BONUS_QTY, 0 RIGHTS_QTY, 0 SPLIT_QTY, 0 IPO_QTY, 0 IPO_PRICE
		FROM tbl_Client_Ledger TTT
		WHERE (BS='BUY' OR BS='SELL') AND CashCheque IS NULL AND Particulars != '--x--For' AND TTT.ClientID IS NOT NULL
			AND (@pTradingCode IS NULL OR TTT.Particulars=@pTradingCode) 
			AND (@pClientId IS NULL OR TTT.ClientID=@pClientId) 
			AND CAST(CONVERT(VARCHAR,Date,101) AS DATE)>=@date
		GROUP BY TTT.ClientID, Particulars, TTT.Date, BS

		UNION ALL

		SELECT TCD.ClientID, TCI.TESACode, TCB.EffectiveDate TR_DATE
			, 0 OPENING_QTY, 0 OPENTING_RATE
			, 0 BUY_QTY, 0 BUY_COST, 0 BUY_COMM, 0 SALE_QTY, 0 SALE_VALUE, 0 SALE_COMM
			, SUM(CASE WHEN TCB.ShareType = 'BONUS' THEN Amount1 ELSE 0 END) BONUS_QTY
			, SUM(CASE WHEN TCB.ShareType = 'RIGHTS' THEN Amount1 ELSE 0 END) RIGHTS_QTY
			, SUM(CASE WHEN TCB.ShareType = 'STOCK SPLIT' THEN 
					CASE WHEN DrCr='CREDIT' THEN Amount1 ELSE Amount1*-1 END
				ELSE 0 END) SPLIT_QTY
			, 0 IPO_QTY, 0 IPO_PRICE
		FROM L_tbl_CDBL_Bonus TCB
			INNER JOIN LU_tbl_CompanyISIN TCI ON TCB.ISIN=TCI.ISINCode
			INNER JOIN tbl_Client_Details TCD ON TCB.BONumber=TCD.BONumber
		WHERE (@pTradingCode IS NULL OR TCI.TESACode=@pTradingCode) AND (@pClientId IS NULL OR TCD.ClientID=@pClientId) AND CAST(TCB.EffectiveDate AS DATE)>=@date
		GROUP BY TCD.ClientID, TCI.TESACode, TCB.EffectiveDate,TCB.ShareType

		UNION ALL

		SELECT TCD.ClientID, TCI.TESACode, TCB.EffectiveDate TR_DATE
			, 0 OPENING_QTY, 0 OPENTING_RATE
			, 0 BUY_QTY, 0 BUY_COST, 0 BUY_COMM, 0 SALE_QTY, 0 SALE_VALUE, 0 SALE_COMM
			, 0 BONUS_QTY
			, 0 RIGHTS_QTY
			, 0 SPLIT_QTY
			, SUM(ISNULL(CurrentBalance,0)-ISNULL(FreeBalance,0)) IPO_QTY
			, ISNULL(TIP.IPOPrice,0) IPO_PRICE
		FROM L_tbl_CDBL_IPO TCB
			INNER JOIN LU_tbl_CompanyISIN TCI ON TCB.ISIN=TCI.ISINCode
			INNER JOIN tbl_Client_Details TCD ON TCB.BONumber=TCD.BONumber
			LEFT JOIN tbl_IPO_Prices TIP ON TCB.ISIN=TIP.ISIN
		WHERE (@pTradingCode IS NULL OR TCI.TESACode=@pTradingCode) AND (@pClientId IS NULL OR TCD.ClientID=@pClientId) AND CAST(TCB.EffectiveDate AS DATE)>=@date
		GROUP BY TCD.ClientID, TCI.TESACode, TCB.EffectiveDate, TIP.IPOPrice
		HAVING SUM(ISNULL(CurrentBalance,0)-ISNULL(FreeBalance,0))>0

		UNION ALL

		SELECT TCD.ClientID, TCI.TESACode, CAST(TCB.S4 AS DATE) TR_DATE
			, 0 OPENING_QTY, 0 OPENTING_RATE
			, 0 BUY_QTY, 0 BUY_COST, 0 BUY_COMM, 0 SALE_QTY, 0 SALE_VALUE, 0 SALE_COMM
			, 0 BONUS_QTY
			, 0 RIGHTS_QTY
			, 0 SPLIT_QTY
			, SUM(ISNULL(FreeBalance,0)) IPO_QTY
			, ISNULL(TIP.IPOPrice,0) IPO_PRICE
		FROM L_tbl_CDBL_IPO TCB
			INNER JOIN LU_tbl_CompanyISIN TCI ON TCB.ISIN=TCI.ISINCode
			INNER JOIN tbl_Client_Details TCD ON TCB.BONumber=TCD.BONumber
			LEFT JOIN tbl_IPO_Prices TIP ON TCB.ISIN=TIP.ISIN
		WHERE (@pTradingCode IS NULL OR TCI.TESACode=@pTradingCode) AND (@pClientId IS NULL OR TCD.ClientID=@pClientId) AND CAST(TCB.S4 AS DATE)>=@date
		GROUP BY TCD.ClientID, TCI.TESACode, TCB.S4, TIP.IPOPrice

	) AS M
	GROUP BY ClientID, TradingCode, TR_DATE
	ORDER BY ClientID, TradingCode, TR_DATE

	DROP TABLE #TCH

	DELETE FROM tbl_Instrument_Transaction_History WHERE (@pTradingCode IS NULL OR TradingCode=@pTradingCode) AND (@pClientId IS NULL OR ClientID=@pClientId)

	DECLARE
		  @ClientID AS VARCHAR(10)
		, @TradingCode AS VARCHAR(20)
		, @TR_DATE AS DATETIME
		, @OPENING_QTY AS NUMERIC(15)
		, @OPENTING_RATE AS NUMERIC(30,10)
		, @BUY_QTY AS NUMERIC(15)
		, @BUY_COST AS NUMERIC(30,10)
		, @BUY_COMM AS NUMERIC(30,10)
		, @SALE_QTY AS NUMERIC(15)
		, @SALE_VALUE AS NUMERIC(30,10)
		, @SALE_COMM AS NUMERIC(30,10)
		, @BONUS_QTY AS NUMERIC(15)
		, @RIGHTS_QTY AS NUMERIC(15)
		, @SPLIT_QTY AS NUMERIC(15)
		, @IPO_QTY AS NUMERIC(15)
		, @IPO_PRICE AS NUMERIC(30,10)

	DECLARE
		  @OQ AS NUMERIC(15) = 0		-- OPENING QUANTITY
		, @OC AS NUMERIC(30,10) = 0		-- OPENING COST
		, @OR AS NUMERIC(30,10) = 0		-- OPENING RATE
		, @RQ AS NUMERIC(15) = 0		-- RECEIVED QUANTITY (BONUS/RIGHTS/SPLIT)
		, @RR AS NUMERIC(30,10) = 0		-- RECEIVED RATE
		, @RC AS NUMERIC(30,10) = 0		-- RECEIVED COST 
		, @SR AS NUMERIC(30,10) = 0		-- SALE RATE
		, @SCR AS NUMERIC(30,10) = 0	-- SALE COST RATE
		, @SC AS NUMERIC(30,10) = 0		-- COST OF SALE QUANTITY
		, @GL AS NUMERIC(30,10) = 0		-- GAIN OR LOSS
		, @RMQ AS NUMERIC(15) = 0		-- REMAINING QUANTITY AFTER SALE
		, @RMC AS NUMERIC(30,10) = 0	-- REMAINING COST
		, @RMR AS NUMERIC(30,10) = 0	-- RATE OF REMAINING QUANTITY
		, @BR AS NUMERIC(30,10) = 0		-- BUY RATE
		, @CQ AS NUMERIC(15) = 0		-- CLOSING QUANTITY
		, @CC AS NUMERIC(30,10) = 0		-- CLOSING COST
		, @CR AS NUMERIC(30,10) = 0		-- CLOSING RATE

	DECLARE 
		  @OldClientID AS VARCHAR(10)
		, @OldTradingCode AS VARCHAR(20)

	DECLARE TRANS CURSOR FOR 
	SELECT ClientID, TradingCode, TR_DATE, ISNULL(OPENING_QTY,0), ISNULL(OPENTING_RATE,0), ISNULL(BUY_QTY,0), ISNULL(BUY_COST,0), ISNULL(BUY_COMM,0), ISNULL(SALE_QTY,0), ISNULL(SALE_VALUE,0), ISNULL(SALE_COMM,0)
		, ISNULL(BONUS_QTY,0), ISNULL(RIGHTS_QTY,0), ISNULL(SPLIT_QTY,0), ISNULL(IPO_QTY,0) IPO_QTY, ISNULL(IPO_PRICE,0) IPO_PRICE
	FROM #TRANS WHERE (@pTradingCode IS NULL OR TradingCode=@pTradingCode) AND (@pClientId IS NULL OR ClientID=@pClientId) ORDER BY ClientID, TradingCode, TR_DATE
	OPEN TRANS

	FETCH NEXT FROM TRANS 
	INTO @ClientID, @TradingCode, @TR_DATE, @OPENING_QTY, @OPENTING_RATE, @BUY_QTY, @BUY_COST, @BUY_COMM, @SALE_QTY, @SALE_VALUE, @SALE_COMM, @BONUS_QTY, @RIGHTS_QTY, @SPLIT_QTY, @IPO_QTY, @IPO_PRICE

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		DECLARE @MARKET_VALUE AS NUMERIC(30,10)=0
		IF(@RIGHTS_QTY>0)
			SET @MARKET_VALUE = (SELECT TOP 1 LastTradePrice FROM L_tbl_PriceIndex TP WHERE TP.Instrument=@TradingCode 
									AND TP.FileDatetime = (SELECT MAX(TPI.FileDatetime) FROM L_tbl_PriceIndex TPI WHERE TPI.Instrument=TP.Instrument AND CAST(TPI.FileDatetime AS DATE)<=@TR_DATE))
		IF(@MARKET_VALUE IS NULL) SET @MARKET_VALUE = 0

		IF NOT (@ClientID=@OldClientID AND @TradingCode=@OldTradingCode)
		BEGIN
			SET @OQ = 0
			SET @OC = 0
			SET @OR = 0
			SET @RQ = 0
			SET @RR = 0
			SET @RC = 0
			SET @SR = 0
			SET @SCR = 0
			SET @SC = 0
			SET @GL = 0
			SET @RMQ = 0
			SET @RMC = 0
			SET @RMR = 0
			SET @BR = 0
			SET @CQ = 0
			SET @CC = 0
			SET @CR = 0
		END

		SET @OldClientID=@ClientID
		SET @OldTradingCode=@TradingCode

		SET @OQ = @CQ
		SET @OC = @CC
		SET @OR = @CR
		SET @RQ = @OPENING_QTY + @IPO_QTY + @BONUS_QTY + @RIGHTS_QTY + @SPLIT_QTY
		IF (@RQ = 0) SET @RC = 0 ELSE SET @RC = (@OPENING_QTY * @OPENTING_RATE) + (@IPO_QTY*@IPO_PRICE) + (@RIGHTS_QTY*@MARKET_VALUE)
		IF (@RQ > 0) SET @RR = @RC/@RQ ELSE SET @RR = 0
		IF (@SALE_QTY > 0) SET @SR = (@SALE_VALUE-@SALE_COMM)/@SALE_QTY ELSE SET @SR = 0
		IF ((@OQ+@RQ) > 0 AND @SALE_QTY > 0) SET @SCR = (@OC+@RC)/(@OQ+@RQ) ELSE SET @SCR = 0
		IF (@SALE_QTY=0) SET @SC = 0 ELSE SET @SC = @SALE_QTY * @SCR
		SET @GL = @SALE_VALUE - @SALE_COMM - @SC
		SET @RMQ = @OQ + @RQ - @SALE_QTY
		IF (@RMQ > 0) SET @RMR = (@OC+@RC)/(@OQ+@RQ) ELSE SET @RMR = 0
		SET @RMC = @RMQ * @RMR
		IF (@BUY_QTY > 0) SET @BR = (@BUY_COST + @BUY_COMM) / @BUY_QTY ELSE SET @BR = 0
		SET @CQ = @RMQ + @BUY_QTY
		IF (@CQ = 0) SET @CC=0 ELSE SET @CC = @RMC + @BUY_COST + @BUY_COMM
		IF (@CQ > 0) SET @CR = @CC / @CQ ELSE SET @CR = 0

		INSERT INTO tbl_Instrument_Transaction_History(ClientID, TradingCode, TradingDate, OpeningQty, OpeningRate, OpeningCost, ReceivedQty, ReceivedRate, ReceivedCost, SaleQty, SaleValue, SaleCommission, SaleRate, SaleAmount, SaleCostRate, SaleCost
			, GainLoss, RemainingQty, RemainingRate, RemainingCost, BuyQty, BuyCost, BuyCommission, BuyRate, BuyAmount, ClosingQty, ClosingRate, ClosingCost)
		VALUES (@ClientID, @TradingCode, @TR_DATE, @OQ, @OR, @OC, @RQ, @RR, @RC, @SALE_QTY, @SALE_VALUE, @SALE_COMM, @SR, @SALE_VALUE + @SALE_COMM, @SCR, @SC, @GL, @RMQ, @RMR, @RMC, @BUY_QTY, @BUY_COST, @BUY_COMM, @BR, @BUY_COST + @BUY_COMM, @CQ, @CR, @CC)

		PRINT 'Client ID: ' + @ClientID + '; Instrument: ' + @TradingCode + '; Date:' + CAST(@TR_DATE AS VARCHAR)

		FETCH NEXT FROM TRANS 
		INTO @ClientID, @TradingCode, @TR_DATE, @OPENING_QTY, @OPENTING_RATE, @BUY_QTY, @BUY_COST, @BUY_COMM, @SALE_QTY, @SALE_VALUE, @SALE_COMM, @BONUS_QTY, @RIGHTS_QTY, @SPLIT_QTY, @IPO_QTY, @IPO_PRICE
	END 
	CLOSE TRANS;
	DEALLOCATE TRANS;



	DROP TABLE #TRANS
END
