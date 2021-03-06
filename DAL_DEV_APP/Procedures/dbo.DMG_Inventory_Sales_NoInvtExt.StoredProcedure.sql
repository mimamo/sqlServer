USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Inventory_Sales_NoInvtExt]    Script Date: 12/21/2015 13:35:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Inventory_Sales_NoInvtExt]
	@InvtID	varchar(30)
as
	select	*
	from	Inventory
	where	InvtID like @InvtID
	and	TranStatusCode in ('AC','NP','NU')
	order by InvtID
GO
