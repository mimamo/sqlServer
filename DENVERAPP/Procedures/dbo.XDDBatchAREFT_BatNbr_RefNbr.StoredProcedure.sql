USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchAREFT_BatNbr_RefNbr]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchAREFT_BatNbr_RefNbr]
	@BatNbr		varchar(10),
	@RefNbr		varchar(10)
AS

	SELECT		*
	FROM		XDDBatchAREFT
	WHERE		BatNbr = @BatNbr
			and RefNbr = @RefNbr
GO
