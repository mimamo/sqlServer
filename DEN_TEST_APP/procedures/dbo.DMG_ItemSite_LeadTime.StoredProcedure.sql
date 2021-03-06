USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemSite_LeadTime]    Script Date: 12/21/2015 15:36:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ItemSite_LeadTime]
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
		return 0	-- Failure
	end
	else begin
		return 1	-- Success
	end
GO
