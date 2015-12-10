USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityUpdateReply]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityUpdateReply]
	(
	@ActivityKey int,
	@UserKey int,
	@Notes text
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 12/16/10  GHL 10.5.3.9 Created to update Diary
|| 01/06/10  GHL 10.5.4.0 Using now UTC date for DateUpdated
|| 03/03/14 GWG 10.5.7.8 Added support for clearing the read flag
*/

	SET NOCOUNT ON 

	update tActivity
	set    Notes = @Notes
	      ,DateUpdated = getutcdate()
		  ,UpdatedByKey = @UserKey
	where  ActivityKey = @ActivityKey
	
	
	--Clear any read flags
	exec sptAppReadClearRead @UserKey, 'tActivity', @ActivityKey

	RETURN 1
GO
