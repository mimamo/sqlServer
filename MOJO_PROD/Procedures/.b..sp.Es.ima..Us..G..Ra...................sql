USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateUserGetRate]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptEstimateUserGetRate]

	(
		@ProjectKey int,
		@UserKey int
	)

AS --Encrypt

if exists(Select 1 from tProject (nolock) Where ProjectKey = @ProjectKey and GetRateFrom = 3)
	Select HourlyRate
	From tAssignment (nolock)
	Where
		ProjectKey = @ProjectKey and
		UserKey = @UserKey
else
	Select HourlyRate
	From tUser (nolock)
	Where
		UserKey = @UserKey
GO
