USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetBySearchTerm]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetBySearchTerm]
	@CompanyKey int,
	@SearchTerm varchar(100)

AS --Encrypted

/*  
|| When       Who Rel      What
|| 05/28/2010 MFT 10.5.3.0 Created
|| 04/14/2011 RLB 10.5.4.3 (108853) Need to set search term to upper to match where clause
*/


SELECT	@SearchTerm = UPPER(@SearchTerm)

SELECT
	0 AS ASC_Selected,
	UserKey,
	ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') AS FormattedName,
	UserCompanyName AS CompanyName,
	Title,
	Phone1,
	Cell,
	Email,
	Active,
	'Active' as ActiveStatus,
	OwnerKey,
	CMFolderKey
FROM
	tUser (nolock)
WHERE
	OwnerCompanyKey = @CompanyKey AND
	Active = 1 AND
	ISNULL(CompanyKey, 0) = 0 AND
	(
		UPPER(FirstName) LIKE '%' + @SearchTerm + '%' OR
		UPPER(LastName) LIKE '%' + @SearchTerm + '%' OR
		UPPER(UserCompanyName) LIKE '%' + @SearchTerm + '%'
	)
GO
