USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepartmentGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepartmentGet]
	@DepartmentKey int = null,
	@DepartmentName varchar(200) = null,
	@CompanyKey  int = null

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/26/11   RLB 10544   Needed to change  SP to work with updates to Departments when importing them.
*/

if ISNULL(@DepartmentKey, 0) = 0
	select * 
	from tDepartment
	where 
		CompanyKey  = @CompanyKey and DepartmentName = @DepartmentName
ELSE		
	SELECT *
	FROM tDepartment (nolock)
	WHERE
		DepartmentKey = @DepartmentKey

	RETURN @DepartmentKey
GO
