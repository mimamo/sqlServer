USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_EmpId_CalYr]    Script Date: 12/21/2015 16:13:21 ******/
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
