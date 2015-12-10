USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWriteOffReasonGetList]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWriteOffReasonGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tWriteOffReason (NOLOCK)
		WHERE
		CompanyKey = @CompanyKey
		Order By Active DESC, ReasonName

	RETURN 1
GO
