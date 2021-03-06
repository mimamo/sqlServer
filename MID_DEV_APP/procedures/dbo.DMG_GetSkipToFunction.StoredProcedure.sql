USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetSkipToFunction]    Script Date: 12/21/2015 14:17:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GetSkipToFunction]
	@cpnyid		varchar(10),
	@sotypeid	varchar(4),
	@skipto		varchar(4),
	@FunctionID	varchar(8) OUTPUT,
	@FunctionClass	varchar(4) OUTPUT
as
	select	top 1
		@FunctionID = ltrim(rtrim(functionid)),
		@FunctionClass = ltrim(rtrim(functionclass))
	from	sostep (NOLOCK)
	where	cpnyid = @cpnyid
	  and	sotypeid = @sotypeid
	  and	seq >= @skipto
	  and	status <> 'D'

	if @@ROWCOUNT = 0 begin
		set @FunctionID = ''
		set @FunctionClass = ''
		return 0	--Failure
	end
	else
		--select @FunctionID, @FunctionClass
		return 1	--Success
GO
