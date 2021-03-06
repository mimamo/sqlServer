USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashSumD_Date]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashSumD_Date    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CashSumD_Date] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 smalldatetime, @parm5 smalldatetime as
    Select * from CashSumD where cpnyid like @parm1 and bankacct like @parm2 and banksub like @parm3
     and (trandate >= @parm4 and trandate <= @parm5)
     Order by Cpnyid, BankAcct, Banksub, trandate
GO
