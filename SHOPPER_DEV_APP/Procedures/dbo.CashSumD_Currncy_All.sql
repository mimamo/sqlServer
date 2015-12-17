USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashSumD_Currncy_All]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashSumD_Currncy_All    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CashSumD_Currncy_All] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24) as
    Select * from CashSumD, Currncy where cashsumd.cpnyid like @parm1 and cashsumd.bankacct like @parm2 and cashsumd.banksub like @parm3 and Cashsumd.Curyid = Currncy.Curyid
     Order by CpnyID DESC, BankAcct DESC, Banksub DESC, trandate desc
GO
