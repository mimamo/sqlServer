USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SlsperHist]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SlsperHist]
	@SlsperID	varchar(10),
	@FiscYr		varchar(4)
as
	select	*
	from	SlsperHist
	where	SlsperID = @SlsperID
	  and	FiscYr = @FiscYr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
