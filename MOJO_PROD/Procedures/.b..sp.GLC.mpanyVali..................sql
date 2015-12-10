USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyValid]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyValid]
	@CompanyKey int,
	@GLCompanyNameOrID varchar(500)
AS --Encrypt

/*
|| When     Who Rel     What
|| 08/09/11 MFT 10.546  Created
*/

DECLARE @key int

SELECT @key = GLCompanyKey
FROM tGLCompany (nolock)
WHERE
	GLCompanyID = @GLCompanyNameOrID AND
	CompanyKey = @CompanyKey

IF @key IS NULL
	SELECT @key = GLCompanyKey
	FROM tGLCompany (nolock)
	WHERE
		GLCompanyName = @GLCompanyNameOrID AND
		CompanyKey = @CompanyKey

SELECT *
FROM tGLCompany (nolock)
WHERE GLCompanyKey = @key
GO
