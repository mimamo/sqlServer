USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetbyProjectNumber]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptProjectGetbyProjectNumber]
	@CompanyKey int,
	@ProjectNumber varchar(50)
AS

/*
|| When      Who Rel      What
|| 5/12/09   MAS 10.5.0.0 Created
*/

	SELECT	*
	FROM	tProject (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		upper(ltrim(rtrim(ProjectNumber))) = upper(ltrim(rtrim(@ProjectNumber)))
	
Return 1
GO
