USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSourceGetByName]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSourceGetByName]
	@CompanyKey int,
	@SourceName varchar(200)
AS

/*
|| When      Who Rel      What
|| 3/13/09   CRG 10.5.0.0 Created for the Web to Lead process
*/

	SELECT	*
	FROM	tSource (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		SourceName = @SourceName
GO
