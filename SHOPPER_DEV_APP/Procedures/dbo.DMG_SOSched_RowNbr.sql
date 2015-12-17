USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOSched_RowNbr]    Script Date: 12/16/2015 15:55:18 ******/
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
