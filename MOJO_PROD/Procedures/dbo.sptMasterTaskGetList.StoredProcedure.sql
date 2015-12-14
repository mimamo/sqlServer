USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tMasterTask (nolock)
		WHERE
		CompanyKey = @CompanyKey
		and TaskType = 1
		Order By Active DESC, TaskID

	RETURN 1
GO
