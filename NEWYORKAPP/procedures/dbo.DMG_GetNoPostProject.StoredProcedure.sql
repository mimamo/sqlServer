USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetNoPostProject]    Script Date: 12/21/2015 16:00:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_GetNoPostProject]
	@control_data	varchar(32) OUTPUT
as
	select	@control_data = ltrim(rtrim(control_data))
	from	PJCONTRL (NOLOCK)
	where	control_type = 'PA'
	and	control_code = 'NO-POST-PROJECT'

	if @@ROWCOUNT = 0 begin
		set @control_data = ''
		return 0	--Failure
	end
	else begin
		--select @control_data
		return 1	--Success
	end
GO
