USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptImportGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptImportGetList]

AS --Encrypt

		SELECT tImport.*, tUser.FirstName, tUser.LastName, tUser.Email
		FROM tImport (nolock)
		inner join tUser (nolock) on tImport.UserKey = tUser.UserKey
		WHERE Status = 1
		Order By tImport.DateAdded

	RETURN 1
GO
