USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardModuleDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardModuleDelete]

	(
		@DashboardModuleKey int
	)

AS --Encrypt

Declare @Pane smallint, @DisplayOrder int, @MoveKey int, @DashboardKey int

Select @Pane = Pane, @DisplayOrder = DisplayOrder, @DashboardKey = DashboardKey 
from tDashboardModule (nolock) 
Where DashboardModuleKey = @DashboardModuleKey
	
Delete tDashboardModuleUser
Where DashboardModuleKey = @DashboardModuleKey

Delete tDashboardModule
Where DashboardModuleKey = @DashboardModuleKey
	
Update tDashboardModule
Set DisplayOrder = DisplayOrder - 1
Where DashboardKey = @DashboardKey and Pane = @Pane and DisplayOrder > @DisplayOrder
GO
