USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DDDepositor_BankID]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDDepositor_BankID] @Parm1 varchar ( 6) as
    Select * from DDDepositor where BankID like @Parm1 ORDER by BankID, EmpID
GO
