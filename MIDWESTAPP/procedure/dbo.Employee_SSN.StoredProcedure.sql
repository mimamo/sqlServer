USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_SSN]    Script Date: 12/21/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_SSN] @parm1 varchar ( 9), @parm2 varchar ( 10) as
       Select * from Employee
           where SSN  =  @parm1 and empid <> @parm2
GO
