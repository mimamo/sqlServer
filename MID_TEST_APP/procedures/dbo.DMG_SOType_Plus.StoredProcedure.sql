USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOType_Plus]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOType_Plus]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
AS
	select	*
	from	SOType
	where	CpnyID LIKE @CpnyID
	and	SOTypeID LIKE @SOTypeID
	order by CpnyID, SOTypeID
GO
