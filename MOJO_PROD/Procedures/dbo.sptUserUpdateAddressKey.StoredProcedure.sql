USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateAddressKey]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateAddressKey]
 @UserKey int,
 @AddressKey int

 
AS --Encrypt


            
 UPDATE
  tUser
 SET
  AddressKey = @AddressKey
  
 WHERE
  UserKey = @UserKey 



		
 RETURN 1
GO
