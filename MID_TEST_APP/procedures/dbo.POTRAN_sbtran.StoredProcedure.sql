USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POTRAN_sbtran]    Script Date: 12/21/2015 15:49:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[POTRAN_sbtran] @parm1 varchar (6), @parm2 varchar (10)   as
select *
from  POTRAN, PJ_ACCOUNT, PORECEIPT
where  POTRAN.perpost =  @parm1 and
POTRAN.batnbr = @parm2 and
POTRAN.pc_status =  '1' and
POTRAN.acct =  PJ_ACCOUNT.gl_acct and
POTran.rcptnbr = POReceipt.rcptnbr and
POReceipt.rlsed = 1
GO
