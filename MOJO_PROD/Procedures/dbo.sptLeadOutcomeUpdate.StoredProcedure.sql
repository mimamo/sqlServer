USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadOutcomeUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadOutcomeUpdate]
	@LeadOutcomeKey int,
	@CompanyKey int,
	@Outcome varchar(200),
	@PositiveOutcome tinyint = -1 --Optional because of CMP90
	
AS --Encrypt

/*
|| When      Who Rel      What
|| 4/30/09   CRG 10.5.0.0 Added PositiveOutcome
|| 08/26/09	 MAS 10.5.0.8 Added insert logic
*/

IF @LeadOutcomeKey <= 0
	BEGIN
		INSERT tLeadOutcome	(CompanyKey, Outcome, PositiveOutcome)
		VALUES(@CompanyKey, @Outcome, @PositiveOutcome)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		IF @PositiveOutcome = -1
			SELECT	@PositiveOutcome = PositiveOutcome
			FROM	tLeadOutcome (nolock)
			WHERE	LeadOutcomeKey = @LeadOutcomeKey

			UPDATE
				tLeadOutcome
			SET
				CompanyKey = @CompanyKey,
				Outcome = @Outcome,
				PositiveOutcome = @PositiveOutcome
			WHERE
				LeadOutcomeKey = @LeadOutcomeKey 

			RETURN @LeadOutcomeKey 		
	END
GO
