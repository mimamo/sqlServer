USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeGetByName]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeGetByName]
	@CompanyKey int,
	@ProjectTypeName varchar(100)
AS

/*
|| When      Who Rel      What
|| 3/13/09   CRG 10.5.0.0 Created for the Web to Lead process
*/

	SELECT	*
	FROM	tProjectType (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		ProjectTypeName = @ProjectTypeName
GO
