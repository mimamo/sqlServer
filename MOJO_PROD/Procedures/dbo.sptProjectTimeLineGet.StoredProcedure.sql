USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTimeLineGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTimeLineGet]
	@ProjectKey int,
	@UserKey int
	
	
AS -- Encrypt

/*
  || When      Who  Rel       What
  || 02/19/13  RLB  10.5.6.5  Adding for new Project TimeLine
*/
	
	
	SELECT *
	FROM vActionLog (nolock)
	WHERE ProjectKey = @ProjectKey
	and (@UserKey = 0 or UserKey = @UserKey)
	Order By ActionDate DESC
	
	RETURN 1
GO
