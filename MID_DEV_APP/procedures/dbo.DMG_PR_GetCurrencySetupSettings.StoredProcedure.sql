USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_GetCurrencySetupSettings]    Script Date: 12/21/2015 14:17:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_GetCurrencySetupSettings]
	@APCuryOverride	bit OUTPUT,
	@APRateDate 	varchar(1) OUTPUT,
	@APRtTpDflt	varchar(6) OUTPUT,
	@APRtTpOverride	bit OUTPUT
as
	select	@APCuryOverride = APCuryOverride,
		@APRateDate = APRateDate,
		@APRtTpDflt = ltrim(rtrim(APRtTpDflt)),
		@APRtTpOverride = APRtTpOverride
	from	CMSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @APCuryOverride = 0
		set @APRateDate = ''
		set @APRtTpDflt = ''
		set @APRtTpOverride = 0
		--select 0
		return 0	--Currency Manager is not installed or multi-currency is not activated
	end
	else
		--select @APCuryOverride, @APRateDate, @APRtTpDflt, @APRtTpOverride
		return 1
GO
