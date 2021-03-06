USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStageInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStageInsert]
	@CompanyKey int,
	@LeadStageName varchar(200),
	@DisplayOrder int,
	@DefaultProbability int,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tLeadStage
		(
		CompanyKey,
		LeadStageName,
		DisplayOrder,
		DefaultProbability
		)

	VALUES
		(
		@CompanyKey,
		@LeadStageName,
		@DisplayOrder,
		@DefaultProbability
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
