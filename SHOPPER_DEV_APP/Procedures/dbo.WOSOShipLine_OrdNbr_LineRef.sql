USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOShipLine_OrdNbr_LineRef]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOSOShipLine_OrdNbr_LineRef]
	@CpnyID		varchar( 10 ),
	@OrdNbr		varchar( 15 ),
	@LineRef	varchar( 5 )

AS
	SELECT		*
	FROM		SOShipLine
	WHERE		CpnyID = @CpnyID and
			OrdNbr = @OrdNbr and
			OrdLineRef LIKE @LineRef
GO
