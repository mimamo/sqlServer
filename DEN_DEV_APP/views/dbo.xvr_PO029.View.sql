USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PO029]    Script Date: 12/21/2015 14:05:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PO029]

AS

SELECT p.PONbr as 'PONumber'
, p.noteID as 'HeaderNoteID'
, sNoteText as 'HeaderNote'
, p.CuryPOAmt as  'Amount'
, p.VendID as 'VendorID'
, RTRIM(v.[Name]) as 'Vendor'
, RTRIM(v.Addr1) as 'Address1'
, RTRIM(v.Addr2) as 'Address2'
, RTRIM(v.Attn) as 'Attention'
, RTRIM(v.City) as 'City'
, RTRIM(v.State) as 'State'
, RTRIM(v.Zip) as 'Zip'
FROM PurchOrd p LEFT JOIN Snote s ON p.noteID = s.nid
	LEFT JOIN Vendor v ON p.VendID = v.VendID
GO
