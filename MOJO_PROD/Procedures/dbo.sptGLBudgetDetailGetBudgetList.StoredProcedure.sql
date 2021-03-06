USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetDetailGetBudgetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetDetailGetBudgetList]
	@GLBudgetKey int,
	@OverrideFrom int = -1,
	@OverrideTo int = 0
AS --Encrypt

/*
|| When      Who Rel      What
|| 6/27/07   CRG 8.5      Created for enhancement 9562.
|| 2/10/09   CRG 10.0.1.9 (46555) Now returning -1 when Class, GLCompanyKey, OfficeKey, and DepartmentKey are 0.
|| 3/10/09   CRG 10.0.2.0 (48828) Added optional OverridFrom/To parameters for backward compatibility to CMP85.
*/

	SELECT 	GLBudgetKey,
			GLAccountKey,
			CASE
				WHEN ISNULL(ClassKey, @OverrideFrom) = @OverrideFrom THEN @OverrideTo
				ELSE ClassKey
			END AS ClassKey,
			Month1,
			Month2,
			Month3,
			Month4,
			Month5,
			Month6,
			Month7,
			Month8,
			Month9,
			Month10,
			Month11,
			Month12,
			ClientKey,
			CASE
				WHEN ISNULL(GLCompanyKey, @OverrideFrom) = @OverrideFrom THEN @OverrideTo
				ELSE GLCompanyKey
			END AS GLCompanyKey,
			CASE
				WHEN ISNULL(OfficeKey, @OverrideFrom) = @OverrideFrom THEN @OverrideTo
				ELSE OfficeKey
			END AS OfficeKey,
			CASE
				WHEN ISNULL(DepartmentKey, @OverrideFrom) = @OverrideFrom THEN @OverrideTo
				ELSE DepartmentKey
			END AS DepartmentKey
	FROM	tGLBudgetDetail (nolock)
	WHERE	GLBudgetKey = @GLBudgetKey
GO
