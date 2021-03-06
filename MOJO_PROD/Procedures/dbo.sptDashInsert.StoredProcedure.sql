USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDashInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDashInsert]

	(
		@DefKey int,
		@Type int
	)

AS



insert into tDashboardModuleDef
	(DashboardModuleDefKey,DisplayName,DashboardType,DashboardModuleGroupKey,DefDisplayOrder,Description,SourceFile)
	select 
	(select max(DashboardModuleDefKey) + 1 from tDashboardModuleDef),
	DisplayName,
	@Type,
	DashboardModuleGroupKey,
	DefDisplayOrder,
	Description,
	SourceFile 
	from tDashboardModuleDef
	where DashboardModuleDefKey = @DefKey


RETURN
GO
