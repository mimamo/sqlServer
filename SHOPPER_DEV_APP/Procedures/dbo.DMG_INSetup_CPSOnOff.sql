USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_INSetup_CPSOnOff]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_INSetup_CPSOnOff]
	@CPSOnOff	smallint OUTPUT
as
	select	@CPSOnOff = CPSOnOff
	from	INSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @CPSOnOff = 0
		return 0	--Failure
	end
	else
		--select @CPSOnOff
		return 1	--Success
GO
