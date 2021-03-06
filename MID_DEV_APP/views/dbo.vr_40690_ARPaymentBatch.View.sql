USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[vr_40690_ARPaymentBatch]    Script Date: 12/21/2015 14:17:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[vr_40690_ARPaymentBatch] As


	SELECT 	'BatNbr' = BatNbr, 'InvcNbr' = SiteID
	FROM 	ARTran
	WHERE	JrnlType = 'OM' and TranType = 'PA' and SiteID + '' <> ''

	UNION
	
	SELECT	'BatNbr' = AdjBatNbr, 'InvcNbr' = AdjdRefNbr
	FROM	ARAdjust JOIN ARDoc
	  On	ARAdjust.AdjBatnbr = ARDoc.Batnbr
	  and	ARADjust.AdjgRefNbr = ARDoc.RefNbr
	WHERE	ARDoc.DocType = 'PA' and ARDoc.Crtd_Prog = '40690'
GO
