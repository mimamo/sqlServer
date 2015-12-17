USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_CostTranExists]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_INTran_CostTranExists]
	@BatNbr		varchar(10),
	@RefNbr		varchar(15),
	@LineRef	varchar(5)
as
	declare		@TranCount	integer
	declare		@TranExists	smallint

	select	@TranCount = count(*)
	from	INTran
	where	BatNbr = @BatNbr
	  and	RefNbr = @RefNbr
	  and	LineRef = @LineRef
	  and	TranType = 'CG'
	  and	Rlsed = 1

	if (@TranCount > 0)
		select @TranExists = 1
	else
		select @TranExists = 0

	select	@TranExists


-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
