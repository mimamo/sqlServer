USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POTran_RcptNbr_TranCount]    Script Date: 12/21/2015 14:06:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POTran_RcptNbr_TranCount]
	@ReceiptNbr varchar( 10 )
	AS
	SELECT Count(*)
	FROM POTran (NOLOCK)
	WHERE RcptNbr LIKE @ReceiptNbr
	   AND PurchaseType IN ('GI','GP','GS','GN')
GO
