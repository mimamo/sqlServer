USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_FOBIDValid]    Script Date: 12/21/2015 16:13:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_FOBIDValid]
	@FOBID	varchar(15)
as
	if (
	select	count(*)
	from	FOBPoint (NOLOCK)
	where	FOBID = @FOBID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
