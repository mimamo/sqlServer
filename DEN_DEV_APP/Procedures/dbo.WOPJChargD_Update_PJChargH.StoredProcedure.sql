USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJChargD_Update_PJChargH]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJChargD_Update_PJChargH]
	@Batch_ID	varchar( 10 ),
	@DeleteFlag	smallint

AS

	Declare
	@Last_Detail_Num 	SmallInt,
	@Batch_Amount		Float,
	@BaseCury		SmallInt
		-- Delete the Batch
	if @DeleteFlag = 1
		DELETE 	From PJChargH
		WHERE	Batch_ID = @Batch_ID
	else

	-- Update the PJChargH totals from its PJChargD
	BEGIN
		-- Get the base currency precision
		SELECT	@BaseCury = c.DecPl
		FROM	GLSetup s (NOLOCK),
			Currncy c (NOLOCK)
		WHERE	s.BaseCuryID = c.CuryID

		-- Sum PJChargD values
		SELECT 	@Batch_Amount = 	Coalesce( Sum( Round(Amount, @BaseCury) ), 0),
			@Last_Detail_Num = 	Coalesce( Max( Detail_Num ), 0)
		FROM 	PJChargD
		WHERE	Batch_ID = @Batch_ID

		UPDATE 	PJChargH
		SET 	Batch_Amount = Round( @Batch_Amount, @BaseCury ),
			Batch_Bal = Round( @Batch_Amount, @BaseCury ),
			Last_Detail_Num = @Last_Detail_Num
		WHERE	Batch_ID = @Batch_ID
	END
GO
