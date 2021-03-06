USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSsp_PSSCalcAssetAmts]    Script Date: 12/21/2015 16:01:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSsp_PSSCalcAssetAmts] @AssetId VARCHAR(10), @AssetSubID VARCHAR(10), @BookCode varchar(10), @DeprMethod varchar(20), @BonusDeprCd varchar(10) AS
  
-- Declare Variables

Declare @AccumDepr As Float   
Declare @BonusDeprTaken As Float
Declare @Tax179Taken As Float 
Declare @TotalDepr As Float   
Declare @LastPerDepr as varchar(6)
Declare @Depreciate as varchar(1)

-- Calculate Last Period Depreciated, Accum Deprecation, Bonus AND Sect 179

Set @LastPerDepr = (Select IsNull(max(perpost), '') from PSSFATran WHERE TranType = 'D' AND AssetId = @AssetID AND AssetSubID = @AssetSubID AND BookCode = @BookCOde AND DeprMethod = @DeprMethod AND batnbr in (select batnbr from pssfatranhdr WHERE status = 'P')  AND batnbr <> 'FORECAST')
Set @AccumDepr = (Select IsNull(Sum(amt), 0.00) from PSSFATran WHERE TranType = 'D' AND AssetId = @AssetID AND AssetSubID = @AssetSubID AND BookCode = @BookCOde AND DeprMethod = @DeprMethod AND batnbr in (select batnbr from pssfatranhdr WHERE status = 'P')  AND batnbr <> 'FORECAST')
Set @BonusDeprTaken = (Select IsNull(Sum(amt), 0.00) from PSSFATran WHERE TranType = 'D' AND AssetId = @AssetID AND AssetSubID = @AssetSubID AND BookCode = @BookCOde AND DeprMethod = @BonusDeprCd AND batnbr in (select batnbr from pssfatranhdr WHERE status = 'P')  AND batnbr <> 'FORECAST')
Set @Tax179Taken = (Select IsNull(Sum(amt), 0.00) from PSSFATran WHERE TranType = 'D' AND AssetId = @AssetID AND AssetSubID = @AssetSubID AND BookCode = @BookCOde AND DeprMethod = 'SECT179' AND batnbr in (select batnbr from pssfatranhdr WHERE status = 'P')  AND batnbr <> 'FORECAST')

-- Update with the totals we just calculated

 Update PSSAssetDeprBook
    Set AccumDep = @AccumDepr + @BonusDeprTaken + @Tax179Taken,
            RegDeprTaken = @AccumDepr,
            BOnusDeprTaken = @BonusDeprTaken,
            Tax179Taken = @Tax179Taken,
            Basis = Cost - @AccumDepr, 
            LastDeprPerNbr = @LastPerDepr
      WHERE AssetID = @AssetID 
      AND AssetSubID = @AssetSUbID
      AND BookCode = @Bookcode

-- See if Set to fully deprecaite

Update PSSAssetDeprBook
    Set Depreciate = 'F'
      WHERE AssetID = @AssetID 
      AND AssetSubID = @AssetSUbID
      AND BookCode = @Bookcode
   AND ((left(DeprMethod,2) = 'SL' or left(DeprMethod,3) = 'DDB'  AND (cost-SalvageValue) <= AccumDep) 
   AND (left(DeprMethod,2) <> 'SL' AND left(DeprMethod,3) <> 'DDB'      AND (cost) <= AccumDep) )
GO
