USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_KitId_StepNbr]    Script Date: 12/21/2015 13:35:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgStep_KitId_StepNbr] @parm1 varchar ( 30), @parm2beg varchar (5), @parm2end varchar (5) as
            Select * from RtgStep where KitId = @parm1
                           and StepNbr between @parm2beg and @parm2end
                        Order by KitId, StepNbr
GO
