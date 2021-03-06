USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_Active]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Employee_Active] @parm1 varchar ( 10) as
Select count(empid) from Employee
where Status = "A" and Empid <> @parm1 and (PayType <> "H" or (PayType = "H" and EXISTS
(select * from PRTran where PRTran.Empid = Employee.Empid and PRTran.paid = 0 and PRTran.TimeShtFlg <> 0)))
GO
