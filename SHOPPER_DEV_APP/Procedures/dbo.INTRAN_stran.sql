USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTRAN_stran]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[INTRAN_stran] @parm1 varchar (6)   as
select INTRAN.*, PJ_ACCOUNT.*, INVENTORY.descr
from   INTRAN, PJ_ACCOUNT, INVENTORY
where INTRAN.pc_status = '1' and
INTRAN.perpost =  @parm1 and
INTRAN.rlsed =  1 and
( (INTRAN.jrnltype = 'IN' and INTRAN.acct = PJ_ACCOUNT.gl_acct)
   or
  (INTRAN.jrnltype = 'OM' and INTRAN.trantype <> 'CG' and INTRAN.cogsacct = PJ_ACCOUNT.gl_acct) ) and
INTRAN.invtid = INVENTORY.invtid
GO
