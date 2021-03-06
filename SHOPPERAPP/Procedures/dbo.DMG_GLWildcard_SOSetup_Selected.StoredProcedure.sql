USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GLWildcard_SOSetup_Selected]    Script Date: 12/21/2015 16:13:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GLWildcard_SOSetup_Selected]
	@ErrorAcct	varchar(10) OUTPUT,
	@ErrorSub	varchar(24) OUTPUT
as
	select	@ErrorAcct = ltrim(rtrim(ErrorAcct)),
		@ErrorSub = ltrim(rtrim(ErrorSub))
	from	SOSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @ErrorAcct = ''
		set @ErrorSub = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
