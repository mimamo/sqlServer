USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetGetLinkedList]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetGetLinkedList]

	@Entity varchar(50),
	@EntityKey int


AS --Encrypt

		SELECT pr.ProjectNumber + ' - ' + ss.Subject as Subject,
			   ss.SpecSheetKey
		FROM tSpecSheet ss (nolock) inner join tProject pr (nolock) on ss.EntityKey = pr.ProjectKey
		and ss.Entity = 'Project'
		and ss.EntityKey = @EntityKey

	RETURN 1
GO
