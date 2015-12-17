USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_InvtID_AvgCost]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_InvtID_AvgCost]

	@InvtID varchar(30)
as
	select	case when ltrim(rtrim(ValMthd)) = 'A' then 1 else 0 end
	from	Inventory
	where	InvtID = @InvtID

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
