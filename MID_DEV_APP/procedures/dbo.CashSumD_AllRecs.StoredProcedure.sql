USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashSumD_AllRecs]    Script Date: 12/21/2015 14:17:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashSumD_AllRecs    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CashSumD_AllRecs] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24) as
    Select * from CashSumD where cpnyid like @parm1 and bankacct like @parm2 and banksub like @parm3
     Order by CpnyID, BankAcct, Banksub, trandate
GO
