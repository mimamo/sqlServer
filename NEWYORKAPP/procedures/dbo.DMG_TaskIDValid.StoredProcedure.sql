USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_TaskIDValid]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_TaskIDValid]
	@project	varchar(16),
	@pjt_entity	varchar(32)
as
	if (
	select	count(*)
	from	PJPENT (NOLOCK)
	where	project = @project
	and	pjt_entity = @pjt_entity
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
