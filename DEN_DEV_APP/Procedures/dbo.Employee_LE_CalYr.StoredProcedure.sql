USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_LE_CalYr]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_LE_CalYr] @parm1 varchar ( 4) as
       Select * from Employee
           where CalYr  <=  @parm1
           order by EmpId
GO
