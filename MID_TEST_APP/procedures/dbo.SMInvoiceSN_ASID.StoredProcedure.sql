USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SMInvoiceSN_ASID]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SMInvoiceSN_ASID] @parm1 int

AS
	SELECT * FROM smInvoice WHERE ASID = @parm1 and (Doctype = 'C' or Doctype = 'M') ORDER BY asid
GO
