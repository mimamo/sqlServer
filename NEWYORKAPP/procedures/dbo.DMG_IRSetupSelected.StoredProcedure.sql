USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_IRSetupSelected]    Script Date: 12/21/2015 16:00:54 ******/
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
