USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_BMSetupSelected]    Script Date: 12/21/2015 15:49:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_BMSetupSelected]
	@GlbSiteID	varchar(10) OUTPUT,
	@SiteBOM	smallint OUTPUT
as
	select	@GlbSiteID = ltrim(rtrim(GlbSiteID)),
		@SiteBOM = SiteBOM
	from	BMSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @GlbSiteID = ''
		set @SiteBOM = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
