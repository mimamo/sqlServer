USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardModuleMoveDown]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardModuleMoveDown]

	(
		@DashboardModuleKey int
	)

AS --Encrypt

Declare @Pane smallint, @DisplayOrder int, @MoveKey int, @DashboardKey int

Select @Pane = Pane, @DisplayOrder = DisplayOrder, @DashboardKey = DashboardKey 
from tDashboardModule (nolock) 
Where DashboardModuleKey = @DashboardModuleKey
	
Select @MoveKey = DashboardModuleKey from tDashboardModule (nolock) 
	Where DashboardKey = @DashboardKey and DisplayOrder = @DisplayOrder + 1 and Pane = @Pane
	
if @MoveKey is null
	return -1
	
Update tDashboardModule
Set DisplayOrder = @DisplayOrder + 1
Where DashboardModuleKey = @DashboardModuleKey
	
Update tDashboardModule
Set DisplayOrder = @DisplayOrder
Where DashboardModuleKey = @MoveKey
GO
