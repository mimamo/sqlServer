USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_SubXref]    Script Date: 12/21/2015 13:44:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_SubXref]
	@CpnyID	varchar(10),
	@Sub	varchar(24)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	set nocount on

	declare	@GLCpnyID	varchar(10)
	declare @Query		varchar(255)

	-- Get the 'subaccount' company.
	select	@GLCpnyID = CpnySub
	from	VS_Company
	where	CpnyID = @CpnyID

	set nocount off

	--Execute the query from a variable so this procedure will compile even though the
	--view may not exist
	select @Query = 'select count(*) from VS_SubXref where CpnyID = ' + QUOTENAME(@GLCpnyID,'''') + ' and Sub = ' + QUOTENAME(@Sub, '''')

	execute (@Query)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
