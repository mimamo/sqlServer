USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdateTotalGross]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdateTotalGross]

AS -- Encrypt

  /*
  || When     Who Rel   What
  || 02/05/07 GHL 8.4   Creation to solve active project list performance issue 
  ||                    This SP is to be called before rescheduling by the Task Manager 
  || 02/23/07 GHL 8.4   Corrected POAmt because of NULL AppliedCost 
  */
  
	RETURN 1  -- replaced by project rollup
  
  /*
  
	SET NOCOUNT ON

	UPDATE tProject
	SET    tProject.TotalGross = 	
			ISNULL((Select SUM(ROUND(ActualHours * ActualRate, 2)) 
			from tTime (nolock) 
			where tTime.ProjectKey = tProject.ProjectKey), 0) -- ActualLabor
			+ISNULL((Select SUM(BillableCost) 
			from tExpenseReceipt (nolock) 
			where tExpenseReceipt.ProjectKey = tProject.ProjectKey), 0) -- ExpReceiptAmt
			+ISNULL((Select SUM(BillableCost) 
			from tMiscCost (nolock) 
			where tMiscCost.ProjectKey = tProject.ProjectKey), 0) -- MiscCostAmt
			+ISNULL((Select SUM(BillableCost) 
			from tVoucherDetail (nolock)
			where tVoucherDetail.ProjectKey = tProject.ProjectKey), 0) -- VoucherAmt
			+ISNULL((SELECT SUM(pod.TotalCost - ISNULL(pod.AppliedCost, 0) )
			FROM	tPurchaseOrderDetail pod (NOLOCK)
			WHERE	pod.Closed = 0
			AND		pod.ProjectKey = tProject.ProjectKey), 0) -- POAmt
	WHERE   tProject.Active = 1
	AND     tProject.Closed = 0

	RETURN 1
*/
GO
