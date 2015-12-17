USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemXRef_CustomerItemExists]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ItemXRef_CustomerItemExists]
	@InvtID		varchar(30),
	@EntityID	varchar(15)
as
	if (
	select	count(*)
	from 	ItemXRef (NOLOCK)
	where	InvtID = @InvtID
	and	EntityID = @EntityID
	and	AltIDType = 'C'
	) = 0
 		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
