USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[sp_PSSTemp_RenameColumnInTable]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PSSTemp_RenameColumnInTable]
	@TableName     VARCHAR(100),
	@ColumnNameOld VARCHAR(100),
	@ColumnNameNew VARCHAR(100)
	AS

SET NOCOUNT ON

IF (@TableName     IS NULL) RETURN
IF (@ColumnNameOld IS NULL) RETURN
IF (@ColumnNameNew IS NULL) RETURN

DECLARE @ID_Table INT
SET @ID_Table = OBJECT_ID('dbo.' + @TableName)

IF (@ID_Table IS NULL)
	RETURN

SET @ColumnNameOld = LTRIM(RTRIM(@ColumnNameOld))
SET @ColumnNameNew = LTRIM(RTRIM(@ColumnNameNew))

-- If the old column doesn't exist, then nothing to do
IF NOT EXISTS (SELECT C.[Name] FROM SysColumns C (NOLOCK) WHERE (C.[Id] = @ID_Table) AND (C.[Name] = @ColumnNameOld))
    RETURN

-- If the new column exists, then nothing to do
IF     EXISTS (SELECT C.[Name] FROM SysColumns C (NOLOCK) WHERE (C.[Id] = @ID_Table) AND (C.[Name] = @ColumnNameNew))
    RETURN

EXEC('EXEC sp_Rename ''' + @TableName + '.' + @ColumnNameOld + ''', ''' + @ColumnNameNew + ''', ''COLUMN''')
GO
