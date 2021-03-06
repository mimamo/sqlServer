USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_all]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerT_all]
	@cpnyid			varchar( 10 ),
	@batnbr			varchar( 10 ),
	@refnbr			varchar( 15 ),
	@intranlineref		varchar( 5 ),
	@lotserref			varchar( 5 )
AS
	SELECT *
	FROM LotSerT
	WHERE CpnyID = @cpnyid
	   AND BatNbr = @batnbr
	   AND RefNbr LIKE @refnbr
	   AND INTranLineRef LIKE @intranlineref
	   AND LotSerRef LIKE @lotserref
	ORDER BY CpnyID,
	   BatNbr,
	   RefNbr,
	   INTranLineRef,
	   LotSerRef
GO
