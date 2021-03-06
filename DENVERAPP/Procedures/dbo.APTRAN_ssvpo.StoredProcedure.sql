USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APTRAN_ssvpo]    Script Date: 12/21/2015 15:42:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[APTRAN_ssvpo] @parm1 varchar (10) , @parm2 varchar (05)   as
SELECT *
FROM      APDOC, APTRAN, PJ_ACCOUNT
WHERE     APDOC.PONbr   =  @parm1 and
APTRAN.batnbr =  APDOC.batnbr and
APTRAN.refnbr =  APDOC.refnbr and
APTRAN.POLineRef =  @parm2 and
APTRAN.rlsed  =  1 and
APTRAN.pc_status  =  '2' and
APTRAN.acct = PJ_ACCOUNT.gl_acct
GO
