USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_POTran_BatNbr]    Script Date: 12/21/2015 16:12:59 ******/
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
