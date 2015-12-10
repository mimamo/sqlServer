USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailInsertSpot]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailInsertSpot]

									
	@PurchaseOrderKey int,
	@LineNumber int,
	@AdjustmentNumber int,	
	@Quantity decimal(24,4),
	@DetailOrderDate smalldatetime,
	@DetailOrderEndDate smalldatetime,
	@UserDate1 smalldatetime,
	@UserDate2 smalldatetime,
	@UserDate3 smalldatetime,
	@UserDate4 smalldatetime,
	@UserDate5 smalldatetime,
	@UserDate6 smalldatetime


AS --Encrypt

/*
|| When     Who Rel    What
|| 05/23/07 GHL 8.422  Fixed rounding problem with the calc of TotalCost. Bug 9306
|| 09/19/07	BSH 8.5    Added OfficeKey, DepartmentKey while inserting spot. 
|| 07/07/11 GHL 10.546 (111482) calling now sptPurchaseOrderRollupAmounts instead of recalculating the taxes
|| 02/03/14 GHL 10.576   Added update of PTotalCost
*/

declare @PurchaseOrderDetailKey int
declare @NewPurchaseOrderDetailKey int
declare @ExistingDetailOrderDate smalldatetime
declare @MediaRevisionReasonKey int

	select @PurchaseOrderDetailKey = min(PurchaseOrderDetailKey)
	  from tPurchaseOrderDetail (nolock)
	 where PurchaseOrderKey = @PurchaseOrderKey
	   and LineNumber = @LineNumber
	   and isnull(AdjustmentNumber, 0) = @AdjustmentNumber -- this is a new field
	   
	select @MediaRevisionReasonKey = isnull(MediaRevisionReasonKey, 0) -- beware of missing field
	  from tPurchaseOrderDetail (nolock)
	 where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
    
	-- beware of missing record (not missing field)
	-- If not found, this is a type = regular, not rev or make good  
	select @MediaRevisionReasonKey = isnull(@MediaRevisionReasonKey, 0)   
	   	
	--need to determine if this is the newly inserted, first detail line nad then only update
	if @PurchaseOrderDetailKey is not null
		select @ExistingDetailOrderDate = DetailOrderDate
		  from tPurchaseOrderDetail (nolock)
		 where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	if  @ExistingDetailOrderDate = @DetailOrderDate
		begin 
			select @NewPurchaseOrderDetailKey = @PurchaseOrderDetailKey
		end 
	else
		begin
			insert tPurchaseOrderDetail
				(PurchaseOrderKey,
				LineNumber,
				AdjustmentNumber,
				MediaRevisionReasonKey,
				ProjectKey, 
				TaskKey, 
				ItemKey, 
				ClassKey, 
				ShortDescription, 
				UnitCost,
				UnitDescription, 
				Billable, 
				Markup, 
				UnitRate,
				LongDescription,
				CustomFieldKey, 
				OrderDays, 
				OrderTime, 
				OrderLength,
				Taxable, 
				Taxable2,
				MakeGoodKey,
				OfficeKey,
				DepartmentKey
				)	
			select PurchaseOrderKey,
				LineNumber,
				@AdjustmentNumber,
				@MediaRevisionReasonKey,
				ProjectKey, 
				TaskKey, 
				ItemKey, 
				ClassKey, 
				ShortDescription, 
				UnitCost,
				UnitDescription, 
				Billable, 
				Markup, 
				UnitRate,
				LongDescription,
				CustomFieldKey, 
				OrderDays, 
				OrderTime, 
				OrderLength,
				Taxable, 
				Taxable2,
				MakeGoodKey,
				OfficeKey,
				DepartmentKey
			from tPurchaseOrderDetail (nolock)
			where PurchaseOrderDetailKey = @PurchaseOrderDetailKey		

			select 	@NewPurchaseOrderDetailKey = @@IDENTITY
		end
		
	update tPurchaseOrderDetail
	   set 	Quantity = @Quantity,
			DetailOrderDate = @DetailOrderDate,
			DetailOrderEndDate = @DetailOrderEndDate,
			UserDate1 = @UserDate1,
			UserDate2 = @UserDate2,
			UserDate3 = @UserDate3,
			UserDate4 = @UserDate4,
			UserDate5 = @UserDate5,
			UserDate6 = @UserDate6,
			BillableCost = round(@Quantity*UnitCost,2),
			TotalCost = round((@Quantity*UnitCost - (@Quantity*UnitCost * Markup) / 100), 2),
			PTotalCost = round((@Quantity*UnitCost - (@Quantity*UnitCost * Markup) / 100), 2)
	  where PurchaseOrderDetailKey = @NewPurchaseOrderDetailKey 
		
	EXEC sptPurchaseOrderRollupAmounts @PurchaseOrderKey, 0  
	
	RETURN 1
GO
