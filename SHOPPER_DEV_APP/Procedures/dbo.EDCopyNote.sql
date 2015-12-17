USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCopyNote]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCopyNote] @NoteID int, @Level varchar(20), @Table varchar(20)
As
	Insert Into Snote Select GetDate(), @Level,@Table,sNoteText,Null From SNote Where nID = @NoteID
	Select Cast(@@Identity As int)
GO
