USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_DfltWrkLoc]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_DfltWrkLoc] @parm1 varchar ( 6) as
       Select * from Employee
           where DfltWrkLoc  LIKE  @parm1
           order by EmpId
GO
