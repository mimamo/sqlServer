USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_EmpId]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_EmpId] @parm1 varchar ( 10) as
       Select * from Employee
           where EmpId  LIKE  @parm1
           order by EmpId
GO
