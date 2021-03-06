USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailUpdateApprover]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailUpdateApprover]

	(
		@PurchaseOrderKey int
	)

AS --Encrypt

	Declare @NetAmount money, @ApprovedByKey int, @HeaderProjectKey int, @CompanyKey int, @AE int, @Limit money, @POKind smallint
	Select @NetAmount = Sum(TotalCost) from tPurchaseOrderDetail (NOLOCK) Where PurchaseOrderKey = @PurchaseOrderKey
	Select @ApprovedByKey = ISNULL(ApprovedByKey, 0), @HeaderProjectKey = ISNULL(ProjectKey, 0), @CompanyKey = CompanyKey, @POKind = POKind from tPurchaseOrder (NOLOCK) Where PurchaseOrderKey = @PurchaseOrderKey
	
	
	if @POKind = 0 --Purchase Orders
	BEGIN
		Select @Limit = ISNULL(POLimit, 0) from tUser (NOLOCK) Where UserKey = @ApprovedByKey
		if @NetAmount > @Limit
		BEGIN
			if @HeaderProjectKey > 0
			BEGIN
				Select @AE = ISNULL(AccountManager, 0) from tProject (NOLOCK) Where ProjectKey = @HeaderProjectKey
				if @AE > 0
				BEGIN
					Select @Limit = ISNULL(POLimit, 0) from tUser (NOLOCK) Where UserKey = @AE
					if @NetAmount > @Limit
						Update tPurchaseOrder Set ApprovedByKey = 0 Where PurchaseOrderKey = @PurchaseOrderKey
					else
						Update tPurchaseOrder Set ApprovedByKey = @AE Where PurchaseOrderKey = @PurchaseOrderKey
				END
				ELSE
					Update tPurchaseOrder Set ApprovedByKey = 0 Where PurchaseOrderKey = @PurchaseOrderKey		
			END
			ELSE
				Update tPurchaseOrder Set ApprovedByKey = 0 Where PurchaseOrderKey = @PurchaseOrderKey	
		END
		ELSE
		BEGIN
			Update tPurchaseOrder Set ApprovedByKey = @ApprovedByKey Where PurchaseOrderKey = @PurchaseOrderKey
		END
	END


	if @POKind = 1  --Insertion Orders
	BEGIN
		Select @Limit = ISNULL(IOLimit, 0) from tUser (NOLOCK) Where UserKey = @ApprovedByKey
		if @NetAmount > @Limit
		BEGIN
			if @HeaderProjectKey > 0
			BEGIN
				Select @AE = ISNULL(AccountManager, 0) from tProject (NOLOCK) Where ProjectKey = @HeaderProjectKey
				if @AE > 0
				BEGIN
					Select @Limit = ISNULL(IOLimit, 0) from tUser (NOLOCK) Where UserKey = @AE
					if @NetAmount > @Limit
						Update tPurchaseOrder Set ApprovedByKey = 0 Where PurchaseOrderKey = @PurchaseOrderKey
					else
						Update tPurchaseOrder Set ApprovedByKey = @AE Where PurchaseOrderKey = @PurchaseOrderKey
				END
				ELSE
					Update tPurchaseOrder Set ApprovedByKey = 0 Where PurchaseOrderKey = @PurchaseOrderKey		
			END
			ELSE
				Update tPurchaseOrder Set ApprovedByKey = 0 Where PurchaseOrderKey = @PurchaseOrderKey	
		END
		ELSE
		BEGIN
			Update tPurchaseOrder Set ApprovedByKey = @ApprovedByKey Where PurchaseOrderKey = @PurchaseOrderKey
		END
	END
	
	
	if @POKind = 2 --Broadcast
	BEGIN
		Select @Limit = ISNULL(BCLimit, 0) from tUser (NOLOCK) Where UserKey = @ApprovedByKey
		if @NetAmount > @Limit
		BEGIN
			if @HeaderProjectKey > 0
			BEGIN
				Select @AE = ISNULL(AccountManager, 0) from tProject (NOLOCK) Where ProjectKey = @HeaderProjectKey
				if @AE > 0
				BEGIN
					Select @Limit = ISNULL(BCLimit, 0) from tUser (NOLOCK) Where UserKey = @AE
					if @NetAmount > @Limit
						Update tPurchaseOrder Set ApprovedByKey = 0 Where PurchaseOrderKey = @PurchaseOrderKey
					else
						Update tPurchaseOrder Set ApprovedByKey = @AE Where PurchaseOrderKey = @PurchaseOrderKey
				END
				ELSE
					Update tPurchaseOrder Set ApprovedByKey = 0 Where PurchaseOrderKey = @PurchaseOrderKey		
			END
			ELSE
				Update tPurchaseOrder Set ApprovedByKey = 0 Where PurchaseOrderKey = @PurchaseOrderKey	
		END
		ELSE
		BEGIN
			Update tPurchaseOrder Set ApprovedByKey = @ApprovedByKey Where PurchaseOrderKey = @PurchaseOrderKey
		END
	END
GO
