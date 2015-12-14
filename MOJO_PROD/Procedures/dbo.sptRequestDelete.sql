USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDelete]
	@RequestKey int,
	@UserKey int = NULL

AS --Encrypt

/*
|| When     Who Rel      What
|| 04/27/15 KMC 10.5.9.1 (248283) Added @UserKey param and to pass through to sptSpecSheetDelete for insert into tActionLog
*/

Declare @SpecSheetKey int

	Select @SpecSheetKey = -1
	While 1=1
	BEGIN
		Select @SpecSheetKey = Min(SpecSheetKey) from tSpecSheet (NOLOCK) Where Entity = 'ProjectRequest' and EntityKey = @RequestKey and SpecSheetKey > @SpecSheetKey

		if @SpecSheetKey is null
			break

		exec sptSpecSheetDelete @SpecSheetKey, @UserKey
	END

	DELETE
	FROM tRequest
	WHERE
		RequestKey = @RequestKey 

	RETURN 1
GO
