USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetGetItemList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetGetItemList]
	(
		@CompanyKey int,
		@CampaignKey int,
		@CampaignBudgetKey int
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 07/10/07 QMD/GHL 8.5   Expense Type reference changed to tItem
*/

if @CampaignBudgetKey = 0  -- Get all items for the available list
	BEGIN
		Select 
			s.ServiceKey as EntityKey,
			'Service' as Entity,
			s.Description as ItemName,
			1 as DisplayOrder
		From 
			tService s (nolock)
		Where
			s.CompanyKey = @CompanyKey and
			s.ServiceKey not in (Select EntityKey from tCampaignBudgetItem (nolock) Where CampaignKey = @CampaignKey and Entity = 'Service')
			
		UNION ALL
		
		Select 
			i.ItemKey as EntityKey,
			'Item' as Entity,
			i.ItemName as ItemName,
			CASE WHEN i.ItemType < 3 THEN 2 ELSE 3 END as DisplayOrder
		From 
			tItem i (nolock)
		Where
			i.CompanyKey = @CompanyKey and
			i.ItemKey not in (Select EntityKey from tCampaignBudgetItem (nolock) Where CampaignKey = @CampaignKey and Entity = 'Item')
		
	END
ELSE
	BEGIN
		Select 
			s.ServiceKey as EntityKey,
			'Service' as Entity,
			s.Description as ItemName,
			1 as DisplayOrder
		From 
			tService s (nolock)
			inner join tCampaignBudgetItem cbi (nolock) on s.ServiceKey = cbi.EntityKey and cbi.Entity = 'Service'
		Where
			cbi.CampaignBudgetKey = @CampaignBudgetKey
			
		UNION ALL
		
		Select 
			i.ItemKey as EntityKey,
			'Item' as Entity,
			i.ItemName as ItemName,
			CASE WHEN i.ItemType < 3 THEN 2 ELSE 3 END as DisplayOrder
		From 
			tItem i (nolock)
			inner join tCampaignBudgetItem cbi (nolock) on i.ItemKey = cbi.EntityKey and cbi.Entity = 'Item'
		Where
			cbi.CampaignBudgetKey = @CampaignBudgetKey
					
	END
GO
