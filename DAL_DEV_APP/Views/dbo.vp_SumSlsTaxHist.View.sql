USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vp_SumSlsTaxHist]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***** Last Modified by DCR on 03/11/99 at 3:30PM *****/

--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vp_SumSlsTaxHist] AS

select  t.CpnyID, TaxID = t.taxid, YrMon = t.yrmon, TotTaxPaid = SUM(CASE t.DocType 

                WHEN 'VO' THEN (t.TaxTot)
                WHEN 'AC' THEN (t.TaxTot)
                ELSE (t.TaxTot * -1) 
        END), TxblPurchTot = SUM(CASE t.DocType 
                WHEN 'VO' THEN (t.TxblTot)
                WHEN 'AC' THEN (t.TxblTot)
                ELSE (t.TxblTot * -1)
        END), UserAddress = t.UserAddress
FROM  Wrk_SalesTax t
group by t.CpnyID, t.taxid,t.YrMon,  t.UserAddress
GO
