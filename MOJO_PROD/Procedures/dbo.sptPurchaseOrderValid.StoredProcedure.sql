USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderValid]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderValid]
	@CompanyKey int,
	@PurchaseOrderNumber varchar(30)

AS --Encrypt

/*
|| When      Who Rel     What
|| 05/05/11  MFT 10.543	 Created
*/

SELECT
	PurchaseOrderKey,
	PurchaseOrderNumber,
	POKind,
	PurchaseOrderTypeKey,
	ProjectKey
FROM
	tPurchaseOrder
WHERE
	PurchaseOrderNumber = @PurchaseOrderNumber AND
	CompanyKey = @CompanyKey
GO
