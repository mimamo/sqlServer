USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_LocAvail_Asm]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LocTable_LocAvail_Asm] @parm0 varchar ( 30), @parm1 varchar ( 10), @parm2 varchar ( 30), @parm3 varchar ( 10) as
Select LocTable.*, Location.* from LocTable LEFT JOIN Location ON LocTable.SiteID = Location.SiteID AND LocTable.WhseLoc = Location.WhseLoc AND Location.InvtID LIKE @parm0 where LocTable.SiteID = @parm1 and
LocTable.AssemblyValid In ('Y','W') and
((LocTable.InvtIDValid = 'Y' and LocTable.InvtID = @parm2) or
LocTable.InvtIDValid = 'W' or LocTable.InvtIDValid = 'N' or LocTable.InvtID = '') and LocTable.WhseLoc like @parm3
Order by LocTable.SiteID, LocTable.WhseLoc
GO
