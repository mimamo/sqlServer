USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SpecificCostID_SOLot]    Script Date: 12/21/2015 13:56:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SpecificCostID_SOLot]
	@CpnyID		VARCHAR(10),
	@OrdNbr 	VARCHAR(15),
	@LineRef 	VARCHAR(5),
	@SpecificCostID VARCHAR(25)
AS
	SELECT	DISTINCT *
	FROM	SOLot
	WHERE CpnyID = @CpnyID
		and OrdNbr = @OrdNbr
		and LineRef like @LineRef
		and SpecificCostID like @SpecificCostID
	ORDER BY SpecificCostID
GO
