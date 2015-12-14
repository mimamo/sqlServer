USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spUserSessionEnd]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spUserSessionEnd]
 (
  @UserKey int
 )
AS --Encrypt
 UPDATE tUser
 SET    LastLogin = GETDATE()
 WHERE  UserKey   = @UserKey
 
 /* set nocount on */
 return 1
GO
