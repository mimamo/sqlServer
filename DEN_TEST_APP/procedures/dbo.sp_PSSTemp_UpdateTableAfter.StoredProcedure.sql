USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[sp_PSSTemp_UpdateTableAfter]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PSSTemp_UpdateTableAfter]
	@TableName VARCHAR(50)
	AS

SET NOCOUNT ON

DECLARE @AlterTableName VARCHAR(50)
SET @TableName      = RTRIM(LTRIM(@TableName))
SET @AlterTableName = @TableName + '_AlterTable'

DECLARE @ID_Table INT;SET @ID_Table = OBJECT_ID('dbo.' + @TableName)
DECLARE @ID_Alter INT;SET @ID_Alter = OBJECT_ID('dbo.' + @AlterTableName)


-------------------------------------------------------------------------------------
IF (@ID_Table IS NULL) AND (@ID_Alter IS NOT NULL) BEGIN
-------------------------------------------------------------------------------------
	EXEC sp_Rename @objname = @AlterTableName, @newname = @TableName
-------------------------------------------------------------------------------------
END
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
-- Compare the table structures to see if there is really any difference that
-- requires the use of INSERT statement
-------------------------------------------------------------------------------------
IF (@ID_Table IS NOT NULL) AND (@ID_Alter IS NOT NULL) BEGIN
-------------------------------------------------------------------------------------

	IF (OBJECT_ID('tempDB.dbo.##tmpPSSUpgradeAfter_Compare_Table') IS NOT NULL) EXEC('DROP TABLE ##tmpPSSUpgradeAfter_Compare_Table')
	IF (OBJECT_ID('tempDB.dbo.##tmpPSSUpgradeAfter_Compare_Alter') IS NOT NULL) EXEC('DROP TABLE ##tmpPSSUpgradeAfter_Compare_Alter')

	-- Create a temporary table for the column comparisons
	CREATE TABLE ##tmpPSSUpgradeAfter_Compare_Table (
		[ColumnName]	SYSNAME,
		[ColumnType]	VARCHAR(5),
		[ColumnLength]	INT)
	CREATE CLUSTERED INDEX tmpPSSUpgradeAfter_Compare_Table0 ON ##tmpPSSUpgradeAfter_Compare_Table ([ColumnName], [ColumnType], [ColumnLength])

	INSERT INTO ##tmpPSSUpgradeAfter_Compare_Table ([ColumnName], [ColumnType], [ColumnLength])
		SELECT C.[Name], C.[XType], C.[Length]
		FROM SysColumns C (NOLOCK)
		WHERE (C.[Id] = @ID_Table) AND (C.[Name] <> 'tstamp')

	-- Create a temporary table for the column comparisons
	CREATE TABLE ##tmpPSSUpgradeAfter_Compare_Alter (
		[ColumnName]	SYSNAME,
		[ColumnType]	VARCHAR(5),
		[ColumnLength]	INT)
	CREATE CLUSTERED INDEX ##tmpPSSUpgradeAfter_Compare_Alter0 ON ##tmpPSSUpgradeAfter_Compare_Alter ([ColumnName], [ColumnType], [ColumnLength])

	INSERT INTO ##tmpPSSUpgradeAfter_Compare_Alter ([ColumnName], [ColumnType], [ColumnLength])
		SELECT C.[Name], C.[XType], C.[Length]
		FROM SysColumns C (NOLOCK)
		WHERE (C.[Id] = @ID_Alter) AND (C.[Name] <> 'tstamp')

	DECLARE @Count_Table INT, @Count_Alter INT, @Count_Combined INT
	SET @Count_Table = (SELECT COUNT(*) FROM ##tmpPSSUpgradeAfter_Compare_Table)
	SET @Count_Alter = (SELECT COUNT(*) FROM ##tmpPSSUpgradeAfter_Compare_Alter)
	
	IF (@Count_Table = @Count_Alter) BEGIN

		SET @Count_Combined = (
			SELECT COUNT(*)
			FROM       ##tmpPSSUpgradeAfter_Compare_Table t (NOLOCK)
			INNER JOIN ##tmpPSSUpgradeAfter_Compare_Alter a (NOLOCK)
			ON (t.[ColumnName] = a.[ColumnName]) AND (t.[ColumnType] = a.[ColumnType]) AND (t.[ColumnLength] = a.[ColumnLength])
			)
			
		IF (@Count_Table = @Count_Combined) BEGIN
			EXEC('DROP TABLE dbo.' + @TableName)
			EXEC sp_Rename @objname = @AlterTableName, @newname = @TableName
			SET @ID_Table = NULL
			SET @ID_Alter = NULL
		END

	END -- (@Count_Table = @Count_Alter)

	IF (OBJECT_ID('tempDB.dbo.##tmpPSSUpgradeAfter_Compare_Table') IS NOT NULL) EXEC('DROP TABLE ##tmpPSSUpgradeAfter_Compare_Table')
	IF (OBJECT_ID('tempDB.dbo.##tmpPSSUpgradeAfter_Compare_Alter') IS NOT NULL) EXEC('DROP TABLE ##tmpPSSUpgradeAfter_Compare_Alter')

-------------------------------------------------------------------------------------
END -- (@ID_Table IS NOT NULL) AND (@ID_Alter IS NOT NULL)
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
IF (@ID_Table IS NOT NULL) AND (@ID_Alter IS NOT NULL) BEGIN
-------------------------------------------------------------------------------------

	EXEC dbo.sp_PSSTemp_InsertFromIntoTable @AlterTableName, @TableName

	IF (OBJECT_ID('dbo.sp_PSSGrantPermissions','P') IS NOT NULL)
		EXEC( N'EXEC dbo.sp_PSSGrantPermissions ''U'', ''' + @TableName + '''')

-------------------------------------------------------------------------------------
END -- (@ID_Table IS NOT NULL) AND (@ID_Alter IS NOT NULL)
-------------------------------------------------------------------------------------
GO
