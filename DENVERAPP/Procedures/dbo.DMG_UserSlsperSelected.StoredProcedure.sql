USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UserSlsperSelected]    Script Date: 12/21/2015 15:42:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_UserSlsperSelected]
	@UserID		varchar(47)
as
	select	ltrim(rtrim(SlsperID)) SlsperID,
		CreditPct
	from	UserSlsper (NOLOCK)
	where	UserID = @UserID
GO
