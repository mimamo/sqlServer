USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOVoidInvc_Delete]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOVoidInvc_Delete]
	@CpnyID		varchar( 10 ),
	@ReportName	varchar( 30 ),
	@InvcNbr	varchar( 15 )

as
	delete from SOVoidInvc
	where	CpnyID = @CpnyID
	  and	ReportName = @ReportName
	  and 	InvcNbr = @InvcNbr
	  and 	ShipRegisterID = ''

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
