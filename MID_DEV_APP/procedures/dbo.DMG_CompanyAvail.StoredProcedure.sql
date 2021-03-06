USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CompanyAvail]    Script Date: 12/21/2015 14:17:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_CompanyAvail]
	@BaseCuryID	varchar(4),
	@DatabaseName	varchar(30),
	@CpnyID		varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	Select	*
	from	vs_Company
	where	BaseCuryID like @BaseCuryID
	and	DatabaseName like @DatabaseName
	and	CpnyID like @CpnyID
	order by CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
