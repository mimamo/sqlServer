USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetLinkDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetLinkDelete]
	@Entity varchar(50),
	@EntityKey int

AS --Encrypt

	DELETE
	FROM tSpecSheetLink
	WHERE Entity = @Entity 
	AND EntityKey = @EntityKey 

	RETURN 1
GO
