USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[CashAvgD_Period]    Script Date: 12/21/2015 16:00:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashAvgD_Period    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CashAvgD_Period] @parm1 varchar ( 10), @parm2 varchar(10), @Parm3 varchar ( 24), @parm4 varchar ( 6) as
    Select * from CashAvgD where cpnyid like @parm1 and bankacct like @parm2 and banksub like @parm3 and PerNbr like @parm4
     Order by CpnyID, BankAcct, Banksub, PerNbr
GO
