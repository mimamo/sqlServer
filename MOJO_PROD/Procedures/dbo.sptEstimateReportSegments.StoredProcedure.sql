USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateReportSegments]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateReportSegments]
	(
	@EstimateKey int
	)
AS --Encrypt
	SET NOCOUNT ON

/*
|| When      Who Rel      What
|| 09/02/10  GHL 10.5.3.4 Creation for estimate report  
||                        Retrieve LaborGross, ExpenseGross for each segment
||                        Will be displayed depending on Breakout expenses
*/

	declare @ApprovedQty int

	select @ApprovedQty = ApprovedQty
	from   tEstimate (nolock)
	where  EstimateKey = @EstimateKey

	select cs.DisplayOrder, cs.SegmentName, cs.SegmentDescription
	       , grouped_estimate.*
	       , grouped_estimate.LaborGross +  grouped_estimate.ExpenseGross as TotalGross 
	from
		( 

		select CampaignSegmentKey, Sum(LaborGross) as LaborGross, Sum(ExpenseGross) as ExpenseGross
	
		from
	
			(
			select CampaignSegmentKey
				   , isnull(Hours, 0) * isnull(Rate, 0) as LaborGross
				   , 0 as ExpenseGross 
			from   tEstimateTaskLabor (nolock)
			where  EstimateKey = @EstimateKey  

			union all

			select CampaignSegmentKey
				 , 0 as LaborGross
				 ,case when @ApprovedQty = 1 then BillableCost
					 when @ApprovedQty = 2 then BillableCost2
					 when @ApprovedQty = 3 then BillableCost3
					 when @ApprovedQty = 4 then BillableCost4
					 when @ApprovedQty = 5 then BillableCost5
					 when @ApprovedQty = 6 then BillableCost6
				 end as ExpenseGross

			from   tEstimateTaskExpense (nolock)
			where  EstimateKey = @EstimateKey  
			)

		as estimate

		group by CampaignSegmentKey
		)
		 
		as grouped_estimate

       inner join tCampaignSegment cs (nolock) on grouped_estimate.CampaignSegmentKey = cs.CampaignSegmentKey 	

		where LaborGross + ExpenseGross <> 0
 
	   order by cs.DisplayOrder

	RETURN 1
GO
