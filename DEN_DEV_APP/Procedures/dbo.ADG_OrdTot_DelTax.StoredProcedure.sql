USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_OrdTot_DelTax]    Script Date: 12/21/2015 14:05:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_OrdTot_DelTax]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as
	delete		SOTax
	where		CpnyID = @CpnyID
	  and		OrdNbr = @OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
