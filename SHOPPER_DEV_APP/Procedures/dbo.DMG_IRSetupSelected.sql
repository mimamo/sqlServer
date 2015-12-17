USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_IRSetupSelected]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_IRSetupSelected]
	@IncludeDropShip	smallint OUTPUT
as
	select	@IncludeDropShip = IncludeDropShip
	from 	IRSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @IncludeDropShip = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
