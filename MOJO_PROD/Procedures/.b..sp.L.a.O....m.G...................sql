USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadOutcomeGet]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadOutcomeGet]
	@LeadOutcomeKey int

AS --Encrypt

		SELECT *
		FROM tLeadOutcome (nolock)
		WHERE
			LeadOutcomeKey = @LeadOutcomeKey

	RETURN 1
GO
