USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStandardTextGetDD]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStandardTextGetDD]

	@CompanyKey int,
	@Type varchar(20),
	@StandardTextKey int = NULL

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

	SELECT	*
	FROM	tStandardText (NOLOCK) 
	WHERE	CompanyKey = @CompanyKey
	AND		Type = @Type
	AND		(Active = 1 OR StandardTextKey = @StandardTextKey)
	Order By TextName

	RETURN 1
GO
