USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_EmpId_CpnyId]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_EmpId_CpnyId] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Select * from Employee
           where CpnyId LIKE  @parm1
             and EmpId  LIKE  @parm2
           order by EmpId
GO
