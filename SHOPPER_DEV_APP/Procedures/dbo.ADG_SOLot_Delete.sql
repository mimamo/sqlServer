USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOLot_Delete]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOLot_Delete]
		@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5),
	@LotSerRef	varchar(5)
AS
	DELETE FROM SOLot
	WHERE	CpnyID = @CpnyID AND
		OrdNbr = @OrdNbr AND
		LineRef LIKE @LineRef AND
		SchedRef LIKE @SchedRef AND
		LotSerRef LIKE @LotSerRef
GO
