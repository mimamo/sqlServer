USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashAcct_Acct_Optional]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashAcct_Acct_Optional    Script Date: 4/7/98 12:49:20 PM ******/
---SRS 02/10/98 New PV
Create Proc [dbo].[CashAcct_Acct_Optional] @parm1 varchar ( 10), @parm2 varchar ( 10) as
Select * from CashAcct
where cpnyid like @parm1 and bankacct like @parm2
and active =  1
order by BankAcct
GO
