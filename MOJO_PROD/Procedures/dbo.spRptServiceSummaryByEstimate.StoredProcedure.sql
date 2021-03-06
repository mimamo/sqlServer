USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptServiceSummaryByEstimate]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptServiceSummaryByEstimate]
	(
		@ProjectKey INT
		,@EstimateKey INT -- UI limits to approved estimates
	)
AS -- Encrypt

	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 05/15/07 GHL 8.5	Lifted ambiguity about Taxable fields now in 2 tables
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  */
  		
	DECLARE @CompanyKey INT
	       
	SELECT @CompanyKey = CompanyKey
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	
	SELECT      ISNULL(wt.WorkTypeName, '')  AS WorkTypeName
				,ISNULL(s.WorkTypeKey, 0) as WorkTypeKey
				,s.ServiceKey 
				,s.Description
								
				,isnull((Select Sum(etl.Hours) 
				from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.EstimateKey = @EstimateKey 
				and e.EstType > 1 and e.ChangeOrder = 0 
				and isnull(etl.ServiceKey, 0) = s.ServiceKey), 0)		
				+ isnull((Select Sum(et.Hours) 
				from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.EstimateKey = @EstimateKey 
				and e.EstType = 1 and e.ChangeOrder = 0
				and s.ServiceKey = 0), 0) As BudgetHrs
				
				,isnull((Select Sum(etl.Hours) 
				from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.EstimateKey = @EstimateKey 
				and e.EstType > 1 and e.ChangeOrder = 1 
				and isnull(etl.ServiceKey, 0) = s.ServiceKey), 0)		
				+ isnull((Select Sum(et.Hours) 
				from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.EstimateKey = @EstimateKey 
				and e.EstType = 1 and e.ChangeOrder = 1
				and s.ServiceKey = 0), 0) As COHrs
	
				,ISNULL((SELECT SUM(ti.ActualHours) 
				FROM tTime ti (nolock) 
				WHERE ti.ProjectKey = @ProjectKey
				AND ISNULL(ti.ServiceKey, 0) = s.ServiceKey), 0) AS ActHrs
				
				,Cast(0 as Decimal(24, 4)) As VarianceHrs
							
				,isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2))
				from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.EstimateKey = @EstimateKey 
				and e.EstType > 1 and e.ChangeOrder = 0 
				and isnull(etl.ServiceKey, 0) = s.ServiceKey), 0) 
				+ isnull((Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0),2))
				from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.EstimateKey = @EstimateKey 
				and e.EstType = 1 and e.ChangeOrder = 0
				and s.ServiceKey = 0), 0) AS BudgetAmt
						
				,isnull((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2))
				from tEstimateTaskLabor etl  (nolock) inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
				Where e.EstimateKey = @EstimateKey 
				and e.EstType > 1 and e.ChangeOrder = 1 
				and isnull(etl.ServiceKey, 0) = s.ServiceKey), 0) 
				+ isnull((Select Sum(Round(ISNULL(et.Hours, 0) * ISNULL(et.Rate, 0),2))
				from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.EstimateKey = @EstimateKey 
				and e.EstType = 1 and e.ChangeOrder = 1
				and s.ServiceKey = 0), 0) AS COAmt

				,ISNULL((SELECT SUM(ROUND(ti.ActualHours * ti.ActualRate, 2)) 
				FROM tTime ti (nolock) 
				WHERE ti.ProjectKey = @ProjectKey
				AND ISNULL(ti.ServiceKey, 0) = s.ServiceKey), 0) AS ActAmt
				
				,Cast(0 as Money) As VarianceAmt
		
				,ISNULL((Select Sum(il.TotalAmount) 
				from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
				Where il.ProjectKey = @ProjectKey 
				And   (
					   ISNULL(il.Entity, '') in ('', 'tService')		
				       And   ISNULL(il.EntityKey, 0) = s.ServiceKey
				      )
				And   invc.AdvanceBill = 0
				And   il.EstimateKey = @EstimateKey ), 0) as AmountBilled
				,ISNULL((Select Sum(il.TotalAmount) 
				from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
				Where il.ProjectKey = @ProjectKey 
				And   (
					   ISNULL(il.Entity, '') in ('', 'tService')		
				       And   ISNULL(il.EntityKey, 0) = s.ServiceKey
				      )
				And   invc.AdvanceBill = 0
				), 0) as AllEstimatesAmountBilled
	     
				,0 as InvoiceLineKey
				,Cast(0 as Money) as InvoiceLineAmount
				,Cast(0 as Money) As RemainingInv
				,s.Taxable
				,s.Taxable2
	FROM		
		(
		select ServiceKey
			  ,Description
			  ,WorkTypeKey
			  ,Taxable
			  ,Taxable2
		from tService (nolock)
		where CompanyKey = @CompanyKey
		UNION
		select	0 AS ServiceKey
			   ,'[No Service]' AS Description
			   ,0 AS WorkTypeKey
			   ,0
			   ,0
		) AS s 
		LEFT OUTER JOIN tWorkType wt (NOLOCK) ON s.WorkTypeKey = wt.WorkTypeKey
		
	
	
	RETURN 1
GO
