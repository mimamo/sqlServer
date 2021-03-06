USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptServiceGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptServiceGet]
	@ServiceKey int = 0,
	@ServiceCode varchar(50) = NULL,
	@CompanyKey int = NULL
	
AS --Encrypt

/*
  || When       Who Rel      What
  || 07/29/2009 MFT 10.5.0.5 Added ServiceCode & CompanyKey params and condition
*/

IF @ServiceKey > 0
	SELECT s.*
		,gl.AccountNumber
		,cl.ClassID
	FROM tService s (NOLOCK) 
		left outer join tGLAccount gl (NOLOCK) on s.GLAccountKey = gl.GLAccountKey
		left outer join tClass cl (NOLOCK) on s.ClassKey = cl.ClassKey
	WHERE
		ServiceKey = @ServiceKey
ELSE
	SELECT s.*
		,gl.AccountNumber
		,cl.ClassID
	FROM tService s (NOLOCK) 
		left outer join tGLAccount gl (NOLOCK) on s.GLAccountKey = gl.GLAccountKey
		left outer join tClass cl (NOLOCK) on s.ClassKey = cl.ClassKey
	WHERE
		s.CompanyKey = @CompanyKey AND
		s.ServiceCode = @ServiceCode

RETURN 1
GO
