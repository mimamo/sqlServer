USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_LE_CalYr]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_LE_CalYr] @parm1 varchar ( 4) as
       Select * from Employee
           where CalYr  <=  @parm1
           order by EmpId
GO
