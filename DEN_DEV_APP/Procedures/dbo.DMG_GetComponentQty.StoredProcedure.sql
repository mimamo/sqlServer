USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetComponentQty]    Script Date: 12/21/2015 14:06:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_GetComponentQty]
	@KitID		varchar(30),
	@CmpnentID	varchar(30),
	@CmpnentQty	decimal(25,9) OUTPUT
as
	select	@CmpnentQty = CmpnentQty
	from	Component (NOLOCK)
	where	KitID = @KitID
	and	CmpnentID = @CmpnentID

	if @@ROWCOUNT = 0 begin
		set @CmpnentQty = 0
		return 0	--Failure
	end
	else begin
		--select @CmpnentQty
		return 1	--Success
	end
GO
