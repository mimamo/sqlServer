USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardUpdate]
	@DashboardKey int,
	@CompanyKey int,
	@DashboardType smallint,
	@DashboardName varchar(200),
	@ColumnActive1 tinyint,
	@ColumnActive2 tinyint,
	@ColumnActive3 tinyint,
	@ColumnWidth1 int,
	@ColumnWidth2 int,
	@ColumnWidth3 int

AS --Encrypt

	UPDATE
		tDashboard
	SET
		CompanyKey = @CompanyKey,
		DashboardType = @DashboardType,
		DashboardName = @DashboardName,
		ColumnActive1 = @ColumnActive1,
		ColumnActive2 = @ColumnActive2,
		ColumnActive3 = @ColumnActive3,
		ColumnWidth1 = @ColumnWidth1,
		ColumnWidth2 = @ColumnWidth2,
		ColumnWidth3 = @ColumnWidth3
	WHERE
		DashboardKey = @DashboardKey 

	RETURN 1
GO
