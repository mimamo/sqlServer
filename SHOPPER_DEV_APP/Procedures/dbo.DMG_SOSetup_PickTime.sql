USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOSetup_PickTime]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_SOSetup_PickTime]
	@PickTime	smallint OUTPUT
as
	select	@PickTime = PickTime
	from	SOSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @PickTime = 0
		return 0	-- Failure
	end
	else begin
		return 1	-- Success
	end
GO
