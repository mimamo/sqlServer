USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMiscCostUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMiscCostUpdate]
	@MiscCostKey int = 0,
	@ProjectKey int,
	@TaskKey int,
	@ExpenseDate smalldatetime,
	@ShortDescription varchar(200),
	@LongDescription varchar(1000),
	@ItemKey int,
	@DepartmentKey int,
	@ClassKey int,
	@Quantity decimal(24,4),
	@UnitCost money,
	@UnitDescription varchar(30),
	@TotalCost money,
	@UnitRate money,
	@Markup decimal(24,4),
	@Billable int,
	@BillableCost money,
	@EnteredByKey int,
	@ExchangeRate decimal(24,7) = 1

AS --Encrypt

  /*
  || When     Who Rel    What
  || 02/15/07 GHL 8.4    Added project rollup section 
  || 10/05/07 GWG 8.5    Added Department    
  || 08/14/09 MFT 10.507 Added insert logic
  || 05/09/12 GHL 10.556 (142926) Added checking of InvoiceLineKey and WIP posting before changing
  || 08/29/13 GHL 10.571 Added exchange rate parameter
  || 01/03/14 GHL 10.576 Added update of currency id
  */
  
if exists(Select 1 from tProject p (nolock) Where ProjectKey = @ProjectKey and Closed = 1)
	return -1

DECLARE @InvoiceLineKey int
DECLARE @WIPPostingInKey int

IF @MiscCostKey >0
SELECT
	@InvoiceLineKey = InvoiceLineKey,
	@WIPPostingInKey = WIPPostingInKey
FROM tMiscCost (nolock)
WHERE MiscCostKey = @MiscCostKey

IF ISNULL(@InvoiceLineKey, 0) > 0
	RETURN -3

IF ISNULL(@WIPPostingInKey, 0) > 0
	RETURN -4

DECLARE @WriteOff int, @Unbilled int, @Approved int, @BaseRollup int, @CurItemQty decimal(9, 3), @TranType int

declare @CurrencyID varchar(10)
select @CurrencyID = CurrencyID
from   tProject (nolock)
where  ProjectKey = @ProjectKey

if @CurrencyID is null Or @ExchangeRate <=0
	-- This is the Home currency
	select @ExchangeRate = 1

IF @MiscCostKey > 0
	BEGIN
		if exists(Select 1 from tPreference pre (nolock) inner join tProject pro (nolock) on pre.CompanyKey = pro.CompanyKey Where pro.ProjectKey = @ProjectKey and pre.TrackQuantityOnHand = 1)
			BEGIN
				Declare @CurItemKey int, @CurQty decimal(9, 3)

				Select @CurItemKey = ISNULL(ItemKey, 0), @CurQty = ISNULL(Quantity, 0) from tMiscCost (nolock) Where MiscCostKey = @MiscCostKey

				if ISNULL(@CurItemKey, 0) <> ISNULL(@ItemKey, 0)
				BEGIN
					-- Add to Old Qty and reduce New Item Qty
					Select @CurItemQty = ISNULL(QuantityOnHand, 0) from tItem (nolock) Where ItemKey = @CurItemKey
					Update tItem Set QuantityOnHand = @CurItemQty + @CurQty Where ItemKey = @CurItemKey

					Select @CurItemQty = ISNULL(QuantityOnHand, 0) from tItem (nolock) Where ItemKey = @ItemKey
					Update tItem Set QuantityOnHand = @CurItemQty - @Quantity Where ItemKey = @ItemKey

				END
				ELSE
				BEGIN
					if ISNULL(@ItemKey, 0) > 0
					begin
						Select @CurItemQty = ISNULL(QuantityOnHand, 0) from tItem (nolock) Where ItemKey = @ItemKey
						Update tItem Set QuantityOnHand = @CurItemQty + @CurQty - @Quantity Where ItemKey = @ItemKey

					end

				END
			END

		DECLARE @OldProjectKey INT
		SELECT @OldProjectKey = ProjectKey
		FROM   tMiscCost (NOLOCK)
		WHERE  MiscCostKey = @MiscCostKey

		UPDATE
			tMiscCost
		SET
			ProjectKey = @ProjectKey,
			TaskKey = @TaskKey,
			ExpenseDate = @ExpenseDate,
			ShortDescription = @ShortDescription,
			LongDescription = @LongDescription,
			ItemKey = @ItemKey,
			DepartmentKey = @DepartmentKey,
			ClassKey = @ClassKey,
			Quantity = @Quantity,
			UnitCost = @UnitCost,
			UnitDescription = @UnitDescription,
			TotalCost = @TotalCost,
			UnitRate = @UnitRate,
			Markup = @Markup,
			Billable = @Billable,
			BillableCost = @BillableCost,
			EnteredByKey = @EnteredByKey,
			DateEntered = GETDATE(),
			ExchangeRate = @ExchangeRate,
			CurrencyID = @CurrencyID
		WHERE
			MiscCostKey = @MiscCostKey 

		SELECT	@TranType = 2,@BaseRollup = 1,@Approved = 0,@Unbilled = 1,@WriteOff = 1
		EXEC sptProjectRollupUpdate @ProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff
		IF @OldProjectKey <> @ProjectKey
			EXEC sptProjectRollupUpdate @OldProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff
	
		RETURN @MiscCostKey
	END
ELSE
	BEGIN
		if exists(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey Where ProjectKey = @ProjectKey and ExpenseActive = 0)
			return -2
	
		if exists(Select 1 from tPreference pre (nolock) inner join tProject pro (nolock) on pre.CompanyKey = pro.CompanyKey Where pro.ProjectKey = @ProjectKey and pre.TrackQuantityOnHand = 1)
		BEGIN
			if ISNULL(@ItemKey, 0) > 0
			begin
				Select @CurItemQty = QuantityOnHand from tItem (nolock) Where ItemKey = @ItemKey
				Update tItem Set QuantityOnHand = @CurItemQty - @Quantity Where ItemKey = @ItemKey
			end
		END
		
		INSERT tMiscCost
			(
			ProjectKey,
			TaskKey,
			ExpenseDate,
			ShortDescription,
			LongDescription,
			ItemKey,
			DepartmentKey,
			ClassKey,
			Quantity,
			UnitCost,
			UnitDescription,
			TotalCost,
			UnitRate,
			Markup,
			Billable,
			BillableCost,
			EnteredByKey,
			DateEntered,
			ExchangeRate,
			CurrencyID
			)

		VALUES
			(
			@ProjectKey,
			@TaskKey,
			@ExpenseDate,
			@ShortDescription,
			@LongDescription,
			@ItemKey,
			@DepartmentKey,
			@ClassKey,
			@Quantity,
			@UnitCost,
			@UnitDescription,
			@TotalCost,
			@UnitRate,
			@Markup,
			@Billable,
			@BillableCost,
			@EnteredByKey,
			GETDATE(),
			@ExchangeRate,
			@CurrencyID
			)
			
		SELECT	@TranType = 2,@BaseRollup = 1,@Approved = 0,@Unbilled = 1,@WriteOff = 0
		EXEC sptProjectRollupUpdate @ProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff

		RETURN SCOPE_IDENTITY()

	END
GO
