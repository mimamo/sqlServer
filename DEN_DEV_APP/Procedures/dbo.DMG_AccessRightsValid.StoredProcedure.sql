USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_AccessRightsValid]    Script Date: 12/21/2015 14:06:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_AccessRightsValid]
	@UserID		varchar(47),
	@CpnyID		varchar(10),
	@ScreenNumber	varchar(5)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	if
	(
	select seclevel
          from vs_share_secCpny
         where cpnyid = @cpnyid and userid = @UserID and scrn = @ScreenNumber
	)
	> 3
			return  1	--Success
	else

		return  0	--Failure
GO
