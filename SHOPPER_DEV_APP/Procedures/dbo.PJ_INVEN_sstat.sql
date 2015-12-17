USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_INVEN_sstat]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_INVEN_sstat] @parm1 varchar (6)   as
select *
from  PJ_INVEN, INTRAN, PJ_ACCOUNT
where PJ_INVEN.status_pa =  ' ' and
PJ_INVEN.prim_key = INTRAN.user2 and
INTRAN.perpost =  @parm1 and
INTRAN.rlsed =  1 and
INTRAN.acct = PJ_ACCOUNT.gl_acct
GO
