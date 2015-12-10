USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadOutcomeGetList]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadOutcomeGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tLeadOutcome (nolock)
		WHERE
			CompanyKey = @CompanyKey
		ORDER BY
			Outcome

	RETURN 1
GO
