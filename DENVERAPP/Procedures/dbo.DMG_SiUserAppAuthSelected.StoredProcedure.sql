USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SiUserAppAuthSelected]    Script Date: 12/21/2015 15:42:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SiUserAppAuthSelected]
	@UserID		varchar(47),
	@SiteID		varchar(10) OUTPUT
as
	select	@SiteID = ltrim(rtrim(SiteID))
	from	SiUserAppAuth (NOLOCK)
	where	UserID = @UserID

	if @@ROWCOUNT = 0 begin
		set @SiteID = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
