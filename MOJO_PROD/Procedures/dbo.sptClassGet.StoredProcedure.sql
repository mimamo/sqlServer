USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClassGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClassGet]
	@ClassKey int = null,
	@ClassID varchar(50) = null,
	@CompanyKey int = null

AS --Encrypt

IF ISNULL(@ClassKey, 0) = 0
	SELECT * 
	FROM tClass (nolock)
	Where
		CompanyKey =  @CompanyKey and ClassID = @ClassID
ELSE
	SELECT *
	FROM tClass (nolock)
	WHERE
		ClassKey = @ClassKey

	RETURN 1
GO
