USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsOrdDet_All]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SlsOrdDet_All]
	@CpnyID		char(10),
	@OrdNbr		char(10),
	@LineRef	char(5)
AS
	select	*
	from	SlsOrdDet
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	LineRef = @LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
