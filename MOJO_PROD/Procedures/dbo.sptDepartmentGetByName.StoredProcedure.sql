USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepartmentGetByName]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepartmentGetByName]
	@CompanyKey int,
	@DepartmentName varchar(200)
AS

/*
|| When      Who Rel      What
|| 3/16/09   CRG 10.5.0.0 Created for the Web to Lead process
*/

	SELECT	*
	FROM	tDepartment (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		DepartmentName = @DepartmentName
GO
