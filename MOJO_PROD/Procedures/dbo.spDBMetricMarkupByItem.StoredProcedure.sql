USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricMarkupByItem]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricMarkupByItem]
	@CompanyKey int,
	@StartDate datetime,
	@EndDate datetime,
	@GLCompanyKey int,
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 08/17/12  MFT 10.5.5.9 Created
|| 03/04/14  GHL 10.5.7.8 Converted to home currecny
*/

------------------------------------------------------------
--GL Company restrictions
DECLARE @RestrictToGLCompany tinyint
DECLARE @tGLCompanies table (GLCompanyKey int)
SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey

IF ISNULL(@GLCompanyKey, 0) > 0
	INSERT INTO @tGLCompanies VALUES(@GLCompanyKey)
ELSE
	BEGIN --No @GLCompanyKey passed in
		IF @RestrictToGLCompany = 0
			BEGIN --@RestrictToGLCompany = 0
			 	--All GLCompanyKeys + 0 to get NULLs
				INSERT INTO @tGLCompanies VALUES(0)
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tGLCompany (nolock)
					WHERE CompanyKey = @CompanyKey
			END --@RestrictToGLCompany = 0
		ELSE
			BEGIN --@RestrictToGLCompany = 1
				 --Only GLCompanyKeys @UserKey has access to
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tUserGLCompanyAccess (nolock)
					WHERE UserKey = @UserKey
			END --@RestrictToGLCompany = 1
	END --No @GLCompanyKey passed in
--GL Company restrictions
------------------------------------------------------------

DECLARE @ItemAvgs table
(
	ItemKey int IDENTITY(1,1),
	ItemName varchar(200),
	Markup int
)

INSERT INTO @ItemAvgs
(
	ItemName,
	Markup
)
SELECT
	i.ItemName,
	AVG((
	(BillableCost * isnull(vd.PExchangeRate, 1) - TotalCost * isnull(v.ExchangeRate, 1) ) / 
	TotalCost * isnull(v.ExchangeRate, 1)
	) * 100) AS Markup
FROM
	tVoucherDetail vd (nolock)
	INNER JOIN tVoucher v (nolock) ON v.VoucherKey = vd.VoucherKey
	INNER JOIN @tGLCompanies glc ON ISNULL(v.GLCompanyKey, 0) = glc.GLCompanyKey
	INNER JOIN tItem i (nolock) ON vd.ItemKey = i.ItemKey
	INNER JOIN tProject p (nolock) ON vd.ProjectKey = p.ProjectKey
WHERE
	vd.BillableCost > 0 AND
	vd.TotalCost > 0 AND
	p.NonBillable = 0 AND
	p.CompanyKey = @CompanyKey AND
	v.InvoiceDate >= ISNULL(@StartDate, '1/1/1900') AND
	v.InvoiceDate <= ISNULL(@EndDate, DATEADD(yyyy, 100, GETDATE())) AND
	v.ExchangeRate <> 0
GROUP BY
	i.ItemName
ORDER BY
	Markup DESC

IF EXISTS(SELECT * FROM @ItemAvgs)
	BEGIN
		INSERT INTO @ItemAvgs (ItemName, Markup)
		SELECT 'Overall Average', 
		Avg((
		(BillableCost * isnull(vd.PExchangeRate, 1) - TotalCost * isnull(v.ExchangeRate, 1) ) / 
		TotalCost * isnull(v.ExchangeRate, 1)
		) * 100) AS Markup
		FROM
			tVoucherDetail vd (nolock)
			INNER JOIN tVoucher v (nolock) ON v.VoucherKey = vd.VoucherKey
			INNER JOIN @tGLCompanies glc ON ISNULL(v.GLCompanyKey, 0) = glc.GLCompanyKey
			INNER JOIN tItem i (nolock) ON vd.ItemKey = i.ItemKey
			INNER JOIN tProject p (nolock) ON vd.ProjectKey = p.ProjectKey
		WHERE
			vd.BillableCost > 0 AND
			vd.TotalCost > 0 AND
			p.NonBillable = 0 AND
			p.CompanyKey = @CompanyKey AND
			v.InvoiceDate >= ISNULL(@StartDate, '1/1/1900') AND
			v.InvoiceDate <= ISNULL(@EndDate, DATEADD(yyyy, 25, GETDATE())) AND
			v.ExchangeRate <> 0
	END

SELECT * FROM @ItemAvgs ORDER BY ItemKey
GO
