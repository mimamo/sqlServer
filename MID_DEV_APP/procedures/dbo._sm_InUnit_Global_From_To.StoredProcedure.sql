USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[_sm_InUnit_Global_From_To]    Script Date: 12/21/2015 14:17:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[_sm_InUnit_Global_From_To]
			@FromUnit		VARCHAR (6),
			@ToUnit			VARCHAR (6),
			@InUnitFactor	FLOAT 		OUTPUT,
			@InUnitMultDiv	VARCHAR(1)  OUTPUT,
			@InReverse		SMALLINT	OUTPUT
AS
DECLARE
	@RetVal 	SMALLINT

	SELECT @RetVal = 0

   	SELECT  @InUnitFactor = CnvFact,
			@InUnitMultDiv = MultDiv
	FROM 	INUnit   (NOLOCK)
	WHERE 	UnitType = '1'
	AND 	FromUnit = @FromUnit
	AND		ToUnit   = @ToUnit

	-- return 1 if successfull 0 if not
	IF @@ROWCOUNT > 0 SELECT @RetVal = 1
	ELSE
		BEGIN
		   	SELECT  @InUnitFactor = CnvFact,
					@InUnitMultDiv = MultDiv
			FROM 	INUnit   (NOLOCK)
			WHERE 	UnitType = '1'
			AND 	FromUnit = @ToUnit
			AND		ToUnit   = @FromUnit

			IF @@ROWCOUNT > 0
			BEGIN
				SELECT @RetVal = 1
				SELECT @InReverse = 1
			END
		END

	RETURN @RetVal
GO
