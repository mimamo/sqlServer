USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDOC_SCHECK2]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APDOC_SCHECK2] @parm1 varchar (10) , @parm2 varchar (10)   as
select   COUNT(*)
from     apdoc, apadjust, apdoc apdoc2, pjpayhdr, pjsubcon
where
apdoc.batnbr         =  apadjust.adjbatnbr  and
apdoc.refnbr         =  apadjust.adjgrefnbr and
apadjust.vendid      =  apdoc2.vendid       and
apadjust.adjddoctype =  apdoc2.doctype      and
apadjust.adjdrefnbr  =  apdoc2.refnbr       and
APDoc2.BATNBR        =  PJPAYHDR.BATNBR     and
APDoc2.REFNBR        =  PJPAYHDR.REFNBR     and
PJPAYHDR.PROJECT     = PJSUBCON.PROJECT     and
PJPAYHDR.SUBCONTRACT = PJSUBCON.SUBCONTRACT and
apdoc.doctype        =  'CK'                and
apdoc.status         <> 'V'                 and
apdoc.refnbr         <> ''                  and
apdoc.refnbr between @parm1 and @parm2
GO
