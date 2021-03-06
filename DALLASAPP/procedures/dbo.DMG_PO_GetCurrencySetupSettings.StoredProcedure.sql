USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_GetCurrencySetupSettings]    Script Date: 12/21/2015 13:44:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_GetCurrencySetupSettings]
	@APCuryOverride	bit OUTPUT,
	@APRtTpDflt	varchar(6) OUTPUT,
	@APRtTpOverride	bit OUTPUT
as
	select	@APCuryOverride = APCuryOverride,
		@APRtTpDflt = ltrim(rtrim(APRtTpDflt)),
		@APRtTpOverride = APRtTpOverride
	from	CMSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @APCuryOverride = 0
		set @APRtTpDflt = ''
		set @APRtTpOverride = 0
		--select 0
		return 0	--Currency Manager is not installed or multi-currency is not activated
	end
	else
		--select @ARCuryOverride, @ARRtTpDflt, @ARRtTpOverride, @ARPrcLvlRtTp
		return 1
GO
