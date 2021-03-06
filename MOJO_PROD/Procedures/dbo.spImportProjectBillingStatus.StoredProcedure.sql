USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportProjectBillingStatus]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportProjectBillingStatus]
	@CompanyKey int,
	@ProjectBillingStatusID varchar(30),
	@ProjectBillingStatus varchar(200),
	@DisplayOrder int
AS --Encrypt

	IF EXISTS(SELECT 1 From tProjectBillingStatus (nolock) WHERE ProjectBillingStatusID = @ProjectBillingStatusID AND CompanyKey = @CompanyKey)
		RETURN -1

	INSERT tProjectBillingStatus
		(
		CompanyKey,
		ProjectBillingStatusID,
		ProjectBillingStatus,
		DisplayOrder
		)

	VALUES
		(
		@CompanyKey,
		@ProjectBillingStatusID,
		@ProjectBillingStatus,
		@DisplayOrder
		)
	
	RETURN 1
GO
