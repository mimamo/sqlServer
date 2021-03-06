USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSessionGetAll]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSessionGetAll]
	@UserKey int
AS

	Declare @CompanyKey int
	Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) from tUser Where UserKey = @UserKey
	
	
	Select * from tSession (nolock)
	Where
		(EntityKey = @UserKey and Entity in ('conditions', 'user', 'DynamicReports', 'StandardReports', 'userDashboard', 'rights', 'recentTran'))
		OR
		(EntityKey = @CompanyKey and Entity in ('report', 'companyDashboard','CompanyMetrics'))

	RETURN
GO
