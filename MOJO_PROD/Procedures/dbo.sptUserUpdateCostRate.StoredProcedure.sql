USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateCostRate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateCostRate]
	(
		@UserKey int,
		@HourlyCost money = null
	)
AS --Encrypt

  /*
  || When     Who Rel		What
  || 04/09/08 GHL 8.508		(15279) Recalc data affected by CostRate in tProjectRollup
  || 11/19/09 MAS 10.513	(66678) Allow the option to set a specific rate called from Flex Edit Employee->Accounting curtain
  || 04/12/10 GHL 10.521    (78762) Recalculating now tProjectItemRollup records   
  || 08/30/13 GHL 10.571    Update HCostRate    
  */
  
Declare @CurCost money

If @HourlyCost is NULL
	Select @CurCost = HourlyCost From tUser (nolock) Where UserKey = @UserKey
Else
	Select @CurCost = @HourlyCost		

select @CurCost =  ISNULL(@CurCost, 0)

Update tTime 
Set CostRate = case when ExchangeRate = 0 then @CurCost 
				else @CurCost / ExchangeRate    -- Project currency
				end
   ,HCostRate = @CurCost -- home currency
Where UserKey = @UserKey


-- Update the 2 rollup pieces of info which are affected by CostRate 

CREATE TABLE #rollup (ProjectKey INT, ServiceKey INT NULL, LaborNet MONEY NULL, LaborNetApproved MONEY NULL)					

INSERT #rollup
SELECT DISTINCT ProjectKey, ISNULL(ServiceKey, 0), 0, 0
FROM   tTime (NOLOCK)
WHERE  ProjectKey IN (SELECT DISTINCT ProjectKey FROM tTime (NOLOCK) WHERE UserKey = @UserKey)

UPDATE #rollup
SET    #rollup.LaborNet =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #rollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #rollup.ServiceKey
					), 0) 

UPDATE #rollup
SET    #rollup.LaborNetApproved =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM  tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #rollup.ProjectKey
					AND   tTimeSheet.Status = 4 
					AND   isnull(tTime.ServiceKey, 0) = #rollup.ServiceKey
					), 0) 

UPDATE tProjectRollup
SET    tProjectRollup.LaborNet =
					ISNULL((SELECT SUM(#rollup.LaborNet) 
					FROM #rollup (NOLOCK) 
					WHERE #rollup.ProjectKey = tProjectRollup.ProjectKey), 0) 
WHERE tProjectRollup.ProjectKey in (SELECT DISTINCT ProjectKey  FROM #rollup)
					
UPDATE tProjectRollup
SET    tProjectRollup.LaborNetApproved =
					ISNULL((SELECT SUM(#rollup.LaborNetApproved) 
					FROM #rollup (NOLOCK) 
					WHERE #rollup.ProjectKey = tProjectRollup.ProjectKey), 0) 
WHERE tProjectRollup.ProjectKey in (SELECT DISTINCT ProjectKey FROM #rollup)

					
UPDATE tProjectItemRollup
SET    tProjectItemRollup.LaborNet = #rollup.LaborNet
      ,tProjectItemRollup.LaborNetApproved = #rollup.LaborNetApproved
FROM   #rollup
WHERE  tProjectItemRollup.ProjectKey = #rollup.ProjectKey
AND    tProjectItemRollup.EntityKey = #rollup.ServiceKey
AND    tProjectItemRollup.Entity = 'tService'
GO
