USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XSKNotes_Delete]    Script Date: 12/21/2015 16:13:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[XSKNotes_Delete]
	@nID 			int
as

	DELETE 	FROM	sNote
	WHERE	nID = @nID
GO
