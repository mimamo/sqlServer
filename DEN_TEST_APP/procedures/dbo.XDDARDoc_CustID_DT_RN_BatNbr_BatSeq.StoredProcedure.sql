USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDARDoc_CustID_DT_RN_BatNbr_BatSeq]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDARDoc_CustID_DT_RN_BatNbr_BatSeq]
	@CustID		varchar(15),
	@DocType	varchar(2),
	@RefNbr		varchar(10),
	@BatNbr		varchar(10),
	@BatSeq		int
AS
	SELECT		*
	FROM		ARDoc (nolock)
	WHERE		CustID = @CustID
			and DocType = @DocType
			and RefNbr = @RefNbr
			and BatNbr = @BatNbr
			and BatSeq = @BatSeq
GO
