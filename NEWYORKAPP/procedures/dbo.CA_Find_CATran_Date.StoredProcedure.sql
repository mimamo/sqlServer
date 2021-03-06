USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[CA_Find_CATran_Date]    Script Date: 12/21/2015 16:00:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[CA_Find_CATran_Date] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10), @parm5 smalldatetime as
Select * from CATran
Where bankcpnyid like @parm1
and BankAcct like @parm2
and Banksub like @parm3
and RefNbr = @parm4
and TranDate = @parm5
and RcnclStatus = 'O'
and rlsed = 1
GO
