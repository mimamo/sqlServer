USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDNotes_Delete]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[XDDNotes_Delete]
	@nID		int
as

	DELETE 	FROM	sNote
	WHERE	nID = @nID
GO
