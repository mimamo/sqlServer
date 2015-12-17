USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashSumD_All_ordbytran]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashSumD_All_ordbytran    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CashSumD_All_ordbytran] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 smalldatetime as
Select * from CashSumD
where cpnyid like @parm1
and bankacct like @parm2
and banksub like @parm3
and TranDate >= @parm4
Order by cpnyid, BankAcct, Banksub, trandate desc, pernbr desc
GO
