USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GLWildcard_Error]    Script Date: 12/21/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GLWildcard_Error]
	@ErrorAcct	varchar(10) OUTPUT,
	@ErrorSub	varchar(30) OUTPUT
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
		--select @ErrorAcct,@ErrorSub
		return 1	--Success
GO
