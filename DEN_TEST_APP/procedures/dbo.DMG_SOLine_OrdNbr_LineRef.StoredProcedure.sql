USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOLine_OrdNbr_LineRef]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_SOLine_OrdNbr_LineRef]
	@CpnyID varchar(10),
	@InvtID varchar(30),
	@OrdNbr varchar(15),
	@LineRef varchar(5)
as
	Select	*
	From	SOLine
	Where	CpnyID = @CpnyID
	And	InvtID = @InvtID
	And	QtyOrd >= 0
	And	OrdNbr = @OrdNbr
	And	LineRef like @LineRef
	Order by CpnyID, OrdNbr, LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
