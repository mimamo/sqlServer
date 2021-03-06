USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDARDoc_XDDBatchAREFT_BatNbr]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDARDoc_XDDBatchAREFT_BatNbr]
	@BatNbr		varchar( 10 ),
	@BatEFTGrp	smallint
AS
	SELECT		*
	FROM		ARDoc A LEFT OUTER JOIN XDDBatchAREFT B
			ON A.BatNbr = B.BatNbr and A.BatSeq = B.BatSeq and A.RefNbr = B.RefNbr and B.BatEFTGrp = @BatEFTGrp
	WHERE		A.BatNbr = @BatNbr
--			and A.BatSeq = @BatSeq
	ORDER BY	A.RefNbr
GO
