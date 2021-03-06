USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetBasicInfo]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserGetBasicInfo]

	(
		@UserKey int
	)

AS --Encrypt

SELECT 
	tUser.*, 
	tCompany.CompanyName
FROM tUser (NOLOCK) INNER JOIN
    tCompany (NOLOCK) ON tUser.CompanyKey = tCompany.CompanyKey
WHERE
	tUser.UserKey = @UserKey
GO
