USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ADGPlan_ItemSiteSelected]    Script Date: 12/21/2015 13:44:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ADGPlan_ItemSiteSelected]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@LeadTime	decimal(25,9) OUTPUT
as
	select	@LeadTime = LeadTime
	from	ItemSite (NOLOCK)
	where	InvtID = @InvtID
	and	SiteID = @SiteID

	if @@ROWCOUNT = 0 begin
		set @LeadTime = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
