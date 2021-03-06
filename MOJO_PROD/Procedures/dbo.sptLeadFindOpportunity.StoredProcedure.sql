USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadFindOpportunity]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadFindOpportunity]
	@CompanyKey int,
	@ContactCompanyKey int,
	@AccountManagerKey int,
	@Subject varchar(200)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 05/05/09 MAS 10.5   Created
  || 12/22/09 RLB 10.5.16 Subject limit is 200 so i upped it to that limit from 50
  */


Select * 
From tLead
Where CompanyKey = @CompanyKey
And upper(Subject) = upper(@Subject)
And ContactCompanyKey = @ContactCompanyKey
And AccountManagerKey = @AccountManagerKey

Return 1
GO
