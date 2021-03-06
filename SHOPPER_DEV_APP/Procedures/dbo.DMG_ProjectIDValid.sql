USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ProjectIDValid]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ProjectIDValid]
	@project	varchar(16)
as
	if (
	select	count(*)
	from	PJPROJ (NOLOCK)
	where	project = @project
	and	status_pa = 'A'
	and	status_ar = 'A'
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
