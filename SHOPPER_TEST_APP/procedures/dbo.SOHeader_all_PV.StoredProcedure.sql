USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_all_PV]    Script Date: 12/21/2015 16:07:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOHeader_all_PV]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 )
AS
	SELECT OrdNbr, Status, SOTypeID, OrdDate, CustID, CustOrdNbr, TotMerch, Cancelled
	FROM SOHeader
	WHERE CpnyID = @parm1
	   AND OrdNbr LIKE @parm2
	ORDER BY CpnyID,
	   OrdNbr DESC
GO
