USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_Acct_sub_CheckSelect]    Script Date: 12/21/2015 16:00:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CATran_Acct_sub_CheckSelect   Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CATran_Acct_sub_CheckSelect] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 smalldatetime, @parm5 smalldatetime as
  Select * from CATran
  Where CpnyID like @parm1 and  BankAcct like @parm2 and Banksub like @parm3
   and ((rcnclstatus = 'O' and TranDate <= @parm5)
   or (rcnclstatus = 'C' and (TranDate <= @parm5 and ClearDate > @parm5)
   or (Trandate <= @parm4 and Trandate > @parm5)))
   and ((catran.drcr = 'D' and entryid <> 'TR') or (catran.drcr = 'C' and entryid = 'TR'))
   and  catran.rlsed =  1     and catran.entryid <> 'ZZ'
Order by Module, RefNbr, BatNbr, LineNbr
GO
