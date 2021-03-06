USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTRAN_spostatm]    Script Date: 12/21/2015 13:35:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[APTRAN_spostatm] as
select APTRAN.*,
       APDOC.*,
       PJ_ACCOUNT.*,
       PURCHORD.ponbr,
       PURCHORD.status
from  APTRAN, APDOC, PJ_ACCOUNT, PURCHORD
where APTRAN.pc_status = '1' and
APTRAN.rlsed = 0 and
APTRAN.lineid <> 0 and
APTRAN.refnbr   = APDOC.refnbr and
APTRAN.batnbr   = APDOC.batnbr and
APDOC.DocType   = 'VO' and
apdoc.rlsed = 0 and
apdoc.ponbr = purchord.ponbr and
purchord.status = 'M' and
APTRAN.acct     = PJ_ACCOUNT.gl_acct
order by aptran.pc_status, aptran.rlsed, aptran.jrnltype
GO
