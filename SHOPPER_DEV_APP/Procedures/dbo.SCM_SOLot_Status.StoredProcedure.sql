USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_SOLot_Status]    Script Date: 12/21/2015 14:34:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_SOLot_Status]
	@CpnyID 	varchar(10),
	@OrdNbr 	varchar(15),
	@LineRef 	varchar(5),
	@SchedRef	varchar(5),
	@LotSerRef 	varchar(5),
	@Status		varchar(1)
AS
	SELECT * FROM SOLot
	WHERE CpnyID = @CpnyID
	   AND OrdNbr = @OrdNbr
	   AND LineRef LIKE @LineRef
	   AND SchedRef LIKE @SchedRef
	   AND LotSerRef LIKE @LotSerRef
	   AND Status = @Status
	ORDER BY CpnyID, OrdNbr, SchedRef, LineRef, LotSerRef
GO
