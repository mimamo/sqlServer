USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeOptionGet]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeOptionGet]
	@CompanyKey int
	,@CheckTime smalldatetime = NULL --Optional because it's used in many places
	
AS --Encrypt
 
/*
|| When     Who Rel     What
|| 02/20/08 RTC 1.0.0.0 Added @CheckTime for the ListManager
*/
 
 IF @CompanyKey IS NULL
	SELECT *
	FROM  tTimeOption (NOLOCK) 
 ELSE
	IF @CheckTime IS NULL
	OR EXISTS
			(SELECT NULL
			FROM	tTimeOption (nolock)
			WHERE	CompanyKey = @CompanyKey
			AND		LastModified > @CheckTime)
		SELECT *
		FROM tTimeOption (NOLOCK) 
		WHERE CompanyKey = @CompanyKey
		
 RETURN 1
GO
