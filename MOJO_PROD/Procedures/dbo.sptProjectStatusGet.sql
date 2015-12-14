USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectStatusGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectStatusGet]

	(
		@ProjectStatusKey int = null,
		@ProjectStatusID varchar(30) = null,
		@CompanyKey  int = null
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/26/11   RLB 10544   Needed to change  SP to work with updates to Project Statuses when importing them.
*/


IF ISNULL(@ProjectStatusKey, 0) = 0
	SELECT *
	FROM tProjectStatus (NOLOCK) 
	WHERE
		CompanyKey = @CompanyKey and ProjectStatusID = @ProjectStatusID
else
	SELECT *
	FROM tProjectStatus (NOLOCK) 
	WHERE
		ProjectStatusKey = @ProjectStatusKey

	RETURN 1
GO
