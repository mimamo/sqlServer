USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDistributionGroupCopy]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDistributionGroupCopy]
	@DistributionGroupKey int,
	@UserKey int,
	@Personal tinyint,
	@oIdentity INT OUTPUT
AS -- Encrypt

	DECLARE @GroupName VARCHAR(200)
			,@CompanyKey INT
			
	SELECT @CompanyKey = CompanyKey
	      ,@GroupName = GroupName
	FROM   tDistributionGroup (NOLOCK)
	WHERE  DistributionGroupKey = @DistributionGroupKey
	
	SELECT @GroupName = 'Copy of '+ @GroupName
			 
	IF @Personal = 0 
		IF EXISTS (SELECT 1 
				FROM  tDistributionGroup (NOLOCK)
				WHERE CompanyKey = @CompanyKey
				AND   UPPER(LTRIM(RTRIM(GroupName))) = UPPER(LTRIM(RTRIM(@GroupName)))
				)
			RETURN -1 

	IF @Personal = 1 
		IF EXISTS (SELECT 1 
				FROM  tDistributionGroup (NOLOCK)
				WHERE CompanyKey = @CompanyKey
				AND   UPPER(LTRIM(RTRIM(GroupName))) = UPPER(LTRIM(RTRIM(@GroupName)))
				AND   UserKey = @UserKey
				)
			RETURN -1 

	IF @Personal = 0 
		SELECT @UserKey = NULL
						
	INSERT tDistributionGroup
		(
		CompanyKey,
		UserKey,
		Personal,
		GroupName,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@UserKey,
		@Personal,
		@GroupName,
		1
		)
	
	SELECT @oIdentity = @@IDENTITY

	INSERT tDistributionGroupUser ( DistributionGroupKey, UserKey)
	SELECT @oIdentity, UserKey
	FROM   tDistributionGroupUser (NOLOCK)
	WHERE  DistributionGroupKey = @DistributionGroupKey 
	
	RETURN 1
GO
