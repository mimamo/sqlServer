USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateServiceGetLaborList]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateServiceGetLaborList]
	(
	@EstimateKey INT
	)
AS -- Encrypt

 /*
  || When     Who Rel	  What
  || 04/02/09 GHL 10.022  (50356) Added DISTINCT to eliminate duplicate tEstimateTaskLabor recs
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  */
  
	SET NOCOUNT ON

	Select  DISTINCT
			CASE 
				WHEN wt.WorkTypeKey IS NULL THEN '[No Billing Item]'
				ELSE ISNULL(wt.WorkTypeID, '') + ' - ' + ISNULL(wt.WorkTypeName, '') 
			END
			AS BillingItemFullDescription  
		   ,ISNULL(s.ServiceCode, '') + ' - ' + ISNULL(s.Description, '') AS FullDescription  
		   ,es.*	     		
		   ,ISNULL(etl.Hours, 0) AS Hours
		   ,ROUND(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2) As Gross	
		   ,s.Description
	From  tEstimateService es (nolock) 
	Inner Join tService s (NOLOCK) On es.ServiceKey = s.ServiceKey
	Left Outer Join tWorkType wt (NOLOCK) On s.WorkTypeKey = wt.WorkTypeKey
	Left Outer Join tEstimateTaskLabor etl (NOLOCK) 
		On es.EstimateKey = etl.EstimateKey And es.ServiceKey = etl.ServiceKey
	Where es.EstimateKey = @EstimateKey
	Order By s.Description
			
	RETURN 1
GO
