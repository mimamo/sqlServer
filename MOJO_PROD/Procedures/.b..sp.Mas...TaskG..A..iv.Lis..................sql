USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskGetActiveList]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskGetActiveList]

	@CompanyKey int,
	@TaskType smallint


AS --Encrypt

		SELECT *
		FROM tMasterTask (nolock)
		WHERE
		CompanyKey = @CompanyKey
		and Active = 1
		and TaskType = @TaskType
		Order By TaskID

	RETURN 1
GO
