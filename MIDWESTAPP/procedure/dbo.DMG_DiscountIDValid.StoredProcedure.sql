USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_DiscountIDValid]    Script Date: 12/21/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_DiscountIDValid]
	@CpnyID		varchar(10),
	@DiscountID	varchar(1)
as
	if (
	select	count(*)
	from	SODiscCode (NOLOCK)
	where	CpnyID = @CpnyID
	and	DiscountID = @DiscountID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
