USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vp_08400SumARSalesTaxEntry]    Script Date: 12/21/2015 14:26:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400SumARSalesTaxEntry] AS
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
*
*    View Name: ut_show_tree
*
*++* Narrative: Creates a summary of taxable amounts and tax amounts by yrmon, company and taxid
*
*   Called by: pp_08400
*/

SELECT t.taxid,t.cpnyid,t.YrMon, 
       SUM(CASE t.DocType 
		WHEN 'IN' THEN t.TaxTot
		WHEN 'DM' THEN t.TaxTot
		ELSE (t.TaxTot * -1) 
	        END) TaxTot, 
        SUM(CASE t.DocType 
		WHEN 'IN' THEN t.TxblTot
		WHEN 'DM' THEN t.TxblTot
		ELSE (t.TxblTot * -1)
	        END) txbltot, UserAddress
  FROM Wrk_SalesTax t
 GROUP BY t.TaxID, t.cpnyid, t.YrMon, UserAddress
GO
