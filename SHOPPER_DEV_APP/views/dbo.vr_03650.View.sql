USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vr_03650]    Script Date: 12/21/2015 14:33:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vr_03650] AS

SELECT v.*, cRI_ID = c.RI_ID, c.CpnyName
FROM vr_ShareAPVendorDetail v, RptCompany c
WHERE v.CpnyID = c.CpnyID
GO
