USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PJProj_WorkOrderType_Return]    Script Date: 12/21/2015 14:34:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_PJProj_WorkOrderType_Return]
	@Project	varchar(16),
	@Status_20	varchar(1) OUTPUT
as
	select	@Status_20 = ltrim(rtrim(Status_20))
	from	PJProj (NOLOCK)
	where	Project = @Project

	if @@ROWCOUNT = 0 begin
		set @Status_20 = ''
		return 0	-- Failure
	end
	else begin
		return 1	-- Success
	end
GO
