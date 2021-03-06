USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTRAN_spot]    Script Date: 12/21/2015 15:36:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[APTRAN_spot]
as
select *
from  APTRAN, APDOC, PJ_ACCOUNT
where     APTRAN.pc_status = '1' and
APTRAN.rlsed     = 0 and
APTRAN.JrnlType = 'PO' and
APTRAN.refnbr   = APDOC.refnbr and
APTRAN.batnbr   = APDOC.batnbr and
APDOC.DocType   = 'VO' and
APTRAN.acct     = PJ_ACCOUNT.gl_acct
GO
