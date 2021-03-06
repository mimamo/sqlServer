USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerItemsDeleteList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerItemsDeleteList]
	(
		@RetainerKey INT
		,@Entity VARCHAR(50)
	)
AS	-- Encrypt

	SET NOCOUNT ON
	
	DELETE tRetainerItems
	WHERE  RetainerKey = @RetainerKey
	AND	   Entity = @Entity
	
	RETURN 1
GO
