USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOLotSerT_InvtID_LotSerNbr_Filter]    Script Date: 12/21/2015 14:34:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOLotSerT_InvtID_LotSerNbr_Filter]
	@InvtID          varchar( 30 ),
	@SiteID          varchar( 10 ),
	@WhseLoc         varchar( 10 ),
   @LotSerNbr       varchar( 25 ),
	@MfgrLotSerNbr   varchar( 25 ),
	@TranType        varchar( 5 ),
	@TranBegDate     smalldatetime,
	@TranEndDate     smalldatetime

AS
	SELECT           *
	FROM             WOLotSerT
	WHERE            InvtID = @InvtID and
	                 SiteID LIKE @SiteID and
	                 WhseLoc LIKE @WhseLoc and
	                 LotSerNbr LIKE @LotSerNbr and
	                 MfgrLotSerNbr LIKE @MfgrLotSerNbr and
	                 TranType LIKE @TranType and
	                 TranType <> 'II' and
	                 TranType <> 'RC' and
	                 TranType <> 'RI' and
	                 TranDate BETWEEN @TranBegDate and @TranEndDate
	ORDER BY         LotSerNbr, TranDate DESC, BatNbr DESC
GO
