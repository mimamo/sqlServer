USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CustomerOrderBalance]    Script Date: 12/21/2015 16:00:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_CustomerOrderBalance]
	@CustID		varchar(15)
as
	exec ADG_CreditInfo_OrdShipBal '', @CustID, '', ''

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
