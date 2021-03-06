USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormSubscription]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormSubscription]
 @FormKey int,
 @UserKey int
AS --Encrypt
 IF EXISTS(
  Select 1 
  From tFormSubscription (nolock)
  Where FormKey = @FormKey AND
   UserKey = @UserKey)
 BEGIN
  DELETE
  FROM tFormSubscription
  WHERE
   FormKey = @FormKey AND
   UserKey = @UserKey
  RETURN 1
 END
 ELSE
 BEGIN
  INSERT tFormSubscription
   (
   FormKey,
   UserKey
   )
 
  VALUES
   (
   @FormKey,
   @UserKey
   )
  RETURN 2
 END
GO
