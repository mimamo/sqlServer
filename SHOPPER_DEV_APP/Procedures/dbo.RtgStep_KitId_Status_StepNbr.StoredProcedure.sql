USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_KitId_Status_StepNbr]    Script Date: 12/21/2015 14:34:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgStep_KitId_Status_StepNbr] @parm1 varchar ( 30), @parm2 varchar ( 1), @parm3beg smallint, @parm3end smallint as
            Select * from RtgStep where KitId = @parm1 and status = @parm2
                           and StepNbr between @parm3beg and @parm3end
                        Order by KitId, StepNbr
GO
