USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vp_03400RGOL]    Script Date: 12/21/2015 14:33:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_03400RGOL] AS

SELECT c.BatNbr, c.RefNbr , cDocType=min(c.doctype), t.CuryAdjdCuryId,
	cRGOLAmt = sum(convert(dec(28,3),t.curyrgolamt) * CASE WHEN t.AdjdDocType = 'AD' THEN -1 ELSE 1  END), d.cpnyid, w.UserAddress

 FROM APDoc d, APAdjust t, WrkRelease w, APDoc c
CROSS JOIN GLSetup g 
WHERE t.AdjBatNbr = w.BatNbr AND d.RefNbr = t.AdjdRefNbr AND w.Module = 'AP' AND
	d.DocType = t.AdjdDocType AND 
	((d.CuryID <> c.CuryID OR d.CuryRate <> c.CuryRate) OR (d.CuryID = c.CuryID AND c.CuryID <> g.BaseCuryID)) 
	AND 
	c.BatNbr = w.BatNbr AND c.BatNbr = t.AdjBatNbr AND c.RefNbr = t.AdjgRefNbr AND c.DocType = t.AdjgDocType
GROUP BY c.BatNbr, c.RefNbr, t.CuryAdjdCuryId, d.cpnyid, w.UserAddress
GO
