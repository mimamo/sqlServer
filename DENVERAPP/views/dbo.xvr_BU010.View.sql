USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_BU010]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Created by APATTEN on 3/18/10 for Umbrella Jobs Report
CREATE View [dbo].[xvr_BU010]

AS

SELECT a.UMBJob
, a.RelatedJob
, IsNull(a.RevID, 'NONE') as 'RevID'
, IsNull(a.Estimate, 0) as 'Estimate'
, CASE WHEN right(LTRIM(RTRIM(a.RelatedJob)),3) = 'UMB'
		THEN IsNull(a.Estimate, 0)
		ELSE IsNull(a.Estimate, 0) * -1 end as 'RunningTotal'
, PU.manager1 as 'UMBPMID'
, PR.Manager1 as 'RelatedPMID'
, PU.status_pa as 'UMBStatus'
, PR.status_pa as 'RelatedStatus'
, PU.Purchase_Order_Num as 'UMBPONum'
, PR.Purchase_Order_Num as 'RelatedPONum'
, PU.Project_Desc as 'UMBJobDesc'
, PR.Project_desc as 'RelatedJobDesc'
, PU.pm_id01 as 'UMBClientID'
, PR.pm_id01 as 'RelatedClientID'
, PU.pm_id02 as 'UMBProdID'
, PR.pm_id02 as 'RelatedProdID'
, UMBCust.Name as 'UMBClient'
, RltCust.Name as 'RelatedClient'
, UMBProd.descr as 'UmbProd'
, RltProd.Descr as 'RelatedProd'
FROM (SELECT UMB.Project AS 'UMBJob'
		, UMB.Project as 'RelatedJob'
		--, UMB.Status_PA as 'Status'
		, RC.RevID
		, Sum(Amount) as 'Estimate'
		FROM(SELECT p.Project
				--, p.Status_pa
				, ex.pm_id25
				FROM PJPROJ p JOIN PJPROJEX ex on p.project = ex.project
				WHERE p.project like '%UMB') UMB LEFT JOIN PJREVCAT RC on umb.project = RC.Project 
					AND umb.pm_ID25 = RC.RevID 
				GROUP BY UMB.Project, RC.RevID) a JOIN PJPROJ PU on a.UMBJob = PU.Project
				JOIN PJPROJ PR on a.RelatedJob = PR.Project
				LEFT JOIN Customer UMBCust on PU.pm_id01 = UMBCust.CustId
				LEFT JOIN Customer RltCust on PR.pm_id01 = RltCust.CustId
				LEFT JOIN xIGProdCode UMBProd on PU.pm_id02 = UMBProd.code_id
				LEFT JOIN xIGProdcode RltProd on PR.pm_id02 = RltProd.code_id

UNION ALL

SELECT a.UmbJob
, a.RelatedJob
, IsNull(a.RevID, 'NONE') as 'RevID'
, IsNull(a.Estimate, 0) as 'Estimate'
, CASE WHEN right(LTRIM(RTRIM(a.RelatedJob)),3) = 'UMB'
		THEN IsNull(a.Estimate,0)
		ELSE IsNull(a.Estimate, 0) * -1 end as 'RunningTotal'
, PU.manager1 as 'UMBPMID'
, PR.Manager1 as 'RelatedPMID'
, PU.status_pa as 'UMBStatus'
, PR.status_pa as 'RelatedStatus'
, PU.Purchase_Order_Num as 'UMBPONum'
, PR.Purchase_Order_Num as 'RelatedPONum'
, PU.Project_Desc as 'UMBJobDesc'
, PR.Project_desc as 'RelatedJobDesc'
, PU.pm_id01 as 'UMBClientID'
, PR.pm_id01 as 'RelatedClientID'
, PU.pm_id02 as 'UMBProdID'
, PR.pm_id02 as 'RelatedProdID'
, UMBCust.Name as 'UMBClient'
, RltCust.Name as 'RelatedClient'
, UMBProd.descr as 'UmbProd'
, RltProd.Descr as 'RelatedProd'
FROM(SELECT Right(LTRIM(RTRIM(Replace(Replace(Replace(PJPROJ.pm_id32, '-' ,''), ' ',''), '/', ''))), 11) AS 'UMBJob'
	, PJPROJ.Project as 'RelatedJob'
	--, PJPROJ.status_pa AS 'Status'
	, CASE WHEN ex.pm_id25 = '    ' 
			THEN 'NONE'
			ELSE ex.pm_id25 end as 'RevID'
	, RJob.RelatedEst as 'Estimate'
	FROM PJPROJ JOIN PJPROJEX ex on PJPROJ.Project = ex.Project
		LEFT JOIN (SELECT RC.Project
					, RC.RevId
					, Sum(RC.Amount) as 'RelatedEst' 
					FROM PJPROJEX ex JOIN PJREVCAT RC ON ex.Project = RC.Project 
						AND ex.pm_id25 = RC.RevID
					GROUP BY RC.Project, RC.RevID) RJob ON ex.Project = RJob.Project 
						AND ex.pm_id25 = RJob.RevId
	WHERE pm_ID32 like '%UMB'
		AND PJPROJ.Contract_Type <> 'APS') a JOIN PJPROJ PU on a.UMBJob = PU.Project
			JOIN PJPROJ PR on a.RelatedJob = PR.Project
			LEFT JOIN Customer UMBCust on PU.pm_id01 = UMBCust.custID
			LEFT JOIN Customer RltCust on PR.pm_id01 = RltCust.CustId
			LEFT JOIN xIGProdCode UMBProd on PU.pm_id02 = UMBProd.code_id
			LEFT JOIN xIGProdcode RltProd on PR.pm_id02 = RltProd.code_id
GO
