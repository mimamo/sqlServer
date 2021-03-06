USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_REQ_InventorySelected]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_REQ_InventorySelected]
	@InvtID		varchar(30),
	@MaterialType	varchar(10) OUTPUT
as
	select	@MaterialType = ltrim(rtrim(MaterialType))
	from	Inventory (NOLOCK)
	where	InvtID = @InvtID

	if @@ROWCOUNT = 0 begin
		set @MaterialType = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
