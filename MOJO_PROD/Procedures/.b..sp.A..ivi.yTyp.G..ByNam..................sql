USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityTypeGetByName]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityTypeGetByName]
	@CompanyKey int,
	@TypeName varchar(500)
AS

/*
|| When      Who Rel      What
|| 3/16/09   CRG 10.5.0.0 Created for the Web to Lead process.
*/

	SELECT	*
	FROM	tActivityType (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		upper(ltrim(rtrim(TypeName))) = upper(ltrim(rtrim(@TypeName)))
GO
