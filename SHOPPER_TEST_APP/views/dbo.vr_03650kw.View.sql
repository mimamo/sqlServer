USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[vr_03650kw]    Script Date: 12/21/2015 16:06:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vr_03650kw] AS

SELECT v.*, cRI_ID = c.RI_ID, c.CpnyName
FROM vr_ShareAPVendorDetailKW v, APDoc d, RptCompany c
WHERE d.DocBal <> 0 AND v.Parent = d.RefNbr AND v.ParentType = d.DocType
	AND v.CpnyID = c.CpnyID
GO
