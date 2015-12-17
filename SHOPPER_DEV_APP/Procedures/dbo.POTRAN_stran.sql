USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POTRAN_stran]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[POTRAN_stran] @parm1 varchar (6)   as
select *
from  POTRAN, PJ_ACCOUNT, PORECEIPT
where  POTRAN.perpost =  @parm1 and
POTRAN.pc_status =  '1' and
POTRAN.acct =  PJ_ACCOUNT.gl_acct and
POTran.rcptnbr = POReceipt.rcptnbr and
POReceipt.rlsed = 1
GO
