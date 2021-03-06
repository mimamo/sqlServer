USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustInvt_Price_GroupSite]    Script Date: 12/21/2015 15:36:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CustInvt_Price_GroupSite    Script Date: 1/12/08 12:30:33 PM ******/
CREATE PROCEDURE [dbo].[CustInvt_Price_GroupSite]
	@PriceCat VarChar(2), @CpnyID VarChar(10),  @CuryId Varchar(4), @DiscMthd VarChar(1), @InvtId VarChar(30), 
    @Custid VarChar(15), @UpdateSlsPrc int, @SlsUnits VarChar(6), @QtyBreak float, @CurrentPrice Float,  
    @RvsdPrice Float, @RvsdPricePercent Float, @RvsdPriceFlat float, @SiteGroupID VarChar(10), @DecPlPrice int,
    @DiscPrcTyp VarChar(1)
AS
-- Pricing Categories ('CU' - 'Customer', 'IT' - 'Inventory Item', 'IC' - 'Invt Item and Customer')
--Price 
DECLARE @FetchAllQtyBreaks VarChar(3)
DECLARE @CurrentPriceSent VarChar(3) 

--Default the local values
SELECT @FetchAllQtyBreaks = 'NO'
SELECT @CurrentPriceSent = 'NO'

IF @QtyBreak = 0
  BEGIN
	SELECT @FetchAllQtyBreaks = 'YES'
  END

IF @CurrentPrice = 0 
  BEGIN
	SELECT @CurrentPriceSent = 'YES'
  END



UPDATE d SET RvsdDiscPrice = CASE WHEN @RvsdPrice <> 0 THEN @RvsdPrice  -- Will always be greater or equal to 0 
                                  WHEN @RvsdPricePercent <> 0 THEN CASE WHEN ROUND((d.DiscPrice + ((@RvsdPricePercent * .01) * d.DiscPrice)), @DecPlPrice) >= 0
                                                                        THEN ROUND((d.DiscPrice + ((@RvsdPricePercent * .01) * d.DiscPrice)), @DecPlPrice)
                                                                        ELSE 0 END
                                  WHEN @RvsdPriceFlat <> 0 THEN CASE WHEN ROUND(d.DiscPrice + @RvsdPriceFlat, @DecPlPrice) >= 0 
                                                                     THEN ROUND(d.DiscPrice + @RvsdPriceFlat, @DecPlPrice)
                                                                     ELSE 0 END
                                  ELSE d.RvsdDiscPrice END 

  FROM SlsPrc c JOIN SlsPrcDet d
                     ON c.SlsPrcID = d.SlsPrcID
                   JOIN SiteGroupDet s
                     ON c.SiteID = s.SiteID
 WHERE c.PriceCat = @PriceCat
   AND c.DiscPrcMthd = @DiscMthd  
   AND s.SiteGroupID = @SiteGroupID
   AND c.CuryID = @CuryId 
   AND c.CustID LIKE @CustID
   AND c.InvtID LIKE @InvtID
   AND d.SlsUnit LIKE @SlsUnits
   AND ((@UpdateSlsPrc = 1) OR (@UpdateSlsPrc = 0 AND d.RvsdDiscPrice = 0))
   AND ((d.QtyBreak = @QtyBreak AND @FetchAllQtyBreaks = 'NO')  or @FetchAllQtyBreaks = 'YES')
   AND ((d.DiscPrice = @CurrentPrice AND @CurrentPriceSent = 'NO') or @CurrentPriceSent = 'YES')
   AND c.DiscPrcTyp LIKE @DiscPrcTyp
GO
