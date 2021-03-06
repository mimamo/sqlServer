USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sp_PSSUpdateSNote]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_PSSUpdateSNote] @nID Integer, @RevisedDate VarChar(14), @LevelName VarChar(20), @TableName VarChar(20), @Note VarChar(8000) AS
	
	SET NOCOUNT ON
	
	DECLARE @FoundId INTEGER
	SET @FoundId  = @nId
	
	SET @Note = IsNull(@Note, '')
	
	IF @Note <> ''
	BEGIN -- @Note <> ''
	
	DECLARE @FoundMsg INTEGER
	SET @FoundMsg = -1
	
	-- If not adding a new record, then see if it exists
	IF @nId <> 0
	SET @FoundId = ISNULL((SELECT nId FROM SNote WHERE nId = @nId), -1)
	
	IF @FoundId = 0
	
	BEGIN -- @FoundId = 0
	INSERT INTO SNote
	(dtRevisedDate, sLevelName, sTableName, sNoteText)
	VALUES
	(@RevisedDate,  @LevelName, @TableName, '')
	SET @FoundId = ISNULL((SELECT TOP 1 nId FROM SNote WHERE dtRevisedDate = @RevisedDate AND sLevelName = @LevelName AND sTableName = @TableName ORDER BY nID DESC), -1)
	SET @FoundMsg = -1
	END -- @FoundId = 0
	
	ELSE -- @FoundId = 0
	
	BEGIN -- @FoundId <> 0
	SET @FoundMsg = ISNULL((SELECT nId FROM SNote WHERE nId = @nId AND sNoteText LIKE '%' + RTRIM(LTRIM(@Note)) + '%'), -1)
	END -- @FoundId <> 0
	
	IF @FoundMsg = -1 -- The message was NOT already found in the column
	
	BEGIN -- @FoundMsg = -1
	
	UPDATE SNote
	SET dtRevisedDate = @RevisedDate
	WHERE nId = @FoundId
	
	DECLARE @PtrVal VARBINARY(16)
	SELECT @PtrVal = TEXTPTR(sNoteText)
	FROM SNote
	WHERE nId = @FoundId
	
	UPDATETEXT Snote.sNoteText @PtrVal NULL NULL @Note
	
	END -- @FoundMsg = -1
	
	END -- @Note <> ''
	
	SELECT nId FROM SNote WHERE nId = @FoundId
GO
