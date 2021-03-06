USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BankRec_LastRec]    Script Date: 12/21/2015 14:05:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BankRec_LastRec    Script Date: 4/7/98 12:49:19 PM ******/
Create Proc [dbo].[BankRec_LastRec] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 smalldatetime, @parm5 smalldatetime  as
Select * from BankRec
where bankrec.cpnyid like @parm1
and bankrec.Bankacct like @parm2
and bankrec.Banksub like @parm3
and bankrec.stmtdate between @parm4 and @parm5
Order by Bankrec.cpnyid DESC, Bankrec.BankAcct DESC, bankrec.Banksub DESC, bankrec.stmtdate desc
GO
