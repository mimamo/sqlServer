USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileCheckIn]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileCheckIn]

	(
		@FileKey int,
		@UserKey int
	)

AS

Declare @CheckOutKey int

	Select @CheckOutKey = CheckedOutByKey from tDAFile (nolock) Where FileKey = @FileKey
	
	if @CheckOutKey = 0
		return -1
	else
		if @CheckOutKey <> @UserKey
			return -2
		else
		begin
			Update tDAFile Set CheckedOutByKey = 0, CheckedOutDate = NULL, CheckOutComment = NULL, LockFile = 0 Where FileKey = @FileKey
			return 1
		end
GO
