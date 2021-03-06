USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDOC_SCHECK]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APDOC_SCHECK] @parm1 varchar (10)   as
select
apdoc.batnbr,
apdoc.DocDate,
apdoc.invcnbr,
apdoc.origdocamt,
apdoc.refnbr,
apdoc.status,
apdoc.vendid,
pjpayhdr.batnbr,
pjpayhdr.invoice_date,
pjpayhdr.payreqnbr,
pjpayhdr.project,
pjpayhdr.py_id15,
pjpayhdr.refnbr,
pjpayhdr.subcontract,
pjpayhdr.vendid,
pjpayhdr.vendor_invref,
pjsubcon.project,
pjsubcon.su_id12,
pjsubcon.su_id13,
pjsubcon.subcontract,
pjsubcon.subcontract_desc
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
apdoc.refnbr like @parm1
order by apdoc.refnbr,
apdoc.doctype
GO
