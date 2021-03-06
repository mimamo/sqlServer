USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ProjectIDNoWOValid]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ProjectIDNoWOValid]
	@project	varchar(16)
as
	if (
	select	count(*)
	from	PJPROJ (NOLOCK)
	where	project = @project
	and	status_pa = 'A'
	and	status_ar = 'A'
	and	status_20 = ''	-- WO projects will have the WOType in this field
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
