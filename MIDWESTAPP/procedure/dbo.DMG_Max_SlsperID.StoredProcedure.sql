USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Max_SlsperID]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_Max_SlsperID]
as
	declare @SlsperID1 varchar(10)
	declare @SlsperID2 varchar(10)

	select	@SlsperID1 = max(SlsperID)
	from	SOAddrSlsper

	select	@SlsperID2 = max(SlsperID)
	from	UserSlsper

	if len(rtrim(@SlsperID1)) > len(rtrim(@SlsperID2))
		select @SlsperID1
	else
		select @SlsperID2

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
