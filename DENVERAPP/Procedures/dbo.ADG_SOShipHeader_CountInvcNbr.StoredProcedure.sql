USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeader_CountInvcNbr]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[ADG_SOShipHeader_CountInvcNbr]
	@CpnyID		VarChar(10),
	@InvcNbr	VarChar(10)

As
	Declare	@Count	Integer
	Set	@Count = 0

	Select	@Count = Count(*)
		From	SOShipHeader
		Where	CpnyID = @CpnyID
			And InvcNbr = @InvcNbr
			And Cancelled = 0
	Select	InvcCnt = Coalesce(@Count, 0)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
