USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SMInvoiceSD_RefNbr]    Script Date: 12/21/2015 14:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SMInvoiceSD_RefNbr] @parm1 varchar(10)

AS
	SELECT * FROM smInvoice WHERE Refnbr LIKE @parm1 and (Doctype = 'S' and BillingType <> "M") ORDER BY Refnbr
GO
