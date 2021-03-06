USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMobileSearchGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMobileSearchGetList]

	(
		@UserKey int,
		@ListID varchar(50)
	)

AS

Select MobileSearchKey as data, SearchName as label,
(Select 1 from tMobileSearchDefault (nolock) Where ListID = @ListID and UserKey = @UserKey and MobileSearchKey = tMobileSearch.MobileSearchKey) as LastSearch
From tMobileSearch (nolock)
Where 
( CompanyKey IS NULL and ListID = @ListID and
	StdSearchKey not in (Select ISNULL(StdSearchKey, 0) from tMobileSearch (nolock) Where UserKey = @UserKey and ListID = @ListID and StandardSearch = 0 )  )
	OR
( UserKey = @UserKey and ListID = @ListID and StandardSearch = 0 and Deleted = 0 and ISNULL(StdSearchKey, 0) > 0 )
   
UNION ALL

Select MobileSearchKey as data, SearchName as label,
(Select 1 from tMobileSearchDefault (nolock) Where ListID = @ListID and UserKey = @UserKey and MobileSearchKey = tMobileSearch.MobileSearchKey) as LastSearch
From tMobileSearch (nolock)
Where UserKey = @UserKey and ListID = @ListID and StandardSearch = 0 and ISNULL(StdSearchKey, 0) = 0 and Deleted = 0


Order By SearchName

return 1
GO
