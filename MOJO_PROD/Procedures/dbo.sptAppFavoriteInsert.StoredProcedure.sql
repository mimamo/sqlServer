USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppFavoriteInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptAppFavoriteInsert]
(
	@CompanyKey int
   ,@UserKey int
   ,@ActionID varchar(50)
   ,@ActionKey int
   ,@DisplayOrder int = 0
   )

as

if @DisplayOrder = 0
	Select @DisplayOrder = ISNULL(Max(DisplayOrder), 0) + 1 from tAppFavorite (nolock) Where UserKey = UserKey and ActionID = @ActionID

INSERT INTO tAppFavorite
           (CompanyKey
           ,UserKey
           ,ActionID
           ,ActionKey
           ,DisplayOrder)
     VALUES
		   (@CompanyKey
           ,@UserKey
           ,@ActionID
           ,@ActionKey
           ,@DisplayOrder)
GO
