USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttachmentGetCompanyList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAttachmentGetCompanyList]
 (
  @CompanyKey int
 )
AS --Encrypt

/*
|| When      Who Rel     What
|| 5/31/11   RLB 10.545  Added for new Flex Activation History
*/

	SELECT *
			,0 AS selected
	FROM	vAttachmentList
	WHERE	CompanyKey = @CompanyKey
	ORDER BY Entity, ItemDesc

	RETURN 1
GO
