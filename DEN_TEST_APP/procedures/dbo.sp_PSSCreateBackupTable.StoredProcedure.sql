USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[sp_PSSCreateBackupTable]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PSSCreateBackupTable]
	@TableName SYSNAME,
	@Suffix    NVARCHAR(100)
	AS

SET NOCOUNT ON

DECLARE @ErrorMessage NVARCHAR(1000)
SET @ErrorMessage = ''

DECLARE @TableNameSource SYSNAME, @TableNameBackup SYSNAME
SET @TableNameSource = RTRIM(LTRIM(@TableName))
SET @TableNameBackup = @TableNameSource + '_' + @Suffix

SET @TableNameSource = 'dbo.[' + RTRIM(LTRIM(@TableNameSource)) + ']'
SET @TableNameBackup = 'dbo.[' + RTRIM(LTRIM(@TableNameBackup)) + ']'

IF (OBJECT_ID(@TableNameSource,'U') IS NULL)
	SET @ErrorMessage = @ErrorMessage + ' ' + @TableNameSource
ELSE BEGIN
	IF (OBJECT_ID(@TableNameBackup,'U') IS NOT NULL)
		EXEC('DROP TABLE ' + @TableNameBackup)

	EXEC('SELECT * INTO ' + @TableNameBackup + ' FROM ' + @TableNameSource)
END

IF (OBJECT_ID(@TableNameBackup,'U') IS NULL)
	SET @ErrorMessage = @ErrorMessage + ' ' + @TableNameBackup

IF (@ErrorMessage != '') BEGIN
	SET @ErrorMessage = 'sp_PSSCreateBackupTable: Missing -> ' + @ErrorMessage + ' Unable to backup the information.'
	RAISERROR(@ErrorMessage,18,2)
END
GO
