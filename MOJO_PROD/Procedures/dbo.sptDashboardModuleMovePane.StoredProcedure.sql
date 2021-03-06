USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardModuleMovePane]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardModuleMovePane]

	(
		@DashboardModuleKey int,
		@ToPane smallint
	)

AS --Encrypt

Declare @Pane smallint, @DisplayOrder int, @MoveKey int, @DashboardKey int, @MaxOrder int

Select @Pane = Pane, @DisplayOrder = DisplayOrder, @DashboardKey = DashboardKey 
from tDashboardModule (nolock) 
Where DashboardModuleKey = @DashboardModuleKey

Select @MaxOrder = ISNULL(Max(DisplayOrder), 0) + 1 from tDashboardModule (nolock)
Where DashboardKey = @DashboardKey and Pane = @ToPane
	
Update tDashboardModule
Set Pane = @ToPane, DisplayOrder = @MaxOrder
Where DashboardModuleKey = @DashboardModuleKey
	
Update tDashboardModule
Set DisplayOrder = DisplayOrder - 1
Where DashboardKey = @DashboardKey and Pane = @Pane and DisplayOrder > @DisplayOrder
GO
