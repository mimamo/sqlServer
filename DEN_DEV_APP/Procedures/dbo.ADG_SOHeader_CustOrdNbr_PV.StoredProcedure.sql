USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOHeader_CustOrdNbr_PV]    Script Date: 12/21/2015 14:05:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOHeader_CustOrdNbr_PV]
	@CpnyID varchar(10),
	@CustOrdNbr varchar(25)
AS
	SELECT CustOrdNbr, CustID, OrdNbr, OrdDate, SOTypeID, Status, SlsperID
	FROM SOHeader
	WHERE CpnyID = @CpnyID AND
		CustOrdNbr LIKE @CustOrdNbr
	ORDER BY CustOrdNbr, CustID
GO
