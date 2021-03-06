USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_AP200_Main]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_AP200_Main]

AS

SELECT  b.BatNbr
, b.[Status]
, b.PerPost
, ad.InvcNbr
, at.ExtRefNBr
, ad.VendID
, ad.DocDate
, ad.DocType
, ad.PONbr
, at.RefNbr
, at.LineType
, at.LineID
, at.RecordID
, at.trantype
, at.LineNbr
, at.CuryTranAmt
, v.[Name]
, v.ClassID as 'PayGroup'
, v.User5 as 'MinType'
, CASE WHEN v.User5 = '00' THEN 'None'
		WHEN v.User5 = '10' THEN 'African American Woman'
		WHEN v.User5 = '11' THEN 'African American Male'
		WHEN v.User5 = '12' THEN 'Hispanic Female'
		WHEN v.User5 = '13' THEN 'Hispanic Male'
		WHEN v.User5 = '14' THEN 'Asian/Middle Eastern Female'
		WHEN v.User5 = '15' THEN 'Asian/Middle Eastern Male'
		WHEN v.User5 = '16' THEN 'Native American Female'
		WHEN v.User5 = '17' THEN 'Native American Male'
		WHEN v.User5 = '18' THEN 'Native Hawaiian Female'
		WHEN v.User5 = '19' THEN 'Native Hawaiian Male'
		WHEN v.User5 = '20' THEN 'Caucasian Woman'
		WHEN v.User5 = '02' THEN 'Miscellaneous'
		ELSE 'ERROR - Not Defined' end as Minority
, v.User2 as 'VendType'
FROM Batch b LEFT JOIN APDoc ad on b.BatNbr = ad.BatNbr
	LEFT JOIN APTran at on ad.RefNbr = at.RefNBr
		AND ad.VendID = at.VendID
		AND ad.DocType = at.TranType
	LEFT JOIN Vendor v on ad.VendID = v.VendID
WHERE b.[Status] = 'P' --Posted
	AND ad.DocType = 'VO' --Voucher
	AND at.LineType in ('N', 'S') --Invoices and PO's



/*
sp_helpindex Batch --all good
sp_helpindex APTran --missing LineType, added
sp_helpindex APDoc --all good
sp_helpindex Vendor --all good
*/
GO
