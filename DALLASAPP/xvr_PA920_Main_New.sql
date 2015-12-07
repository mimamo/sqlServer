USE [DALLASAPP]
GO

/****** Object:  View [dbo].[xvr_PA920_Main_New]    Script Date: 12/03/2015 13:30:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER view [dbo].[xvr_PA920_Main_New] as

SELECT		LTRIM(RTRIM(A.project)) AS 'Project',
			LTRIM(RTRIM(A.project_desc)) AS 'ProjectName',
			A.status_pa AS 'ProjectStatus',
			CASE
				WHEN A.alloc_method_cd IN('SEA','GEN','INT','NBIZ','NONB') THEN 0
				ELSE 1
			END AS 'JobBillable',
			LTRIM(RTRIM(A.pm_id01)) AS 'ClientCode',
			LTRIM(RTRIM(B.Name)) AS 'ClientName',
			SUBSTRING(A.project,4,3) AS 'ProductCode',
			LTRIM(RTRIM(A.pm_id02)) AS 'ProductCode2',
			LTRIM(RTRIM(C.code_value_desc)) AS 'ProductName',
			A.start_date AS 'OpenDate',
			A.pm_id08 AS 'CloseDate',
			COALESCE(Est.Amount,0) AS 'Estimate',
			COALESCE(Bill.Amount,0) - COALESCE(Pre.Amount,0) AS 'ActualsBTD',
			COALESCE(Pre.Amount,0) AS 'PrebillBal',
			COALESCE(Bill.Amount,0) AS 'TotalBTD',
			COALESCE(ArBal.Amount,0) AS 'OustandingAr',
			ROUND(COALESCE(Act.Amount,0) + COALESCE(Fee.Amount,0),2) AS 'Actuals',
			COALESCE(Hrs.Amount,0) AS 'ActualHours',
			COALESCE(Fee.Amount,0) AS 'ActualFees',
			COALESCE(Stu.Amount,0) AS 'ActualStudio',
			ROUND(COALESCE(Act.Amount,0) - COALESCE(Fee.Amount,0) - COALESCE(Stu.Amount,0) - COALESCE(Ovr.Amount,0) - COALESCE(Hrs.Amount,0),2)  AS 'ActualWIP',
			COALESCE(Ovr.Amount,0) AS 'OverUnder',
			COALESCE(PO.Amount,0) AS 'OpenPoBal',
			COALESCE([Hours].Amount,0) AS 'Hours',
			CASE
				WHEN A.alloc_method_cd IN('SEA','GEN','INT','NBIZ','NONB') OR A.status_pa = 'I' THEN 0
				ELSE ROUND((COALESCE(Est.[Amount],0) - COALESCE(Bill.[Amount],0)),2)
			END AS 'BilledVsEstimate',
			CASE
				WHEN A.alloc_method_cd IN('SEA','GEN','INT','NBIZ','NONB') THEN 0
				ELSE ROUND((COALESCE(Act.[Amount],0) + COALESCE(Fee.Amount,0) - COALESCE(Bill.[Amount],0)),2)
			END AS 'BilledVsActuals',
			CASE
				WHEN A.alloc_method_cd IN('SEA','GEN','INT','NBIZ','NONB') THEN 0
				ELSE ROUND((COALESCE(Act.[Amount],0) + COALESCE(Fee.Amount,0) + COALESCE(PO.Amount,0) - COALESCE(Bill.[Amount],0) ),2)
			END AS 'BilledVsActualsAndOpenPo',
			CASE
				WHEN A.alloc_method_cd IN('SEA','GEN','INT','NBIZ','NONB') THEN 0
				ELSE ROUND((COALESCE(Est.[Amount],0) - COALESCE(Act.[Amount],0) + COALESCE(Fee.Amount,0) - COALESCE(PO.Amount,0)),2)
			END AS 'EstimateVsActualsAndOpenPo'
FROM		PJPROJ A
			LEFT OUTER JOIN Customer B ON A.pm_id01 = B.CustId
			LEFT OUTER JOIN PJCODE C ON SUBSTRING(A.project,4,3) = C.code_value AND C.code_type = '0PRD'
			LEFT OUTER JOIN	(SELECT		project AS 'Project',
										SUM(eac_amount) AS 'Amount'
							FROM		PJPTDROL
							WHERE		Acct IN ('ESTIMATE', 'ESTIMATE TAX')
							GROUP BY	Project) AS Est ON Est.Project = A.project
			LEFT OUTER JOIN	(SELECT		project_billwith AS 'Project',
										SUM(gross_amt) AS 'Amount'
							FROM		PJINVHDR
							WHERE		inv_status = 'PO'
							GROUP BY	project_billwith) AS Bill ON Bill.Project = A.project
			LEFT OUTER JOIN	(SELECT		ProjectID AS 'Project',
										ROUND(SUM(CrAmt - DrAmt),2) AS 'Amount'
							FROM		GLTRAN
							WHERE		Acct IN ('2100', '2120')
							GROUP BY	ProjectID) AS Pre ON Pre.Project = A.project
			LEFT OUTER JOIN	(SELECT		project AS 'Project',
										ROUND(SUM(amount_01+amount_02+amount_03+amount_04+amount_05+amount_06+amount_07+amount_08+amount_09+amount_10+amount_11+amount_12+amount_13+amount_14+amount_15),2) AS 'Amount'
							FROM		PJACCT INNER JOIN PJACTROL ON PJACCT.acct = PJACTROL.acct
							WHERE		PJACCT.acct_group_cd IN ('WP')
										AND PJACTROL.acct NOT LIKE 'SEA' -- Exlcude SEA costs because allocation rules make a BILLABLE transaction for SEA entries, this was causing a double entry
							GROUP BY	project) AS Act ON Act.Project = A.project
			LEFT OUTER JOIN	(SELECT		project AS 'Project',
										ROUND(SUM(amount_01+amount_02+amount_03+amount_04+amount_05+amount_06+amount_07+amount_08+amount_09+amount_10+amount_11+amount_12+amount_13+amount_14+amount_15),2) AS 'Amount'
							FROM		PJACTROL 
							WHERE		PJACTROL.acct = 'OVER/UNDER'
							GROUP BY	project) AS Ovr ON Ovr.Project = A.project
			LEFT OUTER JOIN	(SELECT		B.ProjectID AS 'Project', ROUND(SUM(B.ExtCost-B.CostVouched),2) AS 'Amount'
							FROM		PurchOrd A LEFT OUTER JOIN PurOrdDet B ON A.PONbr = B.PONbr
							WHERE		A.Status IN ('P','O') AND B.VouchStage IN ('P','N') AND B.ProjectID IS NOT NULL AND B.ProjectID <> ''
							GROUP BY	B.ProjectID
							HAVING		ROUND(SUM(B.ExtCost-B.CostVouched),2) <> 0) AS PO ON PO.Project = A.project
			LEFT OUTER JOIN	(SELECT		A.project_billwith AS 'Project',
										ROUND(SUM(
										CASE
											WHEN B.DocType IN ('CM') THEN B.DocBal *-1
											ELSE B.DocBal
										END),2) AS 'Amount'
							FROM		pjinvhdr A INNER JOIN ARDoc B ON A.invoice_num = B.RefNbr
							WHERE		A.inv_status = 'PO' AND B.DocBal <> 0 AND A.crtd_prog <> 'IMPORT'
							GROUP BY	A.project_billwith ) AS ArBal ON ArBal.Project = A.project
			LEFT OUTER JOIN	(SELECT		project AS 'Project',
										ROUND(SUM(units_01+units_02+units_03+units_04+units_05+units_06+units_07+units_08+units_09+units_10+units_11+units_12+units_13+units_14+units_15),2) AS 'Amount'
							FROM		PJACCT INNER JOIN PJACTROL ON PJACCT.acct = PJACTROL.acct
							WHERE		PJACTROL.acct IN ('LABOR','FREELANCE')
							GROUP BY	project) AS [Hours] ON [Hours].Project = A.project
			LEFT OUTER JOIN	(SELECT		A.project AS 'Project',
										SUM(A.amount) AS 'Amount'
							FROM		PJTran A
							WHERE		A.acct IN ('RETAINER FEES','MEDIA FEES') AND A.Batch_Type = 'BI'
							GROUP BY	A.project) AS Fee ON Fee.Project = A.project
			LEFT OUTER JOIN	(SELECT		A.project AS 'Project',
										SUM(A.amount) AS 'Amount'
							FROM		PJTran A INNER JOIN PJACCT ON PJACCT.acct = A.acct
							WHERE		PJACCT.acct_group_cd IN ('WP')
										AND A.data1 IN ('WIP ST HARD COST','WIP ST HARD COST')
							GROUP BY	A.project) AS Stu ON Stu.Project = A.project
			LEFT OUTER JOIN	(SELECT		project AS 'Project',
										ROUND(SUM(amount_01+amount_02+amount_03+amount_04+amount_05+amount_06+amount_07+amount_08+amount_09+amount_10+amount_11+amount_12+amount_13+amount_14+amount_15),2) AS 'Amount'
							FROM		PJACTROL 
							WHERE		PJACTROL.acct = 'BILLABLE HOURS'
							GROUP BY	project) AS Hrs ON Hrs.Project = A.project






GO


