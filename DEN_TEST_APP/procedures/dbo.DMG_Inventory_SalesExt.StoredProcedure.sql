USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Inventory_SalesExt]    Script Date: 12/21/2015 15:36:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Inventory_SalesExt]
	@InvtID	varchar(30)
as
	select	*
	from	Inventory
	where	InvtID like @InvtID
	and	TranStatusCode in ('AC','NP','OH', 'NU')
	order by InvtID
GO
