USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGLBudget]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptGLBudget]
	@CompanyKey int,
	@GLBudgetKey int,
	@ClassKey int,
	@ClientKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@DepartmentKey int,
	@IncExpOnly tinyint
AS --Encrypt

/*
|| When      Who Rel     What
|| 7/3/07    CRG 8.5     Created for Enhancement 9562.
|| 5/23/08   CRG 8.5.1.2 (26727) Fixed problem with rollup.
|| 5/20/09   CRG 8.5.3.6 (52937) Fixed problems due to keys now being -1 in DB when blank.
|| 5/9/2011  GWG 10.544  Rollup is now a keyword in 2008, changed to [Rollup]
*/

	DECLARE @SearchClassKey int
	IF @ClassKey = 0
		SELECT @SearchClassKey = -1
	ELSE
		SELECT @SearchClassKey = @ClassKey

	DECLARE @SearchGLCompanyKey int
	IF @GLCompanyKey = 0
		SELECT @SearchGLCompanyKey = -1
	ELSE
		SELECT @SearchGLCompanyKey = @GLCompanyKey

	DECLARE @SearchOfficeKey int
	IF @OfficeKey = 0
		SELECT @SearchOfficeKey = -1
	ELSE
		SELECT @SearchOfficeKey = @OfficeKey

	DECLARE @SearchDepartmentKey int
	IF @DepartmentKey = 0
		SELECT @SearchDepartmentKey = -1
	ELSE
		SELECT @SearchDepartmentKey = @DepartmentKey

	IF @ClassKey >= 0
			AND @ClientKey >= 0
			AND @GLCompanyKey >= 0
			AND @OfficeKey >= 0
			AND @DepartmentKey >= 0
	BEGIN
		-- If none of the Keys are in "rollup mode", just do a simple query
		SELECT	gl.AccountNumber + ' ' + gl.AccountName as AccountName,
				gl.[Rollup],
				gl.DisplayLevel,
				gl.DisplayOrder,
				gl.AccountType,
				bd.Month1,
				bd.Month2,
				bd.Month3,
				bd.Month4,
				bd.Month5,
				bd.Month6,
				bd.Month7,
				bd.Month8,
				bd.Month9,
				bd.Month10,
				bd.Month11,
				bd.Month12,
				ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0) + ISNULL(bd.Month11, 0) + ISNULL(bd.Month12, 0) as Year,
				CASE 
					WHEN gl.AccountType in (40, 41, 50, 51, 52) THEN 1 
					ELSE 0 
				END AS IncExpType
		FROM	tGLAccount gl (nolock)
		LEFT JOIN tGLBudgetDetail bd (nolock) ON gl.GLAccountKey = bd.GLAccountKey 
													AND bd.GLBudgetKey = @GLBudgetKey
													AND bd.ClassKey = @SearchClassKey
													AND bd.ClientKey = @ClientKey
													AND bd.GLCompanyKey = @SearchGLCompanyKey
													AND bd.OfficeKey = @SearchOfficeKey
													AND bd.DepartmentKey = @SearchDepartmentKey
		WHERE	gl.CompanyKey = @CompanyKey
		AND		gl.Active = 1
		AND		((@IncExpOnly = 1 AND gl.AccountType in (40, 41, 50, 51, 52)) OR (@IncExpOnly = 0))
		ORDER BY DisplayOrder
	END
	ELSE
	BEGIN
		SELECT	gl.GLAccountKey,
				gl.AccountNumber + ' ' + gl.AccountName as AccountName,
				gl.[Rollup],
				gl.DisplayLevel,
				gl.DisplayOrder,
				bd.Month1,
				bd.Month2,
				bd.Month3,
				bd.Month4,
				bd.Month5,
				bd.Month6,
				bd.Month7,
				bd.Month8,
				bd.Month9,
				bd.Month10,
				bd.Month11,
				bd.Month12,
				CASE bd.ClassKey
					WHEN -1 THEN 0
					ELSE bd.ClassKey
				END AS ClassKey,
				bd.ClientKey,
				CASE bd.GLCompanyKey
					WHEN -1 THEN 0
					ELSE bd.GLCompanyKey
				END AS GLCompanyKey,
				CASE bd.OfficeKey
					WHEN -1 THEN 0
					ELSE bd.OfficeKey
				END AS OfficeKey,
				CASE bd.DepartmentKey
					WHEN -1 THEN 0
					ELSE bd.DepartmentKey
				END AS DepartmentKey,
				CAST(NULL AS money) AS Year
		INTO	#tGLBudgetDetail
		FROM	tGLAccount gl (nolock)
		LEFT JOIN tGLBudgetDetail bd (nolock) ON gl.GLAccountKey = bd.GLAccountKey 
													AND bd.GLBudgetKey = @GLBudgetKey
													AND (bd.ClassKey = @SearchClassKey OR @ClassKey = -1)
													AND (bd.ClientKey = @ClientKey OR @ClientKey = -1)
													AND (bd.GLCompanyKey = @SearchGLCompanyKey OR @GLCompanyKey = -1)
													AND (bd.OfficeKey = @SearchOfficeKey OR @OfficeKey = -1)
													AND (bd.DepartmentKey = @SearchDepartmentKey OR @DepartmentKey = -1)
		WHERE	gl.CompanyKey = @CompanyKey
		AND		gl.Active = 1
		AND		((@IncExpOnly = 1 AND gl.AccountType in (40, 41, 50, 51, 52)) OR (@IncExpOnly = 0))	

		IF @GLCompanyKey = -1
		BEGIN
			INSERT	#tGLBudgetDetail
					(GLAccountKey,
					AccountName,
					[Rollup],
					DisplayLevel,
					DisplayOrder,
					ClassKey,
					ClientKey,
					GLCompanyKey,
					OfficeKey,
					DepartmentKey,
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
					Month12)
			SELECT	GLAccountKey,
					AccountName,
					[Rollup],
					DisplayLevel,
					DisplayOrder,			
					ClassKey,
					ClientKey,
					-1,
					OfficeKey,
					DepartmentKey,
					SUM(Month1),
					SUM(Month2),
					SUM(Month3),
					SUM(Month4),
					SUM(Month5),
					SUM(Month6),
					SUM(Month7),
					SUM(Month8),
					SUM(Month9),
					SUM(Month10),
					SUM(Month11),
					SUM(Month12)
			FROM	#tGLBudgetDetail
			GROUP BY GLAccountKey, AccountName, [Rollup], DisplayLevel, DisplayOrder, ClassKey, ClientKey, OfficeKey, DepartmentKey

			DELETE	#tGLBudgetDetail
			WHERE	GLCompanyKey <> -1
		END	

		IF @OfficeKey = -1
		BEGIN
			INSERT	#tGLBudgetDetail
					(GLAccountKey,
					AccountName,
					[Rollup],
					DisplayLevel,
					DisplayOrder,
					ClassKey,
					ClientKey,
					GLCompanyKey,
					OfficeKey,
					DepartmentKey,
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
					Month12)
			SELECT	GLAccountKey,
					AccountName,
					[Rollup],
					DisplayLevel,
					DisplayOrder,
					ClassKey,
					ClientKey,
					GLCompanyKey,
					-1,
					DepartmentKey,
					SUM(Month1),
					SUM(Month2),
					SUM(Month3),
					SUM(Month4),
					SUM(Month5),
					SUM(Month6),
					SUM(Month7),
					SUM(Month8),
					SUM(Month9),
					SUM(Month10),
					SUM(Month11),
					SUM(Month12)
			FROM	#tGLBudgetDetail
			GROUP BY GLAccountKey, ClassKey, ClientKey, GLCompanyKey, DepartmentKey, AccountName, [Rollup], DisplayLevel, DisplayOrder
			
			DELETE	#tGLBudgetDetail
			WHERE	OfficeKey <> -1
		END	

		IF @DepartmentKey = -1
		BEGIN
			INSERT	#tGLBudgetDetail
					(GLAccountKey,
					AccountName,
					[Rollup],
					DisplayLevel,
					DisplayOrder,
					ClassKey,
					ClientKey,
					GLCompanyKey,
					OfficeKey,
					DepartmentKey,
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
					Month12)
			SELECT	GLAccountKey,
					AccountName,
					[Rollup],
					DisplayLevel,
					DisplayOrder,
					ClassKey,
					ClientKey,
					GLCompanyKey,
					OfficeKey,
					-1,
					SUM(Month1),
					SUM(Month2),
					SUM(Month3),
					SUM(Month4),
					SUM(Month5),
					SUM(Month6),
					SUM(Month7),
					SUM(Month8),
					SUM(Month9),
					SUM(Month10),
					SUM(Month11),
					SUM(Month12)
			FROM	#tGLBudgetDetail
			GROUP BY GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, AccountName, [Rollup], DisplayLevel, DisplayOrder
			
			DELETE	#tGLBudgetDetail
			WHERE	DepartmentKey <> -1
		END	

		IF @ClassKey = -1
		BEGIN
			INSERT	#tGLBudgetDetail
					(GLAccountKey,
					AccountName,
					[Rollup],
					DisplayLevel,
					DisplayOrder,
					ClassKey,
					ClientKey,
					GLCompanyKey,
					OfficeKey,
					DepartmentKey,
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
					Month12)
			SELECT	GLAccountKey,
					AccountName,
					[Rollup],
					DisplayLevel,
					DisplayOrder,
					-1,
					ClientKey,
					GLCompanyKey,
					OfficeKey,
					DepartmentKey,
					SUM(Month1),
					SUM(Month2),
					SUM(Month3),
					SUM(Month4),
					SUM(Month5),
					SUM(Month6),
					SUM(Month7),
					SUM(Month8),
					SUM(Month9),
					SUM(Month10),
					SUM(Month11),
					SUM(Month12)
			FROM	#tGLBudgetDetail
			GROUP BY GLAccountKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, AccountName, [Rollup], DisplayLevel, DisplayOrder
		
			DELETE	#tGLBudgetDetail
			WHERE	ClassKey <> -1
		END		

		IF @ClientKey = -1
		BEGIN
			INSERT	#tGLBudgetDetail
					(GLAccountKey,
					AccountName,
					[Rollup],
					DisplayLevel,
					DisplayOrder,
					ClassKey,
					ClientKey,
					GLCompanyKey,
					OfficeKey,
					DepartmentKey,
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
					Month12)
			SELECT	GLAccountKey,
					AccountName,
					[Rollup],
					DisplayLevel,
					DisplayOrder,
					ClassKey,
					-1,
					GLCompanyKey,
					OfficeKey,
					DepartmentKey,
					SUM(Month1),
					SUM(Month2),
					SUM(Month3),
					SUM(Month4),
					SUM(Month5),
					SUM(Month6),
					SUM(Month7),
					SUM(Month8),
					SUM(Month9),
					SUM(Month10),
					SUM(Month11),
					SUM(Month12)
			FROM	#tGLBudgetDetail
			GROUP BY GLAccountKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, AccountName, [Rollup], DisplayLevel, DisplayOrder
			
			DELETE	#tGLBudgetDetail
			WHERE	ClientKey <> -1
		END	

		UPDATE	#tGLBudgetDetail
		SET		ClassKey = 0
		WHERE	ClassKey = -1
		
		UPDATE	#tGLBudgetDetail
		SET		ClientKey = 0
		WHERE	ClientKey = -1
		
		UPDATE	#tGLBudgetDetail
		SET		GLCompanyKey = 0
		WHERE	GLCompanyKey = -1
		
		UPDATE	#tGLBudgetDetail
		SET		OfficeKey = 0
		WHERE	OfficeKey = -1
		
		UPDATE	#tGLBudgetDetail
		SET		DepartmentKey = 0
		WHERE	DepartmentKey = -1

		UPDATE	#tGLBudgetDetail
		SET		ClientKey = 0
		WHERE	ClientKey = -1

		UPDATE	#tGLBudgetDetail
		SET		[Year] = ISNULL(Month1, 0) + ISNULL(Month2, 0) + ISNULL(Month3, 0) + ISNULL(Month4, 0) + ISNULL(Month5, 0) + ISNULL(Month6, 0) + ISNULL(Month7, 0) + ISNULL(Month8, 0) + ISNULL(Month9, 0) + ISNULL(Month10, 0) + ISNULL(Month11, 0) + ISNULL(Month12, 0)	

		SELECT	gl.GLAccountKey,
				gl.AccountNumber + ' ' + gl.AccountName as AccountName,
				gl.[Rollup],
				gl.DisplayLevel,
				gl.DisplayOrder,
				bd.Month1,
				bd.Month2,
				bd.Month3,
				bd.Month4,
				bd.Month5,
				bd.Month6,
				bd.Month7,
				bd.Month8,
				bd.Month9,
				bd.Month10,
				bd.Month11,
				bd.Month12,
				bd.ClassKey,
				bd.ClientKey,
				bd.GLCompanyKey,
				bd.OfficeKey,
				bd.DepartmentKey,
				bd.[Year]
		FROM	tGLAccount gl (nolock)
		LEFT JOIN #tGLBudgetDetail bd (nolock) ON gl.GLAccountKey = bd.GLAccountKey 
													AND (bd.ClassKey = @ClassKey OR @ClassKey = -1)
													AND (bd.ClientKey = @ClientKey OR @ClientKey = -1)
													AND (bd.GLCompanyKey = @GLCompanyKey OR @GLCompanyKey = -1)
													AND (bd.OfficeKey = @OfficeKey OR @OfficeKey = -1)
													AND (bd.DepartmentKey = @DepartmentKey OR @DepartmentKey = -1)
		WHERE	gl.CompanyKey = @CompanyKey
		AND		gl.Active = 1
		AND		((@IncExpOnly = 1 AND gl.AccountType in (40, 41, 50, 51, 52)) OR (@IncExpOnly = 0))	
		ORDER BY gl.DisplayOrder

	END
GO
