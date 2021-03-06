USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CRTSH_GetSOLot]    Script Date: 12/21/2015 16:06:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_CRTSH_GetSOLot]
	@CpnyID varchar( 10 ),
	@OrdNbr varchar( 15 ),
	@LineRef varchar( 5 ),
	@SchedRef varchar( 5 ),
	@LotSerRef varchar( 5 )
AS
		SELECT *
		FROM SOLot
		WHERE CpnyID = @CpnyID
		   AND OrdNbr = @OrdNbr
		   AND LineRef = @LineRef
		   AND SchedRef = @SchedRef
		   AND LotSerRef = @LotSerRef

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
