USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DDEmployee_EmpID]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDEmployee_EmpID] @parm1 varchar ( 10) as
    Select * from Employee where EmpId LIKE @parm1 order by EmpId
GO
