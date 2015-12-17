USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BankRec_Specific_Acct]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BankRec_Specific_Acct    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[BankRec_Specific_Acct] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 smalldatetime  as
Select * from BankRec
where CpnyID like @parm1
and Bankacct like @parm2
and Banksub like @parm3
and stmtdate = @parm4
Order by CpnyID, BankAcct, Banksub, stmtdate
GO
