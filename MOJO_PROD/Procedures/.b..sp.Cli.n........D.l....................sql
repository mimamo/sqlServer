USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientProductDelete]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientProductDelete]
	@ClientProductKey int

AS --Encrypt

  /*
  || When     Who Rel   What
  || 03/23/07 GHL 8.4.1   Added check of project table                  
  */
  
	If exists(Select 1 From tMediaEstimate (nolock) Where ClientProductKey = @ClientProductKey)
		Return -1

	If exists(Select 1 From tProject (nolock) Where ClientProductKey = @ClientProductKey)
		Return -2

	DELETE
	FROM tClientProduct
	WHERE
		ClientProductKey = @ClientProductKey 

	RETURN 1
GO
