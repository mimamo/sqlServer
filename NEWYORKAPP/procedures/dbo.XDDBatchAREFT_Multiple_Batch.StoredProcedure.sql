USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchAREFT_Multiple_Batch]    Script Date: 12/21/2015 16:01:24 ******/
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
