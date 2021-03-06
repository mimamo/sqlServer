USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOType_Standard]    Script Date: 12/21/2015 15:42:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOType_Standard]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
AS
	select	*
	from	SOType
	where	CpnyID LIKE @CpnyID
	and	SOTypeID LIKE @SOTypeID
	and	SOTypeID IN ('BL', 'CM', 'DM', 'INVC', 'Q', 'RFC', 'SO')
	order by CpnyID, SOTypeID
GO
