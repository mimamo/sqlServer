USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderTypeGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderTypeGetList]

	@CompanyKey int, 
	@Active tinyint = 1,
	@PurchaseOrderTypeKey int = NULL

AS --Encrypt

/*
|| When      Who Rel      What
|| 05/16/07  CRG 8.4.3    (8815) Added optional Key parameter so that it will appear in list if it is not Active.
|| 05/05/11  MFT 10.5.4.4 Made @Active test an ISNULL 
*/

if ISNULL(@Active, 0) = 0
		SELECT *
		FROM 
			tPurchaseOrderType (NOLOCK) 
		WHERE
			CompanyKey = @CompanyKey
		order by
			PurchaseOrderTypeName
else
		SELECT *
		FROM 
			tPurchaseOrderType (NOLOCK) 
		WHERE	CompanyKey = @CompanyKey 
		and		(Active = 1 OR PurchaseOrderTypeKey = @PurchaseOrderTypeKey)
		order by
			PurchaseOrderTypeName

	RETURN 1
GO
