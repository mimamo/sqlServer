USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetQtyOnHand_Location]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_GetQtyOnHand_Location]
	@InvtID		Varchar(30),
	@SiteID		Varchar(10),
	@WhseLoc	Varchar(10)
As

SELECT	QtyOnHand
	FROM	Location (NOLOCK)
	WHERE	InvtID = @InvtID AND SiteID = @SiteID AND WhseLoc = @WhseLoc
GO
