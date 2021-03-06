USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDistributionGroupInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDistributionGroupInsert]
	@CompanyKey int,
	@UserKey int,
	@Personal tinyint,
	@GroupName varchar(200),
	@Active tinyint,
	@oIdentity INT OUTPUT
AS -- Encrypt


	IF @Personal = 0 
		IF EXISTS (SELECT 1 
				FROM  tDistributionGroup (NOLOCK)
				WHERE CompanyKey = @CompanyKey
				AND   UPPER(LTRIM(RTRIM(GroupName))) = UPPER(LTRIM(RTRIM(@GroupName)))
				AND   Personal = 0
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
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
