USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_Comp_Stat_Dates]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Comp_Comp_Stat_Dates] @CmpnentID varchar (30), @StopDate smalldatetime as
	Select * from Component where
		Cmpnentid like @CmpnentID
        		and ((Status = 'P' and StartDate between '01/02/1900' and @StopDate)
			  or (Status = 'A' and StopDate between '01/02/1900' and @StopDate))
        	order by Cmpnentid, Siteid, Status
GO
