USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_CashAcct_sub_DUP]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_CashAcct_sub_DUP]  @parm1 varchar (24), @parm2 varchar (24) as
select  b.bankacct from cashacct b, cashacct x where 
b.banksub = @parm1 
and x.banksub = @parm2 
and b.bankacct = x.bankacct
and b.cpnyid = x.cpnyid
GO
