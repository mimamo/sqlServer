USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Company_GetDBInfo]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Company_GetDBInfo]
	@CpnyID		varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	select	BaseCuryID,
		DatabaseName,
		CpnyCOA,
		CpnySub
	from	VS_COMPANY
	where	CpnyID = @CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
