USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_CmpID_Site_KStat]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--bkb 7/22/99 4.2
--11500
Create Procedure [dbo].[Comp_CmpID_Site_KStat] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 1) as
		Select * from Component where
			cmpnentid = @parm1 and
			siteid = @parm2 and
			kitstatus = @parm3
			Order by CmpnentID, SiteID
GO
