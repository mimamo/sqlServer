USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserContactSearch]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserContactSearch]
	@CompanyKey int,
	@SearchTerm varchar(500),
	@ContactCompanyKey int = NULL
AS --Encrypt

/*
|| When      Who Rel      What
|| 12/12/07  CRG 8.5      Created for report email functionality
|| 5/15/08   GWG 10		  Allowed no email because this lookup is used in other areas now
|| 8/28/08   CRG 10.5.0.0 Added optional ContactCompanyKey parameter
|| 8/29/08   GWG 10.01    Added Hourly rate for adding to the user setup.
|| 6/12/09   GWG 10.5	  Changed the search so a contact not tied to a company would be found.
|| 12/20/10  GHL 10.539   Added subscribe fields
|| 04/29/13  RLB 10.567   (176135) Added Default Service on Contacts
*/

	SELECT	@SearchTerm = UPPER(@SearchTerm)

	SELECT	u.UserKey,
			ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName,
			SUBSTRING(ISNULL(u.FirstName, ''),1,1) + SUBSTRING(ISNULL(u.MiddleName, ''),1,1) + SUBSTRING(ISNULL(u.LastName, ''),1,1) AS Initials,			
			c.CompanyName,
			u.Phone1,
			u.Email,
			u.HourlyRate,
			isnull(u.SubscribeDiary, 0) AS SubscribeDiary,
			isnull(u.SubscribeToDo, 0) AS SubscribeToDo, 
			u.ClientVendorLogin,
			u.DefaultServiceKey,
			s.Description AS ServiceDescription,
			0 AS ASC_Selected
	FROM	tUser u (nolock)
	LEFT OUTER JOIN tCompany c (nolock) on u.CompanyKey = c.CompanyKey
	LEFT OUTER JOIN tService s (nolock) on u.DefaultServiceKey = s.ServiceKey
	WHERE	u.Active = 1
	AND		(c.Active is null OR c.Active = 1)
	AND		u.OwnerCompanyKey = @CompanyKey
	AND		(c.CompanyKey = @ContactCompanyKey OR @ContactCompanyKey IS NULL)
	AND		(UPPER(u.FirstName) LIKE '%' + @SearchTerm + '%'
			OR UPPER(u.LastName) LIKE '%' + @SearchTerm + '%'
			OR UPPER(c.CompanyName) LIKE '%' + @SearchTerm + '%')
	ORDER BY c.CompanyName, u.FirstName, u.LastName
GO
