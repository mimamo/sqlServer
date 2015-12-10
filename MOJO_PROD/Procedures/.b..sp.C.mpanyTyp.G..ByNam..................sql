USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyTypeGetByName]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyTypeGetByName]
	@CompanyKey int,
	@CompanyTypeName varchar(50)
AS

/*
|| When      Who Rel      What
|| 3/13/09   CRG 10.5.0.0 Created for the Web to Lead process
*/

	SELECT	*
	FROM	tCompanyType (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		CompanyTypeName = @CompanyTypeName
GO
