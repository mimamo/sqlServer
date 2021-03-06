USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardModuleGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardModuleGetList]

	@DashboardKey int


AS --Encrypt

Declare @DashboardType smallint

Select @DashboardType = DashboardType from tDashboard (nolock) Where DashboardKey = @DashboardKey

	SELECT dmd.*, dm.DashboardModuleKey, ISNULL(dm.Pane, 0) as Pane, dm.DisplayOrder,
	dmg.GroupName, dmg.GroupDescription, dmg.GroupDisplayOrder
	FROM tDashboardModuleDef dmd (nolock)
	inner join tDashboardModuleGroup dmg (nolock) on dmd.DashboardModuleGroupKey = dmg.DashboardModuleGroupKey
	left outer join (Select * from tDashboardModule (nolock) Where DashboardKey = @DashboardKey) dm on dmd.DashboardModuleDefKey = dm.DashboardModuleDefKey
	WHERE
		dmd.DashboardType = @DashboardType
	Order By GroupDisplayOrder, DefDisplayOrder
	RETURN 1
GO
