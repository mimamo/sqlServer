USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOLotSerT_CpnyID_BatNbr_INTran]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOLotSerT_CpnyID_BatNbr_INTran]
	@CpnyID          varchar( 10 ),
	@BatNbr          varchar( 10 ),
	@TranSDType      varchar( 2 ),
	@INTranLineRef   varchar( 5 )

AS
	SELECT           *
	FROM             WOLotSerT
	WHERE            CpnyID = @CpnyID and
	                 BatNbr = @BatNbr and
	                 TranSDType = @TranSDType and
	                 INTranLineRef = @INTranLineRef
GO
