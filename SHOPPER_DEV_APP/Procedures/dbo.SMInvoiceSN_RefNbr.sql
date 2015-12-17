USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SMInvoiceSN_RefNbr]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SMInvoiceSN_RefNbr] @parm1 varchar(10)

AS
	SELECT * FROM smInvoice WHERE Refnbr LIKE @parm1 and (Doctype = 'C' or Doctype = 'M') ORDER BY Refnbr
GO
