USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetForReportLayout]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetForReportLayout]
	@InvoiceKey int
AS

/*
|| When      Who Rel      What
|| 04/06/10  MFT 10.5.2.1 Created for new Invoice report from the Layout Designer
|| 05/25/10  MFT 10.5.3.0 Added tProject
|| 08/19/10  MFT 10.5.3.4 Added tProject for header fields, NULLed TotalAmount on summary lines, InvoiceOrder in ORDER BY
|| 08/24/10  MFT 10.5.3.4 Added AEName
|| 10/21/10  MFT 10.5.3.7 Suppressed LineProjectDescription & LineProjectNumber for all but LineLevel = 1, Added tCampaign & cm tables & fields
|| 10/25/10  MFT 10.5.3.7 Added tInvoiceSummary subqueries for Labor and Expense amounts on the line
|| 11/15/10  MFT 10.5.3.8 Wrapped RetainerAmount & AmountReceived in ISNULL
|| 11/19/10  MFT 10.5.3.8 Allowed LineProjectDescription & LineProjectNumber for LineLevel = 0 (LineLevel < 2), Added Client AM (clam)
|| 12/03/10  MFT 10.5.3.8 Added tUser as bc & Title as BillingContactTitle, ISNULL on DisplayOption
|| 12/10/10  MFT 10.5.3.9 Corrected get to account for split billing
|| 12/13/10  MFT 10.5.3.9 Added percentage split and SUM/GROUP BY to tax get
|| 01/06/11  MFT 10.5.3.9 Suppressed Quantity and UnitAmount with the same LineType rule as TotalAmount
|| 01/18/11  MFT 10.5.4.0 Made Taxable & Taxable2 display "*"
|| 01/26/11  MFT 10.5.4.0 Setup(!) custom field support
|| 03/16/11  MFT 10.5.4.1 Changed NULL reference tests to check for 0 key on ISNULL as this seems to be possible in some foreign keys
|| 06/07/11  GHL 10.5.4.5 Added logic for company address from the GL company
|| 06/08/11  GHL 10.5.4.5 Added CompanyName/Phone/Fax from Company OR GL Company
|| 08/17/11  MFT 10.5.4.7 Put LineProjectNumber & LineProjectDescription into main select to test for header.CampaignKey (119116)
|| 10/21/11  MFT 10.5.4.9 Added RetainerAmountSales and RetainerAmountTaxes
|| 12/20/11  MFT 10.5.5.1 Added TaskID to line
|| 02/14/12  MFT 10.5.5.2 Added AEEmail
|| 03/21/12  MFT 10.5.5.4 (137257) Added Other Invoice data
|| 04/27/12  MFT 10.5.5.5 Added @PreviousBalance
|| 06/21/12  MFT 10.5.5.7 Removed @PreviousBalance, adjusted calculation to account for AdvanceBill
|| 06/25/12  MFT 10.5.5.7 Added @BalanceForward
|| 07/06/12  MFT 10.5.5.7 Wrapped RetainerAmount & AmountReceived in ISNULL
|| 07/09/12  MFT 10.5.5.7 Calculated @OtherInvoicePaymentsReceived by @InvoiceDate; corrected AllInvoicesOpenAmount calculation
|| 07/10/12  GHL 10.5.5.8 (148091) Added BillingName
|| 07/16/12  MFT 10.5.5.8 Made Office Address the primary address
|| 08/13/12  MFT 10.5.5.8 Added logic to get @PreviousInvoiceKey and @LastInvoicePaymentsReceived, etc.
|| 09/25/12  MFT 10.5.6.0 Added ClientDivisionName and ClientProductName
|| 03/12/13  MFT 10.5.6.7 Added ParentCompany
|| 04/01/13  MFT 10.5.6.7 Added HeaderClientDivision and HeaderClientProduct
|| 08/08/13  MFT 10.5.7.1 Added EINNumber
|| 08/15/13  MFT 10.5.7.1 Added ClientEINNumber
|| 08/16/13  MFT 10.5.7.1 Added StateEINNumber
|| 07/16/14  WDF 10.5.8.2 If GLCompany, use GL EINNumber
|| 03/17/15  MFT 10.5.9.0 (238426) Added @tPreviousInvoiceTasks and PrevAmountBilled, TotalAmountBilled
|| 03/23/15  MFT 10.5.9.0 (238426) Added ProjectKey to the line
|| 03/24/15  MFT 10.5.9.0 (238426) Added PrevAmountBilledTotal, TotalAmountBilledTotal to header
*/

DECLARE
	@ParentInvoiceKey int,
	@PercentageSplit decimal(24, 4),
	@CampaignKey int,
	@ClientKey int,
	@OtherInvoicesAmountBilled money,
	@OtherInvoicePaymentsReceived money,
	@LastInvoicePaymentsReceived money,
	@OtherInvoicesOpenAmount money,
	@InvoiceDate datetime,
	@InvoiceNumber varchar(35),
	@BalanceForward money,
	@PreviousInvoiceKey int,
	@StartDate datetime
DECLARE @tPreviousInvoiceTasks table (TaskKey int, TotalAmount money)

SELECT
	@ParentInvoiceKey = ISNULL(ParentInvoiceKey, @InvoiceKey),
	@PercentageSplit = ISNULL(PercentageSplit, 100),
	@CampaignKey = ISNULL(CampaignKey, 0),
	@ClientKey = ClientKey,
	@InvoiceDate = InvoiceDate,
	@InvoiceNumber = InvoiceNumber,
	@OtherInvoicesAmountBilled = 0,
	@OtherInvoicePaymentsReceived = 0,
	@LastInvoicePaymentsReceived = 0,
	@OtherInvoicesOpenAmount = 0,
	@BalanceForward = 0
FROM tInvoice (nolock)
WHERE InvoiceKey = @InvoiceKey

INSERT INTO @tPreviousInvoiceTasks
SELECT il.TaskKey, SUM(il.TotalAmount)
FROM
	tInvoice i (nolock)
	INNER JOIN tInvoiceLine il (nolock) ON i.InvoiceKey = il.InvoiceKey
WHERE
	ISNULL(CampaignKey, 0) = @CampaignKey AND
	ClientKey = @ClientKey AND
	(
		InvoiceDate < @InvoiceDate OR
		(
			InvoiceDate = @InvoiceDate AND
			InvoiceNumber < @InvoiceNumber
		)
	)
GROUP BY
	il.TaskKey

SELECT TOP 1
	@PreviousInvoiceKey = InvoiceKey,
	@StartDate = ISNULL(InvoiceDate, '1900-01-01-')
FROM
	tInvoice nolock
WHERE
	ClientKey = @ClientKey AND
	PostingDate <= @InvoiceDate AND
	ISNULL(CampaignKey, 0) = @CampaignKey AND
	(
			InvoiceDate < @InvoiceDate OR
			(
				InvoiceDate = @InvoiceDate AND
				InvoiceNumber < @InvoiceNumber
			)
	)
ORDER BY
	InvoiceDate DESC,
	InvoiceNumber DESC

SELECT
	@LastInvoicePaymentsReceived = ISNULL(SUM(ca.Amount), 0)
FROM
	tCheckAppl ca (nolock)
	INNER JOIN tCheck c (nolock) ON ca.CheckKey = c.CheckKey
	INNER JOIN tInvoice i (nolock) ON ca.InvoiceKey = i.InvoiceKey
WHERE
	c.ClientKey = @ClientKey AND
	c.PostingDate <= @InvoiceDate AND
	c.PostingDate >= @StartDate AND
	ISNULL(CampaignKey, 0) = @CampaignKey

SELECT
	@OtherInvoicePaymentsReceived = ISNULL(SUM(ca.Amount), 0)
FROM
	tCheckAppl ca (nolock)
	INNER JOIN tCheck c (nolock) ON ca.CheckKey = c.CheckKey
	INNER JOIN tInvoice i (nolock) ON ca.InvoiceKey = i.InvoiceKey
WHERE
	c.ClientKey = @ClientKey AND
	c.PostingDate <= @InvoiceDate AND
	ISNULL(CampaignKey, 0) = @CampaignKey AND
	(
		InvoiceDate < @InvoiceDate OR
		(
			InvoiceDate = @InvoiceDate AND
			InvoiceNumber < @InvoiceNumber
		)
	)

SELECT
	@OtherInvoicesAmountBilled = ISNULL(SUM(CASE AdvanceBill WHEN 1 THEN 0 ELSE InvoiceTotalAmount END), 0),
	@OtherInvoicesOpenAmount = @OtherInvoicesAmountBilled - @OtherInvoicePaymentsReceived + @LastInvoicePaymentsReceived,
	@BalanceForward = @OtherInvoicesAmountBilled - @OtherInvoicePaymentsReceived
FROM
	tInvoice (nolock)
WHERE
	ISNULL(CampaignKey, 0) = @CampaignKey AND
	ClientKey = @ClientKey AND
	(
		InvoiceDate < @InvoiceDate OR
		(
			InvoiceDate = @InvoiceDate AND
			InvoiceNumber < @InvoiceNumber
		)
	)

SELECT
	*,
	CASE WHEN (lines.LineLevel = 1 AND ISNULL(header.CampaignKey, 0) > 0) OR lines.LineLevel = 0 THEN lines.ProjectNumber ELSE '' END AS LineProjectNumber,
	CASE WHEN (lines.LineLevel = 1 AND ISNULL(header.CampaignKey, 0) > 0) OR lines.LineLevel = 0 THEN lines.ProjectDescription ELSE '' END AS LineProjectDescription
FROM
(
	SELECT
		-- Company Address 1) on Office 2) on GLCompany 3) Default Address on Company
		CASE WHEN oa.AddressKey IS NOT NULL THEN oa.Address1 ELSE CASE WHEN glca.AddressKey IS NOT NULL THEN glca.Address1 ELSE ca.Address1 END END AS CAddress1,
		CASE WHEN oa.AddressKey IS NOT NULL THEN oa.Address2 ELSE CASE WHEN glca.AddressKey IS NOT NULL THEN glca.Address2 ELSE ca.Address2 END END AS CAddress2,
		CASE WHEN oa.AddressKey IS NOT NULL THEN oa.Address3 ELSE CASE WHEN glca.AddressKey IS NOT NULL THEN glca.Address3 ELSE ca.Address3 END END AS CAddress3,
		CASE WHEN oa.AddressKey IS NOT NULL THEN oa.City ELSE CASE WHEN glca.AddressKey IS NOT NULL THEN glca.City ELSE ca.City END END AS CCity,
		CASE WHEN oa.AddressKey IS NOT NULL THEN oa.State ELSE CASE WHEN glca.AddressKey IS NOT NULL THEN glca.State ELSE ca.State END END AS CState,
		CASE WHEN oa.AddressKey IS NOT NULL THEN oa.PostalCode ELSE CASE WHEN glca.AddressKey IS NOT NULL THEN glca.PostalCode ELSE ca.PostalCode END END AS CPostalCode,
		CASE WHEN oa.AddressKey IS NOT NULL THEN oa.Country ELSE CASE WHEN glca.AddressKey IS NOT NULL THEN glca.Country ELSE ca.Country END END AS CCountry,
		CASE WHEN glc.GLCompanyKey IS NOT NULL THEN glc.PrintedName ELSE c.CompanyName END AS CompanyName,
		CASE WHEN glc.GLCompanyKey IS NOT NULL THEN glc.Phone ELSE c.Phone END AS Phone,
		CASE WHEN glc.GLCompanyKey IS NOT NULL THEN glc.Fax ELSE c.Fax END AS Fax,
		CASE WHEN glc.GLCompanyKey IS NOT NULL THEN glc.EINNumber ELSE c.EINNumber END AS EINNumber,
		c.StateEINNumber,
		ISNULL(cl.BillingName, cl.CompanyName) AS ClientName,
		cl.CustomerID,
		cl.EINNumber AS ClientEINNumber,
		pc.CompanyName AS ParentCompany,
		-- Billing Address 1) On Invoice, 2) on Client Billing Address, 3) on Client Default Address
		CASE
			WHEN ISNULL(i.AddressKey, 0) > 0 THEN ia.Address1
			ELSE
				CASE
					WHEN ISNULL(cl.BillingAddressKey, 0) > 0 THEN clba.Address1
					ELSE clda.Address1
				END
		END AS BAddress1,
		CASE
			WHEN ISNULL(i.AddressKey, 0) > 0 THEN ia.Address2
			ELSE
				CASE
					WHEN ISNULL(cl.BillingAddressKey, 0) > 0 THEN clba.Address2
					ELSE clda.Address2
				END
		END AS BAddress2,
		CASE
			WHEN ISNULL(i.AddressKey, 0) > 0 THEN ia.Address3
			ELSE
			CASE
				WHEN ISNULL(cl.BillingAddressKey, 0) > 0 THEN clba.Address3
				ELSE clda.Address3
			END
		END AS BAddress3,
		CASE
			WHEN ISNULL(i.AddressKey, 0) > 0 THEN ia.City
			ELSE
				CASE
					WHEN ISNULL(cl.BillingAddressKey, 0) > 0 THEN clba.City
					ELSE clda.City
				END
		END AS BCity,
		CASE
			WHEN ISNULL(i.AddressKey, 0) > 0 THEN ia.State
			ELSE
				CASE
					WHEN ISNULL(cl.BillingAddressKey, 0) > 0 THEN clba.State
					ELSE clda.State
				END
		END AS BState,
		CASE
			WHEN ISNULL(i.AddressKey, 0) > 0 THEN ia.PostalCode
			ELSE
				CASE 
					WHEN ISNULL(cl.BillingAddressKey, 0) > 0 THEN clba.PostalCode
					ELSE clda.PostalCode
				END
		END AS BPostalCode,
		CASE
			WHEN ISNULL(i.AddressKey, 0) > 0 THEN ia.Country
			ELSE
				CASE 
					WHEN ISNULL(cl.BillingAddressKey, 0) > 0 THEN clba.Country
					ELSE clda.Country
				END
		END AS BCountry,
		i.ContactName AS BillingContact,
		bc.Title AS BillingContactTitle,
		i.AdvanceBill,
		i.InvoiceNumber,
		i.InvoiceDate,
		i.DueDate,
		i.PostingDate,
		ISNULL(i.RetainerAmount, 0) AS RetainerAmount,
		ISNULL(i.RetainerAmount, 0) - ISNULL((SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (nolock) WHERE iabt.InvoiceKey = i.InvoiceKey), 0) AS RetainerAmountSales,
		ISNULL((SELECT sum(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (nolock) WHERE iabt.InvoiceKey = i.InvoiceKey), 0) AS RetainerAmountTaxes,
		i.WriteoffAmount,
		i.DiscountAmount,
		i.SalesTaxAmount AS SalesTaxAmount_ORIG,
		(SELECT SUM(it.SalesTaxAmount) * (@PercentageSplit/100) FROM tInvoiceLine il (nolock) INNER JOIN tInvoiceTax it (nolock) ON il.InvoiceLineKey = it.InvoiceLineKey WHERE il.InvoiceKey = @ParentInvoiceKey) AS SalesTaxAmount,
		i.SalesTax1Amount AS SalesTax1Amount_ORIG,
		(SELECT SUM(it.SalesTaxAmount) * (@PercentageSplit/100) FROM tInvoiceLine il (nolock) INNER JOIN tInvoiceTax it (nolock) ON il.InvoiceLineKey = it.InvoiceLineKey WHERE it.Type = 1 AND il.InvoiceKey = @ParentInvoiceKey) AS SalesTax1Amount,
		st1.SalesTaxID,
		st1.SalesTaxName,
		st1.Description AS SalesTaxDescription,
		st1.TaxRate,
		i.SalesTax2Amount AS SalesTax2Amount_ORIG,
		(SELECT SUM(it.SalesTaxAmount) * (@PercentageSplit/100) FROM tInvoiceLine il (nolock) INNER JOIN tInvoiceTax it (nolock) ON il.InvoiceLineKey = it.InvoiceLineKey WHERE it.Type = 2 AND il.InvoiceKey = @ParentInvoiceKey) AS SalesTax2Amount,
		st2.SalesTaxID AS SalesTax2ID,
		st2.SalesTaxName AS SalesTax2Name,
		st2.Description AS SalesTax2Description,
		st2.TaxRate AS Tax2Rate,
		i.TotalNonTaxAmount,
		i.InvoiceTotalAmount,
		ISNULL(i.AmountReceived, 0) AS AmountReceived,
		ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.DiscountAmount, 0) - ISNULL(i.RetainerAmount, 0) AS BilledAmount,
		ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.DiscountAmount, 0) - ISNULL(i.RetainerAmount, 0) - ISNULL(i.AmountReceived, 0) AS OpenAmount,
		i.HeaderComment,
		i.ApprovedDate,
		i.ApprovedByKey,
		i.ApprovalComments,
		i.PercentageSplit,
		p.ProjectName AS HeaderProjectName,
		p.ProjectNumber AS HeaderProjectNumber,
		p.ClientProjectNumber AS HeaderClientProjectNumber,
		cd.DivisionName AS HeaderClientDivision,
		clp.ProductName AS HeaderClientProduct,
		p.Description AS HeaderProjectDescription,
		CASE WHEN ISNULL(i.ProjectKey, 0) = 0 THEN CASE WHEN ISNULL(cp.CampaignKey, 0) = 0 THEN clam.FirstName + ' ' + clam.LastName ELSE cm.FirstName + ' ' + cm.LastName END ELSE am.FirstName + ' ' + am.LastName END AS AEName,
		CASE WHEN ISNULL(i.ProjectKey, 0) = 0 THEN CASE WHEN ISNULL(cp.CampaignKey, 0) = 0 THEN clam.Email ELSE cm.Email END ELSE am.Email END AS AEEmail,
		cp.CampaignKey,
		cp.CampaignID,
		cp.CampaignName,
		cp.Description AS CampaignDesc,
		cp.Objective AS CampaignObjective,
		cm.FirstName + ' ' + cm.LastName AS CMName,
		pt.TermsDescription,
		@OtherInvoicesAmountBilled AS OtherInvoicesAmountBilled,
		@LastInvoicePaymentsReceived AS OtherInvoicePaymentsReceived,
		@OtherInvoicesOpenAmount AS OtherInvoicesOpenAmount,
		@BalanceForward AS BalanceForward,
		ISNULL(i.InvoiceTotalAmount, 0) + @BalanceForward AS AllInvoicesOpenAmount,
		(SELECT SUM(pit.TotalAmount) FROM @tPreviousInvoiceTasks pit INNER JOIN tInvoiceLine il (nolock) ON pit.TaskKey = il.TaskKey WHERE il.InvoiceKey = @InvoiceKey) AS PrevAmountBilledTotal,
		(SELECT SUM(pit.TotalAmount) FROM @tPreviousInvoiceTasks pit INNER JOIN tInvoiceLine il (nolock) ON pit.TaskKey = il.TaskKey WHERE il.InvoiceKey = @InvoiceKey) + i.InvoiceTotalAmount AS TotalAmountBilledTotal,
		cfh.*
	FROM
		tInvoice i (nolock)
		INNER JOIN tCompany c (nolock)
			ON i.CompanyKey = c.CompanyKey
		INNER JOIN tCompany cl (nolock)
			ON i.ClientKey = cl.CompanyKey
		LEFT JOIN tCompany pc (nolock)
			ON cl.ParentCompanyKey = pc.CompanyKey
		LEFT JOIN tProject p (nolock)
			ON i.ProjectKey = p.ProjectKey
		LEFT JOIN tClientDivision cd (nolock)
			ON p.ClientDivisionKey = cd.ClientDivisionKey
		LEFT JOIN tClientProduct clp (nolock)
			ON p.ClientProductKey = clp.ClientProductKey
		LEFT JOIN tCampaign cp (nolock)
			ON i.CampaignKey = cp.CampaignKey
		LEFT JOIN tUser am (nolock)
			ON p.AccountManager = am.UserKey
		LEFT JOIN tUser cm (nolock)
			ON cp.AEKey = cm.UserKey
		LEFT JOIN tUser clam (nolock)
			ON cl.AccountManagerKey = clam.UserKey
		LEFT JOIN tAddress ca (nolock)
			ON c.DefaultAddressKey = ca.AddressKey
		LEFT JOIN tAddress ia (nolock)
			ON i.AddressKey = ia.AddressKey
		LEFT JOIN tAddress clba (nolock)
			ON cl.BillingAddressKey = clba.AddressKey
		LEFT JOIN tAddress clda (nolock)
			ON cl.DefaultAddressKey = clda.AddressKey
		LEFT JOIN tGLCompany glc (nolock)
			ON i.GLCompanyKey = glc.GLCompanyKey
		LEFT JOIN tAddress glca (nolock)
			ON glc.AddressKey = glca.AddressKey
		LEFT JOIN tOffice o (nolock)
			ON i.OfficeKey = o.OfficeKey
		LEFT JOIN tAddress oa (nolock)
			ON o.AddressKey = oa.AddressKey
		LEFT JOIN tPaymentTerms pt (nolock)
			ON i.TermsKey = pt.PaymentTermsKey
		LEFT JOIN tSalesTax st1 (nolock)
			ON i.SalesTaxKey = st1.SalesTaxKey
		LEFT JOIN tSalesTax st2 (nolock)
			ON i.SalesTax2Key = st2.SalesTaxKey
		LEFT JOIN tUser bc (nolock)
			ON i.PrimaryContactKey = bc.UserKey
		LEFT JOIN #cfHeader cfh (nolock)
			ON p.CustomFieldKey = cfh.CustomFieldKey
	WHERE
		i.InvoiceKey = @InvoiceKey
) header,
(
	SELECT
		il.InvoiceLineKey,
		il.LineType,
		il.LineSubject,
		il.LineDescription,
		il.BillFrom,
		il.BilledTimeAmount,
		il.BilledExpenseAmount,
		il.ProjectKey,
		CASE WHEN il.LineType = 1 AND ISNULL(il.Quantity, 0) = 0 THEN NULL ELSE il.Quantity END AS Quantity,
		CASE WHEN il.LineType = 1 AND ISNULL(il.UnitAmount, 0) = 0 THEN NULL ELSE il.UnitAmount END AS UnitAmount,
		CASE WHEN il.LineType = 1 AND ISNULL(il.TotalAmount, 0) = 0 THEN NULL ELSE il.TotalAmount * (@PercentageSplit/100) END AS TotalAmount,
		il.PostSalesUsingDetail,
		il.InvoiceOrder,
		il.DisplayOrder,
		CASE il.Taxable WHEN 1 THEN '*' ELSE '' END AS Taxable,
		CASE il.Taxable2 WHEN 1 THEN '*' ELSE '' END AS Taxable2,
		il.LineLevel,
		il.SalesTaxAmount * (@PercentageSplit/100) AS LineSalesTaxAmount,
		il.SalesTax1Amount * (@PercentageSplit/100) AS LineSalesTax1Amount,
		il.SalesTax2Amount * (@PercentageSplit/100) AS LineSalesTax2Amount,
		ISNULL(il.DisplayOption, CASE il.LineType WHEN 1 THEN 2 WHEN 2 THEN 1 END) AS DisplayOption,
		pl.ProjectName AS LineProjectName,
		pl.ProjectNumber,
		pl.Description AS ProjectDescription,
		pl.ClientProjectNumber AS LineClientProjectNumber,
		t.TaskID,
		t.TaskKey,
		cd.DivisionName,
		cp.ProductName,
		ise.ExpenseAmount * (@PercentageSplit/100) AS ExpenseAmount,
		isl.LaborAmount * (@PercentageSplit/100) AS LaborAmount,
		CASE WHEN il.LineType = 1 AND ISNULL(il.TotalAmount, 0) = 0 THEN NULL ELSE ISNULL(pit.TotalAmount, 0) END AS PrevAmountBilled,
		(ISNULL(pit.TotalAmount, 0) + (CASE WHEN il.LineType = 1 AND ISNULL(il.TotalAmount, 0) = 0 THEN CASE WHEN il.LineType = 1 THEN NULL ELSE 0 END ELSE il.TotalAmount * (@PercentageSplit/100) END)) AS TotalAmountBilled
	FROM
		tInvoiceLine il (nolock)
		LEFT JOIN (SELECT InvoiceLineKey, SUM(Amount) AS ExpenseAmount FROM tInvoiceSummary (nolock) WHERE Entity = 'tItem' GROUP BY InvoiceLineKey) ise
			ON il.InvoiceLineKey = ise.InvoiceLineKey
		LEFT JOIN (SELECT InvoiceLineKey, SUM(Amount) AS LaborAmount FROM tInvoiceSummary (nolock) WHERE Entity = 'tService' GROUP BY InvoiceLineKey) isl
			ON il.InvoiceLineKey = isl.InvoiceLineKey
		LEFT JOIN tProject pl (nolock)
			ON il.ProjectKey = pl.ProjectKey
		LEFT JOIN tTask t (nolock)
			ON il.TaskKey = t.TaskKey
		LEFT JOIN tClientDivision cd (nolock)
			ON pl.ClientDivisionKey = cd.ClientDivisionKey
		LEFT JOIN tClientProduct cp (nolock)
			ON pl.ClientProductKey = cp.ClientProductKey
		LEFT JOIN @tPreviousInvoiceTasks pit
			ON il.TaskKey = pit.TaskKey
	WHERE
		il.InvoiceKey = @ParentInvoiceKey
) lines
ORDER BY
	InvoiceOrder

--Other sales taxes
SELECT
	il.InvoiceLineKey,
	st.SalesTaxName AS OtherSalesTaxName,
	st.SalesTaxID AS OtherSalesTaxID,
	st.TaxRate AS OtherTaxRate,
	st.Description AS OtherSalesTaxDescription,
	st.PiggyBackTax AS OtherPiggyBackTax,
	SUM(it.SalesTaxAmount * (@PercentageSplit/100)) AS OtherSalesTaxAmount,
	it.Type
FROM
	tInvoice i (nolock)
	INNER JOIN tInvoiceLine il (nolock)
		ON i.InvoiceKey = il.InvoiceKey
	INNER JOIN tInvoiceTax it (nolock)
		ON il.InvoiceLineKey = it.InvoiceLineKey
	INNER JOIN tSalesTax st (nolock)
		ON it.SalesTaxKey = st.SalesTaxKey
WHERE
	i.InvoiceKey = @ParentInvoiceKey
GROUP BY
	il.InvoiceLineKey,
	st.SalesTaxName,
	st.SalesTaxID,
	st.TaxRate,
	st.Description,
	st.PiggyBackTax,
	it.Type
ORDER BY
	it.Type
GO
