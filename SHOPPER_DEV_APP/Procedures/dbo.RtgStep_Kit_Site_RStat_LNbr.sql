USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_Kit_Site_RStat_LNbr]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgStep_Kit_Site_RStat_LNbr] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 1), @parm4beg smallint, @parm4end smallint as
            Select * from RtgStep, Operation where KitId = @parm1 and siteid = @parm2 and rtgstatus = @parm3
                           and LineNbr between @parm4beg and @parm4end and RtgStep.OperationID = Operation.OperationID
                        Order by KitId, SiteId, RtgStatus, LineNbr
GO
