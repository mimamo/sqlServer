USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetLinkGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetLinkGetList]

	@EntityKey int,
	@Entity varchar(50)

/*
|| When      Who Rel      What
|| 10/06/10  MFT 10.5.3.6 Removed Project join & ProjectNumber prefix on Subject
*/

AS --Encrypt

		SELECT ss.Subject as Subject,
			   ss.SpecSheetKey
		FROM tSpecSheetLink ssl (nolock) inner join tSpecSheet ss (nolock) on ssl.SpecSheetKey = ss.SpecSheetKey
		WHERE ssl.EntityKey = @EntityKey
		and ssl.Entity = @Entity

RETURN 1
GO
