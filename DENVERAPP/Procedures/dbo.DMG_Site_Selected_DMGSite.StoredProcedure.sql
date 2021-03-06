USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Site_Selected_DMGSite]    Script Date: 12/21/2015 15:42:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Site_Selected_DMGSite]
	@SiteID 			varchar(10),
	@AlwaysShip			smallint OUTPUT,
	@NeverAutoCreateShippers	smallint OUTPUT
as
	select	@AlwaysShip = convert(smallint, S4Future09),
		@NeverAutoCreateShippers = convert(smallint, S4Future10)
	from	Site (NOLOCK)
	where	SiteID = @SiteID

	if @@ROWCOUNT = 0 begin
		set @AlwaysShip = 0
		set @NeverAutoCreateShippers = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
