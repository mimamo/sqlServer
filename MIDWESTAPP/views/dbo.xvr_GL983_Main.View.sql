USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[xvr_GL983_Main]    Script Date: 12/21/2015 15:55:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_GL983_Main]
as

SELECT p.CustId
, p.[Name]
, p.pm_id02
, p.project
, p.project_desc
, p.pjt_entity
, p.acct
, p.amount
, p.fiscalno
, p.contract_type
, p.pm_id25
, p.status_pa

, b.amount as 'bamount'
, b.project as 'bproejct'
, b.revid as 'brevid'
FROM xvr_GL983_PJTRAN p LEFT JOIN xvr_GL983_Budget b ON p.project = b.project
	AND p.pm_id25 = b.revid
GO
