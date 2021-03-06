USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INLotSerT_InvtID_LotSerNbr_Filter]    Script Date: 12/21/2015 16:07:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INLotSerT_InvtID_LotSerNbr_Filter]
	@InvtID          varchar( 30 ),
	@SiteID          varchar( 10 ),
	@WhseLoc         varchar( 10 ),
   @LotSerNbr       varchar( 25 ),
	@MfgrLotSerNbr   varchar( 25 ),
	@TranType        varchar( 2 ),
	@TranBegDate     smalldatetime,
	@TranEndDate     smalldatetime

AS
	SELECT           *
	FROM             LotSerT L LEFT OUTER JOIN WOLotSerT W
                    ON L.LotSerNbr = W.LotSerNbr and
                    L.RecordID = W.LotSerTRecordID
	WHERE            L.InvtID = @InvtID and
	                 L.SiteID LIKE @SiteID and
	                 L.WhseLoc LIKE @WhseLoc and
	                 L.LotSerNbr LIKE @LotSerNbr and
	                 L.MfgrLotSerNbr LIKE @MfgrLotSerNbr and
	                 L.TranType LIKE @TranType and
	                 L.TranDate BETWEEN @TranBegDate and @TranEndDate
	ORDER BY         L.LotSerNbr, L.TranDate DESC, L.BatNbr DESC
GO
