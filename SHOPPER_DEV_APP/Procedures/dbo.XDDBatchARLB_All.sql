USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLB_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLB_All]
	@LBBatNbr	varchar(10),
	@CustID		varchar(15),
	@LineNbrBeg	smallint,
	@LineNbrEnd	smallint
	
AS
	SELECT		*
	FROM		XDDBatchARLB
	WHERE		LBBatNbr = @LBBatNbr
			and CustID LIKE @CustID
			and LineNbr BETWEEN @LineNbrBeg and @LineNbrEnd
	ORDER BY	LBBatNbr, CustID, LineNbr
GO
