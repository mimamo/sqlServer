USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadOutcomeGetByName]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadOutcomeGetByName]
	@CompanyKey int,
	@LeadOutcome Varchar(50)

AS --Encrypt

/*
|| When     Who Rel      What
|| 5/05/09  MAS 10.5.0.0 Created
*/

SELECT *
FROM tLeadOutcome (nolock)
WHERE CompanyKey = @CompanyKey
and Upper(Outcome) = upper(@LeadOutcome)
GO
