USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOType_BehaviorTR]    Script Date: 12/21/2015 13:44:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOType_BehaviorTR]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
AS
	select	SOType.*
	from	SOType
	where	SOType.CpnyID LIKE @CpnyID
	  and	SOType.SOTypeID LIKE @SOTypeID
	  and	SOType.Active = 1
	  and	SOType.Behavior = 'TR'
	order by SOType.CpnyID,
	   	SOType.SOTypeID
GO
