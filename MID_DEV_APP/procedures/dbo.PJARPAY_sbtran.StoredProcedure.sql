USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJARPAY_sbtran]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJARPAY_sbtran] @parm1 varchar (1) , @parm2 varchar (6), @parm3 varchar (10)   as
	Select PJARPAY.custid, PJARPAY.doctype, PJARPAY.check_refnbr, PJARPAY.applied_amt,
		PJARPAY.discount_amt, PJARPAY.invoice_refnbr, PJARPAY.invoice_type, PJARPAY.status,
		ARDOC.bankacct, ARDOC.banksub, ARDOC.batnbr, ARDOC.cpnyid, ARDOC.custid, ARDOC.docdate,
		ARDOC.doctype, ARDOC.perpost, ARDOC.refnbr, ARDOC.rlsed, inv.projectid, inv.pc_status, Inv.BankAcct, Inv.BankSub
	From PJARPAY, ARDOC, ARDOC inv
	Where
		PJARPAY.status = @parm1 and
		PJARPAY.doctype <> 'CM' and
		PJARPAY.custid = ARDOC.custid and
		PJARPAY.doctype  = ARDOC.doctype  and
		PJARPAY.check_refnbr = ARDOC.refnbr and
		ARDOC.rlsed =  1 and
		ARDOC.perpost = @parm2 and
		ARDOC.batnbr = @parm3 and
		PJARPAY.custid = INV.custid and
		PJARPAY.invoice_type  = INV.doctype  and
		PJARPAY.invoice_refnbr = INV.refnbr and
		INV.pc_status = '1'
	Order by PJARPAY.custid, PJARPAY.doctype, PJARPAY.check_refnbr
GO
