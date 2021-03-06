USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTRAN_sbtran]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[GLTRAN_sbtran] @parm1 varchar (6), @parm2 varchar (10), @parm3 varchar (2) as
select *
from  GLTRAN, BATCH, PJ_ACCOUNT
where
GLTRAN.perpost =  @parm1 and
GLTRAN.batnbr = @parm2 and
GLTRAN.rlsed =  1 and
GLTRAN.pc_status =  '1' and
GLTRAN.module like @parm3  and
GLTRAN.batnbr =  BATCH.batnbr and
GLTRAN.module =  BATCH.module and
GLTRAN.acct = PJ_ACCOUNT.gl_acct
GO
