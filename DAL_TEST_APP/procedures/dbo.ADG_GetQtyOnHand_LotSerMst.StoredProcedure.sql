USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetQtyOnHand_LotSerMst]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_GetQtyOnHand_LotSerMst]
	@InvtID		Varchar(30),
	@SiteID		Varchar(10),
	@WhseLoc	Varchar(10),
	@LotSerNbr	Varchar(25)
As

SELECT	QtyOnHand
	FROM	LotSerMst (NOLOCK)
	WHERE	InvtID = @InvtID AND SiteID = @SiteID AND WhseLoc = @WhseLoc AND LotSerNbr = @LotSerNbr
GO
