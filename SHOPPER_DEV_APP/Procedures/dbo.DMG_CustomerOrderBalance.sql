USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CustomerOrderBalance]    Script Date: 12/16/2015 15:55:16 ******/
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
