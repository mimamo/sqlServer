USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XSKNotes_Delete]    Script Date: 12/21/2015 14:06:29 ******/
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
