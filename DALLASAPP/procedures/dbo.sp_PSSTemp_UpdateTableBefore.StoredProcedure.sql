USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[sp_PSSTemp_UpdateTableBefore]    Script Date: 12/21/2015 13:45:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PSSTemp_UpdateTableBefore]
	@TableName VARCHAR(50)
	AS

SET NOCOUNT ON

DECLARE @AlterTableName VARCHAR(50)
SET @TableName      = RTRIM(LTRIM(@TableName))
SET @AlterTableName = @TableName + '_AlterTable'

DECLARE @ID_Table INT;SET @ID_Table = OBJECT_ID('dbo.' + @TableName)
DECLARE @ID_Alter INT;SET @ID_Alter = OBJECT_ID('dbo.' + @AlterTableName)

DECLARE @SQLStmt NVARCHAR(4000), @IndexName VARCHAR(100)

-------------------------------------------------------------------------------------
IF (@ID_Table IS NOT NULL) BEGIN
-------------------------------------------------------------------------------------

	IF (OBJECT_ID('dbo.' + @AlterTableName,'U') IS NOT NULL) BEGIN
		SET @SQLStmt = 'DROP TABLE dbo.' + @AlterTableName
		EXEC sp_ExecuteSQL @statement = @SQLStmt
	END

	DECLARE index_cursor CURSOR LOCAL FAST_FORWARD FOR
		SELECT I.[Name]
		FROM SysIndexes I (NOLOCK)
		WHERE (LEFT(I.[Name], LEN(@TableName)) = @TableName)
		  AND (I.[Id] = @ID_Table)
		ORDER BY I.[Name]

	OPEN index_cursor
	FETCH NEXT FROM index_cursor INTO @IndexName

	-- Drop all indexes on the table immediately so that when we execute all indexes again there will not be an error
	WHILE (@@FETCH_STATUS = 0) BEGIN
		SET @SQLStmt = 'DROP INDEX ' + RTRIM(@TableName) + '.' + LTRIM(RTRIM(@IndexName))
		EXEC sp_ExecuteSQL @statement = @SQLStmt
		IF (@@ERROR <> 0) PRINT @SQLStmt
		FETCH NEXT FROM index_cursor INTO @IndexName
	END

	CLOSE index_cursor
	DEALLOCATE index_cursor

	EXEC sp_Rename @objname = @TableName, @newname = @AlterTableName

-------------------------------------------------------------------------------------
END -- (@ID_Table IS NOT NULL)
-------------------------------------------------------------------------------------
GO
