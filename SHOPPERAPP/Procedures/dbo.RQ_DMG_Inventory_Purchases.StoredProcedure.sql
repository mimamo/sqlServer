USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[RQ_DMG_Inventory_Purchases]    Script Date: 12/21/2015 16:13:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQ_DMG_Inventory_Purchases    Script Date: 9/4/2003 6:21:41 PM ******/

/****** Object:  Stored Procedure dbo.RQ_DMG_Inventory_Purchases    Script Date: 7/5/2002 2:44:36 PM ******/

create proc [dbo].[RQ_DMG_Inventory_Purchases]
	@InvtID	varchar(30)
as
	select	*
	from	Inventory
	where	InvtID like @InvtID
	and	TranStatusCode in ('AC','NU')
	and	StkItem = 1
	order by InvtID
GO
