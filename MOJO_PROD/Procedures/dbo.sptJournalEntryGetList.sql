USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryGetList]

	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime


AS --Encrypt

if @StartDate is null
	SELECT *
	FROM tJournalEntry (nolock)
	WHERE
		CompanyKey = @CompanyKey
	Order by JournalNumber
else
	SELECT *
	FROM tJournalEntry (nolock)
	WHERE
		CompanyKey = @CompanyKey
	and	EntryDate >= @StartDate
	and EntryDate <= @EndDate
	Order by JournalNumber



	RETURN 1
GO
