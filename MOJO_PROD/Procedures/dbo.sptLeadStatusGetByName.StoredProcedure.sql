USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStatusGetByName]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[sptLeadStatusGetByName]
	@CompanyKey int,
	@LeadStatusName Varchar(50)

AS --Encrypt

/*
|| When     Who Rel      What
|| 5/05/09  MAS 10.5.0.0 Created
*/

SELECT *
FROM tLeadStatus (nolock)
WHERE CompanyKey = @CompanyKey
and Upper(LeadStatusName) = upper(@LeadStatusName)
GO
