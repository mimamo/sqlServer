USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_Status_Update]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_Status_Update]
	@BatNbr		varchar( 10 ),
	@Module		varchar( 2 ),
	@Status		varchar( 1 )
AS
	UPDATE		Batch
	SET		Status = @Status
	WHERE		Module = @Module
			and BatNbr = @BatNbr
GO
