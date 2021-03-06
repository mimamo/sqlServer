USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_swebiiopen]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARDOC_swebiiopen] @parm1 varchar (16), @parm2 varchar (10), @parm3 varchar (10) as

select ardoc.refnbr, ardoc.docdate, ardoc.docbal, ardoc.opendoc, ardoc.doctype, ardoc.OrigDocAmt, customer.name, pjinvhdr.draft_num, 
pjinvhdr.end_date,
(pjinvhdr.gross_amt + pjinvhdr.other_amt + pjinvhdr.tax_amt - pjinvhdr.retention_amt - pjinvhdr.paid_amt) as Base_Amount,
(pjinvhdr.curygross_amt + pjinvhdr.curyother_amt + pjinvhdr.curytax_amt - pjinvhdr.curyretention_amt - pjinvhdr.curypaid_amt) as Cury_Amount,
ardoc.curyid
from  ardoc 
JOIN customer on ardoc.custid = customer.custid 
LEFT OUTER JOIN pjinvhdr on ardoc.refnbr = pjinvhdr.invoice_num

where  ardoc.projectid = @parm1 and
       ardoc.pc_status = '1' and
       ardoc.rlsed = 1 and
       ardoc.opendoc = 1 and
       ardoc.docbal <> 0 and
       ardoc.docdate >= @parm2 and
       ardoc.docdate <= @parm3  
       
order by ardoc.refnbr
GO
