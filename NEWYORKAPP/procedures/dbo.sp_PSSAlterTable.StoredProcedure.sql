USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[sp_PSSAlterTable]    Script Date: 12/21/2015 16:01:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_PSSAlterTable] @Task VARCHAR(10), @TableName VARCHAR(50) AS

DECLARE @AlterTableName VARCHAR(50), @SQLStmt NVARCHAR(4000), @IndexName VARCHAR(100)
SET @AlterTableName = RTrim(@TableName) + '_AlterTable'

IF RTrim(@Task) = 'BEFORE' BEGIN

  IF EXISTS (SELECT [Name] FROM SysObjects WHERE UID = 1 AND XType = 'U' AND [Name] = RTrim(@TableName)) BEGIN

    IF EXISTS (SELECT [Name] FROM SysObjects WHERE UID = 1 AND XType = 'U' And [Name] = @AlterTableName) BEGIN
      SET @SQLStmt = 'DROP TABLE dbo.' + RTrim(@AlterTableName)
      EXEC sp_ExecuteSQL @statement = @SQLStmt
    END

    --SET @SQLStmt = 'SELECT [Name] INTO ##MyTempTable FROM SysIndexes WHERE Keys IS NOT NULL AND [Name] LIKE ''' + RTrim(@TableName) + '%'' AND id = (SELECT id FROM SysObjects WHERE UID = 1 AND XType = ''U'' AND [Name] = ''' + RTrim(@TableName) + ''') ORDER BY [Name]'
    --EXEC sp_ExecuteSQL @statement = @SQLStmt
    --DECLARE index_cursor CURSOR FAST_FORWARD FOR
    --  SELECT * FROM ##MyTempTable

    DECLARE index_cursor CURSOR FAST_FORWARD FOR
      SELECT [Name] FROM SysIndexes
      WHERE LEFT([Name], LEN(RTrim(@TableName))) = RTrim(@TableName) AND id = (SELECT id FROM SysObjects WHERE UID = 1 AND XType = 'U' AND [Name] = RTrim(@TableName)) ORDER BY [Name]

    OPEN index_cursor
    FETCH NEXT FROM index_cursor INTO @IndexName
  
    -- Drop all indexes on the table immediately so that when we execute all indexes again there will not be an error
    WHILE @@FETCH_STATUS = 0 BEGIN
      SET @SQLStmt = 'DROP INDEX ' + RTrim(@TableName) + '.' + RTrim(@IndexName)
      EXEC sp_ExecuteSQL @statement = @SQLStmt
      IF @@ERROR <> 0 PRINT @SQLStmt
      FETCH NEXT FROM index_cursor INTO @IndexName
    END
  
    CLOSE index_cursor
    DEALLOCATE index_cursor

    --DROP TABLE ##MyTempTable

    EXEC sp_Rename @objname = @TableName, @newname = @AlterTableName

  END -- IF EXISTS (SELECT [Name] FROM SysObjects WHERE UID = 1 AND XType = 'U' AND [Name] = RTrim(@TableName))

END -- RTrim(@Task) = 'BEFORE'

IF RTrim(@Task) = 'AFTER' BEGIN

  IF EXISTS (SELECT [Name] FROM SysObjects WHERE UID = 1 AND XType = 'U' AND [Name] = RTrim(@AlterTableName)) BEGIN

    DECLARE @ColumnList VARCHAR(2000), @ValueList VARCHAR(2000)
    SET @ColumnList = ''
    SET @ValueList  = ''
 
    IF NOT EXISTS (SELECT [Name] FROM SysObjects WHERE UID = 1 AND XType = 'U' AND [Name] = 'PSSUpgradeAfter')
      CREATE TABLE dbo.PSSUpgradeAfter (Crtd_DateTime DateTime, SQLStmt NVARCHAR(4000), TableName VARCHAR(50), UserName VARCHAR(50))

    IF     EXISTS (SELECT [Name] FROM SysObjects WHERE UID = 1 AND XType = 'U' AND [Name] = 'PSSUpgradeAfter')
      DELETE dbo.PSSUpgradeAfter WHERE Crtd_DateTime < (GETDATE() - 90)

    DECLARE @ColumnName VARCHAR(30), @ColumnType TINYINT, @ColumnLength SMALLINT
 
    DECLARE INSERT_CURSOR CURSOR FAST_FORWARD FOR
      SELECT CONVERT(VARCHAR(30), C.[Name]) [ColumnName], C.XType [ColumnType], C.Length [ColumnLength]
      FROM SysObjects O INNER JOIN SysColumns C ON O.Id = C.Id WHERE O.XType = 'U' AND O.[Name] = RTrim(@TableName) AND C.[Name] <> 'tstamp' ORDER BY C.[Name]
 
    OPEN INSERT_CURSOR
 
    FETCH NEXT FROM INSERT_CURSOR INTO @ColumnName, @ColumnType, @ColumnLength
 
    WHILE @@FETCH_STATUS = 0
      BEGIN -- @@FETCH_STATUS = 0
 
        IF LEN(RTRIM(@ColumnList)) > 0
          SET @ColumnList = RTrim(@ColumnList) + ','
 
        SET @ColumnList = RTrim(@ColumnList) + @ColumnName
 
        IF LEN(RTRIM(@ValueList)) > 0
          SET @ValueList = RTrim(@ValueList) + ','
 
        IF EXISTS (SELECT C.[Name] FROM SysObjects O INNER JOIN SysColumns C ON O.Id = C.Id WHERE O.[Name] = @AlterTableName AND C.[Name] = @ColumnName)
          SET @ValueList = RTrim(@ValueList) + @ColumnName
        ELSE
          SET @ValueList = RTrim(@ValueList) + 
            CASE @ColumnType
              WHEN 175 THEN ''''''           -- Char
              WHEN 127 THEN '0'              -- BigInt
              WHEN  62 THEN '0.00'           -- Float
              WHEN  58 THEN '''01/01/1900''' -- SmallDateTime
              WHEN  56 THEN '0'              -- Integer
              WHEN  52 THEN '0'              -- SmallInt
              WHEN  48 THEN '0'              -- TinyInt
              ELSE          ''''''           -- Unknown???
            END
 
        FETCH NEXT FROM INSERT_CURSOR INTO @ColumnName, @ColumnType, @ColumnLength
 
      END -- @@FETCH_STATUS = 0
 
    CLOSE INSERT_CURSOR
    DEALLOCATE INSERT_CURSOR
 
    SET @SQLStmt = 'INSERT INTO ' + RTrim(@TableName) + ' (' + @ColumnList + ') SELECT ' + @ValueList + ' FROM ' + RTRim(@AlterTableName)

    IF EXISTS (SELECT [Name] FROM SysObjects WHERE UID = 1 AND XType = 'U' AND [Name] = 'PSSUpgradeAfter')
      INSERT INTO dbo.PSSUpgradeAfter (Crtd_DateTime, SQLStmt, TableName, UserName) VALUES (GETDATE(), @SQLStmt, @TableName, USER_NAME())

    EXEC sp_ExecuteSQL @statement = @SQLStmt

  END -- IF EXISTS (SELECT [Name] FROM SysObjects WHERE UID = 1 AND XType = 'U' AND [Name] = RTrim(@AlterTableName))

END -- RTrim(@Task) = 'AFTER'
GO
