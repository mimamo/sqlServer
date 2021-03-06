USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_LocTable_LocAvail]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_LocTable_LocAvail]
 	@parm1 varchar ( 30),
 	@parm2 varchar ( 10),
	@parm3 varchar ( 10)
AS
SELECT LocTable.*, Location.*
FROM LocTable
LEFT JOIN Location
ON LocTable.SiteID = Location.SiteID
AND LocTable.WhseLoc = Location.WhseLoc
AND Location.InvtID LIKE @parm1
WHERE LocTable.SiteID LIKE @parm2 AND LocTable.WhseLoc LIKE @parm3
ORDER BY LocTable.SiteID, LocTable.WhseLoc
GO
