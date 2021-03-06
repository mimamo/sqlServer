USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppFavoriteDelete]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppFavoriteDelete]
(
	@UserKey int,
	@ActionID varchar(50),
	@ActionKey int
   )

as


declare @key int, @Order int


Delete tAppFavorite Where UserKey = @UserKey and ActionID = @ActionID and ActionKey = @ActionKey

select @key = 0, @Order = 0

while 1=1
BEGIN
	Select @key = MIN(AppFavoriteKey) from tAppFavorite (nolock) Where UserKey = @UserKey and ActionID = @ActionID and AppFavoriteKey > @key
		if @key is null
			break
	
	Select @Order = @Order + 1
	
	Update tAppFavorite Set DisplayOrder = @Order Where AppFavoriteKey = @key

END
GO
