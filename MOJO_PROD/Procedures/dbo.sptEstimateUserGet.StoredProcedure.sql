USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateUserGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateUserGet]
	@EstimateUserKey int

AS --Encrypt

		SELECT eu.*, u.FirstName + ' ' + u.LastName as UserName
		FROM tEstimateUser eu (nolock),
			tUser u (nolock)
		WHERE
			eu.UserKey = u.UserKey and
			EstimateUserKey = @EstimateUserKey

	RETURN 1
GO
