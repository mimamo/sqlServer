USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchAREFT_PmtApplicBatNbr]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchAREFT_PmtApplicBatNbr]
	@BatNbr		varchar(10)
AS

	SELECT		*
	FROM		XDDBatchAREFT (nolock)
	WHERE		BatNbr = @BatNbr
			and PmtApplicBatNbr <> ''
GO
