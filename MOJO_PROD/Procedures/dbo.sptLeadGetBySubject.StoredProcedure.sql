USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetBySubject]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGetBySubject]
	@CompanyKey int,
	@LeadSubject varchar(100)

AS --Encrypt

		SELECT 
			*
		FROM 
			tLead (nolock)
		WHERE
			CompanyKey = @CompanyKey AND
			Subject = @LeadSubject

RETURN 1
GO
