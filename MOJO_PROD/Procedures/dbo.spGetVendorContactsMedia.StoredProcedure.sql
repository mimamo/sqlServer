USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetVendorContactsMedia]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetVendorContactsMedia]

	@CompanyMediaKey int


AS --Encrypt

		SELECT us.UserKey,
		       CASE 
			       WHEN us.Title is null THEN isnull(us.FirstName,'') + ' ' + isnull(us.LastName,'')
				   ELSE isnull(us.FirstName,'') + ' ' + isnull(us.LastName,'') + '-' + isnull(us.Title,'') 
			   END AS NameTitle,
		       isnull(us.FirstName,'') + ' ' + isnull(us.LastName,'') as Name,
		       isnull(us.Title,'') as Title
		FROM tCompanyMedia cm (nolock) inner join tCompany co (nolock) on cm.VendorKey = co.CompanyKey
		inner join tUser us (nolock) on co.CompanyKey = us.CompanyKey
		WHERE us.Active = 1
		AND CompanyMediaKey = @CompanyMediaKey

	RETURN 1
GO
