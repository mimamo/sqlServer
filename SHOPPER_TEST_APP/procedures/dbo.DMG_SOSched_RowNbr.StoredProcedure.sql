USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOSched_RowNbr]    Script Date: 12/21/2015 16:07:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOSched_RowNbr]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
AS
	SELECT	COUNT (*)
	FROM	SOSched (NOLOCK)
	WHERE	CpnyID = @CpnyID
	  AND	OrdNbr = @OrdNbr
	  AND 	LineRef < @LineRef OR (LineRef = @LineRef AND SchedRef <= @SchedRef)
GO
