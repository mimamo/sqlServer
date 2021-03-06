USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderTypeInfo]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptPurchaseOrderTypeInfo]

	(
		@PurchaseOrderKey int
	)

AS --Encrypt

 /*
  || When     Who Rel   What
  || 11/26/07 GHL 8.5   Removed non ANSI joins for SQL 2005 
  */
  
	select 
		pot.*
	from
		tPurchaseOrder p (nolock)
		left outer join tPurchaseOrderType pot (nolock) on p.PurchaseOrderTypeKey = pot.PurchaseOrderTypeKey
	Where
		p.PurchaseOrderKey = @PurchaseOrderKey
GO
