USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ProcessQueue_Drop_Index]    Script Date: 12/21/2015 16:13:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ProcessQueue_Drop_Index]

as
	declare @Name1 varchar(60)
	declare @SQLStmnt varchar(128)

	select @Name1 = name from sysindexes where name like 'PK%' and id in (select id from sysobjects where name = 'ProcessQueue')

	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = object_id(@Name1) and sysstat & 0xf = 9)
	begin
		select @SQLStmnt = 'ALTER TABLE ProcessQueue DROP CONSTRAINT ' + @Name1
		exec (@SQLStmnt)
	end

	IF EXISTS (SELECT * FROM SYSINDEXES WHERE NAME = @Name1 AND ID = object_id('dbo.ProcessQueue'))
	begin

		select @SQLStmnt = 'DROP INDEX ProcessQueue.' + @Name1
		exec (@SQLStmnt)
	end
GO
