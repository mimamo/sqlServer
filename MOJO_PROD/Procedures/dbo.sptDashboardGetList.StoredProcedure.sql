USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardGetList]

	@CompanyKey int,
	@DashboardType smallint


AS --Encrypt

		SELECT *
		FROM tDashboard (nolock)
		WHERE
		CompanyKey = @CompanyKey and
		DashboardType = @DashboardType
		Order By DashboardName

	RETURN 1
GO
