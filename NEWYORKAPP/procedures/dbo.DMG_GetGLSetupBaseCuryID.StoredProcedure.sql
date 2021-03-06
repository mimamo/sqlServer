USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetGLSetupBaseCuryID]    Script Date: 12/21/2015 16:00:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_GetGLSetupBaseCuryID]
	@BaseCuryID	varchar(4) OUTPUT
as
	select	@BaseCuryID = ltrim(rtrim(BaseCuryID))
	from	GLSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @BaseCuryID = ''
		return 0	--Failure
	end
	else begin
		--select @BaseCuryID
		return 1	--Success
	end
GO
