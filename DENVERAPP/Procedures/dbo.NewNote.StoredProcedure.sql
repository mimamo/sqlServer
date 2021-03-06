USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[NewNote]    Script Date: 12/21/2015 15:42:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.NewNote    Script Date: 1/3/2002 12:51:35 PM ******/

Create Procedure [dbo].[NewNote] @LevelName varchar(20), @TableName varchar(20), @OldNID int
 as
DECLARE @NoteText varchar(8000)
Set @NoteText = (select substring(snotetext, 1, 8000) from snote where nid = @OldNID)
insert into snote (dtRevisedDate, sLevelName, sTableName, sNoteText) values (GETDATE(), @LevelName, @TableName, @NoteText)
GO
