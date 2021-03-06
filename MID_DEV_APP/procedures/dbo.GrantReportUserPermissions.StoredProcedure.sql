USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GrantReportUserPermissions]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GrantReportUserPermissions] @ObjectType sysname, @UserName sysname
AS
	Declare @ObjectName sysname
	Declare @permType  varchar(10)
	Declare query_cursor CURSOR
	for
	select name from sysobjects where type = @ObjectType order by name
        if (@ObjectType = 'P')
	begin
		select @permType = 'Execute'
	end
	else
	begin
	 	select @permType = 'Select'
	end
	open query_cursor
		fetch next from query_cursor into @ObjectName
		while (@@FETCH_STATUS <> -1)
		begin
			EXEC ('grant ' + @permType  + ' on [' + @ObjectName + '] to [' + @UserName + ']')
			fetch next from query_cursor into @ObjectName
		end
	close query_cursor
	deallocate query_cursor
GO
