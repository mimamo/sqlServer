USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptSalesTaxAnalysisOld]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptSalesTaxAnalysisOld]
	(
		@CompanyKey int,
		@SalesTaxKey int, 
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@ShowCollected tinyint,
		@ShowPaid tinyint,
		@PaidInvoicesOnly tinyint,
		@ShowTaxAppliedLinesOnly tinyint,
		@GLCompanyKey int = -1 -- -1 All, 0 Blank, >0 
	)

AS --Encrypt
	
	
  /*
  || When     Who Rel     What
  || 01/12/07 GWG 8.4001  Changed the joins on paid only so that it shows if the payment is in the window
  || 05/15/07 GHL 8.5     Added support of tInvoiceAdvanceBillTax. Enh 6553
  || 02/26/08 GHL 8.5     Fixed problem with 2 InvoiceDates when Paid Only case
  || 04/29/08 GHL 8.509   (25531) Fixed problem with rounding issues with CollectableAmount and TaxablePlusTax
  || 05/26/08 GHL 8.512   (26981) When moving to a temp table, invoice date was set in #taxes.PostingDate
  ||                      Setting it now in #taxes.InvoiceDate. Also changed SalesTaxRate to TaxRate to show on report
  || 06/03/08 GHL 8.512   (27484) With split billing, the sales taxes are not shown on either parent or child
  ||                       Parent has lines, but no taxes on header, and child has no lines but taxes on header
  ||                       Problem was with Lines.TotalAmount since child has no lines
  ||                       Decided to query invoices where ParentInvoice = 0 only (i.e children) but modified where clause
  ||                       with Lines to ISNULL(i.ParentInvoiceKey, i.InvoiceKey) = Lines.InvoiceKey to get the lines from
  ||                       the parent invoice when there is one  
  || 03/19/09 GHL 10.021   Adjusted TaxableAmount according to Percentsplit for split billing
  || 07/10/09 GHL 10.504   (56758) Added GLCompanyKey parameter
  || 07/15/09 GHL 10.504   (45187) Added tax summary (+ taking in account now adv bills)
  || 08/25/09 GHL 10.508   (59770) Corrected the way AdvBillAmount is used
  || 09/22/09 GHL 10.5     Added support of other taxes on voucher lines
  || 09/30/09 GHL 10.5     Using now tInvoiceTax and tVoucherTax
  || 03/11/10 GHL 10.519   Fixed bad join with advbilltax.SalesTaxKey
  || 03/12/10 GHL 10.520   Added logic for Advance Bills
  ||                       Even if there are no taxes on the advance bill, we must recognize taxes 
  ||                       if they exist on the real invoice
  || 05/21/10 RLB 10.523   (81169) On Deck Change to removed invoice lines with no applied tax
  || 07/20/10 GHL 10.532   (85615) Reviewed logic for advance bills, see below...SalesTaxAmount was multiplied
  ||                       by the number of advance bills applied. Changed Sum(SalesTaxAmount) to Min(SalesTaxAmount) 
  || 07/26/10 MFT 10.532   Added unions for tPaymentDetail and tCheckAppl (GWG Fixed tax calculations)
  || 08/19/10 RLB 10.532   Added InvoiceTotalAmount to Taxes Summary
  || 08/23/10 GHL 10.534  (87948) Issue at Hawse Design was that the Collected/Paid was missing the AB contribution
  ||                      My findings were that the reason for that, was that the Taxable fields were resulting in SalesTaxAmount = 0
  ||                      I removed all the checks on SalesTaxAmount = 0 in spRptSalesTaxAB
  ||                      And I added a delete if SalesTaxAmount = 0 in this stored procedure
  || 9/22/10 GWG 10.535   Added a final order by to the last select SalesTaxID, Type, PostingDate, InvoiceNumber
  || 3/29/11 GWG 10.542   Added a comment on advance bill removal.
  || 5/27/11 GHL 10.544   Added a check for Hawse on advance bill removal
  || 8/30/11 GHL 10.547   (119937) If ShowTaxAppliedOnly = 0, remove if SalesTaxAmount = 0 for vouchers also
  || 07/18/13 WDF 10.570  (176497) Added VoucherID
*/
  
SELECT @SalesTaxKey = ISNULL(@SalesTaxKey, 0)
		,@ShowCollected = ISNULL(@ShowCollected, 0)
		,@ShowPaid = ISNULL(@ShowPaid, 0)
		,@PaidInvoicesOnly = ISNULL(@PaidInvoicesOnly, 0)
	    ,@GLCompanyKey = ISNULL(@GLCompanyKey, 0)
	    	
DECLARE @PaidSign AS smallmoney

	IF @ShowCollected = 1
		SELECT @PaidSign = -1.0
	ELSE
		SELECT @PaidSign = 1.0

--Assume done in VB
/*
CREATE TABLE #taxes_summary (
	SalesTaxKey int null
	,SalesTaxID VARCHAR(100) NULL, SalesTaxName VARCHAR(100) NULL, SalesTaxFullName VARCHAR(200) NULL
    ,TaxCollected MONEY NULL, TaxPaid MONEY NULL, VAT MONEY NULL
    ,SalesTaxableAmount MONEY NULL,PurchaseTaxableAmount MONEY NULL) 	
*/

CREATE TABLE #abtaxes (
		ABInvoiceKey int null
		,ABInvoiceTotalAmount money null
		,CheckKey int null
		,CAApplAmount money null
		,InvoiceKey int null
		,ParentInvoiceKey int null
        ,PercentageSplit decimal(24,4) null
		,ABApplAmount money null
		,InvoiceTotalAmount money null
		,SalesTaxKey int null
		,SalesAmount money null
		,SalesTaxAmount money null
		,SalesTaxType INT NULL  -- 1 SalesTax1, 2 SalesTax2, 3 Other Taxes 
		,CalculatedTaxAmount money null
		,CalculatedTaxablePlusTax money null
		,CalculatedCollectedAmount money null
		,CheckDate smalldatetime null
		,UpdateFlag int null
		)

CREATE TABLE #taxes (
		InvoiceKey int null
        ,ParentInvoiceKey int null
        ,PercentageSplit decimal(24,4) null
        ,PostingDate DATETIME NULL
        ,Type VARCHAR(25) NULL	-- 'Collected Taxes' or 'Paid Taxes'
        ,InvoiceNumber VARCHAR(50) NULL
        ,InvoiceDate DATETIME NULL
        ,CompanyName VARCHAR(255) NULL
		
		,SalesTaxKey INT NULL
		,SalesTaxID VARCHAR(100) NULL
		,SalesTaxName VARCHAR(100) NULL
		,TaxRate DECIMAL(24,4) NULL
		,PiggyBackTax INT NULL
		
		,InvoiceTotalAmount MONEY NULL
		,SalesTaxAmount MONEY NULL
		,SalesTaxType INT NULL  -- 1 SalesTax1, 2 SalesTax2, 3 Other Taxes 
		,TaxableAmount MONEY NULL
		,PaidCollected MONEY NULL
		,CollectableAmount MONEY NULL
		,TaxablePlusTax MONEY NULL
		
		,UpdateFlag int null
		)

/* Displayed on the report

this is calculated regardless of applications of any kind
========================================================= 
Invoice Total = #taxes.InvoiceTotalAmount          = tInvoice.TotalAmount
Taxable Sales = #taxes.TaxableAmount               = Sum(tInvoiceLine.TotalAmount) where Taxable = 1  (Take in account PercentageSplit)
Tax Amount = #taxes.SalesTaxAmount                 = tInvoiceTax.SalesTaxAmount (no need to take in account PercentageSplit) 

this is calculated taking in accounts the applications 
========================================================= 
Paid/Collected = #taxes.PaidCollected              = sum of the amount on check applications 
**************

if on the Advance Bill = #abtaxes.ABApplAmount * #abtaxes.CAApplAmount  / #abtaxes.ABInvoiceTotalAmount 
will be #abtaxes.CalculatedCollectedAmount


Collected Amt = #taxes.CollectableAmount           = SalesTaxAmount * PaidCollected / InvoiceTotalAmount
*************

if on the Advance Bill = #abtaxes.ABApplAmount * #abtaxes.CAApplAmount * #abtaxes.SalesTaxAmount 
                       / (#abtaxes.ABInvoiceTotalAmount + #abtaxes.InvoiceTotalAmount)
will be #abtaxes.CalculatedTaxAmount

Taxable Plus Tax = #taxes.TaxablePlusTax           = (SalesTaxAmount + TaxableAmount) * PaidCollected / InvoiceTotalAmount
*****************

if on the Advance Bill =
(ABApplAmount * CAApplAmount * (TotalNonTaxAmount + SalesTaxAmount) / (ABInvoiceTotalAmount * InvoiceTotalAmount)
will be #abtaxes.CalculatedTaxablePlusTaxAmount

*/


if @PaidInvoicesOnly = 1 and @ShowCollected = 1
	exec spRptSalesTaxAB @CompanyKey,@SalesTaxKey,@StartDate,@EndDate,@GLCompanyKey 

IF @PaidInvoicesOnly = 0
	BEGIN

		Insert #taxes 
		Select
			i.InvoiceKey,
			i.ParentInvoiceKey,
			i.PercentageSplit,
			i.PostingDate,
			'Collected Taxes' As Type,
			i.InvoiceNumber,
			i.InvoiceDate,
			c.CustomerID + ' - ' + c.CompanyName As CompanyName,
			
			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,
			
			i.InvoiceTotalAmount,
			Taxes.SalesTaxAmount - isnull(advbilltax.Amount, 0) as SalesTaxAmount,
			Taxes.Type  AS SalesTaxType,
			0 as TaxableAmount, 
			isnull(pmt.AmountReceived, 0) as PaidCollected
			,0,0, 0 
		From
			tInvoice i (nolock)
			inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
			
			inner Join 
			(Select i2.InvoiceKey, it.SalesTaxKey, it.Type, SUM(it.SalesTaxAmount) As SalesTaxAmount
			From tInvoiceTax it (nolock)
			Inner Join tInvoice i2 (nolock) On it.InvoiceKey = i2.InvoiceKey
			Where i2.CompanyKey = @CompanyKey
			Group By i2.InvoiceKey, it.SalesTaxKey, it.Type) 
			As Taxes On Taxes.InvoiceKey = i.InvoiceKey
		
			inner join tSalesTax st (nolock) on Taxes.SalesTaxKey = st.SalesTaxKey
		
			left outer join (Select Sum(tCheckAppl.Amount) as AmountReceived
									,Min(tCheck.CheckDate) as PaymentDate
									,tCheckAppl.InvoiceKey 
							from	tCheckAppl (nolock) 
							inner join tCheck (nolock) on tCheckAppl.CheckKey = tCheck.CheckKey
							inner join tCompany (nolock) on tCheck.ClientKey = tCompany.CompanyKey
							Where	tCompany.OwnerCompanyKey = @CompanyKey 
							And		tCheck.PostingDate <= @EndDate
							Group By InvoiceKey) as pmt on i.InvoiceKey = pmt.InvoiceKey
								
			left outer join (Select iabt.InvoiceKey, iabt.SalesTaxKey, Sum(Amount) AS Amount
							from tInvoiceAdvanceBillTax iabt (NOLOCK)
							Group By iabt.InvoiceKey, iabt.SalesTaxKey 
			) as advbilltax on i.InvoiceKey = advbilltax.InvoiceKey and Taxes.SalesTaxKey = advbilltax.SalesTaxKey		
					
		Where	i.CompanyKey = @CompanyKey 
		and		i.PostingDate >= @StartDate 
		and		i.PostingDate <= @EndDate 
		and		(@SalesTaxKey = 0 or Taxes.SalesTaxKey = @SalesTaxKey) 
		and		@ShowCollected = 1 
		and     i.ParentInvoice = 0 -- added to fix 27484
		and		(@GLCompanyKey = -1 or isnull(i.GLCompanyKey, 0) = @GLCompanyKey) 
						
		UNION ALL
		
		Select
			i.VoucherKey,
			NULL, -- ParentInvoiceKey
			NULL, -- PercentageSplit
			i.PostingDate,
			'Paid Taxes' As Type,
			i.InvoiceNumber,
			i.InvoiceDate,
			c.VendorID + ' - ' + c.CompanyName  As CompanyName,
			
			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,
			
			i.VoucherTotal * @PaidSign AS InvoiceTotalAmount,
			Taxes.SalesTaxAmount * @PaidSign as SalesTaxAmount,
			Taxes.Type  AS SalesTaxType,
			0 as TaxableAmount, 
			pmt.AmountPaid as PaidCollected
			,0,0,0
		From
			tVoucher i (nolock)
			inner join tCompany c (nolock) on i.VendorKey = c.CompanyKey
			
			inner Join (Select v.VoucherKey, vt.SalesTaxKey, vt.Type, SUM(vt.SalesTaxAmount) As SalesTaxAmount
				From tVoucherTax vt (nolock)
				Inner Join tVoucher v (nolock) On vt.VoucherKey = v.VoucherKey
				Where v.CompanyKey = @CompanyKey
				Group By v.VoucherKey, vt.SalesTaxKey, vt.Type) 
				As Taxes On Taxes.VoucherKey = i.VoucherKey
		
			inner join tSalesTax st (nolock) on Taxes.SalesTaxKey = st.SalesTaxKey
			
			left outer join (Select Sum(tPaymentDetail.Amount) as AmountPaid
									,Min(tPayment.PaymentDate) as PaymentDate
									,tPaymentDetail.VoucherKey
				from tPaymentDetail (nolock) 
				inner join tPayment (nolock) on tPaymentDetail.PaymentKey = tPayment.PaymentKey
				Where tPayment.CompanyKey = @CompanyKey 
				And   tPayment.PostingDate <= @EndDate
				Group By VoucherKey) as pmt on i.VoucherKey = pmt.VoucherKey	
		Where
			i.CompanyKey = @CompanyKey and
			i.PostingDate >= @StartDate and
			i.PostingDate <= @EndDate and
			(@SalesTaxKey = 0 or Taxes.SalesTaxKey = @SalesTaxKey) and
			@ShowPaid = 1 and		
			(@GLCompanyKey = -1 or isnull(i.GLCompanyKey, 0) = @GLCompanyKey) 
			
		UNION ALL
			
		SELECT
			pd.PaymentDetailKey,
			NULL, -- ParentInvoiceKey
			NULL, -- PercentageSplit
			p.PostingDate,
			'Paid Taxes' As Type,
			p.CheckNumber,
			p.PaymentDate,
			c.VendorID + ' - ' + c.CompanyName As CompanyName,
			
			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,
			
			p.PaymentAmount * @PaidSign,  --InvoiceTotalAmount
			pd.Amount * @PaidSign,  --SalesTaxAmount
			0,  --SalesTaxType
			(Select Sum(Amount) from tPaymentDetail (nolock) Where PaymentKey = p.PaymentKey and SalesTaxKey is null),  --TaxableAmount
			pd.Amount * @PaidSign,  --PaidCollected
			0,  --CollectableAmount
			0,  --TaxablePlusTax
			0  --UpdateFlag

		
		FROM
			tPaymentDetail pd (nolock)
			INNER JOIN tPayment p (nolock) ON pd.PaymentKey = p.PaymentKey
			INNER JOIN tCompany c (nolock) ON p.VendorKey = c.CompanyKey
			INNER JOIN tSalesTax st (nolock) ON pd.SalesTaxKey = st.SalesTaxKey
		WHERE
			p.CompanyKey = @CompanyKey AND
			p.PostingDate >= @StartDate AND
			p.PostingDate <= @EndDate AND
			(@SalesTaxKey = 0 OR st.SalesTaxKey = @SalesTaxKey) AND
			@ShowPaid = 1 AND
			(@GLCompanyKey = -1 OR ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			
		UNION ALL
			
		SELECT
			ca.CheckApplKey,
			NULL, -- ParentInvoiceKey
			NULL, -- PercentageSplit
			ch.PostingDate,
			'Collected Taxes' As Type,
			ch.ReferenceNumber,
			ch.CheckDate,
			c.CustomerID + ' - ' + c.CompanyName As CompanyName,

			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,

			ch.CheckAmount,  --InvoiceTotalAmount
			ca.Amount,  --SalesTaxAmount
			0,  --SalesTaxType
			(Select Sum(Amount) from tCheckAppl (nolock) Where CheckKey = ca.CheckKey and SalesTaxKey is null),  --TaxableAmount
			ca.Amount,  --PaidCollected
			0,  --CollectableAmount
			0,  --TaxablePlusTax
			0  --UpdateFlag
		FROM
			tCheckAppl ca (nolock)
			INNER JOIN tCheck ch (nolock) ON ca.CheckKey = ch.CheckKey
			INNER JOIN tSalesTax st (nolock) ON ca.SalesTaxKey = st.SalesTaxKey
			INNER JOIN tCompany c (nolock) ON ch.ClientKey = c.CompanyKey
		WHERE
			ch.CompanyKey = @CompanyKey AND
			ch.PostingDate >= @StartDate AND
			ch.PostingDate <= @EndDate AND
			(@SalesTaxKey = 0 OR st.SalesTaxKey = @SalesTaxKey) AND
			@ShowCollected = 1 AND
			(@GLCompanyKey = -1 OR ISNULL(ch.GLCompanyKey, 0) = @GLCompanyKey)
		
		Order By SalesTaxID, Type, InvoiceDate
				
	END
ELSE
	BEGIN
		--@PaidInvoicesOnly = 1
	
		Insert #taxes 
		Select
			i.InvoiceKey,
			i.ParentInvoiceKey,
			i.PercentageSplit,
			null, -- as PostingDate,
			'Collected Taxes' As Type,
			i.InvoiceNumber,
			pmt.PaymentDate as InvoiceDate,
			c.CustomerID + ' - ' + c.CompanyName As CompanyName,
			
			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,
			
			i.InvoiceTotalAmount,
			Taxes.SalesTaxAmount - isnull(advbilltax.Amount, 0) as SalesTaxAmount,
			Taxes.Type  AS SalesTaxType,
			0 as TaxableAmount, 
			isnull(pmt.AmountReceived, 0) as PaidCollected,
			0,0,0 
		From
			tInvoice i (nolock)
			inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
			
			inner Join (Select i2.InvoiceKey, it.SalesTaxKey, it.Type, SUM(it.SalesTaxAmount) As SalesTaxAmount
				From tInvoiceTax it (nolock)
				Inner Join tInvoice i2 (nolock) On it.InvoiceKey = i2.InvoiceKey
				Where i2.CompanyKey = @CompanyKey
				Group By i2.InvoiceKey, it.SalesTaxKey, it.Type) 
				As Taxes On Taxes.InvoiceKey = i.InvoiceKey
		
			inner join tSalesTax st (nolock) on Taxes.SalesTaxKey = st.SalesTaxKey
			
			inner join (Select Sum(tCheckAppl.Amount) as AmountReceived
									,Min(tCheck.CheckDate) as PaymentDate
									,tCheckAppl.InvoiceKey 
							from	tCheckAppl (nolock) 
							inner join tCheck (nolock) on tCheckAppl.CheckKey = tCheck.CheckKey
							inner join tCompany (nolock) on tCheck.ClientKey = tCompany.CompanyKey
							Where	tCompany.OwnerCompanyKey = @CompanyKey 
							And		tCheck.PostingDate <= @EndDate
							And		tCheck.PostingDate >= @StartDate
							Group By InvoiceKey) as pmt on i.InvoiceKey = pmt.InvoiceKey	
			
			left outer join (Select iabt.InvoiceKey, iabt.SalesTaxKey, Sum(Amount) AS Amount
							from tInvoiceAdvanceBillTax iabt (NOLOCK)
							Group By iabt.InvoiceKey, iabt.SalesTaxKey 
			) as advbilltax on i.InvoiceKey = advbilltax.InvoiceKey and Taxes.SalesTaxKey = advbilltax.SalesTaxKey											
		Where	i.CompanyKey = @CompanyKey 
		and		(@SalesTaxKey = 0 or Taxes.SalesTaxKey = @SalesTaxKey) 
		and		@ShowCollected = 1 
		and		isnull(pmt.AmountReceived, 0) > 0
		and     i.ParentInvoice = 0 -- added to fix 27484
		and		(@GLCompanyKey = -1 or isnull(i.GLCompanyKey, 0) = @GLCompanyKey) 
							
		UNION ALL
		
		Select
			i.VoucherKey,
			null,
			null,
			null, -- as PostingDate,
			'Paid Taxes' As Type,
			i.InvoiceNumber,
			pmt.PaymentDate as InvoiceDate,
			c.VendorID + ' - ' + c.CompanyName  As CompanyName,
			
			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,
			
			i.VoucherTotal * @PaidSign AS InvoiceTotalAmount,
			Taxes.SalesTaxAmount * @PaidSign as SalesTaxAmount,
			Taxes.Type  AS SalesTaxType,
			0 as TaxableAmount, 
			pmt.AmountPaid as PaidCollected
			,0,0,0
		From
			tVoucher i (nolock)
			inner join tCompany c (nolock) on i.VendorKey = c.CompanyKey
			
			inner Join (Select v.VoucherKey, vt.SalesTaxKey, vt.Type, SUM(vt.SalesTaxAmount) As SalesTaxAmount
				From tVoucherTax vt (nolock)
				Inner Join tVoucher v (nolock) On vt.VoucherKey = v.VoucherKey
				Where v.CompanyKey = @CompanyKey
				Group By v.VoucherKey, vt.SalesTaxKey, vt.Type) 
				As Taxes On Taxes.VoucherKey = i.VoucherKey
		
			inner join tSalesTax st (nolock) on Taxes.SalesTaxKey = st.SalesTaxKey
			
			inner join (Select Sum(tPaymentDetail.Amount) as AmountPaid
									,Min(tPayment.PaymentDate) as PaymentDate
									,tPaymentDetail.VoucherKey
				from tPaymentDetail (nolock) 
				inner join tPayment (nolock) on tPaymentDetail.PaymentKey = tPayment.PaymentKey
				Where tPayment.CompanyKey = @CompanyKey 
				And   tPayment.PostingDate <= @EndDate
				And   tPayment.PostingDate >= @StartDate
				Group By VoucherKey) as pmt on i.VoucherKey = pmt.VoucherKey	
		Where
			i.CompanyKey = @CompanyKey and
			(@SalesTaxKey = 0 or Taxes.SalesTaxKey = @SalesTaxKey) and
			@ShowPaid = 1 and
			isnull(pmt.AmountPaid, 0) > 0 and
			(@GLCompanyKey = -1 or isnull(i.GLCompanyKey, 0) = @GLCompanyKey) 
		
		UNION ALL
		
		SELECT
			pd.PaymentDetailKey,
			NULL, -- ParentInvoiceKey
			NULL, -- PercentageSplit
			p.PostingDate,
			'Paid Taxes' As Type,
			p.CheckNumber,
			p.PaymentDate,
			c.VendorID + ' - ' + c.CompanyName As CompanyName,
			
			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,

			p.PaymentAmount * @PaidSign,  --InvoiceTotalAmount
			pd.Amount * @PaidSign,  --SalesTaxAmount
			0,  --SalesTaxType
			(Select Sum(Amount) from tPaymentDetail (nolock) Where PaymentKey = p.PaymentKey and SalesTaxKey is null),  --TaxableAmount
			pd.Amount * @PaidSign,  --PaidCollected
			0,  --CollectableAmount
			0,  --TaxablePlusTax
			0  --UpdateFlag
			
		FROM
			tPaymentDetail pd (nolock)
			INNER JOIN tPayment p (nolock) ON pd.PaymentKey = p.PaymentKey
			INNER JOIN tCompany c (nolock) ON p.VendorKey = c.CompanyKey
			INNER JOIN tSalesTax st (nolock) ON pd.SalesTaxKey = st.SalesTaxKey
		WHERE
			p.CompanyKey = @CompanyKey AND
			p.PostingDate >= @StartDate AND
			p.PostingDate <= @EndDate AND
			(@SalesTaxKey = 0 OR st.SalesTaxKey = @SalesTaxKey) AND
			@ShowPaid = 1 AND
			(@GLCompanyKey = -1 OR ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
		
		UNION ALL
		
		SELECT
			ca.CheckApplKey,
			NULL, -- ParentInvoiceKey
			NULL, -- PercentageSplit
			ch.PostingDate,
			'Collected Taxes' As Type,
			ch.ReferenceNumber,
			ch.CheckDate,
			c.CustomerID + ' - ' + c.CompanyName As CompanyName,
			
			st.SalesTaxKey,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,
			
			ch.CheckAmount,  --InvoiceTotalAmount
			ca.Amount,  --SalesTaxAmount
			0,  --SalesTaxType
			(Select Sum(Amount) from tCheckAppl (nolock) Where CheckKey = ca.CheckKey and SalesTaxKey is null),  --TaxableAmount
			ca.Amount,  --PaidCollected
			0,  --CollectableAmount
			0,  --TaxablePlusTax
			0  --UpdateFlag
		FROM
			tCheckAppl ca (nolock)
			INNER JOIN tCheck ch (nolock) ON ca.CheckKey = ch.CheckKey
			INNER JOIN tSalesTax st (nolock) ON ca.SalesTaxKey = st.SalesTaxKey
			INNER JOIN tCompany c (nolock) ON ch.ClientKey = c.CompanyKey
		WHERE
			ch.CompanyKey = @CompanyKey AND
			ch.PostingDate >= @StartDate AND
			ch.PostingDate <= @EndDate AND
			(@SalesTaxKey = 0 OR st.SalesTaxKey = @SalesTaxKey) AND
			@ShowCollected = 1 AND
			(@GLCompanyKey = -1 OR ISNULL(ch.GLCompanyKey, 0) = @GLCompanyKey)
		
		Order By SalesTaxID, Type, InvoiceDate
		
	END
 
	-- At the Australians request and MW, if the header has a SalesTaxKey but no line taxable
	-- show it on the report...as a result I had tInvoiceTax records with SalesTaxAmount = 0
	-- 3/18/10 at GG's request remove them for Advance Bill
	-- If you include advance bills, it will end up counting the revenue twice. Also, Adv Bills are really not revenue, they are a liability.
	-- We may have to leave this for Hawse Design

	declare @CompanyName varchar(200)
	select @CompanyName = CompanyName from tCompany (nolock) where CompanyKey = @CompanyKey
	select @CompanyName = ltrim(rtrim(@CompanyName))

	if @CompanyName <> 'Hawse Design, Inc'
	delete #taxes
	from   tInvoice i (nolock)
	where  #taxes.InvoiceKey = i.InvoiceKey
	and    #taxes.Type = 'Collected Taxes'
	and    i.AdvanceBill = 1
	and    #taxes.SalesTaxAmount = 0
	

	-- if header has SalesTaxKey but no line Taxable removed them to give clients option to view it
	-- the way the report was before the Australian change
	/*
	IF @ShowTaxAppliedLinesOnly = 1
		delete #taxes
		from   tInvoice i (nolock)
		where  #taxes.InvoiceKey = i.InvoiceKey
		and    #taxes.Type = 'Collected Taxes'
		and    #taxes.SalesTaxAmount = 0
	*/
	IF @ShowTaxAppliedLinesOnly = 1
	delete #taxes
	where  #taxes.SalesTaxAmount = 0

	
	--select * from #taxes
	--select * from #abtaxes

	-- now check if the regular invoices are not in the AB taxes temp table 
	update #abtaxes
	set    #abtaxes.UpdateFlag = 0
	
	update #abtaxes
	set    #abtaxes.UpdateFlag = 1
	from   #taxes
	where  #abtaxes.InvoiceKey = #taxes.InvoiceKey
	and    #abtaxes.SalesTaxKey = #taxes.SalesTaxKey
	and    #abtaxes.SalesTaxType = #taxes.SalesTaxType
		
   --select * from #abtaxes

	Insert #taxes 
	Select
		i.InvoiceKey,
		i.ParentInvoiceKey,
		i.PercentageSplit,
		null, -- as PostingDate,
		'Collected Taxes' As Type,
		i.InvoiceNumber,
		abtaxes.CheckDate as InvoiceDate,
		c.CustomerID + ' - ' + c.CompanyName As CompanyName,
		
		st.SalesTaxKey,
		st.SalesTaxID,
		st.SalesTaxName,
		st.TaxRate,
		st.PiggyBackTax,
		
		i.InvoiceTotalAmount,
		abtaxes.SalesTaxAmount as SalesTaxAmount,
		abtaxes.SalesTaxType AS SalesTaxType,
		0 as TaxableAmount, -- will be recalced below
		abtaxes.CalculatedCollectedAmount as PaidCollected,
		abtaxes.CalculatedTaxAmount as CollectedAmount,
		abtaxes.CalculatedTaxablePlusTax as TaxablePlusTax,
		1 -- indicates that it comes from AB taxes 
	From
		(select InvoiceKey, SalesTaxKey, SalesTaxType
		-- take min instead of sum because when we have several advance bills, the original SalesTaxAmount is Xed by number of ABs
		, MIN(SalesTaxAmount) AS SalesTaxAmount   -- issue (85615) -- changed from SUM(SalesTaxAmount) to MIN(SalesTaxAmount)  
		, ROUND(SUM(CalculatedTaxAmount), 2) AS CalculatedTaxAmount
		, ROUND(SUM(CalculatedTaxablePlusTax), 2) AS CalculatedTaxablePlusTax
		, ROUND(SUM(CalculatedCollectedAmount), 2) AS CalculatedCollectedAmount
		, MAX(CheckDate) AS CheckDate
		from  #abtaxes
		where #abtaxes.UpdateFlag = 0
		group by InvoiceKey, SalesTaxKey, SalesTaxType
		) as abtaxes	 
		inner join tInvoice i (nolock) on abtaxes.InvoiceKey = i.InvoiceKey 
		inner join tSalesTax st (nolock) on abtaxes.SalesTaxKey = st.SalesTaxKey			
		inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey

	-- Added this where clause for 87948 because AB taxes may include now records where SalesTaxAmount = 0
	where abtaxes.SalesTaxAmount <> 0
	
	-- invoices			
	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		where  il.InvoiceKey = isnull(#taxes.ParentInvoiceKey, #taxes.InvoiceKey)
		and    il.Taxable = 1	
	),0)
	where  #taxes.Type = 'Collected Taxes'
	and #taxes.SalesTaxType = 1
	
	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		where  il.InvoiceKey = isnull(#taxes.ParentInvoiceKey, #taxes.InvoiceKey)
		and    il.Taxable2 = 1	
	),0)
	where  #taxes.Type = 'Collected Taxes'
	and    #taxes.SalesTaxType = 2

	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(il.TotalAmount)
		from   tInvoiceLine il (nolock)
		       inner join tInvoiceLineTax ilt (nolock) on il.InvoiceLineKey = ilt.InvoiceLineKey 
		where  il.InvoiceKey = isnull(#taxes.ParentInvoiceKey, #taxes.InvoiceKey)
		and    ilt.SalesTaxKey = #taxes.SalesTaxKey
	),0)
	where  #taxes.Type = 'Collected Taxes'
	and    #taxes.SalesTaxType = 3

	UPDATE #taxes
	SET    #taxes.TaxableAmount = (#taxes.TaxableAmount * #taxes.PercentageSplit) / 100
	WHERE  #taxes.Type = 'Collected Taxes'
	AND    ISNULL(#taxes.ParentInvoiceKey, 0) > 0   

	-- vouchers
	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(vd.TotalCost)
		from   tVoucherDetail vd (nolock)
		where  vd.VoucherKey = #taxes.InvoiceKey
		and    vd.Taxable = 1	
	),0)
	where  #taxes.Type = 'Paid Taxes'
	and    #taxes.SalesTaxType = 1
	
	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(vd.TotalCost)
		from   tVoucherDetail vd (nolock)
		where  vd.VoucherKey = #taxes.InvoiceKey
		and    vd.Taxable2 = 1	
	),0)
	where  #taxes.Type = 'Paid Taxes'
	and    #taxes.SalesTaxType = 2

	update #taxes
	set    #taxes.TaxableAmount = ISNULL((
		select sum(vd.TotalCost)
		from   tVoucherDetail vd (nolock)
		       inner join tVoucherDetailTax vdt (nolock) on vd.VoucherDetailKey = vdt.VoucherDetailKey 
		where  vd.VoucherKey = #taxes.InvoiceKey
		and    vdt.SalesTaxKey = #taxes.SalesTaxKey
	),0)
	where  #taxes.Type = 'Paid Taxes'
	and    #taxes.SalesTaxType = 3
				
	UPDATE #taxes
	SET    #taxes.TaxableAmount = @PaidSign * #taxes.TaxableAmount 
	WHERE  #taxes.Type = 'Paid Taxes'

	-- This was commented out for (59770)
		
	-- the retainer amount contains the sum of tInvoiceAdvanceBill.Amount
	-- now subtract AdvBillAmount from total or we would double dip if we have the AB invoice and the real invoice   
	-- also adjust the TaxableAmount first

	/* Apply proportion
	TaxableAmount = TaxableAmount * ( InvoiceTotalAmount - AdvBillAmount) / InvoiceTotalAmount
	or
	TaxableAmount = TaxableAmount * ( 1 - AdvBillAmount / InvoiceTotalAmount)
	
	UPDATE #taxes
	SET    #taxes.TaxableAmount = ROUND((
		#taxes.TaxableAmount * (1 - #taxes.AdvBillAmount / #taxes.InvoiceTotalAmount) 
		), 2)
	WHERE  #taxes.Type = 'Collected Taxes'
	AND    #taxes.AdvBillAmount <> 0
	AND    #taxes.InvoiceTotalAmount <> 0	

	UPDATE #taxes
	SET    #taxes.InvoiceTotalAmount = #taxes.InvoiceTotalAmount - #taxes.AdvBillAmount 
	WHERE  #taxes.Type = 'Collected Taxes'
	*/
	
	-- Now calculate CollectableAmount and TaxablePlusTax
	IF @PaidInvoicesOnly = 0
		UPDATE #taxes 
		SET		CollectableAmount = ISNULL(SalesTaxAmount, 0)
				,TaxablePlusTax = ISNULL(TaxableAmount, 0) + ISNULL(SalesTaxAmount, 0)
	ELSE
	BEGIN
		-- This is the amount function of SalesTaxAmount * PaidCollected / InvoiceTotalAmount
		UPDATE #taxes 
		SET	    CollectableAmount = (ISNULL(SalesTaxAmount, 0) * ISNULL(PaidCollected, 0))/ ISNULL(InvoiceTotalAmount, 0)
		WHERE   ISNULL(InvoiceTotalAmount, 0) <> 0 
		AND     UpdateFlag = 0
		
		UPDATE #taxes 
		SET	    CollectableAmount = ISNULL(SalesTaxAmount, 0) 
		WHERE   ISNULL(InvoiceTotalAmount, 0) = 0 
		AND     UpdateFlag = 0
		
		-- added this for AB, contribution of receipts on Advance Bills
		UPDATE #taxes
		SET    #taxes.CollectableAmount = #taxes.CollectableAmount + ISNULL((
			SELECT ROUND(SUM(b.CalculatedTaxAmount), 2)
			FROM   #abtaxes b
			WHERE  b.InvoiceKey = #taxes.InvoiceKey
			AND    b.SalesTaxKey = #taxes.SalesTaxKey
			AND    b.SalesTaxType = #taxes.SalesTaxType
			AND    b.UpdateFlag = 1
		), 0)
		WHERE  #taxes.Type = 'Collected Taxes'
		AND     UpdateFlag = 0
		
		
		-- This is the amount function of (SalesTaxAmount + TaxableAmount) * PaidCollected / InvoiceTotalAmount
		UPDATE #taxes 
		SET	    TaxablePlusTax = ((ISNULL(SalesTaxAmount, 0) + ISNULL(TaxableAmount, 0)) * ISNULL(PaidCollected, 0))/ ISNULL(InvoiceTotalAmount, 0)
		WHERE   ISNULL(InvoiceTotalAmount, 0) <> 0 
		AND     UpdateFlag = 0
		

		UPDATE #taxes 
		SET	    TaxablePlusTax = ISNULL(TaxableAmount, 0) + ISNULL(SalesTaxAmount, 0)
		WHERE   ISNULL(InvoiceTotalAmount, 0) = 0 
		AND     UpdateFlag = 0
		
		-- added this for AB, contribution on taxes of receipts on Advance Bills
		UPDATE #taxes
		SET    #taxes.TaxablePlusTax = #taxes.TaxablePlusTax + ISNULL((
			SELECT ROUND(SUM(#abtaxes.CalculatedTaxablePlusTax), 2)
			FROM   #abtaxes 
			WHERE  #abtaxes.InvoiceKey = #taxes.InvoiceKey
			AND    #abtaxes.SalesTaxKey = #taxes.SalesTaxKey
			AND    #abtaxes.SalesTaxType = #taxes.SalesTaxType
			AND    #abtaxes.UpdateFlag = 1
		), 0)
		WHERE  #taxes.Type = 'Collected Taxes'
		AND     UpdateFlag = 0
		
		
		-- now add the AB contribution to PaidCollected
		-- this is the receipts against Advance bills applied against real invoices
		-- Careful here because we could have the same invoice with several taxes...so take min
		UPDATE #taxes
		SET    #taxes.PaidCollected = #taxes.PaidCollected + ISNULL((
			
			SELECT ROUND(CalculatedCollectedAmount, 2)
			FROM (
				SELECT InvoiceKey, MIN(CalculatedCollectedAmount) AS CalculatedCollectedAmount
				FROM   #abtaxes
				WHERE  UpdateFlag = 1
				GROUP BY InvoiceKey
			) as abtaxes
			WHERE abtaxes.InvoiceKey = #taxes.InvoiceKey 
		), 0)
		WHERE  #taxes.Type = 'Collected Taxes'
		
		
		
		UPDATE #taxes
		SET    CollectableAmount = ROUND(CollectableAmount, 2)
			  ,TaxablePlusTax = ROUND(TaxablePlusTax, 2)
	END	
		
	TRUNCATE TABLE #taxes_summary
		
	INSERT 	#taxes_summary (SalesTaxID,SalesTaxName,SalesTaxFullName,TaxCollected,TaxPaid,VAT,SalesTaxableAmount,PurchaseTaxableAmount,InvoiceTotalAmount) 	
    SELECT SalesTaxID,SalesTaxName,SalesTaxID + ' - ' + SalesTaxName 
    ,SUM(TaxCollected),SUM(TaxPaid),SUM(TaxCollected)-SUM(TaxPaid)
    ,SUM(SalesTaxableAmount),SUM(PurchaseTaxableAmount), SUM(InvoiceTotalAmount)
    FROM  
		(
    SELECT SalesTaxID, SalesTaxName
         , SUM(CollectableAmount)	AS TaxCollected
         , CAST(0 AS MONEY)			AS TaxPaid
         , SUM(TaxableAmount)		AS SalesTaxableAmount 
         , CAST(0 AS MONEY)			AS PurchaseTaxableAmount
		 , Sum(InvoiceTotalAmount)  AS InvoiceTotalAmount
    FROM  #taxes
    WHERE Type = 'Collected Taxes'
    GROUP BY SalesTaxID, SalesTaxName
    
    UNION ALL
    
	SELECT SalesTaxID, SalesTaxName
         , CAST(0 AS MONEY)							AS TaxCollected
         , SUM(CollectableAmount) * @PaidSign		AS TaxPaid
         , CAST(0 AS MONEY)							AS SalesTaxableAmount 
         , SUM(TaxableAmount) * @PaidSign			AS PurchaseTaxableAmount
		 , Sum(InvoiceTotalAmount)                  AS InvoiceTotalAmount
    FROM  #taxes
    WHERE Type = 'Paid Taxes'
    GROUP BY SalesTaxID, SalesTaxName
		) AS tax
	
	GROUP BY SalesTaxID, SalesTaxName
	ORDER BY SalesTaxName
	
		
	--SELECT * FROM #taxes_summary
		     
    SELECT v.VoucherID, t.* 
      FROM #taxes t LEFT JOIN tVoucher v (nolock) ON (v.VoucherKey = t.InvoiceKey AND
                                                      t.Type = 'Paid Taxes')
    Order By t.SalesTaxID, t.Type, t.PostingDate, t.InvoiceNumber

	RETURN 1
GO
