USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptServiceSummary]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptServiceSummary]
	(
		@ProjectKey INT
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 09/27/06 GHL 8.4   Recalc'ed AmountBilled as the sum of BillFrom = 1 invoice lines + sum of transactions billed  
  ||                    to fix discrepancies with task or billing item grids
  ||                    Note: When billing by Service/Item, there are cases when it is not possible to determine
  ||                    whether what was billed was Labor or Expenses. My strategy is to put them in the Service
  ||                    i.e. Labor grid and make sure that the total billed (labor + expenses) is the same as by
  ||                    task and billing item  
  || 05/15/07 GHL 8.5	Lifted ambiguity about Taxable fields now in 2 tables
  || 01/31/08 GHL 8.5   (20123) Using now invoice summary rather project cost view
  */

	SET NOCOUNT ON
	
	-- Patch to make sure that estimates are rolled up
	-- Check for approved estimates
	IF EXISTS (SELECT 1 FROM tEstimate e (NOLOCK)
					WHERE e.ProjectKey = @ProjectKey
				    AND ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				    Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
					)
		BEGIN
			-- Check for Rollups
			IF NOT EXISTS (SELECT 1 FROM tProjectEstByItem (NOLOCK)
							WHERE ProjectKey = @ProjectKey)
			BEGIN
				EXEC sptEstimateRollupDetail @ProjectKey
			END
		END
		
		
	DECLARE @CompanyKey INT
	       
	SELECT @CompanyKey = CompanyKey
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	
	SELECT      ISNULL(wt.WorkTypeName, '')  AS WorkTypeName
				,ISNULL(s.WorkTypeKey, 0) as WorkTypeKey
				,s.ServiceKey 
				,s.Description
				,ISNULL((SELECT pe.Qty  
				FROM tProjectEstByItem pe (NOLOCK) 
				Where pe.ProjectKey = @ProjectKey   
				AND ISNULL(pe.EntityKey, 0) = s.ServiceKey
				AND pe.Entity = 'tService'  
				), 0) AS BudgetHrs
				
				,ISNULL((SELECT pe.COQty  
				FROM tProjectEstByItem pe (NOLOCK) 
				Where pe.ProjectKey = @ProjectKey   
				AND ISNULL(pe.EntityKey, 0) = s.ServiceKey
				AND pe.Entity = 'tService'  
				), 0) AS COHrs
	
				,ISNULL((SELECT SUM(ti.ActualHours) 
				FROM tTime ti (nolock) 
				WHERE ti.ProjectKey = @ProjectKey
				AND ISNULL(ti.ServiceKey, 0) = s.ServiceKey), 0) AS ActHrs
				
				,Cast(0 as Decimal(24, 4)) As VarianceHrs
								
				,ISNULL((SELECT pe.Gross  
				FROM tProjectEstByItem pe (NOLOCK) 
				Where pe.ProjectKey = @ProjectKey   
				AND ISNULL(pe.EntityKey, 0) = s.ServiceKey
				AND pe.Entity = 'tService'  
				), 0) AS BudgetAmt

				,ISNULL((SELECT pe.COGross  
				FROM tProjectEstByItem pe (NOLOCK) 
				Where pe.ProjectKey = @ProjectKey   
				AND ISNULL(pe.EntityKey, 0) = s.ServiceKey
				AND pe.Entity = 'tService'  
				), 0) AS COAmt
				
				,ISNULL((SELECT SUM(ROUND(ti.ActualHours * ti.ActualRate, 2)) 
				FROM tTime ti (nolock) 
				WHERE ti.ProjectKey = @ProjectKey
				AND ISNULL(ti.ServiceKey, 0) = s.ServiceKey), 0) AS ActAmt
				
				,Cast(0 as Money) As VarianceAmt
		
				,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   isum.Entity = 'tService'
				AND   ISNULL(isum.EntityKey, 0) = s.ServiceKey
				AND   inv.AdvanceBill = 0), 0)
				
				as AmountBilled
				
				/*
				,ISNULL((Select Sum(il.TotalAmount) 
				from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
				Where il.ProjectKey = @ProjectKey 
				And   (
					   ISNULL(il.Entity, '') in ('', 'tService')		
				       And   ISNULL(il.EntityKey, 0) = s.ServiceKey
					  )
				And    il.BillFrom = 1      
				And invc.AdvanceBill = 0), 0) 
				 + 
				ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
				WHERE ProjectCosts.ProjectKey = @ProjectKey
				AND   ISNULL(ProjectCosts.ItemKey, 0) = s.ServiceKey
				AND   ProjectCosts.Type IN ('LABOR') 
				AND   ProjectCosts.InvoiceLineKey > 0), 0) -- Detail 
				as AmountBilled
				*/
				
				,0 As AllEstimatesAmountBilled -- Compatibility with spRptServiceSummaryByEstimate
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
