USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_OrdTot_SOMisc]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_OrdTot_SOMisc]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as
	select	'OpenCury' = (CuryMiscChrg - CuryMiscChrgAppl),
		'OpenReg' = (MiscChrg - MiscChrgAppl),
		Taxable,
		TaxCat

	from	SOMisc
	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
