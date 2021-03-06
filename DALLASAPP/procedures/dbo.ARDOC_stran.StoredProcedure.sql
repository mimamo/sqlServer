USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_stran]    Script Date: 12/21/2015 13:44:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[ARDOC_stran] @parm1 varchar (6)   as
select *
from  ARDOC, ARTRAN, PJ_ACCOUNT
where     ARDOC.perpost =  @parm1 and
ARDOC.rlsed =  1 and
ARDOC.pc_status =  '1' and
ARDOC.batnbr =  ARTRAN.batnbr and
ARDOC.custid =  ARTRAN.custid and
ARDOC.doctype =  ARTRAN.trantype and
ARDOC.refnbr =  ARTRAN.refnbr and
ARTRAN.pc_status <  '2' and
ARTRAN.acct = PJ_ACCOUNT.gl_acct
GO
