USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetDetailGetList]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetDetailGetList]

	(
		@CompanyKey int,
		@GLBudgetKey int,
		@ClassKey int,
		@ClientKey int,
		@ActiveOnly tinyint,
		@IncExpOnly tinyint = 0
	)

AS --Encrypt
  
/*
|| When      Who Rel     What
|| 5/3/07    CRG 8.4.3   (8981) Modified to include AccountType 52 when it is setting IncExpType to 1
|| 6/18/07   CRG 8.5     Added AccountNameDash to display the Number and Name with a dash separator.
||                       This SP is used by some custom reports, so I didn't want to change the AccountName column.
||                       Added IncExpOnly optional parameter.
*/  

		Select
			gl.GLAccountKey,
			gl.AccountNumber,
			ISNULL(gl.ParentAccountKey, 0) as ParentAccountKey,
			gl.AccountNumber + ' ' + gl.AccountName as AccountName,
			gl.AccountNumber + ' - ' + gl.AccountName as AccountNameDash,
			gl.Rollup,
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
			case 
				when gl.AccountType in (40, 41, 50, 51, 52) then 1 
				else 0 
			end as IncExpType
		from
			tGLAccount gl (nolock)
			Left Outer Join 
				(Select 
					GLAccountKey 
					,Month1
					,Month2
					,Month3
					,Month4
					,Month5
					,Month6
					,Month7
					,Month8
					,Month9
					,Month10
					,Month11
					,Month12
				from tGLBudgetDetail (nolock) Where GLBudgetKey = @GLBudgetKey and ClientKey = @ClientKey and ClassKey = @ClassKey) as bd on gl.GLAccountKey = bd.GLAccountKey
		Where	gl.CompanyKey = @CompanyKey 
		and		gl.Active >= @ActiveOnly
		AND		((@IncExpOnly = 1 AND gl.AccountType in (40, 41, 50, 51, 52)) OR (@IncExpOnly = 0))
		Order By DisplayOrder
GO
