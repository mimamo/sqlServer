USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Company_Count]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_Company_Count]

	@CpnyID varchar(10)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select 	count(*)
	from	vs_Company
	where	CpnyID like @CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
