USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Location_InvtId_SiteId_]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Location_InvtId_SiteId_    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.Location_InvtId_SiteId_    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Location_InvtId_SiteId_] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 10) as
        Select * from Location where InvtId = @parm1
                                and  SiteId = @parm2
                                and WhseLoc = @parm3
                    order by InvtId, SiteId, WhseLoc
GO
