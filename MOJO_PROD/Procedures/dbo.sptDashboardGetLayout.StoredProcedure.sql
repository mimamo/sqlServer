USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardGetLayout]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardGetLayout]

	(
		@DashboardKey int,
		@UserKey int
	)

AS


Select
	dm.Pane,
	dm.DisplayOrder,
	dm.DashboardModuleKey,
	dmd.DisplayName,
	dmd.DashboardType,
	dmd.Description,
	dmd.SourceFile,
	dmu.DisplayStatus,
	dmu.Settings
From
	tDashboardModule dm (nolock)
	inner join tDashboardModuleDef dmd (nolock) on dm.DashboardModuleDefKey = dmd.DashboardModuleDefKey
	left outer join 
		(Select DashboardModuleKey, DisplayStatus, Settings 
			from tDashboardModuleUser (nolock)
			Where UserKey = @UserKey) dmu
			on dm.DashboardModuleKey = dmu.DashboardModuleKey
Where
	dm.DashboardKey = @DashboardKey
Order By
	Pane, DisplayOrder
GO
