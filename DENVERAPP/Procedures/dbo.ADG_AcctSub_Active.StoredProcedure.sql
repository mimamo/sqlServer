USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_AcctSub_Active]    Script Date: 12/21/2015 15:42:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_AcctSub_Active]
	@CpnyID	varchar(10),
	@Acct	varchar(10),
	@Sub 	varchar(24)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	declare @Query varchar(255)

	--Execute the query from a variable so this procedure will compile even though the
	--view doesn't exist (yet)

	select @Query = 'select * ' +
	'from vs_AcctSub ' +
	'where  CpnyID like ' + QUOTENAME(@CpnyID,'''') +
	  ' and  Acct like ' + QUOTENAME(@Acct,'''') +
	  ' and  Sub like ' + QUOTENAME(@Sub,'''') +
	  'and  Active = 1 ' +
	'order by CpnyID, Acct, Sub'

	execute(@Query)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
