USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XSKNotes_Get]    Script Date: 12/21/2015 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XSKNotes_Get]
	@sNID			int
AS

	declare		@dtRevisedDate	smalldatetime
	declare		@sLevelName	varchar(20)
	declare		@sNoteText	char(8000)
	declare 	@sTableName	varchar(20)
	
	SELECT		@dtRevisedDate = dtRevisedDate,
			@sLevelName = sLevelName,
			@sTableName = sTableName,
			@sNoteText = sNoteText
	FROM		sNote (nolock)
	WHERE		nID = @sNID
	
	if @@ROWCOUNT = 0
		SELECT		0,
				'',
				'',
				'',
				convert(text, @sNoteText)
		FROM		sNote (nolock)
		WHERE		nID = @sNID
		
	else	
		SELECT		@dtRevisedDate,
				@sLevelName,
				@sTableName,
				convert(text, @sNoteText)
GO
