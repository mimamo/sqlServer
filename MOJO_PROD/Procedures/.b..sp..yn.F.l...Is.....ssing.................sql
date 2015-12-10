USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncFolderIsProcessing]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncFolderIsProcessing]
 @SyncFolderKey int,
 @IsProcessing tinyint

AS --Encrypt

UPDATE tSyncFolder
SET IsProcessing = @IsProcessing
WHERE SyncFolderKey = @SyncFolderKey
 
RETURN 1
GO
