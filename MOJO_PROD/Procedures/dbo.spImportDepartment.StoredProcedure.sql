USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportDepartment]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportDepartment]
	@CompanyKey int,
	@DepartmentName varchar(200)
AS --Encrypt

	IF EXISTS (SELECT 1
	           FROM   tDepartment (NOLOCK)
	           WHERE  CompanyKey = @CompanyKey
	           AND    UPPER(LTRIM(RTRIM(DepartmentName))) = UPPER(LTRIM(RTRIM(@DepartmentName)))
	           )
	           RETURN -1
	           
	INSERT tDepartment
		(
		CompanyKey,
		DepartmentName
		)

	VALUES
		(
		@CompanyKey,
		@DepartmentName
		)
	
	RETURN 1
GO
