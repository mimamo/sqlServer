USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_CustClassID]    Script Date: 12/21/2015 16:13:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_CustClassID]
	@CustID		varchar(15)
as
	select	ClassID
	from	Customer
	where	CustID = @CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
