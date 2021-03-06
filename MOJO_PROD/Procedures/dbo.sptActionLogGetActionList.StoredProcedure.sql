USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActionLogGetActionList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActionLogGetActionList]
	(
		@CompanyKey int,
		@ProjectKey int
	)

AS --Encrypt

if ISNULL(@ProjectKey, 0) = 0
	Select Distinct Action
	From tActionLog (nolock)
	Where CompanyKey = @CompanyKey and Entity <> 'FileVersion'
	Order By Action
else
	Select Distinct Action
	From tActionLog (nolock)
	Where ProjectKey = @ProjectKey and Entity <> 'FileVersion'
	Order By Action
GO
