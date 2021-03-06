USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOLine_InvtID_OrdNbr]    Script Date: 12/21/2015 14:34:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_SOLine_InvtID_OrdNbr]
	@CpnyID varchar(10),
	@InvtID varchar(30),
	@OrdNbr varchar(15)
as

	Select	*
	From	vp_SOLinePO
	Where	CpnyID = @CpnyID
	And 	InvtID = @InvtID
	And		OrdNbr LIKE @OrdNbr
	Order by CpnyID, InvtID, OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
