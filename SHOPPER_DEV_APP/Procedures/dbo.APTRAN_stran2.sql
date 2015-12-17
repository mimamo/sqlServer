USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTRAN_stran2]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[APTRAN_stran2] @parm1 varchar (6)   as
select APTRAN.*, APDOC.*, PJ_ACCOUNT.acct
from  APTRAN, APDOC, PJ_ACCOUNT
where     APTRAN.perpost =  @parm1 and
APTRAN.rlsed =  1 and
APTRAN.pc_status =  '1' and
APTRAN.refnbr =  APDOC.refnbr and
APTRAN.batnbr =  APDOC.batnbr and
APTRAN.acct =  PJ_ACCOUNT.gl_acct
GO
