USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdateBilling]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdateBilling]
	@ProjectKey int,
	@GetRateFrom smallint,
	@HourlyRate money,
	@TimeRateSheetKey int,
	@OverrideRate tinyint,
	@NonBillable tinyint,
	@GetMarkupFrom smallint,
	@ItemRateSheetKey int,
	@ItemMarkup decimal(24,4),
	@IOCommission decimal(24,4),
	@BCCommission decimal(24,4),
	@Template tinyint,
	@RetainerKey int,
	@BillingMethod smallint,
	@ExpensesNotIncluded tinyint
	
AS --Encrypt

  /*
  || When     Who Rel	   What
  || 02/18/09 GHL 10.019  (46956) Patch for Flash screen. CMP is OK. 
  ||                      If the Billing Method is not Retainer, set RetainerKey = NULL  
  */
  
	UPDATE
		tProject
	SET
		GetRateFrom = @GetRateFrom,
		HourlyRate = @HourlyRate,
		TimeRateSheetKey = @TimeRateSheetKey,
		OverrideRate = @OverrideRate,
		NonBillable = @NonBillable,
		GetMarkupFrom = @GetMarkupFrom,
		ItemRateSheetKey = @ItemRateSheetKey,
		ItemMarkup = @ItemMarkup,
		IOCommission = @IOCommission,
		BCCommission = @BCCommission,
		Template = @Template,
		RetainerKey = CASE WHEN @BillingMethod = 3 THEN @RetainerKey ELSE NULL END,
		BillingMethod = @BillingMethod,
		ExpensesNotIncluded = @ExpensesNotIncluded
	WHERE
		ProjectKey = @ProjectKey 
  
 RETURN 1
GO
