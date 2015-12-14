USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepositGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepositGet]
	@DepositKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/5/07   GWG 8.5     Added GL Company Name
*/

		SELECT d.*
			,AccountNumber
			,AccountName
			,glc.GLCompanyName
			,Case Cleared When 1 then 'Cleared' else 'Open' end as ClearedText
		FROM tDeposit d (nolock)
			Inner join tGLAccount gl (nolock) on d.GLAccountKey = gl.GLAccountKey
			left outer join tGLCompany glc (nolock) on d.GLCompanyKey = glc.GLCompanyKey
		WHERE
			DepositKey = @DepositKey

	RETURN 1
GO
