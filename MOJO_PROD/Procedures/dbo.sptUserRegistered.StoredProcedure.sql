USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserRegistered]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserRegistered]

	(
		@UserKey int
	)

AS --Encrypt

if exists(Select 1 From tUser (nolock) Where
	UserKey = @UserKey and
	Len(UserID) > 0 and
	Active = 1 and
	ClientVendorLogin = 0)
	
	Return 1
else
	return -1
GO
