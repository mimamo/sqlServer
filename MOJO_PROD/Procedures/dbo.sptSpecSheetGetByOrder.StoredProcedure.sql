USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetGetByOrder]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetGetByOrder]

	(
		@Entity varchar(50),
		@EntityKey int,
		@DisplayOrder int
	)

AS


Select * from tSpecSheet (NOLOCK) 
Where
	Entity = @Entity and
	EntityKey = @EntityKey and
	DisplayOrder = @DisplayOrder
GO
