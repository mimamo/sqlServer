USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Location_SiteID_WhseLoc_InvtId]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Location_SiteID_WhseLoc_InvtId    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.Location_SiteID_WhseLoc_InvtId    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Location_SiteID_WhseLoc_InvtId] @parm1 varchar ( 10), @parm2 varchar ( 10) , @parm3 varchar ( 30) as
Select InvtId, Sum(QtyAlloc), Sum(QtyOnHand), SiteId, WhseLoc from Location where SiteID = @parm1 and WhseLoc = @parm2 and InvtId = @parm3
	group by SiteID,WhseLoc,InvtID
GO
