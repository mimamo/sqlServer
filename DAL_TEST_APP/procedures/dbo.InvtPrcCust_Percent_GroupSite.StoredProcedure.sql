USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[InvtPrcCust_Percent_GroupSite]    Script Date: 12/21/2015 13:57:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.InvtPrcCust_Percent_GroupSite    Script Date: 1/12/08 12:30:33 PM ******/
CREATE PROCEDURE [dbo].[InvtPrcCust_Percent_GroupSite]
	@PriceCat VarChar(2), @CpnyID VarChar(10),  @CuryId Varchar(4), @DiscMthd VarChar(1), @Custid VarChar(15), 
    @InvtPriceClassID VarChar(6), @UpdateSlsPrc int, @SlsUnits VarChar(6), @QtyBreak float, @CurrentPercent Float,   
    @RvsdPercent Float, @RvsdPercentFlat Float, @SiteGroupID VarChar (10), @DiscPrcTyp VarChar(1)
AS
-- Pricing Category: Invtentory Price Class and Customer
--"Percent
DECLARE @FetchAllQtyBreaks VarChar(3)
DECLARE @CurrentPercentSent VarChar(3) 

--Default the local values
SELECT @FetchAllQtyBreaks = 'NO'
SELECT @CurrentPercentSent = 'NO'

IF @QtyBreak = 0
  BEGIN
	SELECT @FetchAllQtyBreaks = 'YES'
  END

IF @CurrentPercent = 0 
  BEGIN
	SELECT @CurrentPercentSent = 'YES'
  END

UPDATE d SET RvsdDiscPct = CASE WHEN @RvsdPercent <> 0 THEN @RvsdPercent  
                                WHEN @RvsdPercentFlat <> 0 THEN ROUND(d.DiscPct + @RvsdPercentFlat,2) 
                                ELSE d.RvsdDiscPct END

  FROM SlsPrc c JOIN SlsPrcDet d
                     ON c.SlsPrcID = d.SlsPrcID
                   JOIN SiteGroupDet s
                     ON c.SiteID = s.SiteID
 WHERE c.PriceCat = @PriceCat
   AND c.DiscPrcMthd = @DiscMthd  
   AND s.SiteGroupID = @SiteGroupID
   AND c.CuryID = @CuryId 
   AND c.PriceClassID LIKE @InvtPriceClassID
   AND c.CustID LIKE @Custid
   AND d.SlsUnit LIKE @SlsUnits
   AND ((@UpdateSlsPrc = 1) OR (@UpdateSlsPrc = 0 AND d.RvsdDiscPct = 0))                              
   AND ((d.QtyBreak = @QtyBreak AND @FetchAllQtyBreaks = 'NO')  or @FetchAllQtyBreaks = 'YES')
   AND ((d.DiscPct = @CurrentPercent AND @CurrentPercentSent = 'NO') or @CurrentPercentSent = 'YES') 
   AND c.DiscPrcTyp LIKE @DiscPrcTyp
GO
