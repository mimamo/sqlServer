USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_KitID_KSite_KStat]    Script Date: 12/21/2015 15:36:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--bkb 6/29/99 4.2
--11500
Create Procedure [dbo].[Comp_KitID_KSite_KStat] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 1) as
	Select * from Component where
		Kitid = @parm1
      	and Kitsiteid = @parm2
		and KitStatus = @parm3
        	Order by Kitid, KitSiteid, KitStatus
GO
