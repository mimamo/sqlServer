USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Company_GetDBCompanies]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Company_GetDBCompanies]
	@CpnyID		varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	select	CpnyID,
		CpnyName
	from	VS_COMPANY
	where	BaseCuryID in (select BaseCuryID from VS_COMPANY where CpnyID = @CpnyID)
	and	DatabaseName in (select DatabaseName from VS_COMPANY where CpnyID = @CpnyID)
	order by CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
