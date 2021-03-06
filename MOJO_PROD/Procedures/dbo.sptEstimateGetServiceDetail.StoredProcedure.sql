USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetServiceDetail]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptEstimateGetServiceDetail]

	(
		@EstimateKey int
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  */

	set nocount on
	
	Select 
		s.ServiceKey,
		s.ServiceCode,
		s.Description,
		bi.WorkTypeID as BillingItemID,
		bi.WorkTypeName + ' Subtotal:' as BillingItemName,
		sum(isnull(etl.Hours, 0)) as TotalHrs,
		Sum(Round(isnull(etl.Hours, 0) * isnull(etl.Rate, 0),2)) as TotalAmt
	from 
		tService s (nolock)
		-- Must be able to show zero amounts so show all services on estimate 
		inner join tEstimateService es (nolock) on s.ServiceKey = es.ServiceKey
		-- But use outer join here since records may be missing
		left outer join tEstimateTaskLabor etl (nolock) on s.ServiceKey = etl.ServiceKey and etl.EstimateKey = @EstimateKey
		left outer join tWorkType bi (nolock) on s.WorkTypeKey = bi.WorkTypeKey
	Where
		es.EstimateKey = @EstimateKey
	Group By s.ServiceKey, s.ServiceCode, s.Description, bi.WorkTypeID, bi.WorkTypeName
	Order By 
		s.ServiceCode

	return 1
GO
