USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_ShipViaValid]    Script Date: 12/21/2015 15:49:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_ShipViaValid]
	@CpnyID		varchar(10),
	@ShipViaID	varchar(15)
as
	if (
	select	count(*)
	from	ShipVia (NOLOCK)
	where	CpnyID = @CpnyID
	and	ShipViaID = @ShipViaID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
