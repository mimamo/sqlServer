USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserServiceDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptUserServiceDelete]

	(
		@UserKey int
	)

AS --Encrypt

Delete tUserService
Where UserKey = @UserKey
GO
