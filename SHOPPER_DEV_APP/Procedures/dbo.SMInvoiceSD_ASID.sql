USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SMInvoiceSD_ASID]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SMInvoiceSD_ASID] @parm1 int

AS
	SELECT * FROM smInvoice WHERE ASID = @parm1 and (Doctype = 'S' and BillingType <> "M") ORDER BY asid
GO
