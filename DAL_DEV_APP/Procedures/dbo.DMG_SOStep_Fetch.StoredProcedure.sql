USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Fetch]    Script Date: 12/21/2015 13:35:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SOStep_Fetch]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
as
	select	*
	from	SOStep
	where	CpnyID = @CpnyID
	and	SOTypeID = @SOTypeID
GO
