USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardModuleInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardModuleInsert]
	@DashboardKey int,
	@DashboardModuleDefKey int,
	@Pane smallint
AS --Encrypt

Declare @DisplayOrder int

	Select @DisplayOrder = ISNULL(Max(DisplayOrder), 0) + 1 from tDashboardModule (nolock) Where DashboardKey = @DashboardKey and Pane = @Pane

	INSERT tDashboardModule
		(
		DashboardKey,
		DashboardModuleDefKey,
		Pane,
		DisplayOrder
		)

	VALUES
		(
		@DashboardKey,
		@DashboardModuleDefKey,
		@Pane,
		@DisplayOrder
		)


	RETURN 1
GO
