USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_MultiCurrencyActivated]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_MultiCurrencyActivated]
as
	declare @MCActivated as bit

	select	@MCActivated = MCActivated
	from	CMSetup (NOLOCK)

	if @@ROWCOUNT = 0 or @MCActivated = 0
		--select 0
		return 0	--Currency Manager is not installed or multi-currency is not activated
	else
		--select 1
		return 1
GO
