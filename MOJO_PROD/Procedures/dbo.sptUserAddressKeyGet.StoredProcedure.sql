USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserAddressKeyGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserAddressKeyGet]
  @UserKey int
AS --Encrypt
 
	SELECT	AddressKey
	FROM	tUser 
	WHERE	UserKey = @UserKey

 RETURN 1
GO
