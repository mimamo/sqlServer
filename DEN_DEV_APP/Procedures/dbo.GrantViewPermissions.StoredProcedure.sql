USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GrantViewPermissions]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GrantViewPermissions]
AS
	Declare @ObjectName sysname
	Declare query_cursor CURSOR
	for
	select name from sysobjects where type = 'V' and name like 'vs_%' order by name
	open query_cursor
		fetch next from query_cursor into @ObjectName
		while (@@FETCH_STATUS <> -1)
		begin
			EXEC ('grant select on [' + @ObjectName + '] to [07718158D19D4f5f9D23B55DBF5DF1]')
			fetch next from query_cursor into @ObjectName
		end
	close query_cursor
	deallocate query_cursor
GO
