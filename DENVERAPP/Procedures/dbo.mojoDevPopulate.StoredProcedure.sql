USE [denverapp]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'mojoDevPopulate'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[mojoDevPopulate]
GO

CREATE PROCEDURE [dbo].[mojoDevPopulate] 

with recompile
	
AS 

/*******************************************************************************************************
*   FinanceDM.dbo.mojoDevPopulate
*
*   Creator:	Michelle Morales    
*   Date:		04/25/2016          
*   
*          
*   Notes: 
*
*   Usage:	set statistics io on

	execute FinanceDM.dbo.mojoDevPopulate 
	

*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
declare @tableName nvarchar(254),
	@sqlInsert nvarchar(max),
	@sqlSelect nvarchar(max),
	@sqlCommand nvarchar(max),
	@columnList nvarchar(max),
	@minColumnName nvarchar(100)

---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##columnList') > 0 drop table ##columnList
create table ##columnList
(
	TABLE_NAME varchar(100),
	COLUMN_NAME varchar(100)
)

---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're usiSng a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
select @tableName = null

select @tableName = min(table_name)
from sql1dev.mojo_dev.information_schema.tables

while @tableName is not null
begin

	truncate table ##columnList

	select @columnList = null

	select @columnList = '

			insert ##columnList
			(
				table_name,
				column_name
			)
			select ''' + @tableName + ''', col.[name] + '',''
			from sql1dev.mojo_dev.sys.columns col 
			inner join sql1dev.mojo_dev.sys.objects obj 
				on obj.[object_id] = col.[object_id]
			where obj.type = ''U''
				and col.is_identity <> 1
				and col.is_computed <> 1     
				and obj.[name] = ''' + @tableName + '''
			order by obj.[name] '

	execute sp_executesql @columnList

	select @sqlInsert = ' 

	use denverapp

	insert sql1dev.mojo_dev.dbo.' + @tableName + ' (' 

	select @sqlSelect = ' select ' 

	select @minColumnName = min(column_name)
	from ##columnList 

	while @minColumnName is not null
	begin
		
		select @sqlInsert = @sqlInsert + @minColumnName

		select @sqlSelect = @sqlSelect + @minColumnName

		select @minColumnName = min(column_name)
		from ##columnList 
		where column_name > @minColumnName

	end		

	select @sqlInsert = left(@sqlInsert, len(@sqlInsert) - 1) + ')'
	select @sqlSelect = left(@sqlSelect, len(@sqlSelect) - 1) + ' from sqlwmj.mojo_prod.dbo.' + @tableName

	select @sqlCommand = (@sqlInsert + @sqlSelect)

	print @sqlCommand

	if (select 1 from ##columnList) > 0
	begin
	
		execute sp_executesql @sqlCommand
	
	end

	select @tableName = min(table_name)
	from sql1dev.mojo_dev.information_schema.tables
	where table_name > @tableName
	
end

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on mojoDevPopulate to BFGROUP
go

grant execute on mojoDevPopulate to MSDSL
go

grant control on mojoDevPopulate to MSDSL
go

grant execute on mojoDevPopulate to MSDynamicsSL
go
