USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_Name]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[Employee_Name] @parm1 varchar ( 10) as
    Select Name from Employee where EmpID = @parm1
GO
