USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetSalespersonCmmnPct]    Script Date: 12/21/2015 13:35:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_GetSalespersonCmmnPct]
	@SlsperID	varchar(10),
	@CmmnPct	float OUTPUT
as
	select	@CmmnPct = CmmnPct
	from	Salesperson (NOLOCK)
	where	SlsperID = @SlsperID

	if @@ROWCOUNT = 0 begin
		set @CmmnPct = 0
		return 0	--Failure
	end
	else begin
		--select @CmmnPct
		return 1	--Success
	end
GO
