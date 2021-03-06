USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLB_PmtApplicBat_All]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLB_PmtApplicBat_All]
	@LBBatNbr	varchar(10),
	@CustID		varchar(15),
	@LineNbrBeg	smallint,
	@LineNbrEnd	smallint
	
AS
	SELECT		*
	FROM		XDDBatchARLB L LEFT OUTER JOIN Batch B
			ON L.PmtApplicBatNbr = B.BatNbr and 'AR' = B.Module
	WHERE		L.LBBatNbr = @LBBatNbr
			and L.CustID LIKE @CustID
			and L.LineNbr BETWEEN @LineNbrBeg and @LineNbrEnd
	ORDER BY	L.LBBatNbr, L.CustID, L.RefNbr, L.LineNbr
GO
