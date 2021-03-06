USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvActionLogGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spvActionLogGet]
	@EntityKey int,
	@Entity varchar(50),
	@UserKey int,
	@CompanyKey int
	
AS -- Encrypt

/*
  || When      Who  Rel       What
  || 09/03/13  WDF  10.5.7.2  (185511) Added for Opportunities
*/
	SELECT *
	FROM vActionLog (nolock)
	WHERE EntityKey = @EntityKey
	  and CompanyKey = @CompanyKey
	  and (@Entity = null 
	   or  Entity = @Entity)
	  and (@UserKey = 0 
	   or  UserKey = @UserKey)
	Order By ActionDate DESC
	
	RETURN 1
GO
