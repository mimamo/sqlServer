USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStatusGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStatusGet]
	@LeadStatusKey int

AS --Encrypt

		SELECT *
		FROM tLeadStatus (nolock)
		WHERE
			LeadStatusKey = @LeadStatusKey

	RETURN 1
GO
