USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetGLSetupBaseCuryID]    Script Date: 12/16/2015 15:55:17 ******/
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
