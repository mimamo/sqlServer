USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDistributionGroupUserDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDistributionGroupUserDelete]
	(
		@DistributionGroupKey INT,
		@UserKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON 
	
	DELETE tDistributionGroupUser
	WHERE DistributionGroupKey = @DistributionGroupKey
	AND   UserKey = @UserKey
					
	RETURN 1
GO
