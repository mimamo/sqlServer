USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INLotSerMsT_InvtID_LotSerNbr_Filter]    Script Date: 12/21/2015 14:34:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INLotSerMsT_InvtID_LotSerNbr_Filter]
	@InvtID          varchar( 30 ),
	@SiteID          varchar( 10 ),
	@WhseLoc         varchar( 10 ),
   @LotSerNbr       varchar( 25 ),
	@MfgrLotSerNbr   varchar( 25 )

AS
	SELECT           *
	FROM             LotSerMst
	WHERE            InvtID = @InvtID and
	                 SiteID LIKE @SiteID and
	                 WhseLoc LIKE @WhseLoc and
	                 LotSerNbr LIKE @LotSerNbr and
	                 MfgrLotSerNbr LIKE @MfgrLotSerNbr
	ORDER BY         LotSerNbr, SiteID, WhseLoc
GO
