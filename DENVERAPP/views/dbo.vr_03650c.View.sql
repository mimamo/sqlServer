USE [DENVERAPP]
GO
/****** Object:  View [dbo].[vr_03650c]    Script Date: 12/21/2015 15:42:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

/****** Last Modified by DCR on 9/17/98 ******/

CREATE VIEW [dbo].[vr_03650c] AS

SELECT v.*, cRI_ID = c.RI_ID, c.CpnyName
FROM vr_ShareAPVendorDetail v, APDoc d, RptCompany c
WHERE (d.DocBal <> 0 OR (v.docbal <> 0 and v.doctype = 'PP') OR (v.doctype not in ('CK', 'HC', 'ZC') and  v.PerClosed = (SELECT PerNbr FROM APSetup (NOLOCK))) OR (v.DocType in ("CK","HC","ZC") AND
	v.PerPost = (SELECT PerNbr FROM APSetup (NOLOCK)))) AND v.Parent = d.RefNbr AND v.ParentType = d.DocType
	AND v.CpnyID = c.CpnyID
GO
