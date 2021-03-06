USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[CaTran_TranDate_EntryID]    Script Date: 12/21/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CaTran_TranDate_EntryID    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CaTran_TranDate_EntryID] @parm1 varchar ( 10), @parm2 varchar ( 10), @Parm3 varchar ( 24), @parm4 smalldatetime as
Select * from CaTran
where (cpnyid like @parm1 or trsftocpnyid like @parm1)
and bankacct like @parm2
and banksub like @parm3
and trandate = @parm4
and rlsed = 1
order by cpnyid DESC, BankAcct DESC, Banksub DESC, trandate DESC, batnbr DESC, EntryID DESC
GO
