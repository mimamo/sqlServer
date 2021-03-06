USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_LocAvail_Rcpts]    Script Date: 12/21/2015 16:01:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LocTable_LocAvail_Rcpts] @parm0 varchar ( 30), @parm1 varchar ( 10), @parm2 varchar ( 30), @parm3 varchar ( 10) as
SELECT LocTable.*, Location.* FROM LocTable LEFT JOIN Location ON LocTable.SiteID = Location.SiteID AND LocTable.WhseLoc = Location.WhseLoc AND Location.InvtID LIKE @parm0 where LocTable.SiteID = @parm1 and
LocTable.ReceiptsValid In ('Y','W') and
((LocTable.InvtIDValid = 'Y' and LocTable.InvtID = @parm2) or
LocTable.InvtIDValid = 'W' or LocTable.InvtIDValid = 'N' or LocTable.InvtID = '')
 and LocTable.WhseLoc like @parm3
Order by LocTable.SiteID,LocTable.WhseLoc
GO
