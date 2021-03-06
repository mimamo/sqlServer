USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ShipVia_FreightDefaults]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ShipVia_FreightDefaults]
	@CpnyID		varchar(10),
	@ShipViaID	varchar(10),
	@DfltFrtAmt	decimal(25,9) OUTPUT,
	@DfltFrtMthd	varchar(1) OUTPUT
as
	select	@DfltFrtAmt = DfltFrtAmt,
		@DfltFrtMthd = ltrim(rtrim(DfltFrtMthd))
	from	ShipVia (NOLOCK)
	where	CpnyID = @CpnyID
	  and	ShipViaID = @ShipViaID

	if @@ROWCOUNT = 0 begin
		set @DfltFrtAmt = 0
		set @DfltFrtMthd = ''
		return 0	--Failure
	end
	else
		--select @DfltFrtAmt, @DfltFrtMthd
		return 1	--Success
GO
