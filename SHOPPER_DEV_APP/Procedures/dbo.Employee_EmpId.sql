USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_EmpId]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_EmpId] @parm1 varchar ( 10) as
       Select * from Employee
           where EmpId  LIKE  @parm1
           order by EmpId
GO
