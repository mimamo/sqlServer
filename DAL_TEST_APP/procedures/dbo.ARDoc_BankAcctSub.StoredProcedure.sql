USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_BankAcctSub]    Script Date: 12/21/2015 13:56:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_BankAcctSub    Script Date: 4/7/98 12:49:19 PM ******/
create Proc [dbo].[ARDoc_BankAcctSub] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24) as
select * from ardoc
where cpnyid = @parm1
and bankacct = @parm2
and banksub = @parm3
and Rlsed = 1
Order by Batnbr
GO
