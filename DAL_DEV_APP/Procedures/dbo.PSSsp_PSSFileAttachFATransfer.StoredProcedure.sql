USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSsp_PSSFileAttachFATransfer]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSsp_PSSFileAttachFATransfer] @TableName VARCHAR(30), @OldAssetID VARCHAR(10),@OldAssetSubId VARCHAR(10), @OldKeyField VARCHAR(100), @NewAssetID VARCHAR(10),@NewAssetSubId VARCHAR(10), @NewKeyField VARCHAR(100) AS

DECLARE @URL VARCHAR(255)
DECLARE @URLImage VARBINARY(MAX)
DECLARE @FileDescr VARCHAR(50)
DECLARE @FileType VARCHAR(10)
DECLARE @LineId AS INTEGER
DECLARE @LocDescr VARCHAR(30)
DECLARE @LocID VARCHAR(10)

-- ===================================
-- Transfer objects stored in table
-- ===================================

DECLARE MyCursor CURSOR  FOR

	SELECT FileDescr,FileType,LineId,LocDescr,LocId,TableName,URL FROM PSSFileAttach WHERE TableName = @TableName AND KeyField = @OldKeyField

OPEN MyCursor

FETCH NEXT FROM MyCursor INTO @FileDescr, @FileType, @LineId, @LocDescr, @LocId, @TableName, @URL

WHILE @@FETCH_STATUS = 0

	BEGIN
		
		INSERT INTO PSSFileAttach (KeyField, FileDescr, FileType, LineId, LocDescr, LocId, TableName, URL, Lupd_Prog, Lupd_DateTime, Lupd_User)
		VALUES (@NewKeyField, @FileDescr, @FileType, @LineId, @LocDescr, @LocId, @TableName, @URL, 'FA465', GETDATE(), 'TRANSFER')

		FETCH NEXT FROM MyCursor INTO @FileDescr, @FileType, @LineId, @LocDescr, @LocId, @TableName, @URL
	
	END
	
CLOSE MyCursor
DEALLOCATE MyCursor 

-- ===================================
-- Transfer objects stored in SQL
-- ===================================

DECLARE MyCursor CURSOR  FOR

	SELECT URL, URLImage FROM PSSFileAttachObj WHERE TableName = @TableName AND KeyField = @OldKeyField

OPEN MyCursor

FETCH NEXT FROM MyCursor INTO @URL, @URLImage


WHILE @@FETCH_STATUS = 0

	BEGIN
		
		INSERT INTO PSSFileAttachObj (KeyField, TableName, URL, URLImage, Lupd_Prog, Lupd_DateTime, Lupd_User)
		VALUES (@NewKeyField, @TableName, @URL, @URLImage, 'FA465', GETDATE(), 'TRANSFER')

		FETCH NEXT FROM MyCursor INTO @URL, @URLImage
	
	END
	
CLOSE MyCursor
DEALLOCATE MyCursor
GO
