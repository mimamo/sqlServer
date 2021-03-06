USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavLogUpdateResponse]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavLogUpdateResponse]
	@WebDavLogKey uniqueidentifier,
	@ResponseCode int
AS

/*
|| When      Who Rel      What
|| 8/31/11   CRG 10.5.4.7 Created
*/

	UPDATE	tWebDavLog
	SET		ResponseCode = @ResponseCode
	WHERE	WebDavLogKey = @WebDavLogKey
GO
