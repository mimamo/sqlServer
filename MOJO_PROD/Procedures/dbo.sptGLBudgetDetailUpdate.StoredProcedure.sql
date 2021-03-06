USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetDetailUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetDetailUpdate]
	@GLBudgetKey int,
	@GLAccountKey int,
	@ClassKey int,
	@ClientKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@DepartmentKey int,
	@Month1 money,
	@Month2 money,
	@Month3 money,
	@Month4 money,
	@Month5 money,
	@Month6 money,
	@Month7 money,
	@Month8 money,
	@Month9 money,
	@Month10 money,
	@Month11 money,
	@Month12 money

AS --Encrypt

/*
|| When      Who Rel      What
|| 6/25/07   CRG 8.5	  (9562) Added GLCompanyKey, OfficeKey, DepartmentKey.
|| 3/10/09   CRG 10.0.2.0 Changing the keys to -1 for compatibility with WMJ. (When the keys are pulled out in CMP they are overridden back to 0). 
|| 10/23/09  CRG 10.5.1.2 (66334) Added conditions to the where clause to prevent duplicate entries of 0 and -1 for Class, GLCompany, Office, and Department
*/

	declare @BudgetType smallint
	
	IF @ClassKey = 0
		SELECT @ClassKey = -1
	
	IF @GLCompanyKey = 0
		SELECT @GLCompanyKey = -1
		
	IF @OfficeKey = 0
		SELECT @OfficeKey = -1
		
	IF @DepartmentKey = 0
		SELECT @DepartmentKey = -1

	select @BudgetType = BudgetType
	from tGLBudget (nolock)
	where GLBudgetKey = @GLBudgetKey
  
  
	if exists(select 1 from tGLBudgetDetail (nolock) 
						Where GLBudgetKey = @GLBudgetKey 
						and GLAccountKey = @GLAccountKey
						and (ClassKey = @ClassKey OR (ClassKey = 0 AND @ClassKey = -1))
						and ClientKey = @ClientKey
						and (GLCompanyKey = @GLCompanyKey OR (GLCompanyKey = 0 AND @GLCompanyKey = -1))
						and (OfficeKey = @OfficeKey OR (OfficeKey = 0 AND @OfficeKey = -1))
						and (DepartmentKey = @DepartmentKey OR (DepartmentKey = 0 AND @DepartmentKey = -1)))
		UPDATE
			tGLBudgetDetail
		SET
			Month1 = @Month1,
			Month2 = @Month2,
			Month3 = @Month3,
			Month4 = @Month4,
			Month5 = @Month5,
			Month6 = @Month6,
			Month7 = @Month7,
			Month8 = @Month8,
			Month9 = @Month9,
			Month10 = @Month10,
			Month11 = @Month11,
			Month12 = @Month12,
			ClassKey = @ClassKey,
			GLCompanyKey = @GLCompanyKey,
			OfficeKey = @OfficeKey,
			DepartmentKey = @DepartmentKey
		WHERE
			GLBudgetKey = @GLBudgetKey 
			AND GLAccountKey = @GLAccountKey 
			and (ClassKey = @ClassKey OR (ClassKey = 0 AND @ClassKey = -1))
			and ClientKey = @ClientKey
			and (GLCompanyKey = @GLCompanyKey OR (GLCompanyKey = 0 AND @GLCompanyKey = -1))
			and (OfficeKey = @OfficeKey OR (OfficeKey = 0 AND @OfficeKey = -1))
			and (DepartmentKey = @DepartmentKey OR (DepartmentKey = 0 AND @DepartmentKey = -1))
	else

		INSERT tGLBudgetDetail
			(
			GLBudgetKey,
			GLAccountKey,
			ClassKey,
			ClientKey,
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
			GLCompanyKey,
			OfficeKey,
			DepartmentKey
			)

		VALUES
			(
			@GLBudgetKey,
			@GLAccountKey,
			@ClassKey,
			@ClientKey,
			@Month1,
			@Month2,
			@Month3,
			@Month4,
			@Month5,
			@Month6,
			@Month7,
			@Month8,
			@Month9,
			@Month10,
			@Month11,
			@Month12,
			@GLCompanyKey,
			@OfficeKey,
			@DepartmentKey
			)
						
	RETURN 1
GO
