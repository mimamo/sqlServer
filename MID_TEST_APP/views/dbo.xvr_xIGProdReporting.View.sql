USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_xIGProdReporting]    Script Date: 12/21/2015 14:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_xIGProdReporting]

AS

SELECT ISNULL(xr.Rptclient, '') as 'Rptclient'
, ISNULL(xr.ClientIdentifier, '') as 'ClientIdentifier'
, ISNULL(d.CustID, '') as 'CustID'
, ISNULL(c.Name, '') as 'CustName'
, ISNULL(d.Product, '') as 'Product'
, ISNULL(cd.descr, '') as 'Description'
, ISNULL(cd.[status], '') as 'Status'
, ISNULL(xr.Brand, '') as 'Brand'
, ISNULL(xr.SubBrand, '') as 'SubBrand'
, ISNULL(xr.Channel, '') as 'Channel'
, ISNULL(xr.Retailer, '') as 'Retailer'
, ISNULL(xr.Region, '') as 'Region'
, ISNULL(CASE WHEN xr.OOS = 0 
		THEN 'False'
		ELSE 'True' end, '') as 'OOS'
, ISNULL(xr.HrsTab, '') as 'HrsTab'
, ISNULL(xr.WIPGroup, '') as 'WIPGroup'
, ISNULL(xr.Director, '') as 'Director'
, ISNULL(xr.GAD, '') as 'GAD'
, ISNULL(xr.VP, '') as 'VP'
, ISNULL(xr.SVP, '') as 'SVP'
, ISNULL(xr.CognosElistI, '') as CognosEListI
, ISNULL(xr.CognosElistII, '') as CognosEListII
, ISNULL(xr.CognosElistIII, '') as CognosEListIII
, ISNULL(xr.CognosElistIV, '') as CognosEListIV
, ISNULL(xr.CognosElistV, '') as CognosEListV
, ISNULL(xr.CognosElistVI, '') as CognosEListVI
, ISNULL(xr.FTEBrand, '') as FTEBrand
, ISNULL(xr.FTEClient, '') as FTEClient
, ISNULL(xr.UtlBM, '') as UtlBM
, ISNULL(xr.UtlCustMktA, '') as UtlCustMktA
, ISNULL(xr.UtlCustMktB, '') as UtlCustMktB
, ISNULL(xr.UtlChannel, '') as UtlChannel
, ISNULL(xr.UtlCreative, '') as UtlCreative
, ISNULL(xr.UtlKellogg, '') as UtlKellogg
, ISNULL(xr.UtlPG, '') as UtlPG
, ISNULL(xr.UtlUser1, '') as UtlUser1
, ISNULL(xr.UtlUser2, '') as UtlUser2
, ISNULL(xr.UtlUser3, '') as UtlUser3


-- SELECT *
FROM xIGProdReporting xr JOIN xProdJobDefault d ON xr.ProdID = d.Product
	LEFT JOIN Customer c ON d.CustID = c.CustId
	LEFT JOIN xIGProdCode cd ON xr.ProdID = cd.code_ID
GO
