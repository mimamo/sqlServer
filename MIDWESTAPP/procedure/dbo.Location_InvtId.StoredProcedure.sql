USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Location_InvtId]    Script Date: 12/21/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Location_InvtId    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.Location_InvtId    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Location_InvtId] @parm1 varchar ( 30) as
        Select * from Location where InvtId = @parm1
                    order by InvtId, SiteId, WhseLoc
GO
