USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vEstimateApproved]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vEstimateApproved]
AS

/*
|| When      Who Rel      What
|| 4/21/10   GHL 10.5.2.2 Update because we made changes to tEstimate 
||                        Should be part of the build
|| 12/17/14  GHL 10.5.8.7 Added DateApproved for new app estimate dashboard 
|| 12/26/14  GHL 10.5.8.7 Added Entity and EntityKey to facilitate some queries
*/

SELECT 	
	
	*,

	CASE 
		WHEN	((ISNULL(ExternalApprover, 0) > 0 AND ExternalStatus = 4) 
			Or	 (ISNULL(ExternalApprover, 0) = 0 AND InternalStatus = 4)) THEN 1
		ELSE 0
	END AS Approved

	,CASE
        WHEN ISNULL(ExternalApprover, 0) > 0 AND ExternalStatus = 4 AND ExternalApproval is not null THEN ExternalApproval
        WHEN ISNULL(ExternalApprover, 0) = 0 AND InternalStatus = 4 AND InternalApproval is not null THEN InternalApproval
        ELSE NULL
     END AS DateApproved
	
	,CASE WHEN ProjectKey > 0 then ProjectKey 
		  WHEN LeadKey >0 then LeadKey
		  WHEN CampaignKey >0 then CampaignKey
		  ELSE ProjectKey
	END as EntityKey
	 
	 ,CASE WHEN ProjectKey > 0 then 'tProject' 
		  WHEN LeadKey >0 then 'tLead'
		  WHEN CampaignKey >0 then 'tCampaign'
		  ELSE 'tProject'
	END as Entity
	
FROM	tEstimate (NOLOCK)
GO
