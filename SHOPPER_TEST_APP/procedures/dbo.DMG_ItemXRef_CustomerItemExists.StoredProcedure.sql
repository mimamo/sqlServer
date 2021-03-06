USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemXRef_CustomerItemExists]    Script Date: 12/21/2015 16:07:00 ******/
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
