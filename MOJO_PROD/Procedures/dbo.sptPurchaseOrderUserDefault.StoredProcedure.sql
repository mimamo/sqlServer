USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderUserDefault]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderUserDefault]

		@PurchaseOrderKey int,
		@CompanyMediaKey int

AS --Encrypt

	-- if contacts have already been specified, do not insert defaults
	if exists (select 1
	             from tPurchaseOrderUser (nolock)
	            where PurchaseOrderKey = @PurchaseOrderKey)
		return 1
		
	insert tPurchaseOrderUser
		  (
		   PurchaseOrderKey
		  ,UserKey
		  )
    select @PurchaseOrderKey
	      ,UserKey
	  from tCompanyMediaContact (nolock)
	 where CompanyMediaKey = @CompanyMediaKey
	 
	 return 1
GO
