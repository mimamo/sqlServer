USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_INSetupSelected]    Script Date: 12/21/2015 15:49:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_INSetupSelected]
	@APClearingAcct		varchar(10) OUTPUT,
	@APClearingSub		varchar(24) OUTPUT,
	@DfltSite		varchar(10) OUTPUT,
	@MultWhse		smallint OUTPUT
as
	select	@APClearingAcct = ltrim(rtrim(APClearingAcct)),
		@APClearingSub = ltrim(rtrim(APClearingSub)),
		@DfltSite = ltrim(rtrim(DfltSite)),
		@MultWhse = MultWhse
	from	INSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @APClearingAcct = ''
		set @APClearingSub = ''
		set @DfltSite = ''
		set @MultWhse = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
