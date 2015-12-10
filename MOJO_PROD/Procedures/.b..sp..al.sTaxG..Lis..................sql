USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSalesTaxGetList]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSalesTaxGetList]
	@CompanyKey int,
	@Active tinyint,
	@SalesTaxKey int = NULL

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
|| 7/16/09   RLB 10.5.0.4 (57167)displaying SalesTaxID - SalesTaxName now
*/

	IF @Active IS NULL
		SELECT	*,
		        ISNULL(SalesTaxID, '') + ' - ' + ISNULL(SalesTaxName,'') as FormattedName
		FROM	tSalesTax (NOLOCK) 
		WHERE	CompanyKey = @CompanyKey
		ORDER BY SalesTaxID
	ELSE
		SELECT	*,
		        ISNULL(SalesTaxID, '') + ' - ' + ISNULL(SalesTaxName,'') as FormattedName
		FROM	tSalesTax (NOLOCK) 
		WHERE	CompanyKey = @CompanyKey 
		AND		(Active = @Active OR SalesTaxKey = @SalesTaxKey)
		ORDER BY SalesTaxID

	RETURN 1
GO
