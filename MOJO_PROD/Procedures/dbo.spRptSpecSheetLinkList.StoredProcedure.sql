USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptSpecSheetLinkList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptSpecSheetLinkList]

	@EntityKey int,
	@Entity varchar(50)


AS --Encrypt

		SELECT ss.*
		FROM tSpecSheetLink ssl (nolock) inner join tSpecSheet ss (nolock) on ssl.SpecSheetKey = ss.SpecSheetKey
		WHERE ssl.EntityKey = @EntityKey
		and ssl.Entity = @Entity
		order by ss.DisplayOrder

	RETURN 1
GO
