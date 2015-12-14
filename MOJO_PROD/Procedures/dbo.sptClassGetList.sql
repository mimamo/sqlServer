USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClassGetList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClassGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tClass (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order by Active DESC, ClassID

	RETURN 1
GO
