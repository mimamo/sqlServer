USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemUpdate]
	@ItemKey int = 0,
	@CompanyKey int,
	@ItemType smallint,
	@ItemID varchar(50),
	@ItemName varchar(200),
	@UnitCost money,
	@UnitRate money,
	@Markup decimal(24,4),
	@UnitDescription varchar(30),
	@StandardDescription varchar(1000),
	@WorkTypeKey int,
	@DepartmentKey int,
	@ExpenseAccountKey int,
	@SalesAccountKey int,
	@ClassKey int,	
	@QuantityOnHand decimal(24,4),
	@Active tinyint,
	@Taxable tinyint,
	@Taxable2 tinyint,
	@UseUnitRate tinyint,
	@CalcAsArea tinyint,
	@ConversionMultiplier decimal(24,4),
	@MinAmount money,
	@UseDescription tinyint = 0
AS --Encrypt

  /*
  || When     Who Rel      What
  || 06/14/07 GWG 8.5      Added the departmentKey
  || 08/28/07 CRG 8.5      Added UseUnitRate
  || 10/19/07 CRG 8.5      (11376) Added CalcAsArea, ConversionMultiplier, MinAmount (for paid enhancement).
  || 07/30/09 MFT 10.5.0.5 Added insert logic
  || 5/6/11   CRG 10.5.4.4 (110628) Added call to sptLayoutBillingInsertNewItem
  || 07/22/11 RLB 10.5.4.6 Adding new items to all item rate sheets for the company
  || 9/19/11  CRG 10.5.4.8 (121294) Modified call to sptLayoutBillingInsertNewItem for parm changes
  || 4/21/14  PLC 10.5.7.9 (207630) New Param for UseDescription
  */

if exists(select 1 from tItem (nolock)
		Where CompanyKey = @CompanyKey
		and ItemKey <> @ItemKey
		and ItemID = @ItemID)
	Return -1

IF @ItemKey > 0
	BEGIN
		UPDATE
			tItem
		SET
			ItemType = @ItemType,
			ItemID = @ItemID,
			ItemName = @ItemName,
			UnitCost = @UnitCost,
			UnitRate = @UnitRate,
			Markup = @Markup,
			UnitDescription = @UnitDescription,
			StandardDescription = @StandardDescription,
			WorkTypeKey = @WorkTypeKey,
			DepartmentKey = @DepartmentKey,
			ExpenseAccountKey = @ExpenseAccountKey,
			SalesAccountKey = @SalesAccountKey,
			ClassKey = @ClassKey,
			QuantityOnHand = @QuantityOnHand,
			Active = @Active,
			Taxable = @Taxable,
			Taxable2 = @Taxable2,
			UseUnitRate = @UseUnitRate,
			CalcAsArea = @CalcAsArea,
			ConversionMultiplier = @ConversionMultiplier,
			MinAmount = @MinAmount,
			UseDescription = @UseDescription
		WHERE
			ItemKey = @ItemKey
		
		RETURN @ItemKey
	END
ELSE
	BEGIN
		IF @Active IS NULL
			SELECT @Active = 1
		
		INSERT tItem
			(
			CompanyKey,
			ItemType,
			ItemID,
			ItemName,
			UnitCost,
			UnitRate,
			Markup,
			UnitDescription,
			StandardDescription,
			WorkTypeKey,
			DepartmentKey,
			ExpenseAccountKey,
			SalesAccountKey,
			ClassKey,
			QuantityOnHand,
			Active,
			Taxable,
			Taxable2,
			UseUnitRate,
			CalcAsArea,
			ConversionMultiplier,
			MinAmount,
			UseDescription
			)

		VALUES
			(
			@CompanyKey,
			@ItemType,
			@ItemID,
			@ItemName,
			@UnitCost,
			@UnitRate,
			@Markup,
			@UnitDescription,
			@StandardDescription,
			@WorkTypeKey,
			@DepartmentKey,
			@ExpenseAccountKey,
			@SalesAccountKey,
			@ClassKey,
			@QuantityOnHand,
			@Active,
			@Taxable,
			@Taxable2,
			@UseUnitRate,
			@CalcAsArea,
			@ConversionMultiplier,
			@MinAmount,
			@UseDescription
			)
		
		SELECT	@ItemKey = @@IDENTITY


		EXEC sptNewItemRateSheetUpdate @CompanyKey, @ItemKey

		DECLARE @RetVal int
		EXEC @RetVal = sptLayoutBillingInsertNewItem 'tItem', @ItemKey

		IF @RetVal <= 0
			RETURN @RetVal
		ELSE
			RETURN @ItemKey
	END
GO
