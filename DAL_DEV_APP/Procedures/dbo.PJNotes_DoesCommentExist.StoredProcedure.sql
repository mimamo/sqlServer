USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJNotes_DoesCommentExist]    Script Date: 12/21/2015 13:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PJNotes_DoesCommentExist]
	@KeyValue char(64),
	@NoteType char(4),
	@CommentExistFlag bit OUTPUT
	
AS
	begin

	-- Check if comments exists for the key_value and note_type passed in in PJNotes
	if exists(select * from PJNotes where key_value = @KeyValue and note_type_cd = @NoteType)
		select @CommentExistFlag = 1
	else
		select @CommentExistFlag = 0

	end
GO
