USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOType_Active_Plus2]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOType_Active_Plus2]
	@FunctionID	varchar(8),
	@FunctionClass	varchar(4),
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
AS
	select	SOType.*
	from	SOType, SOStep
	where	SOType.CpnyID = SOStep.CpnyID
	  and	SOType.SOTypeID = SOStep.SOTypeID
	  and	SOStep.FunctionID = @FunctionID
	  and	SOStep.FunctionClass = @FunctionClass
	  and	SOType.CpnyID LIKE @CpnyID
	  and	SOType.SOTypeID LIKE @SOTypeID
	  and	SOType.Active = 1
	  and   (SOType.Behavior <> 'MO' Or Exists (Select 1 From INsetup (NOLOCK) where CPSOnOff = 0))
	order by SOType.CpnyID,
	   	SOType.SOTypeID
GO
