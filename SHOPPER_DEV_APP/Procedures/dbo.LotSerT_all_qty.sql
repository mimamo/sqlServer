USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_all_qty]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerT_all_qty]
	@cpnyid			varchar( 10 ),
	@batnbr			varchar( 10 ),
	@refnbr			varchar( 15 ),
	@intranlineref		varchar( 5 )
AS
	SELECT CpnyId, BatNbr, RefNbr, INTranLineRef, Sum(Qty)
	FROM LotSerT
	WHERE CpnyID LIKE @cpnyid
	   AND BatNbr LIKE @batnbr
	   AND RefNbr LIKE @refnbr
	   AND INTranLineRef LIKE @intranlineref
	Group BY CpnyID,
	   BatNbr,
	   RefNbr,
	   INTranLineRef
GO
