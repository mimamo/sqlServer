USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadOutcomeDelete]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadOutcomeDelete]
	@LeadOutcomeKey int

AS --Encrypt

if exists(select 1 from tLead (nolock) where LeadOutcomeKey = @LeadOutcomeKey)
	return -1

	DELETE
	FROM tLeadOutcome
	WHERE
		LeadOutcomeKey = @LeadOutcomeKey 

	RETURN 1
GO
