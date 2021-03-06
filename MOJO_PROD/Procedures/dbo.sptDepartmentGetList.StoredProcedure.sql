USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepartmentGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepartmentGetList]

	@CompanyKey int,
	@Active int = 1, -- -1: Show everything
	@DepartmentKey int = NULL

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
|| 10/25/07  CRG 8.5     Changed the ISNULL option for Active to 0 so it doesn't incorrectly show Departments as Active in the list when Active is NULL.
|| 6/23/08   CRG 8.5.1.4 Added ability to pass -1 for Active in order to get all values regardless of whether they were active or not.
|| 7/16/08   GWG 8.5.1.6 added back the null flag as well because the old listings pass in null
*/

	SELECT	DepartmentKey, CompanyKey, DepartmentName, ISNULL(Active, 1) AS Active
	FROM	tDepartment (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND     ((@Active is null) OR (@Active = -1) OR (ISNULL(Active, 0) = @Active) OR (DepartmentKey = @DepartmentKey))
		
	RETURN 1
GO
