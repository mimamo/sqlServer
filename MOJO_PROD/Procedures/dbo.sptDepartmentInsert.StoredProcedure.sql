USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepartmentInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepartmentInsert]
	@CompanyKey int,
	@DepartmentName varchar(200),
	@Active tinyint,
	@oIdentity INT OUTPUT
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
		DepartmentName,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@DepartmentName,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
