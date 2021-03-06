USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLBApplic_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLBApplic_All]
	@LBBatNbr	varchar(10),
	@CustID		varchar(15),
	@PmtRecordID	int,
	@LineNbrBeg	smallint,
	@LineNbrEnd	smallint
	
AS
	SELECT		*
	FROM		XDDBatchARLBApplic A LEFT OUTER JOIN ARDoc D
			ON A.CustID = D.CustID and A.DocType = D.DocType and A.RefNbr = D.RefNbr
	WHERE		A.LBBatNbr = @LBBatNbr
			and A.CustID = @CustID
			and A.PmtRecordID = @PmtRecordID
			and A.LineNbr BETWEEN @LineNbrBeg and @LineNbrEnd
	ORDER BY	A.LBBatNbr, A.CustID, A.PmtRecordID, A.LineNbr
GO
