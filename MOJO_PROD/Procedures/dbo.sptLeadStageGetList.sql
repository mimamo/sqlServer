USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadStageGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadStageGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *, cast(tLeadStage.DisplayOrder as varchar) + ' - ' + tLeadStage.LeadStageName AS StageNameWithOrder
		FROM tLeadStage (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By
			DisplayOrder

	RETURN 1
GO
