USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Location_InvtId_SiteId_PVL]    Script Date: 12/21/2015 15:42:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo. Location_InvtId_SiteId_PVL Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[Location_InvtId_SiteId_PVL] @parm1 varchar ( 30), @parm2 varchar ( 10) as
        Select * from Location where InvtId = @parm1
                                and  SiteId = @parm2
                                order by InvtId, SiteId, WhseLoc
GO
