USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetNextSeqDescr]    Script Date: 12/21/2015 13:44:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GetNextSeqDescr]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4),
	@FunctionID	varchar(8),
	@FunctionClass	varchar(4),
	@Seq		varchar(4) OUTPUT,
	@Descr		varchar(30) OUTPUT
as
	select	@Seq = ltrim(rtrim(Seq)),
		@Descr = ltrim(rtrim(Descr))
	from 	SOStep (NOLOCK)
	where	CpnyID = @CpnyID
	and	SOTypeID = @SOTypeID
	and	FunctionID = @FunctionID
	and	FunctionClass = @FunctionClass

	if @@ROWCOUNT = 0 begin
		set @Seq = ''
		set @Descr = ''
		return 0	--Failure
	end
	else
		--select @Seq, @Descr
		return 1	--Success
GO
