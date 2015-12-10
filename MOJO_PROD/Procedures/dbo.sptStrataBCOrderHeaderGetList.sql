USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataBCOrderHeaderGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataBCOrderHeaderGetList]

	(
		@CompanyKey int
	)

AS --Encrypt

	select po.PurchaseOrderKey
	      ,isnull(po.LinkID, '0') as LinkID
      from tPurchaseOrder po (nolock)
     where po.CompanyKey = @CompanyKey
	   and po.POKind = 2 
	   and po.Status = 4
GO
