USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastGetBalloonData]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastGetBalloonData]
	(
	@ForecastDetailKey int
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/23/12  GHL 10.5.6.1 Created for revenue forecasting
|| 11/1/12   GHL 10.5.6.1 Added project entities
|| 11/6/12   GHL 10.5.6.2 Added retainer entity
|| 12/01/14  GAR 10.5.8.6 (230762) Added code to pull gross, net, and profit instead of just profit.
*/
	SET NOCOUNT ON

	declare @Entity varchar(50)
	declare @EntityKey int
	declare @FromEstimate int

	select @Entity = Entity 
		  ,@EntityKey = EntityKey
	      ,@FromEstimate = FromEstimate
	from   tForecastDetail (nolock)
	where  ForecastDetailKey = @ForecastDetailKey

	if @Entity in ( 'tLead', 'tProject-Approved', 'tProject-Potential' )
		-- cannot get estimate total from tEstimate.EstimateTotal because some tasks may be missing (out of forecast range)
		create table #estimate (EstimateKey int null
		, EstimateNumber varchar(100) null
		, EstimateName varchar(200) null
		, EstimateType varchar(50) null
		, EstimateTotalGross money null
		, EstimateTotalNet money null
		, EstimateTotal money null)

	if @FromEstimate = 1
	begin
		insert #estimate(EstimateKey)
		select distinct EstimateKey from 
			( 
			-- tForecastDetailItem.EntityKey = EstimateKey
			select EntityKey as EstimateKey 
			from   tForecastDetailItem (nolock) 
			where  ForecastDetailKey = @ForecastDetailKey
			and    Entity = 'tEstimateTaskLabor'	
	
			union

			-- tForecastDetailItem.EntityKey = EstimateTaskExpenseKey
			select ete.EstimateKey 
			from   tForecastDetailItem fdi (nolock)
				inner join tEstimateTaskExpense ete (nolock) on fdi.EntityKey = ete.EstimateTaskExpenseKey 
			where  fdi.ForecastDetailKey = @ForecastDetailKey
			and    fdi.Entity = 'tEstimateTaskExpense'	

			union

			-- tForecastDetailItem.EntityKey = EstimateTaskKey
			select et.EstimateKey 
			from   tForecastDetailItem fdi (nolock)
				inner join tEstimateTask et (nolock) on fdi.EntityKey = et.EstimateTaskKey 
			where  fdi.ForecastDetailKey = @ForecastDetailKey
			and    fdi.Entity = 'tEstimateTask'	

			) as est
		
		update #estimate
		set    #estimate.EstimateNumber = e.EstimateNumber
				,#estimate.EstimateName = e.EstimateName
				,#estimate.EstimateType = 
				Case e.EstType
				When 1 Then 'By Task'
				When 2 then 'By Task and Service'
				When 3 then 'By Task and Person' 
				When 4 then 'By Service' 
				When 5 then 'By Segment and Service' 
				When 6 then 'By Project Only' 
				end
		from  tEstimate e (nolock)
		where #estimate.EstimateKey = e.EstimateKey

		-- recalc total because some tasks may have been removed (out of range)
		update #estimate
		set    #estimate.EstimateTotalGross = ISNULL((
				select sum(fdi.Total) 
				from   tForecastDetailItem fdi (nolock) 
				where  fdi.ForecastDetailKey = @ForecastDetailKey
				and    fdi.EntityKey = #estimate.EstimateKey
				and    fdi.Entity = 'tEstimateTaskLabor'
				and    fdi.AtNet = 0
			),0), 
				#estimate.EstimateTotalNet = ISNULL((
				select sum(fdi.Total) 
				from   tForecastDetailItem fdi (nolock) 
				where  fdi.ForecastDetailKey = @ForecastDetailKey
				and    fdi.EntityKey = #estimate.EstimateKey
				and    fdi.Entity = 'tEstimateTaskLabor'
				and    fdi.AtNet = 1
			),0) * -1, 
				#estimate.EstimateTotal = ISNULL((
				select sum(fdi.Total) 
				from   tForecastDetailItem fdi (nolock) 
				where  fdi.ForecastDetailKey = @ForecastDetailKey
				and    fdi.EntityKey = #estimate.EstimateKey
				and    fdi.Entity = 'tEstimateTaskLabor'
			),0)

		update #estimate
		set    #estimate.EstimateTotalGross = ISNULL(#estimate.EstimateTotalGross, 0) + ISNULL((
				select sum(fdi.Total) 
				from   tForecastDetailItem fdi (nolock) 
					inner join tEstimateTaskExpense ete (nolock) on fdi.EntityKey = ete.EstimateTaskExpenseKey
				where  fdi.ForecastDetailKey = @ForecastDetailKey
				and    ete.EstimateKey = #estimate.EstimateKey
				and    fdi.Entity = 'tEstimateTaskExpense'
				and    fdi.AtNet = 0
			),0), 
				#estimate.EstimateTotalNet = ISNULL(#estimate.EstimateTotalNet, 0) + ISNULL((
				select sum(fdi.Total) 
				from   tForecastDetailItem fdi (nolock) 
					inner join tEstimateTaskExpense ete (nolock) on fdi.EntityKey = ete.EstimateTaskExpenseKey
				where  fdi.ForecastDetailKey = @ForecastDetailKey
				and    ete.EstimateKey = #estimate.EstimateKey
				and    fdi.Entity = 'tEstimateTaskExpense'
				and    fdi.AtNet = 1
			),0) * -1, 
				#estimate.EstimateTotal = ISNULL(#estimate.EstimateTotal, 0) + ISNULL((
				select sum(fdi.Total) 
				from   tForecastDetailItem fdi (nolock) 
					inner join tEstimateTaskExpense ete (nolock) on fdi.EntityKey = ete.EstimateTaskExpenseKey
				where  fdi.ForecastDetailKey = @ForecastDetailKey
				and    ete.EstimateKey = #estimate.EstimateKey
				and    fdi.Entity = 'tEstimateTaskExpense'
			),0)

			update #estimate
		set    #estimate.EstimateTotalGross = ISNULL(#estimate.EstimateTotalGross, 0) + ISNULL((
				select sum(fdi.Total) 
				from   tForecastDetailItem fdi (nolock) 
					inner join tEstimateTask et (nolock) on fdi.EntityKey = et.EstimateTaskKey
				where  fdi.ForecastDetailKey = @ForecastDetailKey
				and    et.EstimateKey = #estimate.EstimateKey
				and    fdi.Entity = 'tEstimateTask'
				and    fdi.AtNet = 0
			),0), 
				#estimate.EstimateTotalNet = ISNULL(#estimate.EstimateTotalNet, 0) + ISNULL((
				select sum(fdi.Total) 
				from   tForecastDetailItem fdi (nolock) 
					inner join tEstimateTask et (nolock) on fdi.EntityKey = et.EstimateTaskKey
				where  fdi.ForecastDetailKey = @ForecastDetailKey
				and    et.EstimateKey = #estimate.EstimateKey
				and    fdi.Entity = 'tEstimateTask'
				and    fdi.AtNet = 1
			),0) * -1,
				#estimate.EstimateTotal = ISNULL(#estimate.EstimateTotal, 0) + ISNULL((
				select sum(fdi.Total) 
				from   tForecastDetailItem fdi (nolock) 
					inner join tEstimateTask et (nolock) on fdi.EntityKey = et.EstimateTaskKey
				where  fdi.ForecastDetailKey = @ForecastDetailKey
				and    et.EstimateKey = #estimate.EstimateKey
				and    fdi.Entity = 'tEstimateTask'
			),0)

		select * from #estimate where EstimateName is not null --will not show up in the list if estimate deleted
	end
	
	if @Entity = 'tLead' and @FromEstimate = 0 
		select * from tLead (nolock) where LeadKey = @EntityKey

	if @Entity = 'tRetainer'
		select * from tRetainer (nolock) where RetainerKey = @EntityKey

	-- No particular data for invoices
	 
	RETURN 1
GO
