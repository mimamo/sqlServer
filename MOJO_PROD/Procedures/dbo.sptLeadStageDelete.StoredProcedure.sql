USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStageDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStageDelete]
	@LeadStageKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 05/18/09  MAS 10.5.0.0 Nullify the tLead records when deleting a LeadStage
*/

UPDATE tLead
SET LeadStageKey = null
WHERE LeadStageKey = @LeadStageKey


DELETE
FROM tLeadStage
WHERE
	LeadStageKey = @LeadStageKey 

RETURN 1
GO
