USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchAREFT_BatNbr_Seq_Grp_RefNbr]    Script Date: 12/21/2015 14:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchAREFT_BatNbr_Seq_Grp_RefNbr]
	@BatNbr		varchar( 10 ),
	@BatSeq		smallint,
	@BatEFTGrp	smallint,
	@CustID		varchar( 15 ),
	@DocType	varchar( 2 ),
	@RefNbr		varchar( 10 )
AS

	SELECT		*
	FROM		XDDBatchAREFT
	WHERE		BatNbr = @BatNbr
			and BatSeq = @BatSeq
			and BatEFTGrp = @BatEFTGrp
			and CustID = @CustID
			and Doctype = @DocType
			and RefNbr = @RefNbr
GO
