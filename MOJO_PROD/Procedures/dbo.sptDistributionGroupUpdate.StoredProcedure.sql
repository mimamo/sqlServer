USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDistributionGroupUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDistributionGroupUpdate]
	@DistributionGroupKey int,
	@CompanyKey int,
	@UserKey int,
	@Personal tinyint,
	@GroupName varchar(200),
	@Active tinyint

AS -- Encrypt

	IF @Personal = 0 
		IF EXISTS (SELECT 1 
				FROM  tDistributionGroup (NOLOCK)
				WHERE CompanyKey = @CompanyKey
				AND   UPPER(LTRIM(RTRIM(GroupName))) = UPPER(LTRIM(RTRIM(@GroupName)))
				AND   DistributionGroupKey <> @DistributionGroupKey
				)
			RETURN -1 

	IF @Personal = 1 
		IF EXISTS (SELECT 1 
				FROM  tDistributionGroup (NOLOCK)
				WHERE CompanyKey = @CompanyKey
				AND   UPPER(LTRIM(RTRIM(GroupName))) = UPPER(LTRIM(RTRIM(@GroupName)))
				AND   UserKey = @UserKey
				AND   DistributionGroupKey <> @DistributionGroupKey
				)
			RETURN -1 
			
	IF @Personal = 0 
		SELECT @UserKey = NULL
			
	UPDATE
		tDistributionGroup
	SET
		CompanyKey = @CompanyKey,
		UserKey = @UserKey,
		Personal = @Personal,
		GroupName = @GroupName,
		Active = @Active
	WHERE
		DistributionGroupKey = @DistributionGroupKey 

	RETURN 1
GO
