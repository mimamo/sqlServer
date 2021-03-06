USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStatusUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStatusUpdate]
	@LeadStatusKey int,
	@CompanyKey int,
	@LeadStatusName varchar(200),
	@DisplayOrder int,
	@Active tinyint

AS --Encrypt

/*
  || When     Who Rel		What
  || 09/28/09 MAS 10.5.0.9	Added insert logic
*/

IF @LeadStatusKey <= 0
	BEGIN
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
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tLeadStatus
		SET
			CompanyKey = @CompanyKey,
			LeadStatusName = @LeadStatusName,
			DisplayOrder = @DisplayOrder,
			Active = @Active
		WHERE
			LeadStatusKey = @LeadStatusKey 

		RETURN @LeadStatusKey
	END
GO
