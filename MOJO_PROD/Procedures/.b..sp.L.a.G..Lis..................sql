USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetList]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGetList]

	@CompanyKey int
	

AS --Encrypt



SELECT l.*
FROM tLead l (nolock)
WHERE 
	l.ContactCompanyKey = @CompanyKey
	Order By StartDate DESC

	RETURN 1
GO
