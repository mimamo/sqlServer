USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[UpdateARDocNoteID]    Script Date: 12/21/2015 15:55:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[UpdateARDocNoteID] @CustID CHAR(15), @DocType CHAR(2), @RefNbr CHAR(10), @NoteID INT AS
	UPDATE ARDoc SET NoteID=@NoteID WHERE CustID=@CustID AND DocType=@DocType AND RefNbr=@RefNbr
GO
