USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_ItemXRefSelectedByAlternateID]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_ItemXRefSelectedByAlternateID]
	@AlternateID	varchar(30),
	@EntityID	varchar(15),
	@AltIDType	varchar(1),
	@StkItem	bit,
	@InvtID		varchar(30) OUTPUT
as
	select	top 1
		@InvtID = ltrim(rtrim(ItemXRef.InvtID))
	from	ItemXRef (NOLOCK)
	join	Inventory (NOLOCK) on Inventory.InvtID = ItemXRef.InvtID
	where	((EntityID = @EntityID and AltIDType = @AltIDType)
	or	AltIDType in ('G','O','M'))
	and	AlternateID = @AlternateID
	and	Inventory.StkItem = @StkItem
        order by AltIDType Desc, EntityID, AlternateID

	if @@ROWCOUNT <> 0
		--select @InvtID
		return 1	--Success
	else begin
		set @InvtID = ''
		return 0	--Failure
	end
GO
