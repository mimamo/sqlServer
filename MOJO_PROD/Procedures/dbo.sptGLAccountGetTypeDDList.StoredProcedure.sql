USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetTypeDDList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetTypeDDList]
	(
		@CompanyKey int,
		@MinAccountType smallint,
		@MaxAccountType smallint,
		@GLAccountKey int = null
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

Select	GLAccountKey,
		AccountNumber + ' ' + AccountName as AccountFullName,
		AccountNumber,
		AccountName
from	tGLAccount (nolock)
Where	AccountType >= @MinAccountType 
AND		AccountType <= @MaxAccountType
AND		Rollup = 0
AND		(Active = 1 OR GLAccountKey = @GLAccountKey)
AND		CompanyKey = @CompanyKey
Order By AccountNumber
GO
