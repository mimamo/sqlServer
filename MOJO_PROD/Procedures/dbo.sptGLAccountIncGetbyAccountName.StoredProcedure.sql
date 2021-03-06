USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountIncGetbyAccountName]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[sptGLAccountIncGetbyAccountName]
	@CompanyKey Int,
	@AccountName varchar(200)

AS --Encrypt

/*
  || When     Who Rel		What
  || 05/09/09 MAS 10.5		Created
*/
	SELECT *
	FROM dbo.tGLAccount(NOLOCK)
	WHERE
		CompanyKey = @CompanyKey 
		And ltrim(rtrim(upper(AccountName))) = ltrim(rtrim(upper(@AccountName)))
GO
