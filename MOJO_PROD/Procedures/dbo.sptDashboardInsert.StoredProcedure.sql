USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashboardInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashboardInsert]
	@CompanyKey int,
	@DashboardType smallint,
	@DashboardName varchar(200),
	@ColumnActive1 tinyint,
	@ColumnActive2 tinyint,
	@ColumnActive3 tinyint,
	@ColumnWidth1 int,
	@ColumnWidth2 int,
	@ColumnWidth3 int,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tDashboard
		(
		CompanyKey,
		DashboardType,
		DashboardName,
		ColumnActive1,
		ColumnActive2,
		ColumnActive3,
		ColumnWidth1,
		ColumnWidth2,
		ColumnWidth3
		)

	VALUES
		(
		@CompanyKey,
		@DashboardType,
		@DashboardName,
		@ColumnActive1,
		@ColumnActive2,
		@ColumnActive3,
		@ColumnWidth1,
		@ColumnWidth2,
		@ColumnWidth3
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
