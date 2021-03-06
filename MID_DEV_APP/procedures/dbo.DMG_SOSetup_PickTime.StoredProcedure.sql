USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOSetup_PickTime]    Script Date: 12/21/2015 14:17:37 ******/
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
