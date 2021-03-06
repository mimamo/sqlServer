USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientDivisionDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientDivisionDelete]
	@ClientDivisionKey int

AS --Encrypt

	If exists(Select 1 From tMediaEstimate (nolock) Where ClientDivisionKey = @ClientDivisionKey)
		Return -1

	If exists(Select 1 From tClientProduct (nolock) Where ClientDivisionKey = @ClientDivisionKey)
		Return -2
		
	If exists(Select 1 From tProject (nolock) Where ClientDivisionKey = @ClientDivisionKey)
		Return -3
						
	DELETE
	FROM tClientDivision
	WHERE ClientDivisionKey = @ClientDivisionKey 

	RETURN 1
GO
