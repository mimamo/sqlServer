USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LandedCost_CountLCReceipts]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LandedCost_CountLCReceipts]
	@BatchNbr		Varchar(10),
	@ReceiptNbr		Varchar(10)
AS
	SELECT	Count(*)
	FROM	LCReceipt
	WHERE	BatNbr 	= @BatchNbr
	AND     RcptNbr = @ReceiptNbr
GO
