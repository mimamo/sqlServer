USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BankTran_Delete]    Script Date: 12/21/2015 14:05:57 ******/
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
