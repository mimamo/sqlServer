USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityFindActivity]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityFindActivity]
	@CompanyKey int,
	@ActivityDate datetime,
	@Subject varchar(500)
AS

/*
|| When      Who Rel      What
|| 5/13/09   MAS 10.5.0.0 Created
*/

	SELECT	*
	FROM	tActivity (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		ActivityDate = @ActivityDate
	AND		upper(ltrim(rtrim(Subject))) = upper(ltrim(rtrim(@Subject)))

return 1
GO
