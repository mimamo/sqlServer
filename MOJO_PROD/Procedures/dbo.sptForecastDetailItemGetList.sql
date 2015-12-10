USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastDetailItemGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastDetailItemGetList]
	(
	@ForecastDetailKey int
	,@Month varchar(50)
	,@GrossAndOrNet int = 0
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 11/13/12  GHL 10.5.6.2 Created for revenue forecast drilldowns
|| 11/13/12  GHL 10.5.6.2 Added tItem/tService/tRetainer cases
|| 12/17/12  GHL 10.5.6.3 Display percentages instead of raw values
|| 06/26/13  GHL 10.5.6.9 Added param GrossAndOrNet
*/

	SET NOCOUNT ON

	if @Month not in ('Prior','Month1','Month2','Month3','Month4','Month5','Month6'
					,'Month7','Month8','Month9','Month10','Month11','Month12','NextYear')
		select @Month = 'Prior'

	declare @Entity varchar(50)
	declare @EntityKey int
	declare @CompanyKey int

	select @Entity = fd.Entity
	      ,@EntityKey = fd.EntityKey 
	      ,@CompanyKey = f.CompanyKey
	from tForecastDetail fd (nolock)
		inner join tForecast f (nolock) on fd.ForecastKey = f.ForecastKey   
	where fd.ForecastDetailKey = @ForecastDetailKey


	if @Entity = 'tRetainer'
	begin
		-- for this case, there is no detail items
		select fd.* 
			   ,gl.AccountNumber
			   ,gl.AccountName
			   ,gl.AccountNumber + '-' + gl.AccountName as AccountFullName

			   ,o.OfficeID
				,o.OfficeName
				,o.OfficeID + '-'+ o.OfficeName as OfficeFullName

				,c.ClassID
				,c.ClassName
				,c.ClassID + '-' + c.ClassName as ClassFullName

		,case when @Month = 'Prior' then fd.Prior
					  when @Month = 'Month1' then fd.Month1
					  when @Month = 'Month2' then fd.Month2
					  when @Month = 'Month3' then fd.Month3
					  when @Month = 'Month4' then fd.Month4
					  when @Month = 'Month5' then fd.Month5
					  when @Month = 'Month6' then fd.Month6
					  when @Month = 'Month7' then fd.Month7
					  when @Month = 'Month8' then fd.Month8
					  when @Month = 'Month9' then fd.Month9
					  when @Month = 'Month10' then fd.Month10
					  when @Month = 'Month11' then fd.Month11
					  when @Month = 'Month12' then fd.Month12
					  when @Month = 'NextYear' then fd.NextYear
				end as MonthTotal
			,case when @Month = 'Prior' then cast(round((fd.Prior * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month1' then cast(round((fd.Month1 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month2' then cast(round((fd.Month2 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month3' then cast(round((fd.Month3 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month4' then cast(round((fd.Month4 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month5' then cast(round((fd.Month5 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month6' then cast(round((fd.Month6 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month7' then cast(round((fd.Month7 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month8' then cast(round((fd.Month8 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month9' then cast(round((fd.Month9 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month10' then cast(round((fd.Month10 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month11' then cast(round((fd.Month11 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month12' then cast(round((fd.Month12 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'NextYear' then cast(round((fd.NextYear * fd.Probability) / 100.0000, 2)  as money)
				end as MonthTotalP
			 ,cast(round((fd.Total * fd.Probability) / 100.0000, 2)  as money) as TotalP
		from tForecastDetail fd (nolock) 
			inner join tRetainer r (nolock) on fd.EntityKey = r.RetainerKey
			left outer join tGLAccount gl (nolock) on r.SalesAccountKey = gl.GLAccountKey
			left outer join tOffice o (nolock) on r.OfficeKey = o.OfficeKey
			left outer join tClass c (nolock) on r.ClassKey = c.ClassKey
		where fd.ForecastDetailKey = @ForecastDetailKey
	end

	else if @Entity = 'tService'
	
		-- for this case, there is no detail items
		select fd.* 
			   ,gl.AccountNumber
			   ,gl.AccountName
			   ,gl.AccountNumber + '-' + gl.AccountName as AccountFullName

			   ,o.OfficeID
				,o.OfficeName
				,o.OfficeID + '-'+ o.OfficeName as OfficeFullName

				,d.DepartmentName

				,c.ClassID
				,c.ClassName
				,c.ClassID + '-' + c.ClassName as ClassFullName

		,case when @Month = 'Prior' then fd.Prior
					  when @Month = 'Month1' then fd.Month1
					  when @Month = 'Month2' then fd.Month2
					  when @Month = 'Month3' then fd.Month3
					  when @Month = 'Month4' then fd.Month4
					  when @Month = 'Month5' then fd.Month5
					  when @Month = 'Month6' then fd.Month6
					  when @Month = 'Month7' then fd.Month7
					  when @Month = 'Month8' then fd.Month8
					  when @Month = 'Month9' then fd.Month9
					  when @Month = 'Month10' then fd.Month10
					  when @Month = 'Month11' then fd.Month11
					  when @Month = 'Month12' then fd.Month12
					  when @Month = 'NextYear' then fd.NextYear
				end as MonthTotal
				,case when @Month = 'Prior' then cast(round((fd.Prior * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month1' then cast(round((fd.Month1 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month2' then cast(round((fd.Month2 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month3' then cast(round((fd.Month3 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month4' then cast(round((fd.Month4 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month5' then cast(round((fd.Month5 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month6' then cast(round((fd.Month6 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month7' then cast(round((fd.Month7 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month8' then cast(round((fd.Month8 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month9' then cast(round((fd.Month9 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month10' then cast(round((fd.Month10 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month11' then cast(round((fd.Month11 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month12' then cast(round((fd.Month12 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'NextYear' then cast(round((fd.NextYear * fd.Probability) / 100.0000, 2)  as money)
				end as MonthTotalP
			 ,cast(round((fd.Total * fd.Probability) / 100.0000, 2)  as money) as TotalP
		from tForecastDetail fd (nolock) 
			inner join tService s (nolock) on fd.EntityKey = s.ServiceKey
			left outer join tGLAccount gl (nolock) on s.GLAccountKey = gl.GLAccountKey
			left outer join tOffice o (nolock) on fd.OfficeKey = o.OfficeKey
			left outer join tClass c (nolock) on s.ClassKey = c.ClassKey
			left outer join tDepartment d (nolock) on s.DepartmentKey = d.DepartmentKey
		where fd.ForecastDetailKey = @ForecastDetailKey

	else if @Entity = 'tItem'
	
		-- for this case, there is no detail items
		select fd.* 
			   ,gl.AccountNumber
			   ,gl.AccountName
			   ,gl.AccountNumber + '-' + gl.AccountName as AccountFullName

			   ,o.OfficeID
				,o.OfficeName
				,o.OfficeID + '-'+ o.OfficeName as OfficeFullName

				,d.DepartmentName

				,c.ClassID
				,c.ClassName
				,c.ClassID + '-' + c.ClassName as ClassFullName

		,case when @Month = 'Prior' then fd.Prior
					  when @Month = 'Month1' then fd.Month1
					  when @Month = 'Month2' then fd.Month2
					  when @Month = 'Month3' then fd.Month3
					  when @Month = 'Month4' then fd.Month4
					  when @Month = 'Month5' then fd.Month5
					  when @Month = 'Month6' then fd.Month6
					  when @Month = 'Month7' then fd.Month7
					  when @Month = 'Month8' then fd.Month8
					  when @Month = 'Month9' then fd.Month9
					  when @Month = 'Month10' then fd.Month10
					  when @Month = 'Month11' then fd.Month11
					  when @Month = 'Month12' then fd.Month12
					  when @Month = 'NextYear' then fd.NextYear
				end as MonthTotal
				,case when @Month = 'Prior' then cast(round((fd.Prior * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month1' then cast(round((fd.Month1 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month2' then cast(round((fd.Month2 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month3' then cast(round((fd.Month3 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month4' then cast(round((fd.Month4 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month5' then cast(round((fd.Month5 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month6' then cast(round((fd.Month6 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month7' then cast(round((fd.Month7 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month8' then cast(round((fd.Month8 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month9' then cast(round((fd.Month9 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month10' then cast(round((fd.Month10 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month11' then cast(round((fd.Month11 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month12' then cast(round((fd.Month12 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'NextYear' then cast(round((fd.NextYear * fd.Probability) / 100.0000, 2)  as money)
				end as MonthTotalP
			 ,cast(round((fd.Total * fd.Probability) / 100.0000, 2)  as money) as TotalP
		from tForecastDetail fd (nolock) 
			inner join tItem i (nolock) on fd.EntityKey = i.ItemKey
			left outer join tGLAccount gl (nolock) on i.SalesAccountKey = gl.GLAccountKey
			left outer join tOffice o (nolock) on fd.OfficeKey = o.OfficeKey
			left outer join tClass c (nolock) on i.ClassKey = c.ClassKey
			left outer join tDepartment d (nolock) on i.DepartmentKey = d.DepartmentKey
		where fd.ForecastDetailKey = @ForecastDetailKey
	
	else

		select fdi.*
			   ,gl.AccountNumber
			   ,gl.AccountName
			   ,gl.AccountNumber + '-' + gl.AccountName as AccountFullName
			   ,t.TaskID
			   ,t.TaskName
			   ,isnull(t.TaskID + '-', '') + t.TaskName as TaskFullName

			   ,case when fdi.Entity = 'tEstimateTaskLabor' then e_labor.EstimateName 
					 when fdi.Entity = 'tEstimateTaskExpense' then e_exp.EstimateName
					 when fdi.Entity = 'tEstimateTask' then e_task.EstimateName
				end as EstimateName

				,case when fdi.Entity = 'tEstimateTaskLabor' then e_labor.EstimateNumber 
					 when fdi.Entity = 'tEstimateTaskExpense' then e_exp.EstimateNumber
					 when fdi.Entity = 'tEstimateTask' then e_task.EstimateNumber
				end as EstimateNumber

				,case when fdi.Entity = 'tInvoiceLine' then inv.InvoiceNumber
				 else null end as InvoiceNumber

				,i.ItemID
				,i.ItemName
				,i.ItemID + '-' + i.ItemName as ItemFullName

				,s.ServiceCode
				,s.Description
				,s.ServiceCode + '-' + s.Description as ServiceFullDescription
			
				,o.OfficeID
				,o.OfficeName
				,o.OfficeID + '-'+ o.OfficeName as OfficeFullName

				,d.DepartmentName
			
				,c.ClassID
				,c.ClassName
				,c.ClassID + '-' + c.ClassName as ClassFullName

				,seg.SegmentName
				,u.UserName
				,case when @Month = 'Prior' then fdi.Prior
					  when @Month = 'Month1' then fdi.Month1
					  when @Month = 'Month2' then fdi.Month2
					  when @Month = 'Month3' then fdi.Month3
					  when @Month = 'Month4' then fdi.Month4
					  when @Month = 'Month5' then fdi.Month5
					  when @Month = 'Month6' then fdi.Month6
					  when @Month = 'Month7' then fdi.Month7
					  when @Month = 'Month8' then fdi.Month8
					  when @Month = 'Month9' then fdi.Month9
					  when @Month = 'Month10' then fdi.Month10
					  when @Month = 'Month11' then fdi.Month11
					  when @Month = 'Month12' then fdi.Month12
					  when @Month = 'NextYear' then fdi.NextYear
				end as MonthTotal
				,case when @Month = 'Prior' then cast(round((fdi.Prior * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month1' then cast(round((fdi.Month1 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month2' then cast(round((fdi.Month2 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month3' then cast(round((fdi.Month3 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month4' then cast(round((fdi.Month4 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month5' then cast(round((fdi.Month5 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month6' then cast(round((fdi.Month6 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month7' then cast(round((fdi.Month7 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month8' then cast(round((fdi.Month8 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month9' then cast(round((fdi.Month9 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month10' then cast(round((fdi.Month10 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month11' then cast(round((fdi.Month11 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'Month12' then cast(round((fdi.Month12 * fd.Probability) / 100.0000, 2)  as money)
					  when @Month = 'NextYear' then cast(round((fdi.NextYear * fd.Probability) / 100.0000, 2)  as money)
				end as MonthTotalP
			 ,cast(round((fdi.Total * fd.Probability) / 100.0000, 2)  as money) as TotalP
				,il.LineSubject 
				,p.ProjectNumber + '-' + p.ProjectName as ProjectFullName

				,case when fdi.Entity = 'tLead-Labor' then 'Labor'
				      when fdi.Entity = 'tLead-Production' then 'Production'
					  when fdi.Entity = 'tLead-Media' then 'Media'
					  else ''
				end as LeadEntity

		from   tForecastDetailItem fdi (nolock)
		    inner join tForecastDetail fd (nolock) on fdi.ForecastDetailKey = fd.ForecastDetailKey
			left join tGLAccount gl (nolock) on fdi.GLAccountKey = gl.GLAccountKey
			left join tTask t (nolock) on fdi.TaskKey = t.TaskKey
			left join tItem i (nolock) on fdi.ItemKey = i.ItemKey
			left join tService s (nolock) on fdi.ServiceKey = s.ServiceKey
			left join vUserName u (nolock) on fdi.UserKey = u.UserKey
			left join tOffice o (nolock) on fdi.OfficeKey = o.OfficeKey
			left join tDepartment d (nolock) on fdi.DepartmentKey = d.DepartmentKey
			left join tClass c (nolock) on fdi.ClassKey = c.ClassKey

			left join tEstimateTaskExpense ete (nolock) on fdi.EntityKey = ete.EstimateTaskExpenseKey 
			left join tEstimate e_exp (nolock) on ete.EstimateKey = e_exp.EstimateKey
		
			left join tEstimate e_labor (nolock) on fdi.EntityKey = e_labor.EstimateKey
		
			left join tEstimateTask et (nolock) on fdi.EntityKey = et.EstimateTaskKey
			left join tEstimate e_task (nolock) on et.EstimateKey = e_task.EstimateKey
		 
			left join tInvoiceLine il (nolock) on fdi.EntityKey = il.InvoiceLineKey
			left join tInvoice inv (nolock) on il.InvoiceKey = inv.InvoiceKey
			left join tProject p (nolock) on il.ProjectKey = p.ProjectKey

			left join tCampaignSegment seg (nolock) on fdi.CampaignSegmentKey = seg.CampaignSegmentKey

		where  fdi.ForecastDetailKey = @ForecastDetailKey
		and    (
				(@Month = 'Prior' and fdi.[Prior] <> 0)
				or
				(@Month = 'Month1' and fdi.Month1 <> 0)
				or
				(@Month = 'Month2' and fdi.Month2 <> 0)
				or
				(@Month = 'Month3' and fdi.Month3 <> 0)
				or
				(@Month = 'Month4' and fdi.Month4 <> 0)
				or
				(@Month = 'Month5' and fdi.Month5 <> 0)
				or
				(@Month = 'Month6' and fdi.Month6 <> 0)
				or
				(@Month = 'Month7' and fdi.Month7 <> 0)
				or
				(@Month = 'Month8' and fdi.Month8 <> 0)
				or
				(@Month = 'Month9' and fdi.Month9 <> 0)
				or
				(@Month = 'Month10' and fdi.Month10 <> 0)
				or
				(@Month = 'Month11' and fdi.Month11 <> 0)
				or
				(@Month = 'Month12' and fdi.Month12 <> 0)
				or
				(@Month = 'NextYear' and fdi.NextYear <> 0)
				)
		and    ( 
					-- Gross only
					(@GrossAndOrNet = 0 and isnull(fdi.AtNet, 0) = 0)
					Or
					-- Net only
					(@GrossAndOrNet = 1 and isnull(fdi.AtNet, 0) = 1)
					Or
					-- Gross and Net
					@GrossAndOrNet = 2
					Or
					-- Basically, if the fdi does not come from an estimate, keep it
					-- only on estimates right now, we can identify Net and Gross
					fdi.Entity not in ('tEstimateTask', 'tEstimateTaskLabor', 'tEstimateTaskExpense')
				)
					


	RETURN 1
GO
