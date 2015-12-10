USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContactGetList]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContactGetList]

	@CompanyMediaKey int

AS --Encrypt

/*
|| When      Who Rel       What
|| 10/11/10  MFT 10.5.3.6  Added UserName to support SendNotification
*/

SELECT
	us.UserKey,
	LTRIM(RTRIM(ISNULL(FirstName,'') + ' ' + ISNULL(LastName,''))) AS UserName,
	CASE 
		WHEN us.Title is null THEN isnull(us.FirstName,'') + ' ' + isnull(us.LastName,'')
		ELSE isnull(us.FirstName,'') + ' ' + isnull(us.LastName,'') + '-' + isnull(us.Title,'') 
		END AS NameTitle,
	us.FirstName + ' ' + us.LastName as Name,
	us.Title
FROM tCompanyMediaContact mc (nolock) inner join tUser us (nolock) on mc.UserKey = us.UserKey 
WHERE CompanyMediaKey = @CompanyMediaKey

RETURN 1
GO
