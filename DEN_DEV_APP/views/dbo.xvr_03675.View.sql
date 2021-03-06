USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_03675]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[xvr_03675]

AS

SELECT t.VendId
, t.CuryTranAmt
, t.ProjectID
, t.Rlsed
, t.trantype
, t.TranDesc 
, t.TranDate
, t.PerPost
, t.FiscYr
, v.Addr1
, v.Addr2
, v.APAcct
, v.APSub
, v.Attn
, v.City
, v.ClassID
, v.Country
, v.EMailAddr
, v.ExpAcct
, v.ExpSub
, v.Fax
, v.[Name]
, v.Phone
, v.PmtMethod
, v.Salut
, v.[State]
, v.[Status]
, v.Zip
, ISNULL(p.pm_id01, 'No Client') as 'ClientID'
, ISNULL(p.pm_id02, 'No Prod') as 'ProdID'
FROM APTran t LEFT JOIN Vendor v ON t.VendId = v.VendId
	LEFT JOIN PJPROJ p ON t.ProjectID = p.project
GO
