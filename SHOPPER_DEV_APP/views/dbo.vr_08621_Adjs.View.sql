USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vr_08621_Adjs]    Script Date: 12/21/2015 14:33:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_08621_Adjs] AS

SELECT	Recordid, AdjdRefNbr, AdjdDocType, CustID, AdjgRefNbr,
	AdjgDocType=CASE WHEN CuryAdjdAmt<0 AND S4Future12<>'' THEN S4Future12 ELSE AdjgDocType END,
	AdjgDocDate, PerAppl, CuryAdjdAmt, CuryAdjdDiscAmt, AdjAmt, AdjDiscAmt, RowType='A',
	DocType=AdjgDocType
FROM	ARAdjust

UNION ALL	

SELECT	-1, RefNbr, DocType, CustID, RefNbr,
	DocType,
	NULL, ' ', NULL, NULL, NULL, NULL, 'D',
	DocType
FROM	ARDoc
 WHERE Rlsed = 1
GO
