USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GLSetup_PerInFiscalYr]    Script Date: 12/21/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GLSetup_PerInFiscalYr]
	@PerInFiscalYr	smallint OUTPUT
as
	select	@PerInFiscalYr = NbrPer
	from	GLSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @PerInFiscalYr = 0
		return 0	--Failure
	end
	else
		--select @CPSOnOff
		return 1	--Success
GO
