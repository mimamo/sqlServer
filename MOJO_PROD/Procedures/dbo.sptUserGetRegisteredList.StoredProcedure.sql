USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetRegisteredList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetRegisteredList]

	(
		@CompanyKey int
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 8/13/07   CRG 8.5     (9833) Added ExpenseApprover
|| 8/22/07   CRG 8.5     (9833) Added VendorID & Name
*/

	SELECT	u.UserKey,
			u.FirstName,
			u.LastName,
			u.FirstName + ' ' + u.LastName as UserName,
			u.ExpenseApprover,
			c.VendorID,
			c.CompanyName as VendorName,
			u.TimeApprover
	FROM	tUser u (nolock)
	LEFT JOIN tCompany c (nolock) ON u.VendorKey = c.CompanyKey
	WHERE	ISNULL(u.OwnerCompanyKey, u.CompanyKey) = @CompanyKey 
	AND		LEN(u.UserID) > 0 
	AND		u.Active = 1
	AND		u.ClientVendorLogin = 0
	ORDER BY u.FirstName, u.LastName
GO
