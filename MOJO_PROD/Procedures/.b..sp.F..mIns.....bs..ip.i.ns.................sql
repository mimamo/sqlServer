USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormInsertSubscriptions]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormInsertSubscriptions]
 (
  @FormKey int
  ,@UserKey int
 )
AS --Encrypt

	INSERT tFormSubscription (FormKey, UserKey)
	SELECT @FormKey, @UserKey
GO
