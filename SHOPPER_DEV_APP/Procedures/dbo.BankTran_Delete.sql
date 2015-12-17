USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BankTran_Delete]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BankTran_Delete] @parm1 varchar ( 20), @parm2 varchar ( 10), @parm3 varchar ( 10), @parm4 varchar ( 24) as
Delete from BankTran
where ImportRef like @parm1
and CpnyID like @parm2
and bankacct like @parm3
and banksub like @parm4
GO
