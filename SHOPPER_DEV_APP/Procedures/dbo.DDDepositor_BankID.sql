USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DDDepositor_BankID]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDDepositor_BankID] @Parm1 varchar ( 6) as
    Select * from DDDepositor where BankID like @Parm1 ORDER by BankID, EmpID
GO
