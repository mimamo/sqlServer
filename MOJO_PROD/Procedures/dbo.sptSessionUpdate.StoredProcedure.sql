USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSessionUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptSessionUpdate]
(
	@Entity varchar(50),
	@EntityKey int,
	@Data text
)

as 

If exists(Select 1 from tSession (nolock) Where Entity = @Entity and EntityKey = @EntityKey)
	Update tSession
	Set
		Data = @Data
	Where
		Entity = @Entity and EntityKey = @EntityKey

else
	Insert tSession
	( Entity, EntityKey, Data )
	Values
	( @Entity, @EntityKey, @Data )
GO
