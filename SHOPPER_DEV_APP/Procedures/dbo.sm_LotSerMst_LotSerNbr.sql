USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_LotSerMst_LotSerNbr]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sm_LotSerMst_LotSerNbr]
	@InvtID		varchar (30),
	@SiteID 	varchar (10),
	@WhseLoc	varchar (10),
	@LotSerNbr	varchar (25)
AS
	SELECT
		*
	FROM
		LotSerMst
	WHERE
		InvtID like @InvtID		AND
		SiteID like @SiteID		AND
		WhseLoc like @WhseLoc		AND
		LotSerNbr like @LotSerNbr	AND
		Status = 'A'			AND
		(QtyOnHand) > 0.0
	ORDER BY
		InvtId, SiteID, WhseLoc, LotSerNbr
GO
