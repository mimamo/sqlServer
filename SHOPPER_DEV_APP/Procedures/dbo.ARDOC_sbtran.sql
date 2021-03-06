USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_sbtran]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[ARDOC_sbtran] @parm1 varchar (6), @parm2 varchar (10)   as
select *
from  ARDOC, ARTRAN, PJ_ACCOUNT
where     ARDOC.perpost =  @parm1 and
ARDOC.batnbr = @parm2 and
ARDOC.rlsed =  1 and
ARDOC.pc_status =  '1' and
ARDOC.batnbr =  ARTRAN.batnbr and
ARDOC.custid =  ARTRAN.custid and
ARDOC.doctype =  ARTRAN.trantype and
ARDOC.refnbr =  ARTRAN.refnbr and
ARTRAN.pc_status <  '2' and
ARTRAN.acct = PJ_ACCOUNT.gl_acct
GO
