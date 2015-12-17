USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Book_PostBookings]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_Book_PostBookings]
	@PostBookings	smallint OUTPUT
as
	select	@PostBookings = PostBookings
	from	SOSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @PostBookings = 0
		return 0	-- Failure
	end
	else begin
		return 1	-- Success
	end
GO
