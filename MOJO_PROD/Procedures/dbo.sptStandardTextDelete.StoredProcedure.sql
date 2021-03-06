USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStandardTextDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStandardTextDelete]
	@StandardTextKey int

AS --Encrypt

	If exists(Select 1 from tPurchaseOrder (NOLOCK) Where HeaderTextKey = @StandardTextKey or FooterTextKey = @StandardTextKey)
		return -1
	If exists(Select 1 from tQuote (NOLOCK) Where HeaderTextKey = @StandardTextKey or FooterTextKey = @StandardTextKey)
		return -1

	DELETE
	FROM tStandardText
	WHERE
		StandardTextKey = @StandardTextKey 

	RETURN 1
GO
