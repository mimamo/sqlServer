USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserServiceInsert]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserServiceInsert]

	(
		@UserKey int,
		@ServiceKey int
	)

AS --Encrypt

/*
|| When     Who Rel       What
|| 01/26/07 RTC 8.4.0.2   Prevented insertion of duplicate service for the user
*/
  
  
if exists(select 1 from tUserService (nolock) where UserKey = @UserKey and ServiceKey = @ServiceKey)
	return 1
	
Insert tUserService
	(
	UserKey,
	ServiceKey
	)
Values
	(
	@UserKey,
	@ServiceKey
	)
GO
