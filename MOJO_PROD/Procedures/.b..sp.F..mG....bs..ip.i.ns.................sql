USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormGetSubscriptions]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormGetSubscriptions]
 (
  @FormKey int
 )
AS --Encrypt
 SELECT 
  tUser.UserKey,
  ISNULL(tUser.Email, '') AS Email, 
  tUser.FirstName, 
  tUser.LastName,
  ISNULL(tUser.FirstName, '')+' '+ISNULL(tUser.LastName, '') AS UserFullName
  
 FROM tFormSubscription (nolock) INNER JOIN
     tUser (nolock) ON tFormSubscription.UserKey = tUser.UserKey
 WHERE 
  tFormSubscription.FormKey = @FormKey
GO
