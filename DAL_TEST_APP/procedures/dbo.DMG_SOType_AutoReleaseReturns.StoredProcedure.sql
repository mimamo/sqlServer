USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOType_AutoReleaseReturns]    Script Date: 12/21/2015 13:56:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_SOType_AutoReleaseReturns]
	@CpnyID			varchar(10),
	@SOTypeID		varchar(4),
	@AutoReleaseReturns	smallint OUTPUT
as
	select	@AutoReleaseReturns = AutoReleaseReturns
	from	SOType (NOLOCK)
	where	CpnyID = @CpnyID
	and	SOTypeID = @SOTypeID

	if @@ROWCOUNT = 0 begin
		set @AutoReleaseReturns = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
