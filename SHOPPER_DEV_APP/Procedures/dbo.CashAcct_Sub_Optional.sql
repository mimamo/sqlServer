USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashAcct_Sub_Optional]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashAcct_Sub_Optional    Script Date: 4/7/98 12:49:20 PM ******/
---SRS 02/10/98 New PV
Create Proc [dbo].[CashAcct_Sub_Optional] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24) as
Select * from CashAcct
where CpnyID like @parm1
and bankacct like @parm2
and banksub like @parm3
and active =  1
order by BankAcct, BankSub
GO
