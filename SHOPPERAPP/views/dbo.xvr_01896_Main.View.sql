USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[xvr_01896_Main]    Script Date: 12/21/2015 16:12:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_01896_Main]

as
-- WIP Recon
SELECT RI_ID
, Ledger
, SRC
, ClientID
, Client
, FiscalNo
, ProductID
, Product
, JobID
, Job
, Amount
, '' as 'trans_date'
FROM xwrk_WIPRecon

UNION ALL

-- WIP Aging 
SELECT a.RI_ID 
, '' as Ledger
, 'WA' as SRC
, a.pm_id01 as 'ClientID'
, a.[Name] as 'Client'
, r.BegPerNbr as 'FiscalNo'
, a.code_ID as 'ProductID'
, a.descr as 'Product'
, a.project as 'JobID'
, a.project_desc as 'Job' 
, a.amount as 'Amount'
, a.source_trx_date
FROM xwrk_BI902 a JOIN rptRuntime r ON a.RI_ID = r.RI_ID
WHERE Bill_Status <> 'B'
	AND li_type NOT IN ('A', 'D')
GO
