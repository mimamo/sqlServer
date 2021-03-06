USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemCost_RcptNbr]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_ItemCost_RcptNbr]
	@InvtID varchar (30),
	@SiteID varchar (10),
	@RcptNbr varchar (10)
as
	Select	*
	from	ItemCost
	where	InvtId = @InvtID
        and	SiteId = @SiteID
	and 	RcptNbr like @RcptNbr
        order by InvtId, SiteId, RcptNbr
GO
