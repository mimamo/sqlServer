USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA929_InvoiceAmt]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[xvr_PA929_InvoiceAmt]
as
SELECT SUM(h.gross_amt) as 'InvoiceAmount'
, h.project_billwith as 'JobNum'
FROM PJINVHDR h 
WHERE h.inv_status = 'PO'
GROUP BY h.project_billwith
GO
