USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLBErrors_All]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLBErrors_All]
	@LBBatNbr	varchar(10),
	@CustID		varchar(15),
	@LineNbrBeg	smallint,
	@LineNbrEnd	smallint
	
AS
	SELECT		*
	FROM		XDDBatchARLBErrors
	WHERE		LBBatNbr = @LBBatNbr
			and CustID LIKE @CustID
			and LineNbr BETWEEN @LineNbrBeg and @LineNbrEnd
	ORDER BY	LBBatNbr, CustID, LineNbr
GO
