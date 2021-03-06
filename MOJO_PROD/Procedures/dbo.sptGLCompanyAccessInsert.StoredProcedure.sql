USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyAccessInsert]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyAccessInsert]
	@Entity varchar(50),
	@EntityKey int,
	@GLCompanyKey int

AS --Encrypt
	
/*
|| When     Who Rel       What
|| 06/01/12 MFT 10.5.5.6  Created
*/

DECLARE @CompanyKey int SELECT @CompanyKey = CompanyKey FROM tGLCompany (NOLOCK) WHERE GLCompanyKey = @GLCompanyKey

IF NOT EXISTS(
	SELECT * FROM tGLCompanyAccess (NOLOCK)
	WHERE
		Entity = @Entity AND
		EntityKey = @EntityKey AND
		GLCompanyKey = @GLCompanyKey)
INSERT INTO
	tGLCompanyAccess
	(
		Entity,
		EntityKey,
		GLCompanyKey,
		CompanyKey
	)
VALUES
	(
		@Entity,
		@EntityKey,
		@GLCompanyKey,
		@CompanyKey
	)
GO
