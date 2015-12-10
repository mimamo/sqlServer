USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetLinkUpdate]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetLinkUpdate]
	@SpecSheetKey int,
	@Entity varchar(50),
	@EntityKey int,
	@CompanyKey int

AS --Encrypt

	UPDATE
		tSpecSheetLink
	SET
		CompanyKey = @CompanyKey
	WHERE
		SpecSheetKey = @SpecSheetKey 
		AND Entity = @Entity 
		AND EntityKey = @EntityKey 

	RETURN 1
GO
