USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDistributionGroupUserGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDistributionGroupUserGetList]
	(
		@DistributionGroupKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON 
	
	SELECT dgu.*
		   ,dg.Personal  -- Needed by the Grid
		   ,u.FirstName
		   ,u.MiddleName
		   ,u.LastName		   	
	FROM   tDistributionGroupUser dgu (NOLOCK)
		INNER JOIN tDistributionGroup dg (NOLOCK) ON dgu.DistributionGroupKey = dg.DistributionGroupKey 
		INNER JOIN tUser u (NOLOCK) ON dgu.UserKey = u.UserKey 		
	WHERE  dgu.DistributionGroupKey = @DistributionGroupKey
					
	RETURN 1
GO
