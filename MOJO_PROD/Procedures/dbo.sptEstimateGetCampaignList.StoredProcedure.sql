USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetCampaignList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetCampaignList]
	@CampaignKey int
AS

/*
|| When      Who Rel      What
|| 2/4/10    CRG 10.5.1.8 This is a copy of sptEstimateGetList but for CampaignKey
|| 10/4/10   GHL 10.537   (93748) Using now summary fields in tEstimate instead of recalculating 
||                        fields are calculated in sptEstimateTaskRollupDetail
|| 03/09/15  GHL 10.590   Added new estimate types by title for Abelson Taylor
*/
	
		SELECT 
			e.*,
			e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName,			  
			e.LaborGross as Labor,
			e.ContingencyTotal as ContingencyAmt,
			e.ExpenseNet as Net,
			e.ExpenseGross as Gross,

			e.TaxableTotal as Taxes,

			isnull(e.TaxableTotal,0) + isnull(e.LaborGross,0) + isnull(e.ExpenseGross,0) + isnull(e.ContingencyTotal, 0) as Total,

			Case 
				when ((isnull(ExternalApprover, 0) > 0 and  ExternalStatus = 4) Or (isnull(ExternalApprover, 0) = 0 and  InternalStatus = 4))
				then 1
				else 0
			End as Approved,
			
			CASE ChangeOrder
				WHEN 1 THEN 'CO'
				ELSE 'Est'
			END AS Type	,
			
			CASE InternalStatus
				WHEN 1 THEN 'Not Sent'
				WHEN 2 THEN 'Sent'
				WHEN 3 THEN 'Rejected'
				WHEN 4 THEN 'Approved'
				ELSE 'Not Sent'
			END AS InternalApprovalStatus,
			
			CASE 
				WHEN ISNULL(ExternalApprover, 0) = 0 THEN 'N/A'
				ELSE
					CASE ExternalStatus
						WHEN 1 THEN 'Not Sent'
						WHEN 2 THEN 'Sent'
						WHEN 3 THEN 'Rejected'
						WHEN 4 THEN 'Approved'
						ELSE 'Not Sent'
					END 
			END AS ExternalApprovalStatus,
			
			ia.FirstName + ' ' + ia.LastName as InternalApproverName,
			ea.FirstName + ' ' + ea.LastName as ExternalApproverName,
			CASE e.EstType
				WHEN 1 THEN 'By Task Only'
				WHEN 2 THEN 'By Task and Service'
				WHEN 3 THEN 'By Task and Person'
				WHEN 4 THEN 'By Service Only'
				WHEN 5 THEN 'By Segment and Service'
				WHEN 6 THEN 'By Project Only'
				WHEN 7 THEN 'By Title Only'
				WHEN 8 THEN 'By Segment and Title'

			END AS EstTypeDesc
		FROM tEstimate e (nolock)
			left outer join tUser ia (nolock) on e.InternalApprover = ia.UserKey
			left outer join tUser ea (nolock) on e.ExternalApprover = ea.UserKey
		WHERE
			e.CampaignKey = @CampaignKey
		ORDER BY 
			 EstimateName asc, e.Revision desc
GO
