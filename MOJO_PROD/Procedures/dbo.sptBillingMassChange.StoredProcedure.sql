USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingMassChange]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingMassChange]
	(
		@BillingKey INT
		,@UserKey INT
		,@MassChangeOption INT -- 0 Adjust To Bill, 1 Write Off, 2 Mark As Billed, 3 Do Not Bill
		,@NewTotal MONEY
		,@WriteOffReasonKey int
		,@PostingDate smalldatetime 
		,@EditComments varchar(2000)
		,@AdjustToBillLaborOnly int = 0
		,@AdjustToBillExpenseOnly int = 0
	)
AS	-- Encrypt
	
  /*
  || When     Who Rel     What
  || 09/16/08 GHL 10.009  (34015) Rounding error due to difference between SUM(Total) 
  ||                      and SUM(ROUND(Quantity * Rate, 2))
  ||                      Solution: Apply ratio to rate rather than total for labor
  ||                      Apply rounding errors to expenses rather than labor
  || 02/10/12 GHL 10.552  (131603) Added @AdjustToBillLaborOnly 
  ||                      If there is labor = $2000 and expense = $500 and they mass change to 2700
  ||                      They want Labor at 2200 and expense at 500
  || 08/10/12 GHL 10.558  (150964) Added @AdjustToBillExpenseOnly
  ||                      Needed now for mass change on master where we have 2 columns (labor/Expense)
  ||                      If there is labor = $2000 and expense = $500 and they mass change to 2700
  ||                      They want Labor at 2000 and expense at 700
  */

	SET NOCOUNT ON
		
	DECLARE @Total MONEY			-- Old Total
			,@LaborTotal MONEY		-- Old Labor Total
			,@ExpenseTotal MONEY	-- Old Expense Total
			,@Ratio DECIMAL(24, 4)
			,@BillingCount INT
			,@BillingDetailKey INT 
					
	-- Anything to Bill?
	SELECT @BillingCount = COUNT(*) 
	FROM tBillingDetail (NOLOCK) 
	WHERE BillingKey = @BillingKey
	AND   Action = 1
		
	IF @BillingCount = 0
		RETURN 1	
	
	IF @MassChangeOption = 0
	BEGIN	
		-- Adjust proportionally the totals on the details
		
		IF ISNULL(@NewTotal, 0) <= 0
			RETURN 1
			
		SELECT @Total = ISNULL(LaborTotal, 0) + ISNULL(ExpenseTotal, 0)
			  ,@LaborTotal = ISNULL(LaborTotal, 0)
			  ,@ExpenseTotal = ISNULL(ExpenseTotal, 0)
		FROM   tBilling (NOLOCK)
		WHERE  BillingKey = @BillingKey
		
		SELECT @Total = ISNULL(@Total, 0)
			  ,@LaborTotal = ISNULL(@LaborTotal, 0)
			  ,@ExpenseTotal = ISNULL(@ExpenseTotal, 0)

		IF @Total = 0
			RETURN 1
		IF @AdjustToBillLaborOnly = 1 And @LaborTotal = 0
			RETURN 1
		IF @AdjustToBillExpenseOnly = 1 And @ExpenseTotal = 0
			RETURN 1

		IF @BillingCount = 1
		BEGIN
			UPDATE tBillingDetail
			SET    Total = ROUND(@NewTotal, 2)
			       ,EditorKey = @UserKey	   
				   ,EditComments = @EditComments
			WHERE  BillingKey = @BillingKey
			AND	   Action = 1	
			
			UPDATE tBillingDetail
			SET    Rate = Total / Quantity
			WHERE  BillingKey = @BillingKey
			AND	   Action = 1
			AND    Quantity <> 0
						
		END
		ELSE
		BEGIN			

			IF @AdjustToBillLaborOnly = 0 and @AdjustToBillExpenseOnly = 0
			BEGIN
				-- Apply to Labor and Expense
				SELECT @Ratio = @NewTotal / @Total

				UPDATE tBillingDetail
				SET    Total = ROUND(Total * @Ratio, 2)
					   ,Rate = Rate * @Ratio 
					   ,EditorKey = @UserKey	   
					   ,EditComments = @EditComments
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
			
				-- Recalc the total on time entries
				-- because it will bill based on ROUND(Rate * Quantity, 2)
				UPDATE tBillingDetail
				SET    Total = ROUND(Rate * Quantity, 2)
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
				AND    Entity = 'tTime'
			
				-- Fight possible rounding error
				-- We will apply the rounding error on expenses if possible	
				SELECT @BillingDetailKey = MAX(BillingDetailKey)
				FROM   tBillingDetail (NOLOCK) 
				WHERE  BillingKey = @BillingKey
				AND    Action = 1	
				AND    Entity <> 'tTime'
		
				IF @BillingDetailKey IS NULL
					SELECT @BillingDetailKey = MAX(BillingDetailKey)
					FROM   tBillingDetail (NOLOCK) 
					WHERE  BillingKey = @BillingKey
					AND    Action = 1	
				
				SELECT @Total = SUM(Total)
				FROM   tBillingDetail (NOLOCK) 
				WHERE  BillingKey = @BillingKey
				AND    Action = 1	
				AND    BillingDetailKey <> @BillingDetailKey
			
				SELECT @Total = ISNULL(@Total, 0)
			
				SELECT @Total = @NewTotal - @Total
			
				UPDATE tBillingDetail
				SET    Total = ROUND(@Total, 2)
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
				AND    BillingDetailKey = @BillingDetailKey
			
				UPDATE tBillingDetail
				SET    Rate = Total / Quantity
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
				AND    BillingDetailKey = @BillingDetailKey
				AND    Quantity <> 0

			END


			IF @AdjustToBillLaborOnly = 1
			BEGIN
				-- Apply to Labor Only
				
				SELECT @Ratio = (@NewTotal - @ExpenseTotal) / @LaborTotal

				UPDATE tBillingDetail
				SET    Total = ROUND(Total * @Ratio, 2)
					   ,Rate = Rate * @Ratio 
					   ,EditorKey = @UserKey	   
					   ,EditComments = @EditComments
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
				AND    Entity = 'tTime'

				-- Recalc the total on time entries
				-- because we will bill based on ROUND(Rate * Quantity, 2)
				UPDATE tBillingDetail
				SET    Total = ROUND(Rate * Quantity, 2)
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
				AND    Entity = 'tTime'
			
				-- Fight possible rounding error
				-- We can only apply the rounding error to Labor	
				SELECT @BillingDetailKey = MAX(BillingDetailKey)
				FROM   tBillingDetail (NOLOCK) 
				WHERE  BillingKey = @BillingKey
				AND    Action = 1	
				AND    Entity = 'tTime'
				
				SELECT @Total = SUM(Total)
				FROM   tBillingDetail (NOLOCK) 
				WHERE  BillingKey = @BillingKey
				AND    Action = 1	
				AND    Entity = 'tTime'
				AND    BillingDetailKey <> @BillingDetailKey
			
				SELECT @Total = ISNULL(@Total, 0)
			
				SELECT @Total = (@NewTotal - @ExpenseTotal) - @Total
			
				UPDATE tBillingDetail
				SET    Total = ROUND(@Total, 2)
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
				AND    BillingDetailKey = @BillingDetailKey
			
				UPDATE tBillingDetail
				SET    Rate = Total / Quantity
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
				AND    BillingDetailKey = @BillingDetailKey
				AND    Quantity <> 0

			END


			IF @AdjustToBillExpenseOnly = 1
			BEGIN
				-- Apply to Expense Only
				
				SELECT @Ratio = (@NewTotal - @LaborTotal) / @ExpenseTotal

				UPDATE tBillingDetail
				SET    Total = ROUND(Total * @Ratio, 2)
					   ,Rate = Rate * @Ratio 
					   ,EditorKey = @UserKey	   
					   ,EditComments = @EditComments
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
				AND    Entity <> 'tTime'

				-- Fight possible rounding error
				SELECT @BillingDetailKey = MAX(BillingDetailKey)
				FROM   tBillingDetail (NOLOCK) 
				WHERE  BillingKey = @BillingKey
				AND    Action = 1	
				AND    Entity <> 'tTime'
				
				SELECT @Total = SUM(Total)
				FROM   tBillingDetail (NOLOCK) 
				WHERE  BillingKey = @BillingKey
				AND    Action = 1	
				AND    Entity <> 'tTime'
				AND    BillingDetailKey <> @BillingDetailKey
			
				SELECT @Total = ISNULL(@Total, 0)
			
				SELECT @Total = (@NewTotal - @LaborTotal) - @Total
			
				UPDATE tBillingDetail
				SET    Total = ROUND(@Total, 2)
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
				AND    BillingDetailKey = @BillingDetailKey
			
				UPDATE tBillingDetail
				SET    Rate = Total / Quantity
				WHERE  BillingKey = @BillingKey
				AND	   Action = 1	
				AND    BillingDetailKey = @BillingDetailKey
				AND    Quantity <> 0

			END

		END
		
	END


	IF @MassChangeOption = 1
	BEGIN	
		-- Write Off
		UPDATE tBillingDetail
		SET    Action = 0
			   ,AsOfDate = @PostingDate
			   ,EditorKey = @UserKey	   
			   ,EditComments = @EditComments
			   ,WriteOffReasonKey = @WriteOffReasonKey
		WHERE  BillingKey = @BillingKey
		AND	   Action = 1	
	END
		
	IF @MassChangeOption = 2
	BEGIN	
		-- Mark As Billed
		UPDATE tBillingDetail
		SET    Action = 2
			   ,AsOfDate = @PostingDate	
			   ,EditorKey = @UserKey	   
			   ,EditComments = @EditComments
		WHERE  BillingKey = @BillingKey
		AND	   Action = 1	
	END
	
	IF @MassChangeOption = 3
	BEGIN	
		-- Do not Bill
		UPDATE tBillingDetail
		SET    Action = 7
			   ,EditorKey = @UserKey	   
			   ,EditComments = @EditComments
		WHERE  BillingKey = @BillingKey
		AND	   Action = 1	
	END
	
	EXEC sptBillingRecalcTotals @BillingKey
				 			
	RETURN 1
GO
