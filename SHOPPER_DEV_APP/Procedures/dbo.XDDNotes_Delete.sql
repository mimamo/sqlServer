USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDNotes_Delete]    Script Date: 12/16/2015 15:55:38 ******/
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
