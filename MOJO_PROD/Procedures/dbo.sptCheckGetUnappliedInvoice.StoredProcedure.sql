USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckGetUnappliedInvoice]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckGetUnappliedInvoice]
	@ClientKey int,
	@GLCompanyKey int,
	@UserKey int,
	@CheckKey int = -1,
	@CurrencyID varchar(10) = null
AS --Encrypt

/*
|| When      Who Rel     What
|| 02/23/10  MFT 10.519  Created
|| 03/10/10  MFT 10.520  Added @ClientKey
|| 04/01/10  MFT 10.521  Fixed GLCompany lookup
|| 04/23/10  RLB 10.521  Fixed Availabe Invoice if client was a Parent Company
|| 05/11/10  MFT 10.523  Fixed for all parent/child/sibling relationships
|| 06/07/10  MFT 10.530  Added Order By clause
|| 11/24/10  MFT 10.538  Added tClass & tGLAccount & fields
|| 12/15/10  MFT 10.538  Changed sort from InvoiceNumber to InvoiceDate
|| 04/07/11  MFT 10.543  (108124) fix for this issue
|| 04/05/12  GHL 10.554  setting ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) (instead of = @GLCompanyKey)
||                       following bug reported by Julie Huntley on APP13
|| 09/11/12  MFT 10.559  Checking Alternate Payer
|| 09/20/13  GHL 10.572  Added support for multi currencies
|| 09/27/13  GHL 10.572  (181928) Filter out voided invoices
*/

DECLARE @ParentCompanyKey int

	declare @RestrictToGLCompany tinyint
	
	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

SELECT
	@ParentCompanyKey = cp.ParentCompanyKey
FROM
	tCompany cp (nolock)
WHERE
	cp.CompanyKey = @ClientKey

SELECT DISTINCT
	i.InvoiceKey,
	i.InvoiceNumber,
	i.InvoiceDate,
	ISNULL(InvoiceTotalAmount, 0) - ISNULL(WriteoffAmount, 0) - ISNULL(DiscountAmount, 0) - ISNULL(RetainerAmount, 0) AS TotalAmount,
	ISNULL(InvoiceTotalAmount, 0) - ISNULL(AmountReceived, 0) - ISNULL(WriteoffAmount, 0) - ISNULL(DiscountAmount, 0) - ISNULL(RetainerAmount, 0) AS TotalOpen,
	c.CustomerID,
	c.CompanyName,
	cl.ClassKey,
	cl.ClassID,
	cl.ClassName,
	gl.GLAccountKey,
	gl.AccountNumber,
	gl.AccountName
FROM tInvoice i (nolock)
	INNER JOIN tCompany c (nolock) ON i.ClientKey = c.CompanyKey
	LEFT JOIN tClass cl (nolock) ON i.ClassKey = cl.ClassKey
	LEFT JOIN tGLAccount gl (nolock) ON i.ARAccountKey = gl.GLAccountKey
	LEFT OUTER JOIN tUserGLCompanyAccess gla (nolock) on i.GLCompanyKey = gla.GLCompanyKey
WHERE
	(
		ClientKey = @ClientKey OR --Self
		ClientKey = @ParentCompanyKey OR --Parent
		ClientKey IN
			(
				SELECT
					CompanyKey
				FROM
					tCompany (nolock)
				WHERE
					ParentCompanyKey = @ClientKey OR --Children
					ParentCompanyKey = @ParentCompanyKey --Siblings
			) OR
		i.AlternatePayerKey = @ClientKey --Alternate Payer
	) AND
	CASE WHEN ISNULL(InvoiceTotalAmount, 0) >= 0 THEN
		CASE WHEN AmountReceived < (ISNULL(InvoiceTotalAmount, 0) - ISNULL(WriteoffAmount, 0) - ISNULL(DiscountAmount, 0) - ISNULL(RetainerAmount, 0)) THEN 1 ELSE 0 END
		ELSE CASE WHEN AmountReceived > (ISNULL(InvoiceTotalAmount, 0) - ISNULL(WriteoffAmount, 0) - ISNULL(DiscountAmount, 0) - ISNULL(RetainerAmount, 0)) THEN 1 ELSE 0 END
		END = 1 AND
	InvoiceStatus = 4 AND
	(@RestrictToGLCompany = 0 OR gla.UserKey = @UserKey) AND
	(ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) OR
		 i.GLCompanyKey in (Select TargetGLCompanyKey from tGLCompanyMap (nolock) 
							Where SourceGLCompanyKey = @GLCompanyKey) 
	) AND
	ISNULL(i.CurrencyID, '') = ISNULL(@CurrencyID, '') AND   
	ISNULL(i.VoidInvoiceKey, 0) = 0 AND
	i.InvoiceKey NOT IN
	(
		SELECT
			InvoiceKey
		FROM
			tCheckAppl (nolock)
		WHERE
			CheckKey = @CheckKey AND
			InvoiceKey IS NOT NULL AND
			Prepay = 0
	)
ORDER BY
	c.CustomerID,
	i.InvoiceDate
GO
