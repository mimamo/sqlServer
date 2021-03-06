USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStageGetByName]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStageGetByName]
	@CompanyKey int,
	@LeadStageName Varchar(50)

AS --Encrypt

/*
|| When     Who Rel      What
|| 5/05/09  MAS 10.5.0.0 Created
*/

SELECT *
FROM tLeadStage (nolock)
WHERE CompanyKey = @CompanyKey
and Upper(LeadStageName) = upper(@LeadStageName)
GO
