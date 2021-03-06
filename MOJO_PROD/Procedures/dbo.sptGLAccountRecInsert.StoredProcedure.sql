USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecInsert]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecInsert]
	@CompanyKey int,
	@GLAccountKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@StartBalance money,
	@EndBalance money,
	@OtherIncrease money,
	@OtherDecrease money,
	@Comments text,
	@FilterStart smalldatetime,
	@FilterEnd smalldatetime,
	@GLCompanyKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/9/07   CRG 8.5     Added GLCompanyKey
*/

	INSERT tGLAccountRec
		(
		CompanyKey,
		GLAccountKey,
		StartDate,
		EndDate,
		StartBalance,
		EndBalance,
		OtherIncrease,
		OtherDecrease,
		Comments,
		Completed,
		FilterStart,
		FilterEnd,
		GLCompanyKey
		)

	VALUES
		(
		@CompanyKey,
		@GLAccountKey,
		@StartDate,
		@EndDate,
		@StartBalance,
		@EndBalance,
		@OtherIncrease,
		@OtherDecrease,
		@Comments,
		0,
		@FilterStart,
		@FilterEnd,
		@GLCompanyKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
