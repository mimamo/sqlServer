USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GLWildcard_SV]    Script Date: 12/21/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GLWildcard_SV]
	@CpnyID		varchar(10),
	@ShipViaID	varchar(15),
	@FrtAcct	varchar(10) OUTPUT,
	@FrtSub		varchar(24) OUTPUT
as
	select	@FrtAcct = FrtAcct,
		@FrtSub = FrtSub
	from	ShipVia (NOLOCK)
	where	CpnyID = @CpnyID
	and	ShipViaID = @ShipViaID

	if @@ROWCOUNT = 0 begin
		set @FrtAcct = ''
		set @FrtSub = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
