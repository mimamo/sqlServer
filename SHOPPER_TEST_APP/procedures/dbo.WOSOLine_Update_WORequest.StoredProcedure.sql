USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOLine_Update_WORequest]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOSOLine_Update_WORequest]
	@CpnyID		varchar( 10 ),
	@OrdNbr		varchar( 15 ),
	@LineRef	varchar( 5 ),
	@WONbr		varchar( 16 ),
	@TaskID		varchar( 32 )

AS
	UPDATE		SOLine
	SET		ProjectID = @WONbr,
			TaskID = @TaskID
	WHERE		CpnyID = @CpnyID and
			OrdNbr = @OrdNbr and
			LineRef LIKE @LineRef
	DELETE		WORequest
	WHERE		CpnyID = @CpnyID and
			OrdNbr = @OrdNbr and
			LineRef LIKE @LineRef
GO
