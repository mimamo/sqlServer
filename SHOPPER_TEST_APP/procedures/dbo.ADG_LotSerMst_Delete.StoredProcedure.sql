USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LotSerMst_Delete]    Script Date: 12/21/2015 16:06:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_LotSerMst_Delete]

	@InvtID		varchar(30),
	@LotSerNbr	varchar(25),
	@SiteID		varchar(10),
	@WhseLoc  	varchar(10)
AS
	DELETE FROM LotSerMst
	WHERE	InvtID = @InvtID AND
		LotSerNbr = @LotSerNbr AND
		SiteID = @SiteID AND
		WhseLoc = @WhseLoc AND
		Status = 'H'
GO
