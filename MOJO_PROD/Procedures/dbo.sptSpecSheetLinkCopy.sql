USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetLinkCopy]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetLinkCopy]
	@EntityFrom varchar(50),
	@EntityFromKey int,
	@EntityTo varchar(50),
	@EntityToKey int

AS --Encrypt


	INSERT tSpecSheetLink
		(
		SpecSheetKey,
		Entity,
		EntityKey,
		CompanyKey
		)

	SELECT
		SpecSheetKey,
		@EntityTo,
		@EntityToKey,
		CompanyKey
	FROM tSpecSheetLink (nolock)
	WHERE Entity = @EntityFrom
	and EntityKey = @EntityFromKey
	
	RETURN 1
GO
