USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStatusInsert]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStatusInsert]
	@CompanyKey int,
	@LeadStatusName varchar(200),
	@DisplayOrder int,
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tLeadStatus
		(
		CompanyKey,
		LeadStatusName,
		DisplayOrder,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@LeadStatusName,
		@DisplayOrder,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
