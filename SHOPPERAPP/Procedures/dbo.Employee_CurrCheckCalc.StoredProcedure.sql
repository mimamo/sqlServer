USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_CurrCheckCalc]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_CurrCheckCalc]  as
       Select EmpId from Employee
           where CurrCheckCalc = 1
GO
