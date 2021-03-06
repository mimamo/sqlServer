USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Location_SiteID_InvtId]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Location_SiteID_InvtId]
@parm1 varchar ( 10), 
@parm2 varchar ( 30) as
Select InvtId, Sum(QtyAlloc), Sum(QtyAvail), SiteId, WhseLoc, '' 
from Location 
where SiteID = @parm1 
	and InvtId = @parm2
group by SiteID, WhseLoc, InvtID
GO
