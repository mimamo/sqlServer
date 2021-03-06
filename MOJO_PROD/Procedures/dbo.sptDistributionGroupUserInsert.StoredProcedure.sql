USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDistributionGroupUserInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDistributionGroupUserInsert]
	(
		@DistributionGroupKey INT,
		@UserKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON 
	
	IF NOT EXISTS (SELECT 1
					FROM  tDistributionGroupUser (NOLOCK)
					WHERE DistributionGroupKey = @DistributionGroupKey
					AND   UserKey = @UserKey
					)
					
	INSERT tDistributionGroupUser (DistributionGroupKey, UserKey)
	VALUES (@DistributionGroupKey, @UserKey)
					
	RETURN 1
GO
