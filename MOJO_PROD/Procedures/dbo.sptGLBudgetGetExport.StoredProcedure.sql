USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetGetExport]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetGetExport]
		@CompanyKey int
AS --Encrypt

/*
|| When     Who Rel      What
|| 01/26/12 MFT 10.5.5.2 Created
*/

SELECT
	b.BudgetName,
	b.Active,
	gla.AccountNumber,
	c.CustomerID,
	ISNULL(Month1, 0) AS Month1,
	ISNULL(Month2, 0) AS Month2,
	ISNULL(Month3, 0) AS Month3,
	ISNULL(Month4, 0) AS Month4,
	ISNULL(Month5, 0) AS Month5,
	ISNULL(Month6, 0) AS Month6,
	ISNULL(Month7, 0) AS Month7,
	ISNULL(Month8, 0) AS Month8,
	ISNULL(Month9, 0) AS Month9,
	ISNULL(Month10, 0) AS Month10,
	ISNULL(Month11, 0) AS Month11,
	ISNULL(Month12, 0) AS Month12,
	cl.ClassID,
	glc.GLCompanyName,
	o.OfficeName,
	d.DepartmentName
FROM
	tGLBudget b (nolock)
	LEFT JOIN tGLBudgetDetail bd (nolock) ON b.GLBudgetKey = bd.GLBudgetKey
	LEFT JOIN tGLAccount gla (nolock) ON bd.GLAccountKey = gla.GLAccountKey
	LEFT JOIN tClass cl (nolock) ON bd.ClassKey = cl.ClassKey
	LEFT JOIN tCompany c (nolock) ON bd.ClientKey = c.CompanyKey
	LEFT JOIN tGLCompany glc (nolock) ON bd.GLCompanyKey = glc.GLCompanyKey
	LEFT JOIN tOffice o (nolock) ON bd.OfficeKey = o.OfficeKey
	LEFT JOIN tDepartment d (nolock) ON bd.DepartmentKey = d.DepartmentKey
WHERE
	b.CompanyKey = @CompanyKey
GO
