USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_CashAcct_acct_DUP]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_CashAcct_acct_DUP] @parm1 varchar (24), @parm2 varchar (24) as
select  b.banksub from cashacct b, cashacct x where 
b.bankacct = @parm1 
and x.bankacct = @parm2 
and b.banksub = x.banksub
and b.cpnyid = x.cpnyid
GO
