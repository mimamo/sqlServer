USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActionLogGetSectionList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActionLogGetSectionList]
	(
		@CompanyKey int,
		@ProjectKey int
	)

AS --Encrypt

if ISNULL(@ProjectKey, 0) = 0
	Select Distinct Entity
	From tActionLog (nolock)
	Where CompanyKey = @CompanyKey and Entity <> 'FileVersion'
	Order By Entity
else
	Select Distinct Entity
	From tActionLog (nolock)
	Where ProjectKey = @ProjectKey and Entity <> 'FileVersion'
	Order By Entity
GO
