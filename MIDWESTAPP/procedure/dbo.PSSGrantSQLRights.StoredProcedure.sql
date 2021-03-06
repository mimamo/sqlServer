USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSGrantSQLRights]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSGrantSQLRights] AS

IF EXISTS (SELECT [Name] FROM SysObjects WHERE [UID] = 1 AND XType = 'P' AND [Name] = 'sp_PSSGrantPermissions') BEGIN
  DECLARE @Type VARCHAR(10), @Name VarChar(100), @SQLPermission VARCHAR(20)
  SET @SQLPermission = 'CONTROL'
  IF CHARINDEX('2000 - 8.', @@Version) > 0 SET @SQLPermission = 'ALL'
  PRINT 'Granting permissions to objects...Start'
  DECLARE object_cursor CURSOR FOR
    SELECT [XType], [Name] FROM SysObjects WHERE XType IN ('U','V','P','FN') AND [Name] LIKE '%PSS%' ORDER BY [XType], [Name]
  OPEN object_cursor
  FETCH NEXT FROM object_cursor INTO @Type, @Name
  WHILE @@FETCH_STATUS = 0 BEGIN
    PRINT '    ' + @Name
    EXEC dbo.sp_PSSGrantPermissions @Type, @Name
    FETCH NEXT FROM object_cursor INTO @Type, @Name
  END
  CLOSE object_cursor
  DEALLOCATE object_cursor
  PRINT 'Granting permissions to objects...Complete'
END ELSE
  PRINT 'sp_PSSGrantPermissions procedure is missing!'
GO
