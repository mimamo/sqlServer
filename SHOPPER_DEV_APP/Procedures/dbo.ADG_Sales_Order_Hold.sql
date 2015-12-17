USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Sales_Order_Hold]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Sales_Order_Hold]
	@CpnyID	varchar(10),
	@OrdNbr	varchar(15)
as
	update	SOHeader
	set	AdminHold = 1
	where	CpnyID like @CpnyID
	  and	OrdNbr	like @OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
