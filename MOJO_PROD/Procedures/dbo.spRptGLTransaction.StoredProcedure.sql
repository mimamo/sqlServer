USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGLTransaction]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptGLTransaction]
	(	
		@CompanyKey int
		,@GLAccountKey int
		,@GLCompanyKey INT = -1		-- -1 All, 0 NULL, >0 valid GLCompany
		,@StartDate DATETIME
		,@EndDate DATETIME	
		,@Cleared INT	
		,@UserKey int = null
	)
AS

/*
|| When     Who Rel     What
|| 4/1/08   GWG 8.507   Modified to be date sensitive to the bank rec's
|| 9/15/09  GWG 10.510  Added Reference to the sort
|| 3/09/10  RLB 10.520  Added filter on GL Company
|| 10/13/11 GHL 10.459  Added new entity CREDITCARD 
|| 04/12/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
*/

	SET NOCOUNT ON

	Declare @RestrictToGLCompany int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	IF @StartDate is NULL
		SELECT @StartDate = '1/1/1995'

	IF @EndDate is NULL
		SELECT @EndDate = '1/1/2070'
	
	Select @Cleared = ISNULL(@Cleared, 0)
	
if @Cleared = 0

	SELECT  v.*
			,Case When Entity = 'INVOICE' THEN 'Invoice'
			When Entity = 'VOUCHER' THEN 'Voucher'
			When Entity = 'RECEIPT' THEN 'Receipt'
			When Entity = 'PAYMENT' THEN 'Payment'
			When Entity = 'GENJRNL' THEN 'Journal Entry'
			When Entity = 'CREDITCARD' THEN 'Credit Card Charge'
			end AS EntityName 
	FROM	vTransaction v
	WHERE	v.CompanyKey = @CompanyKey
	AND		v.GLAccountKey = @GLAccountKey
	--AND		(@GLCompanyKey = -1 OR (ISNULL(@GLCompanyKey, 0) = ISNULL(v.GLCompanyKey, 0)) )

	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND		v.TransactionDate BETWEEN @StartDate AND @EndDate
	AND	    (v.Cleared = 0
			OR v.TransactionKey in (Select TransactionKey from 
			tGLAccountRecDetail ard (nolock) 
			inner join tGLAccountRec ar (nolock) on ard.GLAccountRecKey = ar.GLAccountRecKey
			Where ar.CompanyKey = @CompanyKey and
				ar.GLAccountKey = @GLAccountKey and
				ar.EndDate > @EndDate ) )


	ORDER BY TransactionDate, Reference
		
ELSE

	SELECT  v.*
			,Case When Entity = 'INVOICE' THEN 'Invoice'
			When Entity = 'VOUCHER' THEN 'Voucher'
			When Entity = 'RECEIPT' THEN 'Receipt'
			When Entity = 'PAYMENT' THEN 'Payment'
			When Entity = 'GENJRNL' THEN 'Journal Entry'
			When Entity = 'CREDITCARD' THEN 'Credit Card Charge'
			end AS EntityName 
	FROM	vTransaction v
	WHERE	v.CompanyKey = @CompanyKey
	AND		v.GLAccountKey = @GLAccountKey
	--AND		(@GLCompanyKey = -1 OR (ISNULL(@GLCompanyKey, 0) = ISNULL(v.GLCompanyKey, 0)) )
	
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND		v.TransactionDate BETWEEN @StartDate AND @EndDate
	AND	    v.Cleared = 1

	ORDER BY TransactionDate, Reference
	
	RETURN 1
GO
