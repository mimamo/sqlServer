USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSsp_UpdateAssetAmts]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSsp_UpdateAssetAmts] @AssetId VARCHAR(10), @AssetSubID VARCHAR(10) AS

DECLARE @TotPurchase             AS FLOAT
DECLARE @TotPurchaseCURY             AS FLOAT

DECLARE @AllPurchases             AS FLOAT
DECLARE @AllPurchasesCURY             AS FLOAT

DECLARE @TotImpairmentLoss       AS FLOAT
DECLARE @TotImpairmentLossCURY       AS FLOAT

DECLARE @AllImpairmentLoss       AS FLOAT
DECLARE @AllImpairmentLossCURY       AS FLOAT

DECLARE @TotImpairmentCostRemoval       AS FLOAT
DECLARE @TotImpairmentCostRemovalCURY       AS FLOAT

DECLARE @TotImpairmentCostAdd	 AS FLOAT
DECLARE @TotImpairmentCostAddCURY	 AS FLOAT

DECLARE @TotSale                 AS FLOAT
DECLARE @TotSaleCURY                 AS FLOAT

DECLARE @Basis                   AS FLOAT
DECLARE @SalvageValue            AS FLOAT

DECLARE @AccumDep                AS FLOAT
DECLARE @AccumDepCURY                AS FLOAT

DECLARE @AccumDepB4Impairment    AS FLOAT
DECLARE @AccumDepB4ImpairmentCURY    AS FLOAT

DECLARE @LineNbr                 AS INTEGER
DECLARE @BookSeq                 AS VARCHAR(10)
DECLARE @BookCode                AS VARCHAR(10)
DECLARE @DeprMethod              AS VARCHAR(20)
DECLARE @TotCostDisp             AS FLOAT -- amount of asset disposed/retired

DECLARE @TotDeprDisp             AS FLOAT -- amount of asset disposed/retired
DECLARE @TotDeprDispCURY             AS FLOAT -- amount of asset disposed/retired

DECLARE @Tax179DeprTaken         AS FLOAT -- total Tax 179 taken
DECLARE @Tax179DeprTakenCURY         AS FLOAT -- total Tax 179 taken

DECLARE @BonusDeprTaken          AS FLOAT -- total bonus depr taken
DECLARE @BonusDeprTakenCURY          AS FLOAT -- total bonus depr taken

DECLARE @TotPurchOver            AS FLOAT -- Purchase Override
DECLARE @TotPurchOverCURY            AS FLOAT -- Purchase Override

DECLARE @TotCostDispOver         AS FLOAT -- Total of Sales Cost for specific asset
DECLARE @TotCostDispOverCURY         AS FLOAT -- Total of Sales Cost for specific asset

DECLARE @OverrideAccumDep        AS FLOAT -- For Secorp Depreciation
DECLARE @OverrideBasis           AS FLOAT -- For Secorp Depreciation
DECLARE @OverrideCost            AS FLOAT -- For Secorp Depreciation
DECLARE @OverrideTax179DeprTaken AS FLOAT -- For Secorp Depreciation
DECLARE @OverrideBonusDeprTaken  AS FLOAT -- For Secorp Depreciation
DECLARE @BonusDeprCd			 AS VARCHAR(10)

DECLARE @GainLoss				 AS FLOAT
DECLARE @GainLossCURY			 AS FLOAT


-- Update Total Cost Disposed with Disposals that have been sent to GL
SET @TotCostDisp = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'A' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '')
SET @AllImpairmentLoss = 0
SET @AllPurchases  = 0
SET @AllPurchasesCURY  = 0

--FMPA wants the cost to be shown AS zero
--UPDATE PSSFAAssets SET Cost = @TotPurchase - @TotCostDisp, SaleAmt = @TotSale WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID

--Update Basis in Deprecication Books
DECLARE csr_AssetDeprBook CURSOR STATIC FOR

  SELECT Basis, AccumDep, SalvageValue, OverrideCost, BookCode, DeprMethod, LineNbr, BonusDeprCd, BookSeq FROM PSSAssetDeprBook WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID

OPEN csr_AssetDeprBook

FETCH NEXT FROM csr_AssetDeprBook INTO @Basis, @AccumDep, @SalvageValue, @OverrideCost, @BookCode, @DeprMethod, @LineNbr, @BonusDeprCd, @BookSeq

WHILE @@FETCH_STATUS = 0 BEGIN

  -- Get all costs for book
  SET @TotPurchase = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND BookSeq = @BookSeq AND PSSFATran.TranType = 'P' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '')
  SET @TotPurchaseCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND BookSeq = @BookSeq AND PSSFATran.TranType = 'P' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '')

  SET @AllPurchases = @AllPurchases + @TotPurchase
  SET @AllPurchasesCURY = @AllPurchasesCURY + @TotPurchaseCURY

  SET @TotImpairmentLoss = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND PSSFATran.TranType = 'I' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookSeq = @BookSeq)
  SET @TotImpairmentLossCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND PSSFATran.TranType = 'I' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookSeq = @BookSeq)

  SET @AllImpairmentLoss = @AllImpairmentLoss + @TotImpairmentLoss
  SET @AllImpairmentLossCURY = @AllImpairmentLossCURY + @TotImpairmentLossCURY

  SET @TotImpairmentCostAdd = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND PSSFATran.TranType = 'M' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookSeq = @BookSeq)
  SET @TotImpairmentCostAddCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND PSSFATran.TranType = 'M' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookSeq = @BookSeq)

  SET @TotImpairmentCostRemoval = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND PSSFATran.TranType = 'N' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookSeq = @BookSeq)
  SET @TotImpairmentCostRemovalCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND PSSFATran.TranType = 'N' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookSeq = @BookSeq)

  -- Get cost override adjustments
  SET @TotPurchOver = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND BookSeq = @BookSeq AND PSSFATran.TranType = 'P' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr = 'OVERRIDE')
  SET @TotPurchOverCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND BookSeq = @BookSeq AND PSSFATran.TranType = 'P' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr = 'OVERRIDE')

  SET @TotCostDispOver = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND BookSeq = @BookSeq AND PSSFATran.TranType = 'A' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '')
  SET @TotCostDispOverCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND BookSeq = @BookSeq AND PSSFATran.TranType = 'A' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '')
  
  -- Update Total Sale with Sales that have been sent to GL
  -- due to book sequences and the new functionality in the transaction screen to create gain/loss transactions based on sales transactions, let's only look at the first book
  -- sequence because the disposal screen is using the first book sequence to record the gain loss although each sequence will be given a sales record  SOS 6/25/12
  SET @TotSale = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND BookSeq = '1' AND PSSFATran.TranType = 'S' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '')
  SET @TotSaleCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE Bookcode = @BookCode AND BookSeq = '1' AND PSSFATran.TranType = 'S' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '')

  -- Update Total Depreciation with Depreciation that have been sent to GL
  SET @AccumDep = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'D' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq = @BookSeq AND DeprMethod = @DeprMethod AND BatNbr <> 'FORECAST')
  SET @AccumDepCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'D' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq = @BookSeq AND DeprMethod = @DeprMethod AND BatNbr <> 'FORECAST')

  --   SET @OverrideAccumDep = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'C' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND DeprMethod = @DeprMethod)

  SET @AccumDepB4Impairment = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'D' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq < @BookSeq AND DeprMethod = @DeprMethod AND BatNbr <> 'FORECAST')
  SET @AccumDepB4ImpairmentCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'D' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq < @BookSeq AND DeprMethod = @DeprMethod AND BatNbr <> 'FORECAST')

  -- Update Total Accum Depr Disposed with Disposals that have been sent to GL
  SET @TotDeprDisp = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'B' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq = @BookSeq AND DeprMethod = @DeprMethod AND BatNbr <> 'FORECAST')
  SET @TotDeprDispCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'B' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq = @BookSeq AND DeprMethod = @DeprMethod AND BatNbr <> 'FORECAST')

  -- Get Total Tax 179 Depr Taken
  SET @Tax179DeprTaken = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'D' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq = @BookSeq AND DeprMethod = 'SECT179' AND BatNbr <> 'FORECAST')
  SET @Tax179DeprTakenCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'D' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq = @BookSeq AND DeprMethod = 'SECT179' AND BatNbr <> 'FORECAST')

  -- Get Bonus Depr Taken
  SET @BonusDeprTaken = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'D' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq = @BookSeq AND DeprMethod = @BonusDeprCd AND BatNbr <> 'FORECAST')
  SET @BonusDeprTakenCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE PSSFATran.TranType = 'D' AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq = @BookSeq AND DeprMethod = @BonusDeprCd AND BatNbr <> 'FORECAST')

 -- get gain loss
 SET @GainLoss = (Select IsNull(Sum(Amt), 0.0) From PSSFATran WHERE PSSFATran.TranType in ('L','G' ) AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq = @BookSeq AND BatNbr <> 'FORECAST')
 SET @GainLossCURY = (Select IsNull(Sum(CuryAmt), 0.0) From PSSFATran WHERE PSSFATran.TranType in ('L','G' ) AND AssetID = @AssetId AND AssetSubId = @AssetSubID AND GLBatNbr <> '' AND BookCode  = @BookCode AND BookSeq = @BookSeq AND BatNbr <> 'FORECAST')

  -- Update Accum Depr with Transfer Depr increase/decrease that have been sent to GL

  -- actual cost will be all purchase (including overrides) minus the override purchases. In theory, theis will produce the same "real" cost no matteer with  book is processed.
  -- but obviously only the amounts of teh last book to be calculated will matter.
	 
	IF @BookSeq <> '1' 
		BEGIN
		UPDATE PSSFAAssets SET Cost = (@AllPurchases-@TotPurchOver) WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID
        UPDATE PSSFAAssets SET CuryCost = (@AllPurchasesCURY-@TotPurchOverCURY) WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID  
		END

		

	IF @BookSeq = '1' 
		BEGIN
		UPDATE PSSFAAssets SET Cost = (@TotPurchase+@TotImpairmentCostAdd-@TotPurchOver) WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID 
        UPDATE PSSFAAssets SET CuryCost = (@TotPurchaseCURY+@TotImpairmentCostAddCURY-@TotPurchOverCURY) WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID 
		END

-- Update Cost/Sale Amounts in Asset Screen
  UPDATE PSSFAAssets SET SaleAmt = @TotSale WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID
  UPDATE PSSFAAssets SET CurySaleAmt = @TotSaleCURY WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID

  UPDATE PSSAssetDeprBook SET Cost = (@TotPurchase+@TotImpairmentCostAdd) WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID AND LineNbr = @LineNbr
  UPDATE PSSAssetDeprBook SET CuryCost = (@TotPurchaseCURY+@TotImpairmentCostAddCURY) WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID AND LineNbr = @LineNbr

  UPDATE PSSAssetDeprBook SET Basis = (((@TotPurchase+@TotImpairmentCostAdd+@TotImpairmentLoss+@TotImpairmentCostRemoval) - (@AccumDep)) - (@TotCostDispOver-@TotDeprDisp+@TotImpairmentLoss+@TotImpairmentCostRemoval)-@Tax179DeprTaken-@BonusDeprTaken) WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID AND LineNbr = @LineNbr
  UPDATE PSSAssetDeprBook SET CuryBasis = (((@TotPurchaseCURY+@TotImpairmentCostAddCURY+@TotImpairmentLossCURY+@TotImpairmentCostRemovalCURY) - (@AccumDepCURY)) - (@TotCostDispOverCURY-@TotDeprDispCURY+@TotImpairmentLossCURY+@TotImpairmentCostRemovalCURY)-@Tax179DeprTakenCURY-@BonusDeprTakenCURY) WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID AND LineNbr = @LineNbr

  UPDATE PSSAssetDeprBook SET AccumDep = (@AccumDep - @TotDeprDisp)+@Tax179DeprTaken+@BonusDeprTaken  WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID AND LineNbr = @LineNbr AND BookSeq = @BookSeq
  UPDATE PSSAssetDeprBook SET CuryAccumDep = (@AccumDepCURY - @TotDeprDispCURY)+@Tax179DeprTakenCURY+@BonusDeprTakenCURY  WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID AND LineNbr = @LineNbr AND BookSeq = @BookSeq
  
  UPDATE PSSAssetDeprBook SET Tax179Taken = @Tax179DeprTaken, BonusDeprTaken = @BonusDeprTaken, RegDeprTaken = @AccumDep WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID AND LineNbr = @LineNbr AND BookSeq = @BookSeq
  UPDATE PSSAssetDeprBook SET CuryTax179Taken = @Tax179DeprTakenCURY, CuryBonusDeprTaken = @BonusDeprTakenCURY, CuryRegDeprTaken = @AccumDepCURY WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID AND LineNbr = @LineNbr AND BookSeq = @BookSeq

  UPDATE PSSAssetDeprBook SET GainLossAmt = @GainLoss WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID AND LineNbr = @LineNbr
  UPDATE PSSAssetDeprBook SET CuryGainLossAmt = @GainLossCURY WHERE AssetID = @AssetId AND AssetSubId = @AssetSubID AND LineNbr = @LineNbr

-- -@TotImpairmentLoss-@TotImpairmentExp

  -- Fetch the next record from the depr book list.
  FETCH NEXT FROM csr_AssetDeprBook INTO @Basis, @AccumDep, @SalvageValue, @OverrideCost, @BookCode, @DeprMethod, @LineNbr, @BonusDeprCd, @BookSeq
	
  END -- @@FETCH_STATUS = 0

  CLOSE csr_AssetDeprBook
  DEALLOCATE csr_AssetDeprBook
GO
