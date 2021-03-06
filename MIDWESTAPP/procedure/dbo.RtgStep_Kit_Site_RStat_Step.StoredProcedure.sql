USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_Kit_Site_RStat_Step]    Script Date: 12/21/2015 15:55:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgStep_Kit_Site_RStat_Step] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 1), @parm4beg smallint, @parm4end smallint as
            Select * from RtgStep where KitId = @parm1 and siteid = @parm2 and rtgstatus = @parm3
                           and StepNbr between @parm4beg and @parm4end
                        Order by KitId, SiteId, RtgStatus, StepNbr
GO
