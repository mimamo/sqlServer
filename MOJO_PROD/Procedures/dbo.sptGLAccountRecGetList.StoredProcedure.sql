USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecGetList]
	@CompanyKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 01/19/11  MFT 10.5.4.0 Added AccountNumberName
*/
		SELECT
			tGLAccountRec.*,
			AccountNumber,
			AccountName,
			AccountType,
			Case Completed When 1 then 'Completed' else 'Open' end as CompletedText,
			AccountNumber + ' - ' + AccountName AS AccountNumberName
		FROM tGLAccountRec (nolock) inner join tGLAccount (nolock) on tGLAccountRec.GLAccountKey = tGLAccount.GLAccountKey
		WHERE
			tGLAccountRec.CompanyKey = @CompanyKey	
		Order By AccountNumber, EndDate DESC

	RETURN 1
GO
