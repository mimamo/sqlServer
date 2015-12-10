USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectBillingStatusInsert]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectBillingStatusInsert]
	@CompanyKey int,
	@ProjectBillingStatusID varchar(30),
	@ProjectBillingStatus varchar(200),
	@DisplayOrder int,
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 5/1/07    CRG 8.5     (8991) Added @Active parameter
*/

	IF EXISTS(SELECT 1 From tProjectBillingStatus (NOLOCK) WHERE ProjectBillingStatusID = @ProjectBillingStatusID AND CompanyKey = @CompanyKey)
		RETURN -1

	INSERT tProjectBillingStatus
		(
		CompanyKey,
		ProjectBillingStatusID,
		ProjectBillingStatus,
		DisplayOrder,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@ProjectBillingStatusID,
		@ProjectBillingStatus,
		@DisplayOrder,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
