USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashApplyToLines]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashApplyToLines]
	(
	@Divider money,			-- Invoice or voucher amount
	@Multiplier MONEY,		-- Total amount to apply, ex:	tCheckAppl.Amount
	@MustTotal MONEY,		-- Could be different from @Multiplier
	@LastApplication INT  = 0
	)
AS --Encrypt

	SET NOCOUNT ON
	
/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019  Creation for cash basis posting 
|| 11/01/13 GHL 10.573	(195153) If the total to apply differs from MustTotal by a certain amount
||                      change @LastApplication = 0, i.e. try a mathematical proportion
*/

	DECLARE @kRoundingDigits INT SELECT @kRoundingDigits = 2 -- If we select 1, we can test negative rounding routine 
	
	/*
	--Assume done in calling sp
	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)
	
	insert #tApply (LineKey, LineAmount, AlreadyApplied)
	values (1, 1624.15, 0)
	insert #tApply (LineKey, LineAmount, AlreadyApplied)
	values (2, 347.43, 0)
	insert #tApply (LineKey, LineAmount, AlreadyApplied)
	values (3, 389.79, 0)
	*/
	
	-- We try to apply proportionally
	-- ToApply = (LineAmount / Divider * Multiplier  
	-- or ToApply = (LineAmount * Multiplier) / Divider  
	
	SELECT @Divider = ISNULL(@Divider, 0)
			,@Multiplier = ISNULL(@Multiplier, 0)
			,@MustTotal = ISNULL(@MustTotal, 0)
			
	IF @Divider = 0
	BEGIN
		UPDATE #tApply
		SET    ToApply = 0
		
		RETURN 1	
	END	

	UPDATE #tApply 
	SET    LineAmount = ROUND(ISNULL(LineAmount, 0), 2)
	      ,AlreadyApplied = ROUND(ISNULL(AlreadyApplied, 0), 2)
	      ,ToApply = 0
	      ,DoNotApply = 0
	
	declare @TotalToApply money

	IF @LastApplication = 1 
	BEGIN
		UPDATE #tApply 
		SET    ToApply = LineAmount - AlreadyApplied
	
		select @TotalToApply = sum(ToApply) from #tApply 

		if ABS(@MustTotal - @TotalToApply) > 50
			-- if the difference is too large, something went wrong and try the mathematical proportion
			select @LastApplication = 0
		else
			RETURN 1
	END
	        
	-- cannot over apply
	-- is it the proper way to deal with negative numbers?
	UPDATE #tApply 
	SET    DoNotApply = 1
	WHERE ABS(AlreadyApplied) > ABS(LineAmount)
		
	IF NOT EXISTS (SELECT 1 FROM #tApply WHERE DoNotApply = 0)
		RETURN 1
	
	-- try the mathematical proportion		
	UPDATE #tApply 
	SET    ToApply = ROUND((LineAmount * @Multiplier / @Divider), @kRoundingDigits)
	WHERE  DoNotApply = 0
	
	DECLARE @LineAmountTotal MONEY
	DECLARE @OrigLineAmountTotal MONEY
	DECLARE @RoundingError MONEY
	DECLARE @OrigRoundingError MONEY
	DECLARE @LineKey INT
	DECLARE @LineAmount MONEY
	DECLARE @AlreadyApplied MONEY
	DECLARE @ToApply MONEY
	DECLARE @DoNotApply INT
	DECLARE @CircuitBreaker INT	
	
	SELECT @LineAmountTotal = SUM(ToApply)
	FROM   #tApply 
	
	SELECT @OrigLineAmountTotal = SUM(LineAmount)
	FROM   #tApply 
	
	IF @MustTotal IS NOT NULL
		SELECT @RoundingError = @MustTotal - @LineAmountTotal
	ELSE
		SELECT @RoundingError = 0
		
	-- This can be changed as desired for testing
	--SELECT @RoundingError = 0.04
		
	IF @RoundingError = 0
		RETURN 1	 
	
	SELECT @OrigRoundingError = @RoundingError, @CircuitBreaker = 0

	-- we are going to add one penny at a time		
	IF @RoundingError > 0
	BEGIN
		WHILE @RoundingError <> 0
		BEGIN
			SELECT @CircuitBreaker = @CircuitBreaker + 1
			
			SELECT @LineKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @LineKey = MIN(LineKey)
				FROM   #tApply 
				WHERE  LineKey > @LineKey	
				AND    DoNotApply = 0	
				
				IF @LineKey IS NULL
					BREAK
				
				SELECT @LineAmount = LineAmount
						,@AlreadyApplied = AlreadyApplied
						,@ToApply = ToApply
						,@DoNotApply = DoNotApply 
				FROM   #tApply
				WHERE  LineKey = @LineKey
				 	 	
				IF ABS(@LineAmount) - ABS(@AlreadyApplied) -ABS(@ToApply) > 0
				BEGIN
					SELECT @ToApply = @ToApply + .01 
								,@RoundingError = @RoundingError -.01
					
					IF ABS(@LineAmount) - ABS(@AlreadyApplied) -ABS(@ToApply) <= 0
						SELECT @DoNotApply = 1
							
															
					UPDATE #tApply 
					SET    ToApply = @ToApply
							,DoNotApply = @DoNotApply
					WHERE  LineKey = @LineKey
					
					IF @RoundingError = 0
						BREAK		 												
		
					-- stop if we are making matters worst				
					IF ABS(@RoundingError) > ABS(@OrigRoundingError)
						BREAK

				END		
				
														
			END -- LineKey loop

			-- Circuit breaker
			IF @CircuitBreaker > 1000
				BREAK

			-- stop if we are making matters worst				
			IF ABS(@RoundingError) > ABS(@OrigRoundingError)
				BREAK
							
		END -- While @RoundingError <> 0
			
	END -- IF @RoundingError <> 0	


	-- We are going to subtract one penny at a time
	IF @RoundingError < 0
	BEGIN
		WHILE @RoundingError <> 0
		BEGIN
			SELECT @CircuitBreaker = @CircuitBreaker + 1
			
			SELECT @LineKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @LineKey = MIN(LineKey)
				FROM   #tApply 
				WHERE  LineKey > @LineKey	
				AND    DoNotApply = 0	
				
				IF @LineKey IS NULL
					BREAK
				
				SELECT @LineAmount = LineAmount
						,@AlreadyApplied = AlreadyApplied
						,@ToApply = ToApply
						,@DoNotApply = DoNotApply 
				FROM   #tApply
				WHERE  LineKey = @LineKey
				 	 	
				-- this is when we overapplied on the AdvBill screen
				IF @OrigLineAmountTotal > 0 AND @OrigLineAmountTotal < @MustTotal
				BEGIN
					-- should we only limit when ToApply > 0
					IF ABS(@ToApply) > 0 
						SELECT @ToApply = @ToApply - .01 
							,@RoundingError = @RoundingError +.01
					
															
					UPDATE #tApply 
					SET    ToApply = @ToApply
							,DoNotApply = @DoNotApply
					WHERE  LineKey = @LineKey
					
					IF @RoundingError = 0
						BREAK

				END
				ELSE
				BEGIN
				 	 	
					IF ABS(@LineAmount) - ABS(@AlreadyApplied) -ABS(@ToApply) > 0
					BEGIN
						-- should we only limit when ToApply > 0
						IF ABS(@ToApply) > 0 
							SELECT @ToApply = @ToApply - .01 
								,@RoundingError = @RoundingError +.01
						
																
						UPDATE #tApply 
						SET    ToApply = @ToApply
								,DoNotApply = @DoNotApply
						WHERE  LineKey = @LineKey
						
						IF @RoundingError = 0
							BREAK		 												

					END		
				
					-- stop if we are making matters worst				
					IF ABS(@RoundingError) > ABS(@OrigRoundingError)
						BREAK
				
				END
														
			END -- LineKey loop

			-- Circuit breaker
			IF @CircuitBreaker > 1000
				BREAK

			-- stop if we are making matters worst				
			IF ABS(@RoundingError) > ABS(@OrigRoundingError)
				BREAK
							
		END -- While @RoundingError <> 0
			
	END -- IF @RoundingError <> 0	
	
	
	RETURN 1
GO
