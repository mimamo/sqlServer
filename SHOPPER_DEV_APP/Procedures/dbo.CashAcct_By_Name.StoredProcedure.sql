USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashAcct_By_Name]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashAcct_By_Name    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CashAcct_By_Name] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 varchar ( 4) as
    select * from CashAcct, Currncy
    where cpnyid like @parm1 and bankacct like @parm2 and banksub like @parm3 and CashAcct.curyid like @parm4
    and active =  1 and cashacct.curyid = currncy.curyid
     order by CpnyID, BankAcct, Banksub
GO
