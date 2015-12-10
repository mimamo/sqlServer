USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadUpdateOutcome]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadUpdateOutcome]
	@LeadKey int,
	@LeadStatusKey int,
	@LeadOutcomeKey int,
	@OutcomeComment varchar(2000),
	@ActualCloseDate smalldatetime

AS --Encrypt

	UPDATE
		tLead
	SET
		LeadStatusKey = @LeadStatusKey,
		LeadOutcomeKey = @LeadOutcomeKey,
		OutcomeComment = @OutcomeComment,
		ActualCloseDate = @ActualCloseDate
	WHERE
		LeadKey = @LeadKey 

	RETURN 1
GO
