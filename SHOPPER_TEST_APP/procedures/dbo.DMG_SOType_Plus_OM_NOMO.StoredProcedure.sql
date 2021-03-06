USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOType_Plus_OM_NOMO]    Script Date: 12/21/2015 16:07:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOType_Plus_OM_NOMO]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
AS
	select	*
	from	SOType
	where	CpnyID = @CpnyID
	and	SOTypeID LIKE @SOTypeID
	and Behavior <> 'MO'
	order by CpnyID, SOTypeID
GO
