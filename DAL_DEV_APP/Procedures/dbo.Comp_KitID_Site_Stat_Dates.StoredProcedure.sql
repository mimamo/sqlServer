USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_KitID_Site_Stat_Dates]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--bkb 6/29/99 4.2
--11500
Create Procedure [dbo].[Comp_KitID_Site_Stat_Dates] @parm1 varchar ( 30), @parm2 varchar ( 10),
@parm3beg smalldatetime, @parm3end smalldatetime, @parm4beg smalldatetime, @parm4end smalldatetime as
	Select * from Kit where
		Kitid like @parm1
		and siteid like @parm2
        	and ((Kit.status = 'P' and (startdate between @parm3beg and @parm3end))
			or (status = 'A' and (stopdate between @parm4beg and @parm4end))) 		Order by Kitid, Siteid, Status
GO
