USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_DfltEarnType]    Script Date: 12/21/2015 15:49:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_DfltEarnType] @parm1 varchar ( 10) as
       Select * from Employee
           where DfltEarnType  LIKE  @parm1
           order by EmpId
GO
