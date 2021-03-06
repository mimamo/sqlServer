USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_SiteID_InvtID_Asm]    Script Date: 12/21/2015 13:57:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LocTable_SiteID_InvtID_Asm    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LocTable_SiteID_InvtID_Asm    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LocTable_SiteID_InvtID_Asm] @parm1 varchar ( 10), @parm2 varchar ( 30), @parm3 varchar ( 10) as
Select * from LocTable where LocTable.SiteID = @parm1 and
LocTable.AssemblyValid In ('Y','W') and
((LocTable.InvtIDValid = 'Y' and LocTable.InvtID = @parm2) or
LocTable.InvtIDValid = 'W' or LocTable.InvtIDValid = 'N' or LocTable.InvtID = '') and WhseLoc like @parm3
Order by SiteID, InvtID, WhseLoc
GO
