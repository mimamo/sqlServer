USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppReadClearRead]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppReadClearRead]
(
	@UserKey int,
	@Entity varchar(50),
	@EntityKey int
)

as

Update tAppRead Set IsRead = 0 Where UserKey <> @UserKey and Entity = @Entity and EntityKey = @EntityKey

-- Need to add a record if none exists so it does not show as new for you
if not exists(Select 1 from tAppRead (nolock) Where UserKey = @UserKey and Entity = @Entity and EntityKey = @EntityKey)
	Insert tAppRead (Entity, EntityKey, UserKey, IsRead) Values (@Entity, @EntityKey, @UserKey, 1)
GO
