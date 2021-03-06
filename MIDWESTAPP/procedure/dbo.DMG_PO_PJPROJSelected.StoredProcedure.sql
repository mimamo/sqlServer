USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_PJPROJSelected]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_PJPROJSelected]
	@project	varchar(16),
	@gl_subacct	varchar(24) OUTPUT
as
	select	@gl_subacct = ltrim(rtrim(gl_subacct))
	from	PJPROJ (NOLOCK)
	where	status_pa = 'A'
	and	status_po = 'A'
	and	project = @project

	if @@ROWCOUNT = 0 begin
		set @gl_subacct = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
