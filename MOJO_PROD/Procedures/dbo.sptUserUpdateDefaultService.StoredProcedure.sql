USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateDefaultService]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateDefaultService]
	(
		@UserKey int,
		@ServiceKey int
	)
AS --Encrypt

  /*
  || When     Who Rel		What
  || 09/17/10 RLB 10.535    Added for Default Service Update  
  */
  
  
   Declare @cnt int

  select @cnt = ISNULL(COUNT(*), 0) from tTaskUser (nolock) where UserKey = @UserKey and ServiceKey is NULL

  Update tTaskUser set ServiceKey = @ServiceKey where UserKey = @UserKey and ServiceKey is NULL
 
 return @cnt
GO
