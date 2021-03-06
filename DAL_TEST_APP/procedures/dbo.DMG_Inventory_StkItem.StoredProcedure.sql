USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Inventory_StkItem]    Script Date: 12/21/2015 13:56:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Inventory_StkItem]
	@InvtID		varchar(30),
	@StkItem	smallint OUTPUT
as
	select		@StkItem = StkItem
	from		Inventory (NOLOCK)
	where		InvtID = @InvtID

	if @@ROWCOUNT = 0 begin
		set @StkItem = 0
		return 0	-- Failure
	end
	else begin
		return 1	-- Success
	end
GO
