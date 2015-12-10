USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileCheckOut]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileCheckOut]

	(
		@FileKey int,
		@UserKey int,
		@CheckOutComment varchar(1000),
		@LockFile tinyint
	)

AS

Declare @CheckOutKey int

	Select @CheckOutKey = CheckedOutByKey from tDAFile (nolock) Where FileKey = @FileKey
	
	if @CheckOutKey = 0
	begin
		Update tDAFile Set 
			CheckedOutByKey = @UserKey, 
			CheckedOutDate = GETUTCDATE(),
			CheckOutComment = @CheckOutComment,
			LockFile = @LockFile
		Where FileKey = @FileKey
		return 1
	end
	else
		return -1
GO
