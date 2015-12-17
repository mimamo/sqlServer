USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOType_Plus]    Script Date: 12/16/2015 15:55:18 ******/
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
