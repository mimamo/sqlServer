USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_CostTranLineRef]    Script Date: 12/21/2015 15:49:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_CostTranLineRef]
	@BatNbr		varchar(10),
	@RefNbr		varchar(15),
	@ARLineRef	varchar(5)
as
	select	LineRef
	from	INTran
	where	BatNbr = @BatNbr
	  and	RefNbr = @RefNbr
	  and	ARLineRef = @ARLineRef
	  and	TranType = 'CG'
	  and	Rlsed = 1


-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
