USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vp_SalesTax]    Script Date: 12/21/2015 14:33:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/***** Routine requires vp_SalesTaxCat, vp_SalesTaxID for it to function properly  *****/

--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vp_SalesTax] AS 

SELECT c.CatID, t.* 
FROM vp_SalesTaxCat c, vp_SalesTaxID t

WHERE  

((t.CatFlg = 'N' AND (	t.CatExcept00 = c.CatID OR 
			t.CatExcept01 = c.CatID OR 
			t.CatExcept02 = c.CatID OR 
			t.CatExcept03 = c.CatID OR
			t.CatExcept04 = c.CatID OR 
			t.CatExcept05 = c.CatID)) 
OR

(t.CatFlg = 'A' AND (	t.CatExcept00 <> c.CatID AND 
			t.CatExcept01 <> c.CatID AND 
			t.CatExcept02 <> c.CatID AND 
			t.CatExcept03 <> c.CatID AND
			t.CatExcept04 <> c.CatID AND 
			t.CatExcept05 <> c.CatID)) 
OR

(t.CatExcept00 = ' ' AND t.CatExcept01 = ' ' AND t.CatExcept02 = ' ' AND
t.CatExcept03 = ' ' AND t.CatExcept04 = ' ' AND t.CatExcept05 = ' ')

OR 

c.CatID = ' ')
GO
