USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_AcctSub]    Script Date: 12/21/2015 14:05:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_AcctSub]
	@CpnyID	varchar(10),
	@Acct	varchar(10),
	@Sub	varchar(24)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	declare @Query varchar(255)

	--Execute the query from a variable so this procedure will compile even though the
	--view may not exist

	select @Query = 'select count(*) from VS_AcctSub where CpnyID = ' + QUOTENAME(@CpnyID,'''') + ' and Acct = ' + QUOTENAME(@Acct,'''') + ' and Sub = ' + QUOTENAME(@Sub, '''')

	execute (@Query)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
