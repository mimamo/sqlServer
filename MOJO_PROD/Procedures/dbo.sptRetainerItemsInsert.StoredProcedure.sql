USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerItemsInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerItemsInsert]
	(
		@RetainerKey INT
		,@Entity VARCHAR(50)
		,@EntityKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	INSERT tRetainerItems (RetainerKey, Entity, EntityKey)
	VALUES (@RetainerKey, @Entity, @EntityKey)
		
	RETURN 1
GO
