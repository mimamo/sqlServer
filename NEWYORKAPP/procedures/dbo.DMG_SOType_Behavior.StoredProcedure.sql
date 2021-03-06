USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOType_Behavior]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_SOType_Behavior]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4),
	@Behavior	varchar(4) OUTPUT
as
	select	@Behavior = ltrim(rtrim(Behavior))
	from	SOType (NOLOCK)
	where	CpnyID = @CpnyID
	and	SOTypeID = @SOTypeID

	if @@ROWCOUNT = 0 begin
		set @Behavior = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
