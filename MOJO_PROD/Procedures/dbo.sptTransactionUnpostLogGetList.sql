USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTransactionUnpostLogGetList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTransactionUnpostLogGetList]
	@CompanyKey int,
	@Entity varchar(50),
	@ReferenceNumber varchar(100),
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@VendorKey int,
	@ClientKey int
AS

/*
|| When      Who Rel      What
|| 10/9/09   CRG 10.5.1.3 Created for the Unposting History screen
*/

	SELECT	ul.*,
			ub.UserName,
			v.CompanyName AS VendorName,
			c.CompanyName AS ClientName,
			glc.GLCompanyName
	FROM	tTransactionUnpostLog ul (nolock)
	INNER JOIN vUserName ub (nolock) ON ul.UnpostedBy = ub.UserKey --Inner join because UnposedBy cannot be null
	LEFT JOIN tCompany v (nolock) ON ul.VendorKey = v.CompanyKey
	LEFT JOIN tCompany c (nolock) ON ul.ClientKey = c.CompanyKey
	LEFT JOIN tGLCompany glc (nolock) ON ul.GLCompanyKey = glc.GLCompanyKey
	WHERE	ul.CompanyKey = @CompanyKey
	AND		(@Entity IS NULL OR UPPER(ul.Entity) = UPPER(@Entity))
	AND		((ISNULL(UPPER(@ReferenceNumber), '') = '') OR (UPPER(ul.ReferenceNumber) LIKE '%' + ISNULL(UPPER(@ReferenceNumber), '') + '%'))
	AND		((@StartDate IS NULL) OR (@EndDate IS NULL) OR (ul.DateUnposted BETWEEN @StartDate AND DATEADD(day, 1, @EndDate))) --Add 1 day because DateUnposted includes time
	AND		(@VendorKey IS NULL OR ul.VendorKey = @VendorKey)
	AND		(@ClientKey IS NULL OR ul.ClientKey = @ClientKey)
	ORDER BY DateUnposted DESC
GO
