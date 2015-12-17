USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_CmpID_KitID_KSite_KStat_LNbr]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--bkb 6/29/99 4.2
--11500
Create Procedure [dbo].[Comp_CmpID_KitID_KSite_KStat_LNbr] @parm1 varchar ( 30), @parm2 varchar ( 30), @parm3 varchar ( 10), @parm4 varchar ( 1), @parm5 smallint as
	Select * from Component where
        	CmpnentID = @parm1
		and Kitid = @parm2
      		and Kitsiteid = @parm3
		and KitStatus = @parm4
		and LineNbr = @parm5
        	Order by CmpnentID, Kitid, KitSiteID, KitStatus, LineNbr
GO
