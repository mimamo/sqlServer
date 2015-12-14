USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWorkTypeGetList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWorkTypeGetList]

	@CompanyKey int
	,@WorkTypeKey int = NULL
	,@Active int = NULL

AS --Encrypt

		/*
		If @WorkTypeKey is not NULL, return row even if Active = 0
		*/
		
		IF @WorkTypeKey IS NULL
		
			SELECT wt.*
				,wt.WorkTypeID + ' - ' + WorkTypeName as WorkTypeFullName
				,gl.AccountNumber, gl.AccountName
			FROM tWorkType wt (NOLOCK)
				left outer join tGLAccount gl (NOLOCK) on wt.GLAccountKey = gl.GLAccountKey
			WHERE
				wt.CompanyKey = @CompanyKey
			AND (@Active IS NULL OR wt.Active = @Active)
			ORDER BY
				wt.DisplayOrder, wt.WorkTypeID

		ELSE
			-- WorkTypeKey IS NOT NULL
			SELECT wt.*
				,wt.WorkTypeID + ' - ' + WorkTypeName as WorkTypeFullName
				,gl.AccountNumber, gl.AccountName
			FROM tWorkType wt (NOLOCK)
				left outer join tGLAccount gl (NOLOCK) on wt.GLAccountKey = gl.GLAccountKey
			WHERE
				wt.CompanyKey = @CompanyKey
			AND    ((@Active IS NULL OR wt.Active = @Active) OR wt.WorkTypeKey = @WorkTypeKey) 
			ORDER BY
				wt.DisplayOrder, wt.WorkTypeID
		
	RETURN 1
GO
