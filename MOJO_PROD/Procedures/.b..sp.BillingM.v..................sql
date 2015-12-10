USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingMove]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptBillingMove]
(
	@BillingKey int,
	@ParentWorksheetKey int,
	@Direction smallint
)

as --Encrypt

Declare @Order int, @NextOrder int, @NextKey int

Select @Order = DisplayOrder from tBilling (nolock) Where BillingKey = @BillingKey


if @Direction = 1 -- Move Down
BEGIN
	Select @NextOrder = Min(DisplayOrder) from tBilling Where ParentWorksheetKey = @ParentWorksheetKey and DisplayOrder >= @Order and BillingKey <> @BillingKey
	if @NextOrder is null
		return -1
	
	Select @NextKey = Min(BillingKey) from tBilling Where ParentWorksheetKey = @ParentWorksheetKey and DisplayOrder = @NextOrder and BillingKey <> @BillingKey
	
	Update tBilling Set DisplayOrder = @Order Where BillingKey = @NextKey
	Update tBilling Set DisplayOrder = @NextOrder Where BillingKey = @BillingKey

END
ELSE
BEGIN
	-- Move Up
	Select @NextOrder = Max(DisplayOrder) from tBilling Where ParentWorksheetKey = @ParentWorksheetKey and DisplayOrder <= @Order and BillingKey <> @BillingKey
	if @NextOrder is null
		return -1
	
	Select @NextKey = Max(BillingKey) from tBilling Where ParentWorksheetKey = @ParentWorksheetKey and DisplayOrder = @NextOrder and BillingKey <> @BillingKey
	
	Update tBilling Set DisplayOrder = @Order Where BillingKey = @NextKey
	Update tBilling Set DisplayOrder = @NextOrder Where BillingKey = @BillingKey




END
GO
