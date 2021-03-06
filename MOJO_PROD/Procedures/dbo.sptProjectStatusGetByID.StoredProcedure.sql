USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectStatusGetByID]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectStatusGetByID]
	@CompanyKey int,
	@ProjectStatusID varchar(30)

AS --Encrypt

	SELECT
		*
	FROM
		tProjectStatus (nolock) 
	WHERE
		CompanyKey = @CompanyKey AND
		ProjectStatusID = @ProjectStatusID

	RETURN 1
GO
