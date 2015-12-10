USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemGetActiveList]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemGetActiveList]

	@CompanyKey int,
	@ItemType smallint,
	@ItemKey int = NULL

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

if @ItemType = -1
	SELECT	i.*
	FROM	tItem i (nolock)
	WHERE	i.CompanyKey = @CompanyKey 
	AND		(Active = 1 OR ItemKey = @ItemKey)
	Order By ItemName
else
	SELECT	i.*
	FROM	tItem i (nolock)
	WHERE	i.CompanyKey = @CompanyKey
	AND		i.ItemType = @ItemType
	AND		(Active = 1 OR ItemKey = @ItemKey)
	Order By ItemName

	RETURN 1
GO
