USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[sptAppReadMarkRead]    Script Date: 04/29/2016 16:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[sptAppReadMarkRead]
(
	@UserKey int,
	@Entity varchar(50),
	@EntityKey int
)

as


if ISNULL(@UserKey, 0) = 0
	return 1


if not exists(Select 1 from tAppRead (nolock) Where UserKey = @UserKey and Entity = @Entity and EntityKey = @EntityKey)
	Insert tAppRead (UserKey, Entity, EntityKey, IsRead) Values (@UserKey, @Entity, @EntityKey, 1)
Else
	Update tAppRead Set IsRead = 1 Where UserKey = @UserKey and Entity = @Entity and EntityKey = @EntityKey
