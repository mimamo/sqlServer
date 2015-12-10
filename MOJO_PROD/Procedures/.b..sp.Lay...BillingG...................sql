USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutBillingGet]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutBillingGet]
	(
		@LayoutKey int,
		@CompanyKey int
	)
AS

/*
|| When      Who Rel      What
|| 1/5/10    CRG 10.5.1.6 Changed Level to LayoutLevel to match tLayoutBilling
|| 1/5/10    CRG 10.5.1.6 Added code to pull in existing Layout data
|| 2/3/10    CRG 10.5.1.8 Added "Campaign" to the "Project / Segment" EntityName
|| 3/2/10    CRG 10.5.1.9 Fixed logic in query for Services and Items when @LayoutKey = 0
|| 03/15/10  MFT 10.5.2.0 Changed name from sptLayoutGetBilling, removed tLayout (header) query
|| 08/30/10  MFT 10.5.3.4 Added ORDER BY to tWorkType default (@LayoutKey = 0) layout
|| 02/10/11  MFT 10.5.4.1 Removed non-active services and items
|| 02/18/11  MFT 10.5.4.1 Rolled back active filter
|| 01/03/12  GHL 10.5.5.1 (130049) In the case of existing layouts, added newly created billing items, items, services
*/

IF @LayoutKey = 0
BEGIN
	-- layout for a new one

	Select 
		 NULL as ParentEntityKey
		,NULL as ParentEntity
		,0 as EntityKey
		,'tProject' as Entity
		,'Campaign / Project / Segment' as EntityName
		,2 as DisplayOption  -- show item detail by default
		,0 as LayoutLevel
		,0 as DisplayOrder

	UNION ALL

	Select
		 0 as ParentEntityKey
		,'tProject' as ParentEntity
		,WorkTypeKey as EntityKey
		,'tWorkType' as Entity
		,WorkTypeName as EntityName
		,2 as DisplayOption  -- show item detail by default
		,1 as LayoutLevel
		,DisplayOrder as DisplayOrder
	from tWorkType (nolock) Where CompanyKey = @CompanyKey

	UNION ALL

	Select
		 case When ISNULL(WorkTypeKey, 0) = 0 then 0 else WorkTypeKey end as ParentEntityKey
		,case When ISNULL(WorkTypeKey, 0) = 0 then 'tProject' else 'tWorkType' end  as ParentEntity
		,ServiceKey as EntityKey
		,'tService' as Entity
		,Description as EntityName
		,1 as DisplayOption  -- show item detail by default
		,2 as LayoutLevel
		,0 as DisplayOrder
	from tService (nolock)
	Where
		CompanyKey = @CompanyKey

	UNION ALL

	Select
		 case When ISNULL(WorkTypeKey, 0) = 0 then 0 else WorkTypeKey end as ParentEntityKey
		,case When ISNULL(WorkTypeKey, 0) = 0 then 'tProject' else 'tWorkType' end  as ParentEntity
		,ItemKey as EntityKey
		,'tItem' as Entity
		,ItemName as EntityName
		,1 as DisplayOption  -- show item detail by default
		,2 as LayoutLevel
		,0 as DisplayOrder
	from tItem (nolock)
	Where
		CompanyKey = @CompanyKey


	ORDER BY LayoutLevel, DisplayOrder

END
ELSE
BEGIN
	SELECT	lb.LayoutKey
			,lb.ParentEntityKey
			,lb.ParentEntity
			,lb.EntityKey
			,lb.Entity
			,CASE Entity
				WHEN 'tProject'	THEN 'Campaign / Project / Segment'
				WHEN 'tWorkType' THEN wt.WorkTypeName
				WHEN 'tService' THEN s.Description
				WHEN 'tItem' THEN i.ItemName
			END AS EntityName
			,lb.DisplayOption
			,lb.LayoutLevel
			,lb.DisplayOrder
			,lb.LayoutOrder	
	FROM	tLayoutBilling lb (nolock)
	LEFT JOIN tWorkType wt (nolock) ON lb.EntityKey = wt.WorkTypeKey
	LEFT JOIN tService s (nolock) ON lb.EntityKey = s.ServiceKey
	LEFT JOIN tItem i (nolock) ON lb.EntityKey = i.ItemKey
	WHERE
		lb.LayoutKey = @LayoutKey

	UNION ALL

	Select
		@LayoutKey as LayoutKey
		,0 as ParentEntityKey
		,'tProject' as ParentEntity
		,WorkTypeKey as EntityKey
		,'tWorkType' as Entity
		,WorkTypeName as EntityName
		,2 as DisplayOption  -- show item detail by default
		,1 as LayoutLevel
		,DisplayOrder as DisplayOrder
		,1000 as LayoutOrder
	from tWorkType (nolock) Where CompanyKey = @CompanyKey
	and  WorkTypeKey not in (select EntityKey from tLayoutBilling (nolock) where Entity = 'tWorkType' and LayoutKey = @LayoutKey)


	UNION ALL

	Select
		@LayoutKey as LayoutKey
		,case When ISNULL(WorkTypeKey, 0) = 0 then 0 else WorkTypeKey end as ParentEntityKey
		,case When ISNULL(WorkTypeKey, 0) = 0 then 'tProject' else 'tWorkType' end  as ParentEntity
		,ServiceKey as EntityKey
		,'tService' as Entity
		,Description as EntityName
		,1 as DisplayOption  -- show item detail by default
		,case when ISNULL(WorkTypeKey, 0) = 0 then 1 else 2 end as LayoutLevel
		,0 as DisplayOrder
		,2000 as LayoutOrder
	from tService (nolock)
	Where
		CompanyKey = @CompanyKey
	and  ServiceKey not in (select EntityKey from tLayoutBilling (nolock) where Entity = 'tService' and LayoutKey = @LayoutKey)


	UNION ALL

	Select
		 @LayoutKey as LayoutKey
		,case When ISNULL(WorkTypeKey, 0) = 0 then 0 else WorkTypeKey end as ParentEntityKey
		,case When ISNULL(WorkTypeKey, 0) = 0 then 'tProject' else 'tWorkType' end  as ParentEntity
		,ItemKey as EntityKey
		,'tItem' as Entity
		,ItemName as EntityName
		,1 as DisplayOption  -- show item detail by default
		,case when ISNULL(WorkTypeKey, 0) = 0 then 1 else 2 end as LayoutLevel
		,0 as DisplayOrder
		,3000 as LayoutOrder
	from tItem (nolock)
	Where
		CompanyKey = @CompanyKey
	and  ItemKey not in (select EntityKey from tLayoutBilling (nolock) where Entity = 'tItem' and LayoutKey = @LayoutKey)

	ORDER BY LayoutOrder

END
GO
