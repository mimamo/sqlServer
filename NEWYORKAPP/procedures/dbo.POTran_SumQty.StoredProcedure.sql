USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[POTran_SumQty]    Script Date: 12/21/2015 16:01:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POTran_SumQty]
	@ReceiptNbr varchar( 10 ),
	@IntMin smallint, @IntMax smallint
AS
	SELECT Sum(Qty)
	FROM POTran (NOLOCK)
	WHERE RcptNbr LIKE @ReceiptNbr
	   AND LineNbr BETWEEN @IntMin AND @IntMax
	   AND PurchaseType IN ('GI','GP','GS','GN')

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
