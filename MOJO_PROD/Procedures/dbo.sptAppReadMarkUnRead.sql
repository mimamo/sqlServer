USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppReadMarkUnRead]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppReadMarkUnRead]
(
	@UserKey int,
	@Entity varchar(50),
	@EntityKey int
)

as

Delete tAppRead Where UserKey = @UserKey and Entity = @Entity and EntityKey = @EntityKey
GO
