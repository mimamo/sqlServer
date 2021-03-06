USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_EventType]    Script Date: 12/21/2015 13:56:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_SOStep_EventType]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4),
	@FunctionID	varchar(8),
	@FunctionClass	varchar(4),
	@EventType	varchar(4) OUTPUT
as
	select  @EventType = ltrim(rtrim(EventType))
	from    SOStep (NOLOCK)
	where   CpnyID = @CpnyID
	  and   SOTypeID = @SOTypeID
	  and   FunctionID = @FunctionID
          and	FunctionClass = @FunctionClass
	  and   EventType <> 'X'

	if @@ROWCOUNT = 0 begin
		set @EventType = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
