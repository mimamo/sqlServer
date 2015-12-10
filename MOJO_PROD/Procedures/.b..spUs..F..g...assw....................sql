USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spUserForgotPassword]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spUserForgotPassword]
 @UserID varchar(100)
 
AS --Encrypt
 SELECT UserKey, Email, Password
 FROM tUser (NOLOCK)
 WHERE UPPER(UserID) = UPPER(@UserID)
 
 RETURN 1
GO
