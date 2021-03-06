USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_0826_TO_PJARPAY]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_0826_TO_PJARPAY]  @CustId varchar(15), @doctype varchar(2), @check_refnbr varchar(10), @invoice_refnbr varchar(10), @invoice_type varchar(2), @lupd_datetime smalldatetime, @applied_amt float as
declare @numrecs int
SELECT @numrecs =  count(*) from pjarpay where
CustId = @custid 
and doctype = @doctype
and check_refnbr = @check_refnbr 
and invoice_refnbr = @invoice_refnbr
and invoice_type  = @invoice_type
and lupd_datetime = @lupd_datetime
and applied_amt = @applied_amt
if @numrecs >0  
    BEGIN
	delete from pjarpay where CustId = @custid and doctype = @doctype and check_refnbr = @check_refnbr  and invoice_refnbr = @invoice_refnbr and invoice_type  = @invoice_type and lupd_datetime = @lupd_datetime and applied_amt = @applied_amt
    END
GO
