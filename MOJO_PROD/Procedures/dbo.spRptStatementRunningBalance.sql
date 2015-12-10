USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptStatementRunningBalance]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptStatementRunningBalance]
	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@ClientKey int,
	@ParentClientKey int,
	@ProjectKey int,
	@PostStatus tinyint,
	@IncludeZeroBal tinyint,
	@GLCompanyKey int, ---1 All, 0 NULL, >0 valid company
	@UserKey int = null,
	@AccountManager int = null,
	@CurrencyID varchar(10) = null, -- Null Home Currency, or a foreign currency
	@Receipts tinyint = 0 -- Include unapplied receipts

AS --Encrypt

/*
|| When     Who Rel  What
|| 12/4/06  CRG 8.4  Added IncludeZeroBal parameter.
|| 12/4/06  CRG 8.4  Added TranSort to temp table in order to sort the transaction that appear on the same day.
|| 12/5/06  CRG 8.4  Wrapped Beginning Balance calculations with ISNULL.
|| 10/18/07 CRG 8.5  Added GLCompanyKey parameter.
|| 11/19/07 GHL 8.5  Fixed bad alias
|| 02/10/09 GHL 10.018 (37631) Changed logic of GLCompanyKey to make it similar to spRptInvoiceAging
|| 06/09/11 RLB 10.545 (108018) Checking the Checks GL Company instead of the one on the client
|| 08/08/11 GHL 10.546 (118116) Getting payments for the BeginningBalance  from tCheckApp.Amount instead of tCheck.CheckAmount
||                     so that we can ignore payments against sales accts (i.e. tCheckAppl.InvoiceKey is not null)
||                     But in the date window display them as 2 lines 1 negative and 1 positive so that end result is 0 
|| 03/19/12 RLB 10.554 (137443) increased Temp Table TranRef to 100 since payment ref is 100 and was causing an error 4 a client
|| 04/16/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 09/30/13 RLB 10.573 (191660) should have been added for (185716) Adding filter for client Account mananger
|| 11/21/13 MFT 10.574 (191660) pushed @AccountManager filter to the last 6 gets, patched App servers for 10.573
|| 03/04/14 GHL 10.577 Added CurrencyID param to support multi currency fucntionality
|| 05/09/14 GHL 10.580 (215708) Added ParentClientKey parameter for enhancement
|| 05/14/14 GHL 10.580 (216216) Added param @Receipts so that unapplied receipts can be added
*/

-- check for the cbre customization
declare @Customizations varchar(2000), @RollUpMatching int
Select @Customizations = LOWER(ISNULL(Customizations, '')) from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
Select @RollUpMatching = CHARINDEX('cbre', @Customizations)

Declare @RestrictToGLCompany int
Declare @MultiCurrency int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	,@MultiCurrency = ISNULL(MultiCurrency, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
	,@MultiCurrency = isnull(@MultiCurrency, 0)


--Create the Temp Table
CREATE TABLE #ClientStmt
	(LoggedCompanyKey int,
	TranType varchar(20) null,
	ClientKey int null,
	TranDate smalldatetime null,
	TranRef varchar(100) null,
	DueDate smalldatetime null,
	ProjectKey int null,
	TranAmt money null,
	Sort int null,
	TranSort int null,
	Action int null)

--Add all clients with Invoices for the company
INSERT	#ClientStmt (ClientKey)
SELECT DISTINCT ClientKey
FROM	tInvoice i (nolock)
INNER JOIN tCompany c (nolock) on i.ClientKey = c.CompanyKey 
WHERE	i.CompanyKey = @CompanyKey
AND		(i.ClientKey = @ClientKey OR @ClientKey IS NULL)
And     (@ParentClientKey IS NULL or (i.ClientKey = @ParentClientKey or i.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
AND		(i.ProjectKey = @ProjectKey OR @ProjectKey IS NULL)
AND		(c.AccountManagerKey = @AccountManager OR @AccountManager IS NULL)
AND		ISNULL(Posted, 0) >= @PostStatus
--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(GLCompanyKey, 0)) ) 
AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
			)
AND (@MultiCurrency = 0
	OR isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') )


--Add all clients with Receipts that weren't already added above
INSERT	#ClientStmt (ClientKey)
SELECT DISTINCT ClientKey
FROM	tCheck c (nolock)
INNER JOIN tCompany com (nolock) ON c.ClientKey = com.CompanyKey
WHERE	com.OwnerCompanyKey = @CompanyKey
AND		(c.ClientKey = @ClientKey OR @ClientKey IS NULL)
And     (@ParentClientKey IS NULL or (c.ClientKey = @ParentClientKey or c.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
AND		(com.AccountManagerKey = @AccountManager OR @AccountManager IS NULL)
AND		c.ClientKey NOT IN (SELECT ClientKey FROM #ClientStmt)
AND		ISNULL(c.Posted, 0) >= @PostStatus
--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(c.GLCompanyKey, 0)) ) 
AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(c.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey)
			)
AND		(@ProjectKey IS NULL 
		OR
		c.CheckKey IN 
			(SELECT	ca.CheckKey
			FROM	tCheckAppl ca (nolock)
			INNER JOIN tInvoice i (nolock) ON ca.InvoiceKey = i.InvoiceKey
			WHERE	i.ProjectKey = @ProjectKey)
		)
AND (@MultiCurrency = 0
	OR isnull(c.CurrencyID, '') = isnull(@CurrencyID, '') )

--Get the Beginning Balance for each Client
UPDATE	#ClientStmt
SET		TranDate = @StartDate
		,TranRef = 'Beginning Balance'
		,TranAmt =	--Invoices
				ISNULL((SELECT	SUM(ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0))
				FROM	tInvoice i (nolock)
				WHERE	i.ClientKey = #ClientStmt.ClientKey
				AND		i.PostingDate < @StartDate
				AND		ISNULL(i.Posted, 0) >= @PostStatus
				--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) ) 
				AND     (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey != -1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
				)
				AND (@MultiCurrency = 0
					OR isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') )
				), 0)

				- --less Receipts...8/8/11 read tCheckAppl.Amount rather tCheck.CheckAmount
				ISNULL((SELECT SUM(ca.Amount)
				FROM	tCheck c (nolock)
					INNER JOIN tCheckAppl ca (nolock) on c.CheckKey = ca.CheckKey
				WHERE	c.ClientKey = #ClientStmt.ClientKey
				AND     ca.InvoiceKey is not null
				AND		c.PostingDate < @StartDate
				AND		ISNULL(c.Posted, 0) >= @PostStatus
				--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(c.GLCompanyKey, 0)) )
				AND     (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(c.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey != -1 AND ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey)
				)
				AND (@MultiCurrency = 0
					OR isnull(c.CurrencyID, '') = isnull(@CurrencyID, '') )
				
				), 0)

--This ensures that the Beginning Balances are sorted to the top of the statement
UPDATE	#ClientStmt
SET		Sort = 0

-- temp table for the unapplied receipts
create table #UnappliedRec
	(CheckKey int 
	,ClientKey int null
	,PostingDate datetime null
	,CheckAmt money null
	,AppliedAmt money null
	)

if @Receipts = 1 And @ProjectKey is Null
BEGIN
	-- Add Back any unapplied receipts from the client

	insert #UnappliedRec(CheckKey,ClientKey,PostingDate,CheckAmt,AppliedAmt)
	select ch.CheckKey,ch.ClientKey,ch.PostingDate,ch.CheckAmount, 0
	From tCheck ch (nolock)
	Inner Join tCompany c (nolock) On ch.ClientKey = c.CompanyKey
	-- join with a possible voided check, make sure that CheckKey <> VoidCheckKey on the void
	left Join tCheck void_ch (nolock) on ch.CheckKey = void_ch.VoidCheckKey and void_ch.CheckKey <> void_ch.VoidCheckKey 
	Where
		c.OwnerCompanyKey = @CompanyKey 
	And	ch.PostingDate <= @EndDate 
	And	(isnull(ch.VoidCheckKey, 0) = 0
		Or
		void_ch.PostingDate > @EndDate
		)
	--And	(@GLCompanyKey IS NULL OR ISNULL(ch.GLCompanyKey, 0) = @GLCompanyKey)
	AND     (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(ch.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey != -1 AND ISNULL(ch.GLCompanyKey, 0) = @GLCompanyKey)
				)
	And	(@ClientKey IS NULL OR ch.ClientKey = @ClientKey)  -- Reduce # of records upfront
	And (@ParentClientKey IS NULL or (ch.ClientKey = @ParentClientKey or ch.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	--And	(@ClassKey IS NULL OR ch.ClassKey = @ClassKey)  -- Reduce # of records upfront
	And (@AccountManager IS NULL OR c.AccountManagerKey = @AccountManager)
	And ch.Posted >= @PostStatus	
	AND (@MultiCurrency = 0
			OR isnull(ch.CurrencyID, '') = isnull(@CurrencyID, '') )


	-- now calc the applied amounts, do we have to take in account the dates of the invoices?
	update #UnappliedRec
	set    #UnappliedRec.AppliedAmt = (select sum (ca.Amount) from tCheckAppl ca (nolock) 
		where ca.CheckKey = #UnappliedRec.CheckKey)

	update #UnappliedRec
	set    CheckAmt = isnull(CheckAmt, 0), AppliedAmt = isnull(AppliedAmt, 0) 

	-- delete if completely applied
	delete #UnappliedRec where CheckAmt - AppliedAmt = 0

	-- now add the contributions of the unapplied receipts
	UPDATE	#ClientStmt
	SET		#ClientStmt.TranAmt =isnull(#ClientStmt.TranAmt, 0) - ISNULL((
		select sum(b.CheckAmt - b.AppliedAmt)
		from   #UnappliedRec b
		where  #ClientStmt.ClientKey = b.ClientKey
		AND	b.PostingDate < @StartDate
	),0)

END


--Now Get the Transactions in the date range

--Get Invoices
INSERT	#ClientStmt
		(TranType
		,ClientKey
		,TranDate
		,TranRef
		,DueDate
		,ProjectKey
		,TranAmt
		,Sort
		,TranSort)
SELECT	'Invoice'
		,i.ClientKey
		,i.InvoiceDate
		,i.InvoiceNumber
		,i.DueDate
		,i.ProjectKey
		,ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0)
		,1	
		,1
FROM	tInvoice i (nolock)
INNER JOIN tCompany c (nolock) on i.ClientKey = c.CompanyKey 
WHERE	i.CompanyKey = @CompanyKey
AND		(c.AccountManagerKey = @AccountManager OR @AccountManager IS NULL)
AND		(i.ClientKey = @ClientKey OR @ClientKey IS NULL)
And     (@ParentClientKey IS NULL or (i.ClientKey = @ParentClientKey or i.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
AND		(i.ProjectKey = @ProjectKey OR @ProjectKey IS NULL)
AND		ISNULL(i.Posted, 0) >= @PostStatus
AND		ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0) > 0
AND		i.PostingDate BETWEEN @StartDate AND @EndDate
--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) ) 
AND     (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey != -1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
				)
AND (@MultiCurrency = 0
	OR isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') )

--Get Credit Memos
INSERT	#ClientStmt
		(TranType
		,ClientKey
		,TranDate
		,TranRef
		,DueDate
		,ProjectKey
		,TranAmt
		,Sort
		,TranSort)
SELECT	'Credit'
		,i.ClientKey
		,i.InvoiceDate
		,i.InvoiceNumber
		,i.DueDate
		,i.ProjectKey
		,ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0)
		,1
		,2
FROM	tInvoice i (nolock)
INNER JOIN tCompany c (nolock) on i.ClientKey = c.CompanyKey 
WHERE	i.CompanyKey = @CompanyKey
AND		(c.AccountManagerKey = @AccountManager OR @AccountManager IS NULL)
AND		(i.ClientKey = @ClientKey OR @ClientKey IS NULL)
And     (@ParentClientKey IS NULL or (i.ClientKey = @ParentClientKey or i.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
AND		(i.ProjectKey = @ProjectKey OR @ProjectKey IS NULL)
AND		ISNULL(i.Posted, 0) >= @PostStatus
AND		ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0) < 0
AND		i.PostingDate BETWEEN @StartDate AND @EndDate
--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) ) 
AND     (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey != -1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
				)
AND (@MultiCurrency = 0
	OR isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') )

if ISNULL(@ProjectKey, 0) = 0
BEGIN
	--Get Payments applied to invoices
	INSERT	#ClientStmt
			(TranType
			,ClientKey
			,TranDate
			,TranRef
			,ProjectKey
			,TranAmt
			,Sort
			,TranSort)
	SELECT	'Payment'
			,c.ClientKey
			,c.CheckDate
			,c.ReferenceNumber
			,NULL
			--,ca.CheckAmount * -1
			,Sum(ca.Amount) * -1 -- added 8/8/11
			,1
			,3
	FROM	tCheck c (nolock)
	INNER JOIN tCheckAppl ca (nolock) on c.CheckKey = ca.CheckKey -- added 8/8/11
	INNER JOIN tCompany com (nolock) ON c.ClientKey = com.CompanyKey
	WHERE	com.OwnerCompanyKey = @CompanyKey
	AND		(c.ClientKey = @ClientKey OR @ClientKey IS NULL)
	And     (@ParentClientKey IS NULL or (c.ClientKey = @ParentClientKey or c.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	AND		(com.AccountManagerKey = @AccountManager OR @AccountManager IS NULL)
	AND		ISNULL(c.Posted, 0) >= @PostStatus
	AND		c.PostingDate BETWEEN @StartDate AND @EndDate	
	--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(c.GLCompanyKey, 0)) ) 
	AND     (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(c.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey != -1 AND ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey)
				)
	AND (@MultiCurrency = 0
		OR isnull(c.CurrencyID, '') = isnull(@CurrencyID, '') )
	AND  ca.InvoiceKey is not null -- added 8/8/11 Applied to Invoices
	Group By -- added 8/8/11
		 c.ClientKey
		,c.CheckDate
		,c.ReferenceNumber


	-- now get payments applied to  sales accts (2 lines 1 neg + 1 pos)
	INSERT	#ClientStmt
			(TranType
			,ClientKey
			,TranDate
			,TranRef
			,ProjectKey
			,TranAmt
			,Sort
			,TranSort)
	SELECT	'Payment'
			,c.ClientKey
			,c.CheckDate
			,c.ReferenceNumber
			,NULL
			,Sum(ca.Amount) * -1 -- negative
			,1
			,3
	FROM	tCheck c (nolock)
	INNER JOIN tCheckAppl ca (nolock) on c.CheckKey = ca.CheckKey 
	INNER JOIN tCompany com (nolock) ON c.ClientKey = com.CompanyKey
	WHERE	com.OwnerCompanyKey = @CompanyKey
	AND		(c.ClientKey = @ClientKey OR @ClientKey IS NULL)
	And     (@ParentClientKey IS NULL or (c.ClientKey = @ParentClientKey or c.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	AND		(com.AccountManagerKey = @AccountManager OR @AccountManager IS NULL)
	AND		ISNULL(c.Posted, 0) >= @PostStatus
	AND		c.PostingDate BETWEEN @StartDate AND @EndDate	
	--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(c.GLCompanyKey, 0)) ) 
	AND     (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(c.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey != -1 AND ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey)
				)
	AND (@MultiCurrency = 0
		OR isnull(c.CurrencyID, '') = isnull(@CurrencyID, '') )
	AND  ca.InvoiceKey is null -- Applied to Sales
	Group By 
		 c.ClientKey
		,c.CheckDate
		,c.ReferenceNumber
 
	INSERT	#ClientStmt
			(TranType
			,ClientKey
			,TranDate
			,TranRef
			,ProjectKey
			,TranAmt
			,Sort
			,TranSort)
	SELECT	'Payment'
			,c.ClientKey
			,c.CheckDate
			,c.ReferenceNumber
			,NULL
			,Sum(ca.Amount) -- Positive
			,1
			,3
	FROM	tCheck c (nolock)
	INNER JOIN tCheckAppl ca (nolock) on c.CheckKey = ca.CheckKey -- added 8/8/11
	INNER JOIN tCompany com (nolock) ON c.ClientKey = com.CompanyKey
	WHERE	com.OwnerCompanyKey = @CompanyKey
	AND		(c.ClientKey = @ClientKey OR @ClientKey IS NULL)
	And     (@ParentClientKey IS NULL or (c.ClientKey = @ParentClientKey or c.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	AND		(com.AccountManagerKey = @AccountManager OR @AccountManager IS NULL)
	AND		ISNULL(c.Posted, 0) >= @PostStatus
	AND		c.PostingDate BETWEEN @StartDate AND @EndDate	
	--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(c.GLCompanyKey, 0)) ) 
	AND     (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(c.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey != -1 AND ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey)
				)
	AND (@MultiCurrency = 0
		OR isnull(c.CurrencyID, '') = isnull(@CurrencyID, '') )
	AND  ca.InvoiceKey is null -- Applied to Sales
	Group By 
		 c.ClientKey
		,c.CheckDate
		,c.ReferenceNumber

END
ELSE
BEGIN
	--Get Payments
	INSERT	#ClientStmt
			(TranType
			,ClientKey
			,TranDate
			,TranRef
			,ProjectKey
			,TranAmt
			,Sort
			,TranSort)
	SELECT	'Payment'
			,c.ClientKey
			,c.CheckDate
			,c.ReferenceNumber
			,i.ProjectKey
			,Sum(ca.Amount) * -1
			,1
			,3
	FROM	tCheck c (nolock)
	INNER JOIN tCompany com (nolock) ON c.ClientKey = com.CompanyKey
	LEFT JOIN tCheckAppl ca (nolock) ON c.CheckKey = ca.CheckKey
	LEFT JOIN tInvoice i (nolock) ON ca.InvoiceKey = i.InvoiceKey
	WHERE	com.OwnerCompanyKey = @CompanyKey
	AND		(c.ClientKey = @ClientKey OR @ClientKey IS NULL)
	And     (@ParentClientKey IS NULL or (c.ClientKey = @ParentClientKey or c.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	AND		(com.AccountManagerKey = @AccountManager OR @AccountManager IS NULL)
	AND		ISNULL(c.Posted, 0) >= @PostStatus
	AND		i.ProjectKey = @ProjectKey
	AND		c.PostingDate BETWEEN @StartDate AND @EndDate
	--AND		(ISNULL(com.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	--AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(c.GLCompanyKey, 0)) ) 
	AND     (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(c.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey != -1 AND ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey)
				)
	AND (@MultiCurrency = 0
		OR isnull(c.CurrencyID, '') = isnull(@CurrencyID, '') )
	Group By
		 c.ClientKey
		,c.CheckDate
		,c.ReferenceNumber
		,i.ProjectKey
END

-- now add unapplied receipts
if @Receipts = 1 and @ProjectKey is null
begin
	INSERT	#ClientStmt
				(TranType
				,ClientKey
				,TranDate
				,TranRef
				,ProjectKey
				,TranAmt
				,Sort
				,TranSort)
		SELECT	'Payment'
				,c.ClientKey
				,c.CheckDate
				,c.ReferenceNumber
				,NULL
				,-1 * (unapp.CheckAmt - unapp.AppliedAmt)
				,1
				,3
		from #UnappliedRec unapp (nolock)
		inner join tCheck c (nolock) on unapp.CheckKey = c.CheckKey
		where unapp.PostingDate >= @StartDate
end

UPDATE	#ClientStmt
SET		LoggedCompanyKey = @CompanyKey

--Delete rows where the only row is a Beg. Balance, and the Balance is 0.
IF @IncludeZeroBal = 0
	DELETE	#ClientStmt
	WHERE	Sort = 0
	AND		ISNULL(TranAmt, 0) = 0
	AND		ClientKey NOT IN
				(SELECT ClientKey
				FROM	#ClientStmt
				WHERE	Sort = 1)


if @RollUpMatching > 0
BEGIN
-- cbre custom functions
	INSERT #ClientStmt (LoggedCompanyKey, TranType, ClientKey, TranDate, TranRef, DueDate, TranAmt, Sort, TranSort, Action)
	SELECT LoggedCompanyKey, TranType, ClientKey, MAX(TranDate), TranRef, MAX(DueDate), SUM(TranAmt), MAX(Sort), MAX(TranSort), 1
	From #ClientStmt
	GROUP BY LoggedCompanyKey, TranType, ClientKey, TranRef

	DELETE #ClientStmt Where Action is null

END
		
SELECT	#ClientStmt.*, c.CompanyName, ISNULL(p.ProjectNumber,'') + ' ' + ISNULL(p.ProjectName,'') AS ProjectNumber
	,RTRIM(ISNULL(cl.CustomerID, 'NO ID')) as ClientID
	,RTRIM(ISNULL(cl.CompanyName, 'NO NAME')) as ClientName
	,RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME')) as ClientFullName
	,ad.Address1
	,ad.Address2
	,ad.Address3
	,ad.City
	,ad.State
	,ad.PostalCode
	,ad.Country
	,cl.CompanyName as BCompanyName
	,case when cl.BillingAddressKey IS NOT NULL then bad.Address1
	else cad.Address1 end as BAddress1,	
	case when cl.BillingAddressKey IS NOT NULL then bad.Address2
	else cad.Address2 end as BAddress2,	
	case when cl.BillingAddressKey IS NOT NULL then bad.Address3
	else cad.Address3 end as BAddress3,
	case when cl.BillingAddressKey IS NOT NULL then bad.City
	else cad.City end as BCity,
	case when cl.BillingAddressKey IS NOT NULL then bad.State
	else cad.State end as BState,	
	case when cl.BillingAddressKey IS NOT NULL then bad.PostalCode
	else cad.PostalCode end as BPostalCode,
	case when cl.BillingAddressKey IS NOT NULL then bad.Country
	else cad.Country end as BCountry
FROM	#ClientStmt
INNER JOIN tCompany cl (nolock) ON #ClientStmt.ClientKey = cl.CompanyKey
inner join tCompany c (nolock) on #ClientStmt.LoggedCompanyKey = c.CompanyKey
LEFT JOIN tProject p (nolock) ON #ClientStmt.ProjectKey = p.ProjectKey
LEFT JOIN tAddress ad (nolock) ON c.DefaultAddressKey = ad.AddressKey
LEFT JOIN tAddress cad (nolock) ON cl.DefaultAddressKey = cad.AddressKey
LEFT JOIN tAddress bad (nolock) ON cl.BillingAddressKey = bad.AddressKey
ORDER BY cl.CustomerID, Sort, TranDate, TranSort
GO
