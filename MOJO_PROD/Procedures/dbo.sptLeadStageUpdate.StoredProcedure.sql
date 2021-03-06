USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStageUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStageUpdate]
	@LeadStageKey int,
	@CompanyKey int,
	@LeadStageName varchar(200),
	@DisplayOrder int,
	@DefaultProbability int,
	@DisplayOnDashboard tinyint,
	@UseDefaultProbability tinyint

AS --Encrypt
/*
  || When     Who Rel		What
  || 09/28/09 MAS 10.5.0.9	Added insert logic
*/


If @LeadStageKey <= 0
	BEGIN

		INSERT tLeadStage
			(
			CompanyKey,
			LeadStageName,
			DisplayOrder,
			DefaultProbability,
			DisplayOnDashboard,
			UseDefaultProbability
			)

		VALUES
			(
			@CompanyKey,
			@LeadStageName,
			@DisplayOrder,
			@DefaultProbability,
			@DisplayOnDashboard,
			@UseDefaultProbability
			)
		
		RETURN @@IDENTITY
	END
ElSE
	BEGIN
		UPDATE
			tLeadStage
		SET
			CompanyKey = @CompanyKey,
			LeadStageName = @LeadStageName,
			DisplayOrder = @DisplayOrder,
			DefaultProbability = @DefaultProbability,
			DisplayOnDashboard = @DisplayOnDashboard,
			UseDefaultProbability = @UseDefaultProbability
		WHERE
			LeadStageKey = @LeadStageKey 

		RETURN @LeadStageKey
	END
GO
