USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecUpdate]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecUpdate]
	@GLAccountRecKey int = NULL,
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
	@OpeningRec tinyint,
	@OpeningUncleared money,
	@OpeningCleared money

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/9/07   CRG 8.5     Added GLCompanyKey
|| 12/14/10  MFT 10.539  Added insert logic
|| 12/17/12  MFT 10.564  Added Opening fields
*/

IF @GLAccountRecKey IS NULL
BEGIN
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
		GLCompanyKey,
		OpeningRec,
		OpeningUncleared,
		OpeningCleared
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
		@GLCompanyKey,
		@OpeningRec,
		@OpeningUncleared,
		@OpeningCleared
		)
	
	SELECT @GLAccountRecKey = SCOPE_IDENTITY()
END
ELSE
	UPDATE
		tGLAccountRec
	SET
		CompanyKey = @CompanyKey,
		GLAccountKey = @GLAccountKey,
		StartDate = @StartDate,
		EndDate = @EndDate,
		StartBalance = @StartBalance,
		EndBalance = @EndBalance,
		OtherIncrease = @OtherIncrease,
		OtherDecrease = @OtherDecrease,
		Comments = @Comments,
		FilterStart = @FilterStart,
		FilterEnd = @FilterEnd,
		GLCompanyKey = @GLCompanyKey,
		OpeningRec = @OpeningRec,
		OpeningUncleared = @OpeningUncleared,
		OpeningCleared = @OpeningCleared
	WHERE
		GLAccountRecKey = @GLAccountRecKey 

RETURN ISNULL(@GLAccountRecKey, -1)
GO
