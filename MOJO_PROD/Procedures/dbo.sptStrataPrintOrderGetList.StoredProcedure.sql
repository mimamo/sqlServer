USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataPrintOrderGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataPrintOrderGetList]

	(
		@CompanyKey int
	)

AS --Encrypt

Select 
	po.PurchaseOrderKey,
	ISNULL(po.LinkID, '0') as LinkID
From tPurchaseOrder po (nolock)
Where
	po.CompanyKey = @CompanyKey and 
	po.POKind = 1 and 
	po.Status = 4
GO
