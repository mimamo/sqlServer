USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SODiscCodeAcctSub]    Script Date: 12/21/2015 15:42:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SODiscCodeAcctSub]
	@CpnyID		varchar(10),
	@DiscountID	varchar(1),
	@DiscAcct	varchar(10) OUTPUT,
	@DiscSub	varchar(31) OUTPUT
as
	select	@DiscAcct = DiscAcct,
		@DiscSub = DiscSub
	from	SODiscCode
	where	CpnyID = @CpnyID
	and	DiscountID = @DiscountID

	if @@ROWCOUNT = 0 begin
		set @DiscAcct = ''
		set @DiscSub = ''
		return 0	--Failure
	end
	else
		--select 1
		return 1	--Success
GO
