USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWorkTypeGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWorkTypeGet]
	@WorkTypeKey int = 0,
	@WorkTypeID varchar(100) = NULL,
	@CompanyKey int = NULL

AS --Encrypt

/*
  || When       Who Rel      What
  || 07/30/2009 MFT 10.5.0.5 Added WorkTypeID & CompanyKey params and condition
*/

IF @WorkTypeKey > 0
		SELECT tWorkType.*,
			tGLAccount.AccountNumber,
			tClass.ClassID
		FROM tWorkType (NOLOCK)
			Left Outer Join tGLAccount (NOLOCK) on tWorkType.GLAccountKey = tGLAccount.GLAccountKey
			left outer join tClass (NOLOCK) on tWorkType.ClassKey = tClass.ClassKey
		WHERE
			WorkTypeKey = @WorkTypeKey
ELSE
		SELECT tWorkType.*,
			tGLAccount.AccountNumber,
			tClass.ClassID
		FROM tWorkType (NOLOCK)
			Left Outer Join tGLAccount (NOLOCK) on tWorkType.GLAccountKey = tGLAccount.GLAccountKey
			left outer join tClass (NOLOCK) on tWorkType.ClassKey = tClass.ClassKey
		WHERE
			tWorkType.CompanyKey = @CompanyKey AND
			WorkTypeID = @WorkTypeID

RETURN 1
GO
