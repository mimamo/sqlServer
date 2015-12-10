USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGet]
	@LeadKey int

AS --Encrypt
/*
  || When     Who Rel    What
  || 02/04/12 RLB 10565  Added some fields to use with get lead row function
*/
		SELECT 
			l.*,
			c.CompanyName,
			ls.LeadStageName as LeadStageName,
			lstat.LeadStatusName as LeadStatusName
		FROM 
			tLead l (nolock)
			inner join tCompany c (nolock) on l.ContactCompanyKey = c.CompanyKey
			left outer join tLeadStage ls (nolock) on l.LeadStageKey = ls.LeadStageKey
			left outer join tLeadStatus lstat (nolock) on l.LeadStatusKey = lstat.LeadStatusKey
		WHERE
			l.LeadKey = @LeadKey

	RETURN 1
GO
