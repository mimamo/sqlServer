USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_LocTableSelected]    Script Date: 12/21/2015 16:07:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_LocTableSelected]
	@SiteID		varchar(10),
	@WhseLoc	varchar(10),
	@InclQtyAvail	smallint OUTPUT,
	@InvtID		varchar(30) OUTPUT,
	@InvtIDValid	varchar(1) OUTPUT,
	@ReceiptsValid	varchar(1) OUTPUT
as
	select	@InclQtyAvail = InclQtyAvail,
		@InvtID = ltrim(rtrim(InvtID)),
		@InvtIDValid = ltrim(rtrim(InvtIDValid)),
		@ReceiptsValid = ltrim(rtrim(ReceiptsValid))
	from	LocTable (NOLOCK)
	where	SiteID = @SiteID
	and	WhseLoc = @WhseLoc

	if @@ROWCOUNT = 0 begin
		set @InclQtyAvail = 0
		set @InvtID = ''
		set @InvtIDValid = ''
		set @ReceiptsValid = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
