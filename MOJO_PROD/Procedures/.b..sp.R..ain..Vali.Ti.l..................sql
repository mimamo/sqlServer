USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerValidTitle]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerValidTitle]
	@CompanyKey int,
	@Title varchar(200)
AS --Encrypt

	SELECT	RetainerKey
	FROM	tRetainer (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		Title = @Title
GO
