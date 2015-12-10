USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckMethodDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckMethodDelete]
	@CheckMethodKey int

AS --Encrypt

	if exists(Select 1 from tCheck (nolock) Where CheckMethodKey = @CheckMethodKey)
		Return -1
		
	DELETE
	FROM tCheckMethod
	WHERE
		CheckMethodKey = @CheckMethodKey 

	RETURN 1
GO
