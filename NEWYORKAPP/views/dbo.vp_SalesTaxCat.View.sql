USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[vp_SalesTaxCat]    Script Date: 12/21/2015 16:00:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vp_SalesTaxCat] AS 

SELECT CatId FROM SlsTaxCat

UNION

SELECT ' '
GO
