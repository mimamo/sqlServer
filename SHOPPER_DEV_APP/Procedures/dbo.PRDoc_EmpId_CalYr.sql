USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_EmpId_CalYr]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRDoc_EmpId_CalYr] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Select * from PRDoc
           where EmpId  =  @parm1
             and CalYr  =  @parm2
           order by EmpId,
                    CalYr
GO
