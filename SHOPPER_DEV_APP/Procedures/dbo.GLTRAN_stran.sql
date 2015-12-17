USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTRAN_stran]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[GLTRAN_stran] @parm1 varchar (6)   as
select *
from  GLTRAN, BATCH, PJ_ACCOUNT
where     GLTRAN.perpost =  @parm1 and
GLTRAN.rlsed =  1 and
GLTRAN.pc_status =  '1' and
(GLTRAN.module = 'GL' or GLTRAN.module = 'CA' or GLTRAN.module = 'TE') and
GLTRAN.batnbr =  BATCH.batnbr and
GLTRAN.module =  BATCH.module and
GLTRAN.acct = PJ_ACCOUNT.gl_acct
GO
