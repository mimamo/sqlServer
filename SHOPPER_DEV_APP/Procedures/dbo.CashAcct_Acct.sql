USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashAcct_Acct]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashAcct_Acct    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CashAcct_Acct] @parm1 varchar ( 10), @parm2 varchar(10) as
    select * from CashAcct
     where cpnyid like @parm1 and bankacct like @parm2
    and active =  1
    order by CpnyID, BankAcct
GO
