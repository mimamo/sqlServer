USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[sp_PSSRestoreBackupTable]    Script Date: 12/21/2015 15:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PSSRestoreBackupTable]
	@TableName SYSNAME,
	@Suffix    NVARCHAR(100)
	AS

SET NOCOUNT ON

DECLARE @ErrorMessage NVARCHAR(1000)
SET @ErrorMessage = ''

DECLARE @TableNameSource SYSNAME, @TableNameBackup SYSNAME
SET @TableNameSource = 'dbo.' + RTRIM(LTRIM(@TableName))
SET @TableNameBackup = @TableNameSource + '_' + @Suffix

IF (OBJECT_ID(@TableNameSource,'U') IS NULL)
	SET @ErrorMessage = @ErrorMessage + ' ' + @TableNameSource
ELSE BEGIN

	IF (OBJECT_ID(@TableNameBackup,'U') IS NOT NULL) BEGIN
		BEGIN TRY
			EXEC('TRUNCATE TABLE ' + @TableNameSource)
		END TRY
		BEGIN CATCH
			EXEC('DELETE FROM ' + @TableNameSource)
		END CATCH

		EXEC dbo.sp_PSSTemp_InsertFromIntoTable @TableNameBackup,@TableNameSource
	END

END

IF (OBJECT_ID(@TableNameBackup,'U') IS NULL)
	SET @ErrorMessage = @ErrorMessage + ' ' + @TableNameBackup

IF (@ErrorMessage != '') BEGIN
	SET @ErrorMessage = 'sp_PSSRestoreBackupTable: Missing -> ' + @ErrorMessage + ' Unable to restore the information.'
	RAISERROR(@ErrorMessage,18,2)
END
GO
