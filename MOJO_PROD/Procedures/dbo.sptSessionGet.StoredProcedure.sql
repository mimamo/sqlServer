USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSessionGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptSessionGet]
(
	@Entity varchar(50),
	@EntityKey int
)

as 

Select Data from tSession (nolock) 
Where Entity = @Entity and EntityKey = @EntityKey
GO
