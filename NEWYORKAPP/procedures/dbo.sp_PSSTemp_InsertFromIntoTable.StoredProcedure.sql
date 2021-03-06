USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[sp_PSSTemp_InsertFromIntoTable]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PSSTemp_InsertFromIntoTable]
	@TableFrom VARCHAR(100),
	@TableInto VARCHAR(100)
	AS

SET NOCOUNT ON

IF (@TableFrom IS NULL) OR (@TableInto IS NULL)
	RETURN

SET @TableFrom = RTRIM(LTRIM(@TableFrom))
SET @TableInto = RTRIM(LTRIM(@TableInto))

IF (@TableFrom = '') OR (@TableInto = '')
	RETURN

DECLARE @ID_From INT;SET @ID_From = OBJECT_ID('dbo.' + @TableFrom)
DECLARE @ID_Into INT;SET @ID_Into = OBJECT_ID('dbo.' + @TableInto)

IF (@ID_From IS NULL) OR (@ID_Into IS NULL)
	RETURN

DECLARE @ColumnName VARCHAR(30), @ColumnType TINYINT, @ColumnLength SMALLINT
DECLARE @ColumnList VARCHAR(8000), @ValueList VARCHAR(8000), @NextValue VARCHAR(1000)
SET @ColumnList = ''
SET @ValueList  = ''

DECLARE INTO_TABLE CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
	SELECT	CONVERT(VARCHAR(30), C.[Name])	AS [ColumnName],
			CONVERT(TINYINT,     C.[XType])	AS [ColumnType],
			CONVERT(SMALLINT,    C.[Length])AS [ColumnLength]
	FROM SysColumns C (NOLOCK)
	WHERE (C.[Id]   = @ID_Into)
	  AND (C.[Name] <> 'tstamp')
	ORDER BY C.[Name]

OPEN INTO_TABLE

FETCH NEXT FROM INTO_TABLE INTO @ColumnName, @ColumnType, @ColumnLength

WHILE (@@FETCH_STATUS = 0) BEGIN

	SET @ColumnName = LTRIM(RTRIM(@ColumnName))

	-- If the column exists in both tables, then use the reference to the column,
	-- but if the column does not exist in the source, then use the default value for that type
	IF (EXISTS (SELECT C.[Name] FROM SysColumns C (NOLOCK) WHERE (C.Id = @ID_From) AND (C.[Name] = @ColumnName) AND (C.[XType] = @ColumnType)))
		SET @NextValue = '[' + @ColumnName + ']'
	ELSE
		SET @NextValue = 
			CASE @ColumnType
				WHEN 239 THEN 'N'''''          -- NChar
				WHEN 231 THEN 'N'''''          -- NVarChar
				WHEN 175 THEN ''''''           -- Char
				WHEN 173 THEN '0'              -- Binary(8)
				WHEN 167 THEN ''''''           -- VarChar
				WHEN 127 THEN '0'              -- BigInt
				WHEN 108 THEN '0'              -- Numeric
				WHEN 106 THEN '0.00'           -- Decimal
				WHEN 104 THEN '0'              -- Bit
				WHEN  99 THEN 'N'''''          -- NText
				WHEN  62 THEN '0.00'           -- Float
				WHEN  61 THEN '''01/01/1900''' -- DateTime
				WHEN  58 THEN '''01/01/1900''' -- SmallDateTime
				WHEN  56 THEN '0'              -- Integer
				WHEN  52 THEN '0'              -- SmallInt
				WHEN  48 THEN '0'              -- TinyInt
				WHEN  35 THEN ''''''           -- Text
				WHEN  34 THEN '0x0'            -- Image
			END

	-- Append a comma if there is already some data in the variable
	IF (LEN(@ColumnList) > 0) SET @ColumnList = @ColumnList + ','
	IF (LEN(@ValueList)  > 0) SET @ValueList  = @ValueList  + ','

	-- Add the next column to the list of columns
	SET @ColumnList = @ColumnList + '[' + @ColumnName + ']'

	-- Add the next value to the list of values
	SET @ValueList = @ValueList + @NextValue

	FETCH NEXT FROM INTO_TABLE INTO @ColumnName, @ColumnType, @ColumnLength

END -- (@@FETCH_STATUS = 0)

CLOSE INTO_TABLE
DEALLOCATE INTO_TABLE

IF (@ColumnList != '') AND (@ValueList != '')
	EXEC('INSERT INTO dbo.[' + @TableInto + '] (' + @ColumnList + ') SELECT ' + @ValueList + ' FROM dbo.[' + @TableFrom + ']')
GO
