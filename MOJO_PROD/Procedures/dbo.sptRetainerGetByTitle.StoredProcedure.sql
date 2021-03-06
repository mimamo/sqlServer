USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerGetByTitle]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerGetByTitle]
	(
	@CompanyKey int,
	@ClientKey int,
	@Title varchar(200)
	)

AS --Encrypt

/*
  || When        Who Rel       What
  || 12/07/2011  MFT 10.5.5.1  Added @ClientKey 
*/
	SET NOCOUNT ON

	SELECT * 
	FROM  tRetainer (nolock)
	WHERE
		CompanyKey = @CompanyKey AND
		ClientKey = @ClientKey AND
		UPPER(Title) = UPPER(@Title)
	
	RETURN
GO
