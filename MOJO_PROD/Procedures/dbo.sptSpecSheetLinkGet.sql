USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetLinkGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetLinkGet]
	@SpecSheetKey int,
	@Entity varchar(50),
	@EntityKey int

AS --Encrypt

		SELECT *
		FROM tSpecSheetLink (NOLOCK) 
		WHERE
			SpecSheetKey = @SpecSheetKey
			AND Entity = @Entity
			AND EntityKey = @EntityKey

	RETURN 1
GO
