USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_ItemSiteSelected]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_ItemSiteSelected]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@AvgCost	decimal(25,9) OUTPUT,
	@COGSAcct	varchar(10) OUTPUT,
	@COGSSub	varchar(24) OUTPUT,
	@DfltPOUnit	varchar(6) OUTPUT,
	@DirStdCst	decimal(25,9) OUTPUT,
	@InvtAcct	varchar(10) OUTPUT,
	@InvtSub	varchar(24) OUTPUT,
	@LastCost	decimal(25,9) OUTPUT
as
	select	@AvgCost = AvgCost,
		@COGSAcct = ltrim(rtrim(COGSAcct)),
		@COGSSub = ltrim(rtrim(COGSSub)),
		@DfltPOUnit = DfltPOUnit,
		@DirStdCst = DirStdCst,
		@InvtAcct = ltrim(rtrim(InvtAcct)),
		@InvtSub = ltrim(rtrim(InvtSub)),
		@LastCost = LastCost
	from	ItemSite (NOLOCK)
	where	InvtID = @InvtID
	and	SiteID = @SiteID

	if @@ROWCOUNT = 0 begin
		set @AvgCost = 0
		set @COGSAcct = ''
		set @COGSSub = ''
		set @DfltPOUnit = ''
		set @DirStdCst = 0
		set @InvtAcct = ''
		set @InvtSub = ''
		set @LastCost = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
