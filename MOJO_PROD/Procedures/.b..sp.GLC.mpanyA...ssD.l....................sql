USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyAccessDelete]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyAccessDelete]
	@GLCompanyKey int

AS --Encrypt
	
/*
|| When     Who Rel       What
|| 06/01/12 MFT 10.5.5.6  Created
*/

DELETE
FROM
	tGLCompanyAccess
WHERE
	GLCompanyKey = @GLCompanyKey
GO
