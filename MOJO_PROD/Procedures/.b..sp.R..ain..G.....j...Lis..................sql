USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerGetProjectList]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerGetProjectList]
	(
		@RetainerKey int
	)
AS --Encrypt
	SET NOCOUNT ON 
	
	
	/*
	Who		Rel		When		What
	GHL		82		03/26/2005	Replaced references to vProjectCost
	GHL     85      07/09/07    Added restriction on ER
	GHL     8519    09/04/08    (34200) Replaced subqueries by project rollup
	                            to speed up query
	GWG     10519   2/25/10     (75073) Using the rollup tables for order amounts
	RLB     10549   10/27/11	(116487) Added field for Flex page
	RLB     10563   12/19/12    Remove filter for Nonbillable projects not sure why we would not display them if they are on the retainer
	*/

	Declare @CompanyKey int
	Select @CompanyKey = CompanyKey from tRetainer (NOLOCK) Where RetainerKey = @RetainerKey
	
	SELECT p.*
		   ,ISNULL(roll.Hours, 0)		AS ActualHours	
		   ,ISNULL(roll.LaborNet, 0)	AS LaborNet	 
		   ,ISNULL(roll.LaborGross, 0)	AS LaborGross	 
		
		   ,ISNULL(roll.ExpReceiptNet, 0)  
		   +ISNULL(roll.MiscCostNet, 0)
		   +ISNULL(roll.VoucherNet, 0)
		   +ISNULL(roll.OpenOrderNet, 0)					AS ExpenseNet
		
		   ,ISNULL(roll.ExpReceiptGross, 0)  
		   +ISNULL(roll.MiscCostGross, 0)
		   +ISNULL(roll.VoucherGross, 0)
		   +ISNULL(roll.OpenOrderGross, 0)					AS ExpenseGross
				
			,CAST(0 AS MONEY) AS Variance
			,ISNULL(roll.LaborGross, 0)
			+ISNULL(roll.ExpReceiptGross, 0)  
			+ISNULL(roll.MiscCostGross, 0)
			+ISNULL(roll.VoucherGross, 0)
			+ISNULL(roll.OpenOrderGross, 0)					AS ProjectTotal
			,ISNULL(p.EstLabor,0)
			+ISNULL(p.EstExpenses, 0)
			+ISNULL(p.ApprovedCOLabor, 0)
			+ISNULL(p.ApprovedCOExpense, 0)					AS EstimateTotal
	FROM   tProject p (NOLOCK)
		LEFT OUTER JOIN tProjectRollup roll (NOLOCK) ON p.ProjectKey = roll.ProjectKey
	WHERE  p.CompanyKey = @CompanyKey
	AND    p.RetainerKey = @RetainerKey

	
	RETURN 1
GO
