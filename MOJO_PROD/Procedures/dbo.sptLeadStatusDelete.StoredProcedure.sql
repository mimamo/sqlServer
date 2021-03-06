USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStatusDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStatusDelete]
	@LeadStatusKey int

AS --Encrypt

	if exists(select 1 from tLead (nolock) Where LeadStatusKey = @LeadStatusKey)
		return -1

	DELETE
	FROM tLeadStatus
	WHERE
		LeadStatusKey = @LeadStatusKey 

	RETURN 1
GO
