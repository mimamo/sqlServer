USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenEmp_EmpId_BenId]    Script Date: 12/21/2015 14:17:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenEmp_EmpId_BenId] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Select * from BenEmp
           where EmpId  =     @parm1
             and BenId  LIKE  @parm2
           order by EmpId,
                    BenId
GO
