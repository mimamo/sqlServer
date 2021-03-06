USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_RebuildIndexes]    Script Date: 12/21/2015 13:35:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_RebuildIndexes]
as

	declare @Table varchar(255)

	-- Loop through all the objects that are tables
	declare TempCursor cursor for select Name from SysObjects Where Type = 'U'
	open TempCursor
	fetch next from TempCursor into @Table

	while (@@fetch_status = 0)
	begin
		select 'Rebuilding Indexes for Table : ' + @Table
		dbcc dbreindex(@Table, '', 0)

		fetch next from TempCursor into @Table
	end

	close TempCursor
	deallocate TempCursor

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
