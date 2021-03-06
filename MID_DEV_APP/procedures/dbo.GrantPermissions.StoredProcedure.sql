USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GrantPermissions]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GrantPermissions] @ObjectType sysname, @RoleName sysname, @permission varchar(10)
AS
	Declare @ObjectName sysname
	--Declare @permission varchar(10)

        --select @permission = 'CONTROL'
	Declare query_cursor CURSOR
	for
	select name from sysobjects where type = @ObjectType order by name
	open query_cursor
		fetch next from query_cursor into @ObjectName
		while (@@FETCH_STATUS <> -1)
		begin
			EXEC ('grant ' + @permission + ' on [' + @ObjectName + '] to [' + @RoleName + ']')
			fetch next from query_cursor into @ObjectName
		end
	close query_cursor
	deallocate query_cursor
GO
