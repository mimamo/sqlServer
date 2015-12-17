USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_POTran_BatNbr]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_POTran_BatNbr]
	@BatNbr		varchar(10)
as

	select	*
	from	POTran
	where	BatNbr = @BatNbr
	Order by RcptNbr, LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
