USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetDDList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetDDList]
	(
		@CompanyKey INT
		,@UserKey INT
	)
AS

  /*
  || When     Who Rel   What
  || 02/19/07 GHL 8.4   Creation for Drop Downs where a user has been associated to a record 
  ||                    like an account manager to a project then is marked as inactive 
  || 04/19/07 RLB 8.42 Change drop listing from first name to last name                 
  */

	SET NOCOUNT ON
	
	SELECT *
		   ,ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') AS UserName
	FROM   tUser (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    (Active = 1
			OR
			UserKey = @UserKey)
	ORDER BY LastName, FirstName
	
	RETURN 1
GO
