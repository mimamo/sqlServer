USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryGetAttachments]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryGetAttachments]
	(
	@JournalEntryKey int
	)
AS --Encrypt

/*
|| When     Who Rel      What
|| 03/17/14 RLB 10.578  (190898) Added for Enhancement
*/

	SET NOCOUNT ON 

	SELECT	a.*
	FROM	tAttachment a (nolock)
	INNER JOIN tJournalEntry je (nolock) ON a.EntityKey = je.JournalEntryKey
	WHERE je.JournalEntryKey =  @JournalEntryKey
	AND   a.AssociatedEntity = 'tJournalEntry' 
	
	RETURN 1
GO
