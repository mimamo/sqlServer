USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POID_GetPODocID_OP]    Script Date: 12/21/2015 16:00:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[DMG_POID_GetPODocID_OP](
	@CpnyID   	CHAR(10),
	@NumTries 	SMALLINT,
	@Status   	SMALLINT OUTPUT,
	@DocID    	CHAR(10) OUTPUT,
	@Width		SMALLINT OUTPUT
)AS
	DECLARE @Prefix    VARCHAR(30)
	DECLARE @Suffix    VARCHAR(30)
	DECLARE @PrefixLen SMALLINT
	DECLARE @SuffixLen SMALLINT
	DECLARE @Seq       VARCHAR(30)
	DECLARE @Counter   INTEGER
	DECLARE @Done      BIT

	SELECT  @Counter	= 0,
		@Done		= 0,
		@DocID		= '',
		@Prefix		= '',
		@PrefixLen	= 0,
		@Status		= 0,
		@Width		= 0

	-- Loop thru for at most @NumTries times and try to create an unused order nubmer.
	WHILE @Done = 0 AND @Counter < @NumTries BEGIN

		SELECT @Counter = @Counter + 1

		EXEC DMG_POID_NextNum @Seq OUTPUT, @CpnyID

		IF @Seq = '' BEGIN
	 		-- Return (2 = An error occurred.)
			SET @Status = CONVERT(SMALLINT,2)
			RETURN
		END

		-- Format the suffix
		SELECT @Suffix = LTRIM(RTRIM(@Seq)), @SuffixLen = DATALENGTH(LTRIM(RTRIM(@Seq)))

		-- Put the prefix and sequence number together but chop the prefix to make sure everything fits.
		SELECT @DocID = UPPER( RTRIM( SUBSTRING( @Prefix, 1, DATALENGTH(@DocID) - @SuffixLen ) ) + @Suffix )

		IF NOT EXISTS( SELECT PONbr FROM PurchOrd WHERE PONbr = @DocID )
			SELECT @Done = 1
	END

	-- If @Done then return success else return
	IF @Done = 1 begin
		-- Return (0 = Success)
		SET @Status = CONVERT(SMALLINT,0)
		SET @Width = @SuffixLen
	end
	ELSE begin
 		-- Return (1 = Tried @NumTries times but didnt find a free number.)
		SET @Status = CONVERT(SMALLINT,1)
		SET @Width = @SuffixLen
	end

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
