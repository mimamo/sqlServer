USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardGroupDelete]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardGroupDelete]
	@SecurityGroupKey int,
	@Type smallint

AS --Encrypt

	DELETE tDashboardGroup
	FROM tDashboard
	WHERE
		tDashboardGroup.DashboardKey = tDashboard.DashboardKey and
		SecurityGroupKey = @SecurityGroupKey and
		tDashboard.DashboardType = @Type

	RETURN 1
GO
