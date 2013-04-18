-- --------------------------------------------------------------
--
--  get Dynamics SL  version

--  On system DB run:
--
-- --------------------------------------------------------------


EXEC getversion



-- --------------------------------------------------------------
--
--  get Dynamics SL authentication type

--  On system DB run:
--
-- --------------------------------------------------------------

EXEC getauthenticationtype



-- --------------------------------------------------------------
--
--  Update Dbs for a server move:

--  On system DB run:
--
-- --------------------------------------------------------------



--(if name of DBs stayed the same, just different server name)
update domain set servername='NAMEOFNEWSERVER'
-- no need to run system views


-- (if name of DBs changed)
update domain set servername='NAMEOFNEWSERVER'
update company set databasename='NAMEOFNEWDB' where databasename='NAMEOFOLDDB'
update domain set databasename='NAMEOFNEWDB' where databasename='NAMEOFOLDDB'
-- then need to run system views in DB Maintenance


-- --------------------------------------------------------------
--
--  Disable all triggers

--  handy if suspect a custom trigger is breaking something.
--  reenable script is listed after this script
-- --------------------------------------------------------------
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
IF EXISTS (select * FROM sysobjects WHERE id = OBJECT_ID('dbo.udf_Tbl_TriggerStatusTAB'))
	DROP function dbo.udf_Tbl_TriggerStatusTAB
GO
create  FUNCTION dbo.udf_Tbl_TriggerStatusTAB (

     @TABLENamePattern as sysname = NULL -- Tables to show, 
                                         -- NULL for all
) RETURNS TABLE
  -- No schemabinding due to use of system tables.
/*
* Shows the enabled/disabled status of triggers that match
* the table name pattern.  Use NULL for triggers on all tables
* or a pattern for the LIKE operator to match names.
*
* Example:
select * from udf_Tbl_TriggerStatusTAB(null)
* 
* History:
* When          Who     Description
* ------------- ------- ----------------------------------------
* 2003-11-10    ASN     Initial Coding
*
* © Copyright 2003 Andrew Novick http://www.NovickSoftware.com
* You may use this function in any of your SQL Server databases
* including databases that you sell, so long as they contain 
* other unrelated database objects. You may not publish this 
* UDF either in print or electronically.
* Published in the T-SQL UDF of the Week Vol 2 #7 2/3/04
http://www.NovickSoftware.com/UDFofWeek/UDFofWeek.htm
****************************************************************/
AS RETURN 
 
    SELECT TOP 100 PERCENT WITH TIES
           T.[name] as TableName
         , TR.[Name] as TriggerName
         , CASE WHEN 1=OBJECTPROPERTY(TR.[id], 'ExecIsTriggerDisabled')
                THEN 'Disabled' ELSE 'Enabled' END Status
         FROM sysobjects T
        
             INNER JOIN sysobjects TR
                  on t.[ID] = TR.parent_obj
         WHERE (T.xtype = 'U' or T.XType = 'V')
            AND (@TableNamePattern IS NULL OR T.[name] LIKE @TableNamePattern)
            AND (TR.xtype = 'TR')
         ORDER BY T.[name]
                , TR.[name]
 
GO
---------------------------------------------------

declare @TableName varchar(255)
declare @TriggerName varchar(255)
declare @QueryString varchar(255)
DECLARE trigger_cursor CURSOR
   FOR select TableName, TriggerName from udf_Tbl_TriggerStatusTAB(null) where status='Enabled'
OPEN trigger_cursor 
FETCH NEXT FROM trigger_cursor INTO @TableName, @TriggerName
While @@fetch_status = 0  
Begin 
  set @QueryString='ALTER TABLE ' + @TableName + ' DISABLE TRIGGER ' + @TriggerName	
  execute (@QueryString)
  FETCH NEXT FROM trigger_cursor INTO  @TableName, @TriggerName
END 
CLOSE trigger_cursor 
DEALLOCATE trigger_cursor
---------------------------------------------------
select TableName, TriggerName, Status from udf_Tbl_TriggerStatusTAB(null)
---------------------------------------------------


-- --------------------------------------------------------------
--
--  Reenable all triggers

--  handy if suspect a custom trigger is breaking something.
--
-- --------------------------------------------------------------
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
go
IF EXISTS (select * FROM sysobjects WHERE id = OBJECT_ID('dbo.udf_Tbl_TriggerStatusTAB'))
	DROP function dbo.udf_Tbl_TriggerStatusTAB
GO

create  FUNCTION dbo.udf_Tbl_TriggerStatusTAB (

     @TABLENamePattern as sysname = NULL -- Tables to show, 
                                         -- NULL for all
) RETURNS TABLE
  -- No schemabinding due to use of system tables.
/*
* Shows the enabled/disabled status of triggers that match
* the table name pattern.  Use NULL for triggers on all tables
* or a pattern for the LIKE operator to match names.
*
* Example:
select * from udf_Tbl_TriggerStatusTAB(null)
* 
* History:
* When          Who     Description
* ------------- ------- ----------------------------------------
* 2003-11-10    ASN     Initial Coding
*
* © Copyright 2003 Andrew Novick http://www.NovickSoftware.com
* You may use this function in any of your SQL Server databases
* including databases that you sell, so long as they contain 
* other unrelated database objects. You may not publish this 
* UDF either in print or electronically.
* Published in the T-SQL UDF of the Week Vol 2 #7 2/3/04
http://www.NovickSoftware.com/UDFofWeek/UDFofWeek.htm
****************************************************************/
AS RETURN 
 
    SELECT TOP 100 PERCENT WITH TIES
           T.[name] as TableName
         , TR.[Name] as TriggerName
         , CASE WHEN 1=OBJECTPROPERTY(TR.[id], 'ExecIsTriggerDisabled')
                THEN 'Disabled' ELSE 'Enabled' END Status
         FROM sysobjects T
        
             INNER JOIN sysobjects TR
                  on t.[ID] = TR.parent_obj
         WHERE (T.xtype = 'U' or T.XType = 'V')
            AND (@TableNamePattern IS NULL OR T.[name] LIKE @TableNamePattern)
            AND (TR.xtype = 'TR')
         ORDER BY T.[name]
                , TR.[name]
 
GO
---------------------------------------------------

declare @TableName varchar(255)
declare @TriggerName varchar(255)
declare @QueryString varchar(255)
DECLARE trigger_cursor CURSOR
   FOR select TableName, TriggerName from udf_Tbl_TriggerStatusTAB(null) where status='Disabled'
OPEN trigger_cursor 
FETCH NEXT FROM trigger_cursor INTO @TableName, @TriggerName
While @@fetch_status = 0  
Begin 
  set @QueryString='ALTER TABLE ' + @TableName + ' ENABLE TRIGGER ' + @TriggerName	
  execute (@QueryString)
  FETCH NEXT FROM trigger_cursor INTO  @TableName, @TriggerName
END 
CLOSE trigger_cursor 
DEALLOCATE trigger_cursor
---------------------------------------------------
select TableName, TriggerName, Status from udf_Tbl_TriggerStatusTAB(null)
---------------------------------------------------


-- --------------------------------------------------------------
--
--  Rebuild system triggers

--  
--  
-- --------------------------------------------------------------

-- Drop all windows authentication triggers.  
-- If using windows authentication, it will also recreate the triggers
--  and cleans up any stray vs_acctsub or vs_acctxref records
--
-- 1 - Make a good database backup
-- 2 - Run as is against your SL System database
--
-- last updated: 5/13/2008

-- Step 1: Drop all ACCTSUB and ACCTXREF triggers

declare @triggername as char(100)
declare @execString as char(200)
DECLARE trigger_cursor CURSOR FOR 
   select name from sysobjects where type='TR' and ( 
		name like 'sDeleteAcctSub_%' or
		name like 'sInsertAcctSub_%' or
		name like 'sUpdateAcctSub_%' or
		name like 'sDeleteAcctXref_%' or
		name like 'sInsertAcctXref_%' or
		name like 'sUpdateAcctXref_%')
	OPEN trigger_cursor
	FETCH NEXT FROM trigger_cursor INTO @triggername
	WHILE @@FETCH_STATUS = 0
	BEGIN
		set @execString = 'drop trigger ' + @triggername
		print @execString
	exec (@execString)
	print 'Done'
		FETCH NEXT FROM trigger_cursor INTO @triggername
	END
CLOSE trigger_cursor
DEALLOCATE trigger_cursor


-- only do step 2 and 3 if windows auth
if (select top 1 text from syscomments where ID in (select ID from sysobjects where name='getauthenticationtype' and type='P'))
	like '%Windows%'
begin

-- Step 2: Recreate a new set of 6 triggers for each app database listed in the company table

declare @dbname as char(100)
declare @execString2 as char(1000)
DECLARE db_cursor CURSOR FOR 
   select distinct databasename from company  where databasename<>''
	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @dbname
	WHILE @@FETCH_STATUS = 0
	BEGIN
         set @execString2 = 'CREATE TRIGGER sDeleteAcctSub_' + rtrim(@dbname)
+' ON AcctSub WITH EXECUTE AS '+char(39)+'07718158D19D4f5f9D23B55DBF5DF1'+char(39)
+' AFTER DELETE '
+' AS Delete '+rtrim(@dbname)+'..vs_AcctSub from '+rtrim(@dbname)+'..vs_acctsub v join deleted on v.acct = deleted.acct and v.cpnyid = deleted.cpnyid and v.sub = deleted.sub'
	print @execString2
	exec (@execString2)
	print 'Done'

         set @execString2 = 'CREATE TRIGGER sInsertAcctSub_' + rtrim(@dbname)
+' ON AcctSub WITH EXECUTE AS '+char(39)+'07718158D19D4f5f9D23B55DBF5DF1'+char(39)
+' AFTER INSERT '
+' AS Insert into '+rtrim(@dbname)+'..vs_AcctSub select acct,active,cpnyid,crtd_datetime,crtd_prog,crtd_user,descr,lupd_datetime,lupd_prog,lupd_user,noteid,s4future01,s4future02,s4future03,s4future04,s4future05,s4future06,s4future07,s4future08,s4future09,s4future10,'
+'s4future11,s4future12,sub,user1,user2,user3,user4,user5,user6,user7,user8,null from inserted'

	print @execString2
	exec (@execString2)
	print 'Done'

         set @execString2 = 'CREATE TRIGGER sUpdateAcctSub_' + rtrim(@dbname)
+' ON AcctSub WITH EXECUTE AS '+char(39)+'07718158D19D4f5f9D23B55DBF5DF1'+char(39)
+' AFTER UPDATE '
+' AS Delete '+rtrim(@dbname)+'..vs_acctsub from '+rtrim(@dbname)+'..vs_acctsub v join deleted on v.acct = deleted.acct and v.cpnyid = deleted.cpnyid and v.sub = deleted.sub'
+' Insert into '+rtrim(@dbname)+'..vs_acctsub select acct,active,cpnyid,crtd_datetime,crtd_prog,crtd_user,descr,lupd_datetime,lupd_prog,lupd_user,noteid,s4future01,s4future02,s4future03,s4future04,s4future05,s4future06,s4future07,s4future08,s4future09,s4future10,'
+'s4future11,s4future12,sub,user1,user2,user3,user4,user5,user6,user7,user8,null from inserted'

	print @execString2
	exec (@execString2)
	print 'Done'

         set @execString2 = 'CREATE TRIGGER sDeleteAcctXref_' + rtrim(@dbname)
+' ON AcctXref WITH EXECUTE AS '+char(39)+'07718158D19D4f5f9D23B55DBF5DF1'+char(39)
+' AFTER DELETE '
+' AS Delete '+rtrim(@dbname)+'..vs_acctxref from '+rtrim(@dbname)+'..vs_acctxref v join deleted on v.acct = deleted.acct and v.cpnyid = deleted.cpnyid'
	print @execString2
	exec (@execString2)
	print 'Done'

         set @execString2 = 'CREATE TRIGGER sInsertAcctXref_' + rtrim(@dbname)
+' ON AcctXref WITH EXECUTE AS '+char(39)+'07718158D19D4f5f9D23B55DBF5DF1'+char(39)
+' AFTER INSERT '
+' AS Insert into '+rtrim(@dbname)+'..vs_acctXref select acct,accttype,active,cpnyid,descr,user1,user2,user3,user4,null from inserted'
	print @execString2
	exec (@execString2)
	print 'Done'

         set @execString2 = 'CREATE TRIGGER sUpdateAcctXref_' + rtrim(@dbname)
+' ON AcctXref WITH EXECUTE AS '+char(39)+'07718158D19D4f5f9D23B55DBF5DF1'+char(39)
+' AFTER UPDATE '
+' AS Delete '+rtrim(@dbname)+'..vs_acctxref from '+rtrim(@dbname)+'..vs_acctxref v join deleted on v.acct = deleted.acct and v.cpnyid = deleted.cpnyid'
+' Insert into '+rtrim(@dbname)+'..vs_acctXref select acct,accttype,active,cpnyid,descr,user1,user2,user3,user4,null from inserted'

	print @execString2
	exec (@execString2)
	print 'Done'

		FETCH NEXT FROM db_cursor INTO @dbname
	END
CLOSE db_cursor
DEALLOCATE db_cursor

-- Step 3: Cleanup any stray vs_acctxref or vs_acctsub records

declare @dbName3 as char(85)
declare @execString3 as char(200)

DECLARE db_cursor3 CURSOR FOR 
	   select distinct databasename from company where databasename<>''
	OPEN db_cursor3
	FETCH NEXT FROM db_cursor3 INTO @dbName3
	WHILE @@FETCH_STATUS = 0
	BEGIN
		set @execString3 = 'delete a from ' + QUOTENAME(rtrim(@dbName3)) + '..vs_acctxref a left join acctxref b on a.acct=b.acct and a.cpnyid=b.cpnyid where b.acct is null'
		print @execString3
		exec (@execString3)
		set	@execString3 = 'delete a from ' + QUOTENAME(rtrim(@dbName3)) + '..vs_acctsub a left join acctsub b on a.acct=b.acct and a.sub=b.sub and a.cpnyid=b.cpnyid where b.acct is null'
		print @execString3
		exec (@execString3)
		FETCH NEXT FROM db_cursor3 INTO @dbName3
	END
CLOSE db_cursor3
DEALLOCATE db_cursor3

END
-- END


-- --------------------------------------------------------------
--
--  BFGroup script – rebuilds the BusinessPortalUser permissions.  
--  
-- --------------------------------------------------------------
 

if not exists (select * from sysusers where name = 'BFGROUP' and issqlrole = 1)
exec sp_addrole 'BFGROUP'
GO

declare @cStatement varchar(255)
declare G_cursor CURSOR for select 'grant select,update,insert,delete on "' + convert(varchar(64),name) + '" to BFGROUP' from sysobjects 
            where (type = 'U' or type = 'V') and uid = 1 order by name

set nocount on

OPEN G_cursor
FETCH NEXT FROM G_cursor INTO @cStatement 

WHILE (@@FETCH_STATUS <> -1)
begin
            print @cStatement
EXEC (@cStatement)
            FETCH NEXT FROM G_cursor INTO @cStatement 
end
DEALLOCATE G_cursor

GO

declare @cStatement varchar(255)
declare G_cursor CURSOR for select 'grant execute on "' + convert(varchar(64),name) + '" to BFGROUP' from sysobjects 
            where (type = 'P') and uid = 1 order by name

set nocount on
OPEN G_cursor
FETCH NEXT FROM G_cursor INTO @cStatement 

WHILE (@@FETCH_STATUS <> -1)
begin
            print @cStatement
EXEC (@cStatement)
     FETCH NEXT FROM G_cursor INTO @cStatement 
end

DEALLOCATE G_cursor

GO


