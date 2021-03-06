USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemGetList]

	@CompanyKey int,
	@ItemType smallint

AS --Encrypt


	SELECT i.*, wt.WorkTypeID
	FROM tItem i (nolock)
		left outer join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey
	WHERE
		i.CompanyKey = @CompanyKey and
		i.ItemType = @ItemType
	Order By ItemName
		
	RETURN 1
GO
