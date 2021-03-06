USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutGetDefault]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutGetDefault]
	@CompanyKey int,
	@ClientKey int = NULL
AS

/*
|| When      Who Rel      What
|| 1/22/10   CRG 10.5.1.7 Created
*/

	DECLARE	@LayoutKey int
	
	IF ISNULL(@ClientKey, 0) > 0
		SELECT	@LayoutKey = LayoutKey
		FROM	tCompany (nolock)
		WHERE	CompanyKey = @ClientKey
		
	IF ISNULL(@LayoutKey, 0) = 0
		SELECT	@LayoutKey = DefaultLayoutKey
		FROM	tPreference (nolock)
		WHERE	CompanyKey = @CompanyKey
		
	SELECT	*
	FROM	tLayout (nolock)
	WHERE	LayoutKey = @LayoutKey
GO
