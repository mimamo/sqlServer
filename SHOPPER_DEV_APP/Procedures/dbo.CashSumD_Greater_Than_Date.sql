USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashSumD_Greater_Than_Date]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashSumD_Greater_Than_Date    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CashSumD_Greater_Than_Date] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 smalldatetime, @parm4 varchar ( 10) as
Select * from CashSumD
where cpnyid like @parm4
and bankacct like @parm1
and banksub like @parm2
and trandate > @parm3
Order by cpnyid, BankAcct, Banksub, trandate
GO
