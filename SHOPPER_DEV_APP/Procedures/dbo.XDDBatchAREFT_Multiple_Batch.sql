USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchAREFT_Multiple_Batch]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchAREFT_Multiple_Batch]
	@BatNbr		varchar(10)
AS

	SELECT		count(DISTINCT CashAcct + CashSub)
	FROM 		XDDBatchAREFT (nolock)
	WHERE 		BatNbr = @BatNbr
			and rtrim(CashAcct) <> ''
			and rtrim(CashSub) <> ''
GO
