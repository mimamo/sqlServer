USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARDoc_CustARAcct]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARDoc_CustARAcct]
	@CustID	varchar(15)
as
	select	ARAcct,
		ARSub
	from	Customer
	where	CustID = @CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
